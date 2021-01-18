cmake_minimum_required(VERSION 3.15)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release")
endif()

project(python-performance
LANGUAGES C Fortran)

enable_testing()

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/Modules/)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/compiler.cmake)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR})

add_library(perf OBJECT perf.f90)

add_subdirectory(hypot)
add_subdirectory(iter)
add_subdirectory(pisum)
add_subdirectory(matmul)

add_executable(mbfort mandelbrot/mandel.f90)
target_link_libraries(mbfort perf)
add_test(NAME MandlebrotFortran COMMAND mbfort)

add_executable(kind kind.f90)
add_test(NAME kind COMMAND kind)
