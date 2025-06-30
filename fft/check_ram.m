function check_ram(expected_bytes, mem_avail)
arguments
  expected_bytes (1,1) {mustBeInteger,mustBePositive}
  mem_avail {mustBeScalarOrEmpty} = []
end

if isempty(mem_avail)
  m = memory();
  mem_avail = m.MaxPossibleArrayBytes; % set available memory to maximum possible
end

limit_bytes = inf;

% get user set preference for memory limit
s = settings;
ws = s.matlab.desktop.workspace;

% Check if the maximum array size limit is enabled
if ws.ArraySizeLimitEnabled.ActiveValue
  b = java.lang.management.ManagementFactory.getOperatingSystemMXBean();
  total = b.getTotalPhysicalMemorySize();
  limit_bytes = double(ws.ArraySizeLimit.ActiveValue) / 100 * total;
end


limit_bytes = min(limit_bytes, mem_avail);

assert(expected_bytes < limit_bytes, "expected array bytes %d too big for memory %d", expected_bytes, mem_avail)

end
