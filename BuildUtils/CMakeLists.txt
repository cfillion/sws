set(LANGPACK_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/SWS_Template.ReaperLangPack)

add_executable(build-langpack EXCLUDE_FROM_ALL BuildLangpack.cpp)

find_package(WDL REQUIRED)
target_include_directories(build-langpack PRIVATE ${WDL_INCLUDE_DIR})

get_property(LANGPACK_SOURCES TARGET sws PROPERTY SOURCES)
list(REMOVE_ITEM LANGPACK_SOURCES reascript_vararg.h)
list(TRANSFORM LANGPACK_SOURCES PREPEND "${CMAKE_SOURCE_DIR}/" REGEX "^[^/][^:]")

add_custom_command(
  OUTPUT ${LANGPACK_OUTPUT}
  COMMAND build-langpack --template ${LANGPACK_SOURCES} > ${LANGPACK_OUTPUT}
  DEPENDS ${LANGPACK_SOURCES}
  COMMAND_EXPAND_LISTS
)

add_custom_target(langpack DEPENDS ${LANGPACK_OUTPUT})
add_dependencies(langpack build-langpack)
