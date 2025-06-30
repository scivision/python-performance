%% FFT_BENCH compare CPU vs. GPU on FFT()
%
% suggest measuring effects of fftw() with "swisdom" or "dwisdom"
% 
% Inputs
% * useGpu: use the default GPU. If not available, errors.
% * precision: single (32 bit) or double (64 bit)
%
% original by https://github.com/mgagan544/Performance-Benchmarking-of-DFT-vs-FFT-

function fft_bench(useGpu, precision, Fsize)
arguments
  useGpu (1,1) logical = false  % require GPU to be present and working
  precision string {mustBeMember(precision, ["single", "double"])} = "single"
  Fsize (1,:) {mustBeInteger,mustBePositive} = []
end


% Check for GPU availability
hgpu = check_gpu(useGpu);

%% dynamic memory size constraint
[Ns, expected_bytes] = problem_size(Fsize, precision);

num_trials = 5;  % 5 trials are taken for accurate readings

%  result arrays
cpuFFT_times = zeros(size(Ns));
gpuFFT_times = nan(size(Ns));
dft_times = nan(size(Ns));

gpuFFT_energy = nan(size(Ns));

disp('==== Comprehensive FFT Benchmark ====');
fprintf('Testing %d sizes from %d to %d points\n', length(Ns), min(Ns), max(Ns));

% Create figures for real-time plotting
fg = figure('Name', sprintf("%s precision FFT Benchmarks: Time", precision));
timeAxes = axes('Parent', fg, 'NextPlot', 'add');
title(timeAxes, 'Execution Time')
xlabel(timeAxes, 'Array Size (N)')
ylabel(timeAxes, 'Time (seconds)')
set(timeAxes, 'XScale', 'log', 'YScale', 'log', 'XGrid', 'on', 'YGrid', 'on')

% Main benchmarking loop
for i = 1:length(Ns)
  N = Ns(i);
  fprintf('\nTesting precision %s N = %d\n', precision, N);

  % Create signal with actual frequency components
  x = signal_gen(N, precision);

  % 1. CPU FFT Benchmarking
  fprintf('  CPU FFT: ');

  h = @() fft(x);
  cpuFFT_times(i) = timeit(h);

  fprintf(' %.4f s\n', cpuFFT_times(i));

  % 2. DFT Benchmarking (only for small N)
  if N <= 2048
    fprintf('  DFT:     ');

    h = @() cpu_dft(x, N);
    dft_times(i) = timeit(h);

    fprintf(' %.4f s\n', dft_times(i));
  end

  % 3. GPU FFT Benchmarking
  if useGpu
    [gpuFFT_times(i), gpuFFT_energy(i)] = bench_gpu(x, N, num_trials, hgpu);
  end

  % Update plots in real-time
  % Time plot
  cla(timeAxes);
  if any(~isnan(dft_times))
    loglog(timeAxes, Ns(1:i), dft_times(1:i), 'r-o', 'LineWidth', 1.5, 'DisplayName', 'DFT');
  end
  loglog(timeAxes, Ns(1:i), cpuFFT_times(1:i), 'b-s', 'LineWidth', 1.5, 'DisplayName', 'CPU FFT');
  if any(~isnan(gpuFFT_times))
    loglog(timeAxes, Ns(1:i), gpuFFT_times(1:i), 'g-^', 'LineWidth', 1.5, 'DisplayName', 'GPU FFT');
  end
  legend(timeAxes, 'Location', 'northwest');
  drawnow();

end

if useGpu
    gpuDevice([]); 
    % avoid hanging handle that might require restarting Matlab
end
%% Final Results and Analysis

% Find crossover point where GPU becomes faster than CPU
if any(~isnan(gpuFFT_times)) && any(~isnan(cpuFFT_times))
    valid_indices = ~isnan(gpuFFT_times) & ~isnan(cpuFFT_times);
    gpu_better_idx = find(gpuFFT_times < cpuFFT_times & valid_indices);

    if ~isempty(gpu_better_idx)
        gpu_kickin_N = Ns(gpu_better_idx(1));
        fprintf('\n? GPU becomes faster than CPU FFT at N = %d\n', gpu_kickin_N);

        % Calculate speedup at max size
        max_valid_idx = find(valid_indices, 1, 'last');
        if ~isempty(max_valid_idx)
            max_speedup = cpuFFT_times(max_valid_idx) / gpuFFT_times(max_valid_idx);
            fprintf('? Maximum GPU speedup: %.2fx at N = %d\n', max_speedup, Ns(max_valid_idx));
        end
    else
        fprintf('\n GPU never outperformed CPU in this range.\n');
    end
else
    fprintf(2, '\n Insufficient data to determine GPU/CPU crossover point.\n');
end


