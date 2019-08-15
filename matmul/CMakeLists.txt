cmake_minimum_required (VERSION 3.12)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release" FORCE)
endif()
project(MatMult C Fortran) # C is necessary to detect MKL
enable_testing()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/../cmake/Modules/")

get_directory_property(hasParent PARENT_DIRECTORY)
if(NOT hasParent)
  include(${CMAKE_SOURCE_DIR}/../cmake/compiler.cmake)
endif()
#---------- MKL
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
# cmake -DMKL=on ..
if(MKL)
  if(NOT CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
    # be sure Lapack95 is build for your compiler
    if(FC)
      # no "-j" make option ...=.
      execute_process(COMMAND make libintel64 INSTALL_DIR=${CMAKE_CURRENT_BINARY_DIR} interface=lp64 FC=${FC}
                    WORKING_DIRECTORY $ENV{MKLROOT}/interfaces/blas95
                    )
    else()
      message(FATAL_ERROR "specify compiler, e.g.: FC=gfortran cmake -DMKL=on ..")
    endif()
  endif()

  set(BLA_F95 ON)
  find_library(BLAS Intel10_64lp_seq REQUIRED)

  if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)
    set(BLAS95_INCLUDE_DIRS $ENV{MKLROOT}/include/intel64/lp64)
    set(BLAS95_LIBRARIES $ENV{MKLROOT}/lib/intel64/libmkl_blas95_lp64.a mkl_intel_lp64 mkl_sequential mkl_core)
  else()
    set(BLAS95_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/include/intel64/lp64)
    set(BLAS95_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/lib/intel64/libmkl_blas95_lp64.a mkl_intel_lp64 mkl_sequential mkl_core)
  endif()

  add_executable(intelg intel_gemm.f90)
  target_compile_options(intelg PRIVATE ${FFLAGS})
  target_include_directories(intelg PRIVATE ${BLAS95_INCLUDE_DIRS})
  target_link_libraries(intelg PRIVATE ${BLAS95_LIBRARIES} ${FLIBS})
  add_test(NAME intelGEMM COMMAND intelg)
endif()


set(BLA_F95 OFF)
find_package(BLAS)
if(BLAS_FOUND)
  add_executable(matmul matmul.f90 ../perf.f90)
  target_compile_options(matmul PUBLIC ${FFLAGS})
  target_link_libraries(matmul ${BLAS_LIBRARIES} ${FLIBS})
  add_test(NAME matmul COMMAND matmul)

  add_executable(inteld intel_dgemm.f90)
  target_compile_options(inteld PUBLIC ${FFLAGS})
  target_link_libraries(inteld ${BLAS_LIBRARIES} ${FLIBS})
  add_test(NAME intelDGEMM COMMAND inteld)
endif()

find_package(Python3 COMPONENTS Interpreter)
if(Python3_Interpreter_FOUND)
  add_test(NAME MatmulAll
           COMMAND Python3::Interpreter matmul.py
           WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
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

