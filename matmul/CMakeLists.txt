cmake_minimum_required (VERSION 3.7)
project(MatMult Fortran C)
enable_testing()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/../cmake/Modules/")
#---------- MKL 
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
find_package(MKL)
if(MKL_FOUND)
  set(MKLROOT $ENV{MKLROOT})
  include_directories(${MKL_INCLUDE_DIRS} ${MKLROOT}/include/intel64/ilp64)
 
  find_package(Threads REQUIRED)
 
  list(APPEND FLIBS ${MKL_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT} ${CMAKE_DL_LIBS})
  # this example requires MKL
  if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    list(APPEND FFLAGS -i8)
    add_executable(intelg intel_gemm.f90)
    target_compile_options(intelg PUBLIC ${FFLAGS})
    target_link_libraries(intelg mkl_blas95_ilp64 ${MKL_LIBRARIES} ${FLIBS})
    add_test(NAME intelGEMM COMMAND intelg)
  elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU)
  # NOTE: -fdefault-integer-8 -m64  are crucial for MKL using gfortran to avoid SIGSEGV at runtime!
    list(APPEND FFLAGS -fdefault-integer-8 -m64 -fbacktrace)
  endif()
else()
  find_package(BLAS)
  list(APPEND FLIBS ${BLAS_LIBRARIES})
endif()




if(MKL_FOUND OR BLAS_FOUND)
  add_executable(matmul matmul.f90 ../perf.f90)
  target_compile_options(matmul PUBLIC ${FFLAGS})
  add_executable(inteld intel_dgemm.f90)
  target_compile_options(inteld PUBLIC ${FFLAGS})

  target_link_libraries(matmul ${FLIBS})
  target_link_libraries(inteld ${FLIBS})
  
  add_test(NAME matmul COMMAND matmul)
  add_test(NAME intelDGEMM COMMAND inteld)
endif()
  
find_package(PythonInterp)
if(PYTHON_VERSION_STRING VERSION_GREATER_EQUAL 3.6)
  add_test(NAME MatmulAll COMMAND python matmul.py WORKING_DIRECTORY ${PROJECT_SOURCE_DIR})
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

