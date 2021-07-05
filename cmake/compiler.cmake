if(CMAKE_Fortran_COMPILER_ID MATCHES Intel)
  if(WIN32)
    string(APPEND CMAKE_Fortran_FLAGS " /warn /heap-arrays")
    add_compile_options(/QxHost)
  else()
    string(APPEND CMAKE_Fortran_FLAGS " -warn -heap-arrays")
    add_compile_options(-xHost)
  endif()

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -traceback -debug extended -check all -fpe0")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")

  add_compile_options(-march=native -Wall -Wextra)

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -ffpe-trap=zero,overflow,underflow")
endif()
