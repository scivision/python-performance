if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)
  if(WIN32)
    list(APPEND FFLAGS /warn /heap-arrays)
  else()
    list(APPEND FFLAGS -warn -heap-arrays)
  endif()

  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -traceback -debug extended -check all -fpe0)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  list(APPEND FFLAGS -fimplicit-none)

  add_compile_options(-mtune=native -Wall -Wextra -Wpedantic)

  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -ffpe-trap=zero,overflow,underflow)
  endif()
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)
  list(APPEND FFLAGS -Mdclchk)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)

endif()
