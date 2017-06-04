cmake_minimum_required(VERSION 2.8.12)
project( bench Fortran C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_compile_options(-mtune=native -Werror=array-bounds -Wall -Wextra -Wpedantic)

if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    find_program( CODECOV_GCOV gcov )
    find_program( CODECOV_LCOV lcov )
    find_program( CODECOV_GENHTML genhtml )
    add_compile_options( -fprofile-arcs -ftest-coverage )
else()
    add_compile_options(-m64 -g)#-O3)
endif()

set(CMAKE_VERBOSE_MAKEFILE 0)
#---------------------------------------
add_executable(matmul matmul_drv.f90 matmul_sub.f90 perf.f90)
add_executable(inteld intel_dgemm.f90)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")
# https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor
find_package(MKL)
if(MKL_FOUND)
    include_directories(${MKL_INCLUDE_DIRS})
    target_link_libraries(matmul ${MKL_LIBRARIES} pthread dl m)
    target_link_libraries(inteld ${MKL_LIBRARIES} pthread dl m)
else()
    find_package(BLAS REQUIRED)
    target_link_libraries(matmul blas)
    target_link_libraries(inteld blas)
endif()
#-----------------------------------------


add_executable(kind kind.f90)

add_executable(hypot Hypot.f90 benchmark_hypot.f90 perf.f90)


add_executable(iterfort ../pisum/iter_drv.f90 ../pisum/iter_sub.f90 perf.f90)

add_executable(iterc ../pisum/pisum.c)
target_link_libraries(iterc rt m)

# Intel example manually
# you will get SIGSEGV on execution if these options aren't corect (it will compile but fail on run)
# export MKLROOT=/opt/intel/mkl
# export F95ROOT=/opt/intel/mkl
# gfortran  -fdefault-integer-8 -I${F95ROOT}/include/intel64/ilp64 -m64 -I${MKLROOT}/include intel_dgemm.f90 -L${MKLROOT}/lib/intel64 -Wl,--no-as-needed -lmkl_gf_ilp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl
