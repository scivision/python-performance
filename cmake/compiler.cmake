if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

#    message(STATUS "be sure you have in your ~/.bashrc source compilervars.sh")
  list(APPEND FFLAGS -check all -fpe0 -warn -traceback -debug extended)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU) # gfortran

    add_compile_options(-mtune=native -Wall -Wextra -Wpedantic)
    # -ffpe-trap=zero,overflow,underflow)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang) # cmake >= 3.10
  add_compile_options(-Mallocatable=03)
  link_libraries(-static-flang-libs)
endif()
