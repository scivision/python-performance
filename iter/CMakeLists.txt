cmake_minimum_required (VERSION 3.1)
project(Iter Fortran)
enable_testing()

add_executable(iterfort iter.f90 ../perf.f90)
target_compile_options(iterfort PUBLIC ${FFLAGS} ${FCOOPT})
target_link_libraries(iterfort ${FCOLIB})
add_test(NAME IterFortran COMMAND iterfort)

