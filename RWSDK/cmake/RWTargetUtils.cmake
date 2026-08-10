# Common per-target setup shared by the core, world, plugin and toolkit
# libraries. Mirrors the CFLAGS stack built by makeopt + maketarg + makecom.

function(rw_setup_target tgt)
  target_compile_definitions(${tgt} PRIVATE
    ${RW_BASE_DEFINES}
    ${RW_FEATURE_DEFINES}
    ${RW_DRV_DEF})
  target_include_directories(${tgt} PRIVATE
    "${RW_GEN_INCDIR}"
    ${RW_C_INC}
    ${RW_DRV_INC})
  target_compile_options(${tgt} PRIVATE
    ${RW_BASE_C_FLAGS}
    ${RW_CONFIG_FLAGS})
endfunction()

# Records an output file so the top-level rw-headers/rw-equate aggregate
# targets can depend on it.
function(rw_record_output property file)
  set_property(GLOBAL APPEND PROPERTY "${property}" "${file}")
endfunction()
