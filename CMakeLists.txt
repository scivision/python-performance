cmake_minimum_required(VERSION 2.8.12)
project( bench Fortran C)

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# NOTE: -fdefault-integer-8 -m64  are crucial for MKL to avoid SIGSEGV at runtime!
set(FFLAGS ${FFLAGS} -fdefault-integer-8 -std=f2008ts)
add_compile_options(-O3 -mtune=native -Werror=array-bounds -Wall -Wextra -pedantic -m64)

#if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
#    find_program( CODECOV_GCOV gcov )
#    find_program( CODECOV_LCOV lcov )
#    find_program( CODECOV_GENHTML genhtml )
#    add_compile_options( -fprofile-arcs -ftest-coverage )
#else()
#    add_compile_options(-m64 -g)#-O3)
#endif()
#---------- MKL tests -----------------------------
add_executable(matmul matmul_drv.f90 matmul_sub.f90 perf.f90)
target_compile_options(matmul PUBLIC ${FFLAGS})
add_executable(inteld intel_dgemm.f90)
target_compile_options(inteld PUBLIC ${FFLAGS})

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
#find_package(MKL)
if(MKL_FOUND)
    include_directories(${MKL_INCLUDE_DIRS})
    target_link_libraries(matmul ${MKL_LIBRARIES} pthread dl)
    target_link_libraries(inteld ${MKL_LIBRARIES} pthread dl)
    # this example requires MKL
    add_executable(intelg intel_gemm.f90)
    target_compile_options(intelg PUBLIC ${FFLAGS})
    target_link_libraries(intelg ${MKL_LIBRARIES} pthread dl)
else()
    find_package(BLAS REQUIRED)
    target_link_libraries(matmul blas)
    target_link_libraries(inteld blas)
endif()
#------ Non-MKL test -----------------------------------

add_executable(kind kind.f90)

add_executable(hypot Hypot.f90 benchmark_hypot.f90 perf.f90)

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

