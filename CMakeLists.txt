cmake_minimum_required(VERSION 2.8.12)
project( bench Fortran )

add_compile_options(-mtune=native -Werror=array-bounds -Wall -Wextra -Wpedantic)

if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    find_program( CODECOV_GCOV gcov )
    find_program( CODECOV_LCOV lcov )
    find_program( CODECOV_GENHTML genhtml )
    add_compile_options( -fprofile-arcs -ftest-coverage )
else()
    add_compile_options(-O3)
endif()

set(CMAKE_VERBOSE_MAKEFILE 0)
#---------------------------------------
find_package(BLAS REQUIRED)

add_executable(kind kind.f90)

add_executable(hypot Hypot.f90 benchmark_hypot.f90 perf.f90)

add_executable(matmul matmul_drv.f90 matmul_sub.f90 perf.f90)
target_link_libraries(matmul blas)

add_executable(iter ../pisum/iter_drv.f90 ../pisum/iter_sub.f90 perf.f90)
