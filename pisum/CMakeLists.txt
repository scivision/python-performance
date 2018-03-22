cmake_minimum_required (VERSION 2.8.12)
project(PiIterSum Fortran)

add_executable(pisumfort pisum.f90 iter.f90 ../perf.f90)
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
