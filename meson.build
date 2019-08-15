project('Bench', 'c', 'fortran',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release'])

fc = meson.get_compiler('fortran')
fcid = fc.get_id()

if fcid == 'intel'
  add_project_arguments('-heap-arrays', language: 'fortran')
elif fcid == 'intel-cl'
  add_project_arguments('/heap-arrays', language: 'fortran')
endif

subdir('matmul')
subdir('pisum')

kind_exe = executable('kind', 'kind.f90')
test('kind', kind_exe)

hypot_exe = executable('hypot', 'hypot.f90', 'perf.f90')
test('hypot', hypot_exe)