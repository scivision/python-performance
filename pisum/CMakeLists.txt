cmake_minimum_required (VERSION 3.1)
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug or Release" FORCE)
endif()
project(PiIterSum C Fortran)
enable_testing()

set(CMAKE_C_STANDARD 11)

add_executable(pisumfort pisum.f90 ../perf.f90)
target_compile_options(pisumfort PRIVATE ${FFLAGS})
add_test(NAME pisumFortran COMMAND pisumfort)

add_executable(pisumc pisum.c)
if(NOT MSVC)  # MSVC true for icl as well
  target_link_libraries(pisumc m)
endif()
if (UNIX AND NOT APPLE)
  target_link_libraries(pisumc rt)
endif()
add_test(NAME pisumC COMMAND pisumc)

