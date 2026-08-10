rw_add_toolkit(rtvcat DIR tool/vcat
  SOURCES
    rtvcat.cpp
    xbstrip.cpp)
target_compile_options(rtvcat PRIVATE /EHs-c-)

if(RW_VCAT_RUNTIME_VARIANTS AND RW_TARGET STREQUAL "null")
  rw_add_toolkit(rtvcatmd DIR tool/vcat
    PLUGIN rtvcat
    LIBNAME rtvcatmd
    GENERATE_HEADERS OFF
    SOURCES
      rtvcat.cpp
      xbstrip.cpp)
  target_compile_options(rtvcatmd PRIVATE /EHs-c- /MD)
  rw_add_toolkit(rtvcatmt DIR tool/vcat
    PLUGIN rtvcat
    LIBNAME rtvcatmt
    GENERATE_HEADERS OFF
    SOURCES
      rtvcat.cpp
      xbstrip.cpp)
  target_compile_options(rtvcatmt PRIVATE /EHs-c- /MT)
  set(RW_TOOLKIT_LIBS_IN_DIR rtvcat rtvcatmd rtvcatmt PARENT_SCOPE)
else()
  set(RW_TOOLKIT_LIBS_IN_DIR rtvcat PARENT_SCOPE)
endif()
