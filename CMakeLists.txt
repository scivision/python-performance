cmake_minimum_required(VERSION 2.8.12)
project( bench Fortran )

add_compile_options(-mtune=native -Werror=array-bounds -Wall -Wextra -Wpedantic)

find_package(BLAS REQUIRED)

add_executable(kind kind.f90)

add_library(matmul benchmark_matmul.f90)
target_link_libraries(matmul blas)

add_executable(benchfort benchmarks.f90 benchmark_iter.f90 benchmark_hypot.f90 perf.f90)
target_link_libraries(benchfort matmul)
