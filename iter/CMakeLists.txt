add_executable(iterfort iter.f90)
target_link_libraries(iterfort perf)
add_test(NAME IterFortran COMMAND iterfort)
