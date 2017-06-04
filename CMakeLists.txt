cmake_minimum_required(VERSION 2.8.12)
project( bench Fortran C)

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_compile_options(-mtune=native -Werror=array-bounds -Wall -Wextra -pedantic)

if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    find_program( CODECOV_GCOV gcov )
    find_program( CODECOV_LCOV lcov )
    find_program( CODECOV_GENHTML genhtml )
    add_compile_options( -fprofile-arcs -ftest-coverage )
else()
    add_compile_options(-O3)
endif()

set(CMAKE_VERBOSE_MAKEFILE 0)
#----------- MKL/BLAS ----------------------------
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
find_package(MKL)
if(MKL_FOUND)
    message(STATUS "MKL activated")
    include_directories(${MKL_INCLUDE_DIRS})
else()
    find_package(BLAS REQUIRED)
endif()
#--------- programs ---------
add_executable(kind kind.f90)

add_executable(hypot Hypot.f90 benchmark_hypot.f90 perf.f90)

add_executable(matmul matmul_drv.f90 matmul_sub.f90 perf.f90)
target_link_libraries(matmul blas ${MKL_LIBRARIES})

add_executable(iterfort ../pisum/iter_drv.f90 ../pisum/iter_sub.f90 perf.f90)

add_executable(iterc ../pisum/pisum.c)
target_link_libraries(iterc rt m)

# manually:
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor

# source /opt/intel/compilers_and_libraries/linux/mkl/bin/mklvars.sh intel64
# export F95ROOT=/opt/intel/compilers_and_libraries/linux/mkl

# ifort -O3 -march=native -I${MKLROOT}/include/intel64/lp64 -I${MKLROOT}/include ../perf.f90 ../matmul_sub.f90 ../matmul_drv.f90  ${MKLROOT}/lib/intel64/libmkl_blas95_lp64.a ${MKLROOT}/lib/intel64/libmkl_lapack95_lp64.a -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl


# Broken due to gfortran <= std=f95:
# gfortran -O3 -march=native -I${F95ROOT}/include/intel64/lp64 -m64 -I${MKLROOT}/include ../perf.f90 ../matmul_sub.f90 ../matmul_drv.f90  ${F95ROOT}/lib/intel64/libmkl_blas95_lp64.a ${F95ROOT}/lib/intel64/libmkl_lapack95_lp64.a -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_gf_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl

#f951: Fatal Error: Reading module ‘lapack95’ at line 1 column 2: Unexpected EOF compilation terminated.

