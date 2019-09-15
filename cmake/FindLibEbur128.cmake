if(LibEbur128_FOUND)
  return()
endif()

if(SYSTEM_LIBEBUR128)
  find_path(EBUR128_INCLUDE_DIR ebur128.h PATH_SUFFIXES ebur128)
  find_library(EBUR128_LIBRARY ebur128)
  mark_as_advanced(EBUR128_INCLUDE_DIR EBUR128_LIBRARY)

  # Detect libebur128's version
  set(EBUR128_H "${EBUR128_INCLUDE_DIR}/ebur128.h")
  if(EXISTS "${EBUR128_H}")
    file(STRINGS "${EBUR128_H}" EBUR128_H_CONTENTS)

    foreach(segment MAJOR MINOR PATCH)
      set(regex "#define EBUR128_VERSION_${segment} ([0-9]+)")
      string(REGEX MATCH "${regex}" match "${EBUR128_H_CONTENTS}")
      string(REGEX REPLACE "${regex}" "\\1" EBUR128_VERSION_${segment} "${match}")
    endforeach()

    set(EBUR128_VERSION
      "${EBUR128_VERSION_MAJOR}.${EBUR128_VERSION_MINOR}.${EBUR128_VERSION_PATCH}")
  endif()
endif()

# Build libebur128 from source
if(NOT EBUR128_INCLUDE_DIR)
  set(EBUR128_SOURCE_DIR "${CMAKE_SOURCE_DIR}/vendor/libebur128")

  set(ENABLE_INTERNAL_QUEUE_H ON)
  set(CMAKE_POLICY_DEFAULT_CMP0042 NEW)
  add_subdirectory(${EBUR128_SOURCE_DIR} EXCLUDE_FROM_ALL)

  set(EBUR128_INCLUDE_DIR "${EBUR128_SOURCE_DIR}/ebur128")
  set(EBUR128_LIBRARY "${EBUR128_SOURCE_DIR}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibEbur128
  REQUIRED_VARS EBUR128_LIBRARY EBUR128_INCLUDE_DIR
  VERSION_VAR   EBUR128_VERSION
)

if(LibEbur128_FOUND)
  if(EBUR128_SOURCE_DIR)
    add_library(EBUR128::EBUR128 ALIAS ebur128_static)
  else()
    message(FATAL_ERROR TODO)
  endif()
endif()
