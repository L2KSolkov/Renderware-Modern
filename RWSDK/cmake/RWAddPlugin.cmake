# rw_add_plugin() - analogue of makeincl/makeplug.
#
# Handles the implicit <plugin>.c (or .cpp when only that exists), the
# u<plugin> rpdbgerr.c object when RW_DEBUG is on, .rpe + public-header
# generation (inline for PLUGINAPI plugins, plain copy otherwise), per-target
# source selection and library naming (LIBNAME != PLUGIN for variants).

function(rw_add_plugin NAME)
  cmake_parse_arguments(P
    ""
    "DIR;PLUGIN;LIBNAME;PLUGINAPI;GENERATE_HEADERS"
    "SOURCES;TARGET_SOURCES;GENERIC_SOURCES;EXTRA_INCLUDES;EXTRA_DEFINES;PLUGININCDIR"
    ${ARGN})

  if(NOT P_DIR)
    message(FATAL_ERROR "rw_add_plugin(${NAME}): DIR is required")
  endif()
  if(NOT P_PLUGIN)
    set(P_PLUGIN "${NAME}")
  endif()
  if(NOT P_LIBNAME)
    set(P_LIBNAME "${P_PLUGIN}")
  endif()
  set(_dir "${RW_SRC_ROOT}/${P_DIR}")

  # implicit $(CURDIR)/$(PLUGIN).c added by makeplug; rttoon/rtvcat only have
  # the .cpp variant, which make resolves through the C++ suffix rule.
  set(_implicit "")
  if(EXISTS "${_dir}/${P_PLUGIN}.c")
    set(_implicit "${_dir}/${P_PLUGIN}.c")
  elseif(EXISTS "${_dir}/${P_PLUGIN}.cpp")
    set(_implicit "${_dir}/${P_PLUGIN}.cpp")
  endif()

  # per-target source selection: $(RWTARGET)CSRC falls back to genericCSRC
  set(_selected ${P_GENERIC_SOURCES})
  foreach(_entry IN LISTS P_TARGET_SOURCES)
    if(_entry MATCHES "^([A-Za-z0-9_]+)=(.*)$")
      if(RW_TARGET STREQUAL CMAKE_MATCH_1)
        set(_selected ${CMAKE_MATCH_2})
      endif()
    endif()
  endforeach()

  set(_srcs ${_implicit} ${P_SOURCES} ${_selected})
  if(RW_DEBUG)
    list(APPEND _srcs "${RW_GEN_INCDIR}/rpdbgerr.c")
  endif()
  if(_srcs)
    list(REMOVE_DUPLICATES _srcs)
  endif()

  add_library(${NAME} STATIC ${_srcs})
  # -I. comes before -I$(SDKINCDIR) in the make system; the local private
  # header (e.g. plugin/ltmap/rpltmap.h) must shadow the generated one.
  target_include_directories(${NAME} PRIVATE "${_dir}")
  rw_setup_target(${NAME})
  target_include_directories(${NAME} PRIVATE ${P_EXTRA_INCLUDES})
  target_compile_definitions(${NAME} PRIVATE ${P_EXTRA_DEFINES})
  set_target_properties(${NAME} PROPERTIES
    OUTPUT_NAME "${RW_LIB_PREFIX}${P_LIBNAME}${RW_LIB_SUFFIX}")

  set(_rpe "${RW_GEN_INCDIR}/${P_PLUGIN}.rpe")
  set(_hdr "${RW_GEN_INCDIR}/${P_PLUGIN}.h")
  if(NOT P_GENERATE_HEADERS STREQUAL "OFF")
    # --- rpe + public header (generated once per plugin family; variants
    #     such as rpskinmatfx share the rpskin.h/rpskin.rpe outputs)
    rw_generate_rpe(NAME "${NAME}_rpe" PLUGIN_DIR "${_dir}" PLUGIN "${P_PLUGIN}"
      EXTRA_INCLUDES ${P_EXTRA_INCLUDES})

    if(P_PLUGINAPI)
      set(_inline_out "${CMAKE_BINARY_DIR}/plugin-headers/${NAME}.${RW_TARGET}.h")
      set(_incdirs ${P_PLUGININCDIR})
      if(NOT _incdirs)
        if(RW_TARGET MATCHES "null")
          set(_incdirs "." "./null")
        else()
          set(_incdirs "." "./${RW_TARGET}")
        endif()
      endif()
      rw_generate_inline_header(NAME "${NAME}_inline"
        API_FILE "${_dir}/${P_PLUGINAPI}"
        OUTPUT "${_inline_out}"
        WORKING_DIR "${_dir}"
        INC_DIRS ${_incdirs})
      rw_copy_generated_file(NAME "${NAME}_hdr"
        INPUT "${_inline_out}"
        OUTPUT "${_hdr}"
        DEPENDS "${_rpe}")
    else()
      if(NOT EXISTS "${_dir}/${P_PLUGIN}.h")
        message(FATAL_ERROR "rw_add_plugin(${NAME}): no ${P_PLUGIN}.h in ${_dir} and no PLUGINAPI")
      endif()
      rw_copy_generated_file(NAME "${NAME}_hdr"
        INPUT "${_dir}/${P_PLUGIN}.h"
        OUTPUT "${_hdr}"
        DEPENDS "${_rpe}")
    endif()
  endif()

  # make the header dependencies flow into the library build
  target_sources(${NAME} PRIVATE "${_hdr}" "${_rpe}")
endfunction()
