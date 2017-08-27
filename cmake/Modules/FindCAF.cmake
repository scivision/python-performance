# https://github.com/certik/hermes/blob/master/hermes_common/cmake/FindSCALAPACK.cmake
# ScaLAPACK and BLACS
#

find_path(CAF_DIR libcoarrays HINTS ENV CAF_DIR)

FIND_LIBRARY(CAF_LIBRARY  NAMES caf_mpi 
                          PATHS /usr/lib64 /usr/lib /usr/local/lib64 /usr/local/lib
                          HINTS ${CAF_DIR})



# Report the found libraries, quit with fatal error if any required library has not been found.
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CAF DEFAULT_MSG CAF_LIBRARY)

SET(CAF_LIBRARIES ${CAF_LIBRARY})
