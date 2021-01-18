cmake_minimum_required(VERSION 3.15)
project(iterate Fortran)

if(NOT TARGET perf)
  add_library(perf OBJECT ../perf.f90)
endif()


add_executable(iterfort iter.f90)
target_link_libraries(iterfort PRIVATE perf)
add_test(NAME IterFortran COMMAND $<TARGET_FILE:iterfort>)
