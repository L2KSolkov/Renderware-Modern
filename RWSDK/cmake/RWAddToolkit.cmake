# rw_add_toolkit() - analogue of makeincl/maketool.
#
# Nearly identical to makeplug: the public header is always a copy of the
# local <plugin>.h and the docs land under the tool directory. Toolkit
# libraries never use the inline PLUGINAPI mechanism.

function(rw_add_toolkit NAME)
  cmake_parse_arguments(T
    ""
    "DIR;PLUGIN;LIBNAME;GENERATE_HEADERS"
    "SOURCES;TARGET_SOURCES;GENERIC_SOURCES;EXTRA_INCLUDES;EXTRA_DEFINES"
    ${ARGN})

  if(NOT T_DIR)
    message(FATAL_ERROR "rw_add_toolkit(${NAME}): DIR is required")
  endif()
  if(NOT T_PLUGIN)
    set(T_PLUGIN "${NAME}")
  endif()
  if(NOT T_LIBNAME)
    set(T_LIBNAME "${T_PLUGIN}")
  endif()
  set(_dir "${RW_SRC_ROOT}/${T_DIR}")

  set(_implicit "")
  if(EXISTS "${_dir}/${T_PLUGIN}.c")
    set(_implicit "${_dir}/${T_PLUGIN}.c")
  elseif(EXISTS "${_dir}/${T_PLUGIN}.cpp")
    set(_implicit "${_dir}/${T_PLUGIN}.cpp")
  endif()

  set(_selected ${T_GENERIC_SOURCES})
  set(_cur_target "")
  set(_cur_files "")
  foreach(_entry IN LISTS T_TARGET_SOURCES)
    if(_entry MATCHES "^([A-Za-z0-9_]+)=(.*)$")
      if(NOT _cur_target STREQUAL "" AND RW_TARGET STREQUAL _cur_target)
        set(_selected ${_cur_files})
      endif()
      set(_cur_target "${CMAKE_MATCH_1}")
      set(_cur_files "${CMAKE_MATCH_2}")
    else()
      list(APPEND _cur_files "${_entry}")
    endif()
  endforeach()
  if(NOT _cur_target STREQUAL "" AND RW_TARGET STREQUAL _cur_target)
    set(_selected ${_cur_files})
  endif()

  set(_srcs ${_implicit} ${T_SOURCES} ${_selected})
  if(RW_DEBUG)
    list(APPEND _srcs "${RW_GEN_INCDIR}/rpdbgerr.c")
  endif()
  if(_srcs)
    list(REMOVE_DUPLICATES _srcs)
  endif()

  add_library(${NAME} STATIC ${_srcs})
  target_include_directories(${NAME} PRIVATE "${_dir}")
  rw_setup_target(${NAME})
  target_include_directories(${NAME} PRIVATE ${T_EXTRA_INCLUDES})
  target_compile_definitions(${NAME} PRIVATE ${T_EXTRA_DEFINES})
  set_target_properties(${NAME} PROPERTIES
    OUTPUT_NAME "${RW_LIB_PREFIX}${T_LIBNAME}${RW_LIB_SUFFIX}")
  add_dependencies(${NAME} rw-headers)

  set(_rpe "${RW_GEN_INCDIR}/${T_PLUGIN}.rpe")
  set(_hdr "${RW_GEN_INCDIR}/${T_PLUGIN}.h")
  if(NOT T_GENERATE_HEADERS STREQUAL "OFF")
    rw_generate_rpe(NAME "${NAME}_rpe" PLUGIN_DIR "${_dir}" PLUGIN "${T_PLUGIN}"
      EXTRA_INCLUDES ${T_EXTRA_INCLUDES})
    if(NOT EXISTS "${_dir}/${T_PLUGIN}.h")
      message(FATAL_ERROR "rw_add_toolkit(${NAME}): no ${T_PLUGIN}.h in ${_dir}")
    endif()
    rw_copy_generated_file(NAME "${NAME}_hdr"
      INPUT "${_dir}/${T_PLUGIN}.h"
      OUTPUT "${_hdr}"
      DEPENDS "${_rpe}")
  endif()

  target_sources(${NAME} PRIVATE "${_hdr}" "${_rpe}")
endfunction()
