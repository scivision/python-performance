cmake_minimum_required(VERSION 3.1)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release" FORCE)
endif()
project(bench C Fortran)
enable_testing()

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")

include(cmake/compiler.cmake)

add_subdirectory(pisum)
add_subdirectory(matmul)

add_executable(kind kind.f90)
target_compile_options(kind PUBLIC ${FFLAGS})
add_test(NAME kind COMMAND kind)

add_executable(hypot hypot.f90 perf.f90)
target_compile_options(hypot PUBLIC ${FFLAGS})
add_test(NAME hypot COMMAND hypot)

