cmake_minimum_required(VERSION 3.15)
project(Hypotenuse Fortran)

if(NOT TARGET perf)
  add_library(perf OBJECT ../perf.f90)
endif()

add_executable(hypot hypot.f90)
target_link_libraries(hypot PRIVATE perf)
add_test(NAME hypot COMMAND $<TARGET_FILE:hypot>)
