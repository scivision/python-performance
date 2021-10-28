cmake_minimum_required(VERSION 3.20...3.22)

project(bench
LANGUAGES C Fortran)

enable_testing()

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/)

option(mkl "Use Intel oneMKL")

include(cmake/compiler.cmake)

add_library(perf OBJECT perf.f90)

add_subdirectory(iter)
add_subdirectory(pisum)
add_subdirectory(matmul)

add_executable(mbfort mandelbrot/mandel.f90)
target_link_libraries(mbfort perf)
add_test(NAME MandlebrotFortran COMMAND mbfort)

add_executable(kind kind.f90)
add_test(NAME kind COMMAND kind)

add_executable(hypot hypot.f90)
target_link_libraries(hypot perf)
add_test(NAME hypot COMMAND hypot)