if sum(~isnan(dft_times)) >= 2 && sum(~isnan(cpuFFT_times)) >= 2
    disp('Algorithmic Complexity Verification:')


    valid_dft = find(~isnan(dft_times));
    valid_fft = find(~isnan(cpuFFT_times));

    if length(valid_dft) >= 2
        idx1 = valid_dft(1);
        idx2 = valid_dft(end);
        expected_ratio_N2 = (Ns(idx2)/Ns(idx1))^2;
        actual_ratio_dft = dft_times(idx2)/dft_times(idx1);
        fprintf('- DFT: Expected O(N²) ratio: %.2f, Actual ratio: %.2f\n', ...
            expected_ratio_N2, actual_ratio_dft);
    end

    if length(valid_fft) >= 2
        idx1 = valid_fft(1);
        idx2 = valid_fft(end);
        expected_ratio_NlogN = (Ns(idx2)*log2(Ns(idx2))) / (Ns(idx1)*log2(Ns(idx1)));
        actual_ratio_fft = cpuFFT_times(idx2)/cpuFFT_times(idx1);
        fprintf('- FFT: Expected O(N log N) ratio: %.2f, Actual ratio: %.2f\n', ...
            expected_ratio_NlogN, actual_ratio_fft);
    end
end

% Generate comprehensive report table
fprintf('\n%-10s | %-10s | %-10s | %-10s\n', ...
    'N', 'DFT Time', 'CPU Time', 'GPU Time');
fprintf(repmat('-', 1, 40));
fprintf('\n');

for i = 1:length(Ns)
    fprintf('%-10d | %-10.4f | %-10.4f | %-10.4f\n', ...
        Ns(i), dft_times(i), cpuFFT_times(i), gpuFFT_times(i));
end

% Save results to MAT file
try
  ts = datetime('now', Format='yyyyMMdd_HHmmss');
catch
  ts = datestr(now(), 'yyyymmdd_HHMMSS'); %#ok<DATST,TNOW1>
end
matfn = sprintf('fft_%s_%s.mat', precision, ts);
figfn = sprintf('fft_%s_%s.png', precision, ts);

save(matfn, 'Ns', 'dft_times', 'cpuFFT_times', 'gpuFFT_times', ...
    'gpuFFT_energy', 'precision');

fprintf('\nResults saved to %s %s\n', matfn, figfn);

% final comparison figure with all metrics
fa = figure('Name', 'Comprehensive FFT Benchmark Results', 'Position', [100, 100, 1200, 800]);

%% Time
ax = subplot(2, 2, 1, 'Parent', fa, 'NextPlot', 'add');
if any(~isnan(dft_times))
    loglog(ax, Ns, dft_times, 'r-o', 'LineWidth', 1.5, 'DisplayName', 'DFT (O(N²))');
end
loglog(ax, Ns, cpuFFT_times, 'b-s', 'LineWidth', 1.5, 'DisplayName',  'FFT CPU (O(N log N))');
if any(~isnan(gpuFFT_times))
    loglog(ax, Ns, gpuFFT_times, 'g-^', 'LineWidth', 1.5, 'DisplayName', 'FFT GPU');
end
grid(ax, 'on');
xlabel(ax, 'Signal Length (N)');
ylabel(ax, 'Time (seconds)');
title(ax, 'Execution Time');
legend(ax, 'Location', 'northwest');

%% Memory
ax = subplot(2, 2, 2, 'Parent', fa, 'NextPlot', 'add');

loglog(ax, Ns, expected_bytes/1e6, '--', 'DisplayName', 'theoretical')

grid(ax, 'on')
xlabel(ax, 'Signal Length (N)');
ylabel(ax, 'Memory (MB)');
title(ax, 'Memory Usage');
legend(ax, 'Location', 'northwest');
ylims = ylim(ax);
ylim(ax, [ylims(1), 1.1*max(expected_bytes)/1e6])

%% Energy (if available)
ax = subplot(2, 2, 3, 'Parent', fa);
if any(~isnan(gpuFFT_energy))
    loglog(ax, Ns, gpuFFT_energy, 'g-^', 'LineWidth', 1.5, 'DisplayName', 'FFT GPU');
    grid(ax, 'on')
    xlabel(ax, 'Signal Length (N)')
    ylabel(ax, 'Energy (Joules)')
    title(ax, 'Energy Consumption (GPU)')
    legend(ax,'Location', 'northwest')
else
    text(ax, 0.5, 0.5, 'Energy data not available', 'HorizontalAlignment', 'center')
    title(ax, 'Energy Consumption')
end

%% Efficiency (computations per joule)
ax = subplot(2, 2, 4, 'Parent', fa);
if any(~isnan(gpuFFT_energy))
    % Calculate efficiency: N*log2(N) operations per Joule
    valid_energy = ~isnan(gpuFFT_energy) & gpuFFT_energy > 0;
    if any(valid_energy)
        N_valid = Ns(valid_energy);
        ops_valid = N_valid .* log2(N_valid); % Approximate number of operations
        energy_valid = gpuFFT_energy(valid_energy);
        efficiency = ops_valid ./ energy_valid;

        loglog(ax, N_valid, efficiency, 'g-^', 'LineWidth', 1.5);
        grid(ax, 'on')
        xlabel(ax, 'Signal Length (N)');
        ylabel(ax, 'Operations per Joule');
        title(ax, 'Computational Efficiency (GPU)');
    else
        text(ax, 0.5, 0.5, 'Efficiency data not available', 'HorizontalAlignment', 'center');
        title(ax, 'Computational Efficiency');
    end
