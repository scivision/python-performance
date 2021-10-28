# build MKL Lapack95 for non-Intel compiler
include(ExternalProject)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  find_package(LAPACK COMPONENTS MKL LAPACK95 REQUIRED)
  return()
endif()

if(WIN32)
  message(STATUS "SKIP: MKL Lapack 95 on Windows requires Intel compiler")
  return()
endif()

find_package(LAPACK COMPONENTS MKL REQUIRED)

cmake_path(GET CMAKE_Fortran_COMPILER FILENAME FCname)

find_program(MAKE_EXECUTABLE NAMES gmake make REQUIRED)

set(MKL_BLAS95_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/include/intel64/lp64)
set(MKL_BLAS95_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/lib/intel64/libmkl_blas95_lp64.a)

ExternalProject_Add(MKL_LAPACK95
SOURCE_DIR $ENV{MKLROOT}/interfaces/blas95
CONFIGURE_COMMAND ""
# no "-j" make option
BUILD_COMMAND ${MAKE_EXECUTABLE} libintel64 INSTALL_DIR=${CMAKE_CURRENT_BINARY_DIR} interface=lp64 FC=${FCname}
BUILD_IN_SOURCE true
INSTALL_COMMAND ""
BUILD_BYPRODUCTS ${MKL_BLAS95_LIBRARIES}
)

add_dependencies(intelg MKL_LAPACK95)
