
blas = fc.find_library('blas', required: false)
if not fc.links('dnrm2(1, [2.], 1)', dependencies: blas, name: 'BLAS OK')
  blas = disabler()
endif

#if fc.get_id() = 'intel'
#  blas95_include_dirs = '$ENV{MKLROOT}/include/intel64/lp64'
#  blas95_libraries = ['$ENV{MKLROOT}/lib/intel64/libmkl_blas95_lp64.a', 'mkl_intel_lp64', 'mkl_sequential', 'mkl_core']
#else
#  blas95_include_dirs = [cmake_current_binary_dir, '/include/intel64/lp64']
#  blas95_libraries = [cmake_current_binary_dir, '/lib/intel64/libmkl_blas95_lp64.a', 'mkl_intel_lp64', 'mkl_sequential', 'mkl_core']
#endif
#intelg_exe = executable('intelg', 'intel_gemm.f90', dependencies: blas)
#test('intelGEMM', 'intelg')


matmul_exe = executable('matmul_fort', 'matmul.f90', '../perf.f90',
  dependencies: blas)
test('matmul', matmul_exe)

inteld_exe = executable('inteld', 'intel_dgemm.f90', dependencies: blas)
test('intelDGEMM', inteld_exe)

pymod = import('python')
python = pymod.find_installation('python3')

matmul_py = files('matmul.py')
test('MatmulAll', python,
  args: matmul_py
)
