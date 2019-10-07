
pisumc_exe = executable('pisumc', 'pisum.c')
test('pisumC', pisumc_exe)

if usefortran
  pisumfort_exe = executable('pisumfort', 'pisum.f90', '../perf.f90')
  test('pisumFortran', pisumfort_exe)
endif