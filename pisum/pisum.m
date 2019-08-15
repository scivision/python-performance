function pisum(N, Nrun)

addpath('..')  % isoctave
if nargin<2, Nrun=3; end

if isoctave
  v = ver('octave'); % else matlab syntax checker errors
  disp(['--> Octave ', v.Version])
else
  v = ver('matlab');
  disp(['--> Matlab ', v.Release(2:end-1)])
end

pitry = calcpisum(N);

if abs(pitry-pi)>1e-4
  error('Pisum: failed to converge')
end

try
  f = @() calcpisum(N);
  t = timeit(f);
catch
  t = inf;
  for i = 1:Nrun
    tic
    calcpisum(N);
    t = min(toc,t);
  end
end % try
disp([num2str(t),' sec.'])

end % function pisum
%%
function x = calcpisum(N)
s = 0.;
for k = 1:N
  s = s + (-1)^(k+1) / (2*k-1);
end

x=4*s;
end