else
    text(ax, 0.5, 0.5, 'Energy data not available', 'HorizontalAlignment', 'center');
    title(ax, 'Computational Efficiency');
end

ttxt = sprintf('%s precision FFT Benchmark Results', precision);
try
  sgtitle(fa, ttxt);
catch e
  switch e.identifier
    case {'MATLAB:UndefinedFunction', 'Octave:undefined-function'}
      axes('Parent', fa, 'visible', 'off', 'title', ttxt)
    otherwise, rethrow(e)
  end
end

try
  exportgraphics(fa, figfn)
catch e
  switch e.identifier
    case {'MATLAB:UndefinedFunction', 'Octave:undefined-function'}, print(fa, figfn)
    otherwise, rethrow(e)
  end
end

end


function power = getGpuPower()
  power = NaN;
  [status, output] = system('nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits');
  if status == 0
    power = str2double(output); 
  end
end


function g = check_gpu(useGpu)

g = [];
if ~useGpu, return, end


g = gpuDevice();
reset(g);
assert(g.DeviceAvailable, 'GPU %s not available', g.Name)

fprintf('Using GPU: %s with %.2f GB memory\n', g.Name, g.AvailableMemory/1e9);

end


function [Ns, expected_bytes] = problem_size(Fsize, precision)

am = ram_avail();

fprintf('Available system memory: %.2f GB\n', am/1e9);

if ~isempty(Fsize)
  Ns = Fsize;
else

% Base sizes that work on most systems
Ns = 2.^(8:18);

if am > 250e6
Ns = [Ns, 2.^(19:20)];
end

if am > 500e6
Ns = [Ns, 2.^(21:22)];
end

if am > 1e9
Ns = [Ns, 2^23];
end

if am > 2e9 
Ns = [Ns, 2^24];
end

if am > 4e9
Ns = [Ns, 2^25];
end

if am > 8e9
Ns = [Ns, 2.^(26:27)];
end

if am > 16e9
Ns = [Ns, 2.^28];
end

if am > 32e9
Ns = [Ns, 2.^29];
end

end

% the final "* 2" is since there are input and output signals
switch precision
  case 'single', expected_bytes = Ns * 4*2 * 2; % complex single
  case 'double', expected_bytes = Ns * 8*2 * 2; % complex double
  otherwise, error('unexpected precision %s', precision)
end

check_ram(max(expected_bytes), am)

end


function x = signal_gen(N, precision)

f1 = min(50, N/10);          % Base frequency scaled to avoid aliasing
f2 = min(120, N/4);          % Mid frequency
f3 = min(375, N/2-10);       % High frequency

t = linspace(0, 1, N);
x = sin(2*pi*f1*t) + 0.5*sin(2*pi*f2*t) + 0.25*sin(2*pi*f3*t);
% conversion to single below spikes RAM
clear('t') 

if strcmp(precision, "single")
  x = single(x);
end

end


function X = cpu_dft(x, N)

n = 0:N-1;
k = n';
WN = exp(-1j*2*pi/N);
twiddle = WN .^ (k*n);

X = x * twiddle;

end


function [t, mem, energy, X] = gpu_fft(x, g)

% Transfer data to GPU
xg = gpuArray(x);

powerBefore = getGpuPower();

% Time the operation
wait(g);
t0 = tic;
X = fft(xg);
wait(g);
t = toc(t0);

powerAfter = getGpuPower();
avgPower = (powerBefore + powerAfter) / 2;
energy = avgPower * t;

v = whos('X');
mem = v.bytes / 1e6;

end


function [ts, ms, es, X] = bench_gpu(x, N, num_trials, hgpu)

ts = NaN;
ms = NaN;
es = NaN;
X = NaN;

fprintf('  GPU FFT: ');

% To check if  array can fit in GPU memory
mem_needed = N * 16 * 2;  % bytes
if mem_needed > hgpu.AvailableMemory * 0.8  % Allow 20% overhead
  fprintf(2, ' [Skipped - insufficient GPU memory]\n');
  return
end

t = zeros(1, num_trials);
mem = zeros(1, num_trials);
e = zeros(1, num_trials);

for j = 1:num_trials
  [t(j), mem(j), e(j), X] = gpu_fft(x, hgpu);
  fprintf('.');
end

mem(mem < 0) = NaN;

ts = mean(t);
ms = mean(mem, "omitnan");
es = mean(e);
fprintf(' %.4f s, %.2f MB, %.2f J\n', ts, ms, es);

end
