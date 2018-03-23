cmake_minimum_required(VERSION 3.0)
project(bench Fortran)

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines


list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")


if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

#    message(STATUS "be sure you have in your ~/.bashrc source compilervars.sh")
  list(APPEND FFLAGS -check all -fpe0 -warn -traceback -debug extended)
 #   set(FCOOPT -coarray)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU) # gfortran

    list(APPEND FLAGS -Wall -Werror=array-bounds -Wextra -Wpedantic)
    # -ffpe-trap=zero,overflow,underflow)

  #  find_package(CAF)
  #  if(CAF_FOUND)
  #      set(FCOOPT -fcoarray=lib)
  #      set(FCOLIB caf_mpi)
  #  else()
  #     set(FCOOPT -fcoarray=single)
  #  endif()

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI) # flang

endif()

add_compile_options(-g -mtune=native ${FLAGS})


add_subdirectory(pisum)
add_subdirectory(matmul)

add_executable(kind kind.f90)
target_compile_options(kind PUBLIC ${FFLAGS})

add_executable(hypot hypot.f90 perf.f90)
target_compile_options(hypot PUBLIC ${FFLAGS})
#-------------------------
enable_testing()

add_test(NAME kind COMMAND kind)
add_test(NAME hypot COMMAND hypot)
