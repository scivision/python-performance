cmake_minimum_required (VERSION 3.1)
project(mandlebrot Fortran)
enable_testing()

add_executable(mbfort mandel.f90 ../perf.f90)
target_compile_options(mbfort PUBLIC ${FFLAGS} ${FCOOPT})
target_link_libraries(mbfort ${FCOLIB})
add_test(NAME MandlebrotFortran COMMAND mbfort)

