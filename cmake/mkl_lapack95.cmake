# build MKL Lapack95 for non-Intel compiler
include(ExternalProject)

find_package(LAPACK COMPONENTS MKL LAPACK95 REQUIRED)

if(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  return()
endif()

if(WIN32)
  message(STATUS "SKIP: MKL Lapack 95 on Windows requires Intel compiler")
  return()
endif()


find_program(MAKE_EXECUTABLE NAMES gmake make REQUIRED)

set(BLAS95_INCLUDE_DIRS ${CMAKE_CURRENT_BINARY_DIR}/include/intel64/lp64)
set(BLAS95_LIBRARIES ${CMAKE_CURRENT_BINARY_DIR}/lib/intel64/libmkl_blas95_lp64.a mkl_intel_lp64 mkl_sequential mkl_core)

ExternalProject_Add(MKL_LAPACK95
SOURCE_DIR $ENV{MKLROOT}/interfaces/blas95
CONFIGURE_COMMAND ""
# no "-j" make option
BUILD_COMMAND ${MAKE_EXECUTABLE} libintel64 INSTALL_DIR=${CMAKE_CURRENT_BINARY_DIR} interface=lp64 FC=${CMAKE_Fortran_COMPILER}
INSTALL_COMMAND ${MAKE_EXECUTABLE} install
BUILD_BYPRODUCTS ${MKL_LAPACK95_LIBRARIES}
)

add_dependencies(MKL_LAPACK95 intelg)
