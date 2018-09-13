cmake_minimum_required (VERSION 3.1)
project(PiIterSum Fortran C)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

add_executable(pisumfort pisum.f90 ../perf.f90)
target_compile_options(pisumfort PUBLIC ${FFLAGS} ${FCOOPT})
target_link_libraries(pisumfort ${FCOLIB})

add_executable(pisumc pisum.c)
target_link_libraries(pisumc m)

if (UNIX AND NOT APPLE)
  target_link_libraries(pisumc rt)
endif()

#------------
enable_testing()

add_test(NAME pisumFortran COMMAND pisumfort)
add_test(NAME pisumC COMMAND pisumc)

