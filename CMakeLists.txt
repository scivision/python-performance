cmake_minimum_required(VERSION 3.19...3.28)

if(NOT CMAKE_BUILD_TYPE AND NOT DEFINED ENV{CMAKE_BUILD_TYPE})
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")
endif()

project(bench
LANGUAGES C Fortran)

enable_testing()

set(CMAKE_C_STANDARD 99)

include(cmake/compiler.cmake)

add_library(perf OBJECT perf.f90)

# --- iter
add_executable(iterfort iter/iter.f90)
target_link_libraries(iterfort PRIVATE perf)
add_test(NAME IterFortran COMMAND iterfort)

# --- pisum
add_executable(pisumc pisum/pisum.c)
target_link_libraries(pisumc PRIVATE
$<$<NOT:$<BOOL:${MSVC}>>:m>
$<$<STREQUAL:${CMAKE_SYSTEM_NAME},Linux>:rt>
)

add_test(NAME pisumC COMMAND pisumc)

add_executable(pisumfort pisum/pisum.f90)
target_link_libraries(pisumfort PRIVATE perf)
add_test(NAME pisumFortran COMMAND pisumfort)

# --- matmul
add_subdirectory(matmul)

add_executable(mbfort mandelbrot/mandel.f90)
target_link_libraries(mbfort perf)
add_test(NAME MandlebrotFortran COMMAND mbfort)

add_executable(kind kind.f90)
add_test(NAME kind COMMAND kind)

add_executable(hypot hypot.f90)
target_link_libraries(hypot perf)
add_test(NAME hypot COMMAND hypot)
