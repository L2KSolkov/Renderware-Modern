# Common per-target setup shared by the core, world, plugin and toolkit
# libraries. Mirrors the CFLAGS stack built by makeopt + maketarg + makecom.

function(rw_setup_target tgt)
  cmake_parse_arguments(RW "NO_ZL" "" "" ${ARGN})
  set(_base_flags ${RW_BASE_C_FLAGS})
  if(RW_NO_ZL)
    # /Zl suppresses the compiler's default-library directives; static
    # libraries want that, executables do not (they need the CRT to be
    # linked, and MSBuild relies on the .drectve from /MT).
    list(REMOVE_ITEM _base_flags /Zl)
  endif()
  target_compile_definitions(${tgt} PRIVATE
    ${RW_BASE_DEFINES}
    ${RW_FEATURE_DEFINES}
    ${RW_DRV_DEF})
  target_include_directories(${tgt} PRIVATE
    "${RW_GEN_INCDIR}"
    ${RW_C_INC}
    ${RW_DRV_INC})
  target_compile_options(${tgt} PRIVATE
    ${_base_flags}
    ${RW_CONFIG_FLAGS})
endfunction()

# Records an output file so the top-level rw-headers/rw-equate aggregate
# targets can depend on it.
function(rw_record_output property file)
  set_property(GLOBAL APPEND PROPERTY "${property}" "${file}")
endfunction()
