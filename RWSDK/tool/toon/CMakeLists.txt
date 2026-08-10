rw_add_toolkit(rttoon DIR tool/toon
  SOURCES rttoon.cpp)
target_compile_options(rttoon PRIVATE /EHs-c-)
set(RW_TOOLKIT_LIBS_IN_DIR rttoon PARENT_SCOPE)
