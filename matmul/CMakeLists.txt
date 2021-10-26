find_package(Python COMPONENTS Interpreter)
add_test(NAME MatmulAll
COMMAND Python::Interpreter matmul.py
WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
set_tests_properties(MatmulAll PROPERTIES
DISABLED $<NOT:$<BOOL:${Python_Interpreter_FOUND}>>
)


#---------- MKL
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
# cmake -DMKL=on ..
if(mkl)
  include(${PROJECT_SOURCE_DIR}/cmake/mkl_lapack95.cmake)

  add_executable(intelg intel_gemm.f90)
  target_link_libraries(intelg PRIVATE LAPACK::LAPACK95 LAPACK::LAPACK)
  add_test(NAME intelGEMM COMMAND intelg)
endif()

if(NOT LAPACK_FOUND)
  find_package(LAPACK)
endif()
if(LAPACK_FOUND)
  add_executable(matmul_fort matmul.f90)
  target_link_libraries(matmul_fort LAPACK::LAPACK perf)
  add_test(NAME BLAS_Matmul COMMAND matmul_fort)

  add_executable(inteld intel_dgemm.f90)
  target_link_libraries(inteld LAPACK::LAPACK)
  add_test(NAME IntelDGEMM COMMAND inteld)
endif()


# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
#
# manual, works
# ifort -i8 intel_gemm.f90 -I${MKLROOT}/include/intel64/ilp64 ${MKLROOT}/lib/intel64/libmkl_blas95_lp64.a -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl
#
# cmake
# ifort -i8 intel_gemm.f90 -I${MKLROOT}/include/intel64/ilp64



# source /opt/intel/compilers_and_libraries/linux/mkl/bin/mklvars.sh intel64
# export F95ROOT=/opt/intel/compilers_and_libraries/linux/mkl

# ifort -O3 -march=native -I${MKLROOT}/include/intel64/ilp64 -I${MKLROOT}/include ../perf.f90 ../matmul.f90  ${MKLROOT}/lib/intel64/libmkl_blas95_lp64.a ${MKLROOT}/lib/intel64/libmkl_lapack95_lp64.a -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl


# Broken due to gfortran <= std=f95:
# gfortran -O3 -march=native -I${F95ROOT}/include/intel64/lp64 -m64 -I${MKLROOT}/include ../perf.f90 ../matmul.f90   ${F95ROOT}/lib/intel64/libmkl_blas95_lp64.a ${F95ROOT}/lib/intel64/libmkl_lapack95_lp64.a -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl
