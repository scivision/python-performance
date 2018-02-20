cmake_minimum_required(VERSION 2.8.12)
project(bench Fortran C)

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines


set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)


if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

#    message(STATUS "be sure you have in your ~/.bashrc source compilervars.sh")
  set(FFLAGS ${FFLAGS} -i8 -check all -fpe0 -warn -traceback -debug extended)
 #   set(FCOOPT -coarray)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU) # gfortran

# NOTE: -fdefault-integer-8 -m64  are crucial for MKL using gfortran to avoid SIGSEGV at runtime!
    set(FLAGS ${FLAGS} -Wall -Werror=array-bounds -Wextra -Wpedantic)
    set(FFLAGS ${FFLAGS} -fdefault-integer-8 -m64 -fbacktrace)# -ffpe-trap=zero,overflow,underflow)

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

