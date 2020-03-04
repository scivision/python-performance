if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    string(APPEND CMAKE_Fortran_FLAGS " /warn /heap-arrays")
  else()
    string(APPEND CMAKE_Fortran_FLAGS " -warn -heap-arrays")
  endif()

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -traceback -debug extended -check all -fpe0")
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  string(APPEND CMAKE_Fortran_FLAGS " -fimplicit-none")

  add_compile_options(-mtune=native -Wall -Wextra)

  string(APPEND CMAKE_Fortran_FLAGS_DEBUG " -ffpe-trap=zero,overflow,underflow")

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)
  string(APPEND CMAKE_Fortran_FLAGS " -Mdclchk")
endif()
