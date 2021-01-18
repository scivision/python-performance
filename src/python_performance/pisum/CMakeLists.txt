cmake_minimum_required(VERSION 3.15)
project(PiSum C Fortran)

if(NOT TARGET perf)
  add_library(perf OBJECT ../perf.f90)
endif()


add_executable(pisumc pisum.c)
target_compile_features(pisumc PRIVATE c_std_99)
if(NOT MSVC)
  target_link_libraries(pisumc PRIVATE m)
endif()
if (UNIX AND NOT APPLE)
  target_link_libraries(pisumc PRIVATE rt)
endif()
add_test(NAME pisumC COMMAND $<TARGET_FILE:pisumc>)


add_executable(pisumfort pisum.f90)
target_link_libraries(pisumfort PRIVATE perf)
add_test(NAME pisumFortran COMMAND $<TARGET_FILE:pisumfort>)
