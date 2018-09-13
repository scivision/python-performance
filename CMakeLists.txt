cmake_minimum_required(VERSION 3.1)
project(bench Fortran)
enable_testing()

# https://software.intel.com/en-us/mkl-developer-reference-fortran-fortran-95-interface-conventions-for-blas-routines

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules/")


if(${CMAKE_Fortran_COMPILER_ID} STREQUAL Intel)

#    message(STATUS "be sure you have in your ~/.bashrc source compilervars.sh")
  list(APPEND FFLAGS -check all -fpe0 -warn -traceback -debug extended)

elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL GNU) # gfortran

    add_compile_options(-mtune=native -Wall -Warray-bounds -Wextra -Wpedantic)
    # -ffpe-trap=zero,overflow,underflow)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL PGI)
  add_compile_options(-Mallocatable=03)
elseif(${CMAKE_Fortran_COMPILER_ID} STREQUAL Flang) # cmake >= 3.10
  add_compile_options(-Mallocatable=03)
  link_libraries(-static-flang-libs)
endif()

add_compile_options(-O3 -g)


add_subdirectory(pisum)
add_subdirectory(matmul)

add_executable(kind kind.f90)
target_compile_options(kind PUBLIC ${FFLAGS})
add_test(NAME kind COMMAND kind)

add_executable(hypot hypot.f90 perf.f90)
target_compile_options(hypot PUBLIC ${FFLAGS})
add_test(NAME hypot COMMAND hypot)

