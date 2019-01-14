if(CMAKE_BUILD_TYPE STREQUAL Debug)
  add_compile_options(-O0)
else()
  add_compile_options(-O3)
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)

  list(APPEND FFLAGS -implicitnone)

  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -warn -traceback -debug extended -check all -fpe0)
  endif()

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)

    list(APPEND FFLAGS -fimplicit-none)
    
    add_compile_options(-mtune=native -Wall -Wextra -Wpedantic)
    
    if(CMAKE_BUILD_TYPE STREQUAL Debug)
      list(APPEND FFLAGS -ffpe-trap=zero,overflow,underflow)
    endif()
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang)
  list(APPEND FFLAGS -Mallocatable=03)
endif()
