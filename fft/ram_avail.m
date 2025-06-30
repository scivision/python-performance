function bytes = ram_avail()
% by SciVision

try
  % GNU Octave since ~ 2021 has cross-platform memory(), 
  % while Matlab memory() is only for Windows
  m = memory();
  bytes = m.MaxPossibleArrayBytes;
catch e
  switch e.identifier
    case 'MATLAB:memory:unsupported'
      b = java.lang.management.ManagementFactory.getOperatingSystemMXBean();
      bytes = b.getFreePhysicalMemorySize();
    otherwise, rethrow(e)
  end
end

end
