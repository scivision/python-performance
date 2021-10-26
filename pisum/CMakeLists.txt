add_executable(pisumc pisum.c)
target_link_libraries(pisumc PRIVATE
$<$<NOT:$<BOOL:${MSVC}>>:m>
$<$<STREQUAL:${CMAKE_SYSTEM_NAME},Linux>:rt>
)

add_test(NAME pisumC COMMAND pisumc)
target_compile_features(pisumc PRIVATE c_std_99)

add_executable(pisumfort pisum.f90)
target_link_libraries(pisumfort perf)
add_test(NAME pisumFortran COMMAND pisumfort)
