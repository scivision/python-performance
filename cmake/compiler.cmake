if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  add_compile_options(
  "$<IF:$<BOOL:${WIN32}>,/QxHost,-xHost>"
  "$<$<COMPILE_LANGUAGE:Fortran>:-warn;-heap-arrays>"
  "$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-traceback;-debug;-check;-fpe0>"
  )
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  add_compile_options(-march=native -Wall -Wextra
  $<$<COMPILE_LANGUAGE:Fortran>:-fimplicit-none>
  "$<$<AND:$<COMPILE_LANGUAGE:Fortran>,$<CONFIG:Debug>>:-ffpe-trap=zero,overflow,underflow>"
  )
endif()
