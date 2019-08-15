
set(CMAKE_C_STANDARD 11)

add_executable(pisumc pisum.c)
if(NOT MSVC)  # MSVC true for icl as well
  target_link_libraries(pisumc m)
endif()
if (UNIX AND NOT APPLE)
  target_link_libraries(pisumc rt)
endif()
add_test(NAME pisumC COMMAND pisumc)


if(NOT CMAKE_Fortran_COMPILER)
  return()
endif()

add_executable(pisumfort pisum.f90 ../perf.f90)
target_compile_options(pisumfort PRIVATE ${FFLAGS})
add_test(NAME pisumFortran COMMAND pisumfort)
