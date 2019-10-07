project('Bench', 'c',
  meson_version: '>=0.50',
  default_options : ['default_library=static', 'buildtype=release'])

cc = meson.get_compiler('c')
usefortran = add_languages('fortran', required: false)
fc = meson.get_compiler('fortran')

if fc.get_id() == 'intel'
  add_project_arguments('-heap-arrays', language: 'fortran')
elif fc.get_id() == 'intel-cl'
  add_project_arguments('/heap-arrays', language: 'fortran')
endif

subdir('pisum')

if not usefortran
  subdir_done()
endif


subdir('matmul')

kind_exe = executable('kind', 'kind.f90')
test('kind', kind_exe)

hypot_exe = executable('hypot', 'hypot.f90', 'perf.f90')
test('hypot', hypot_exe)