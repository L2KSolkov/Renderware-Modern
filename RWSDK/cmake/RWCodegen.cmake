# Code generation, replacing the pattern rules in makeopt (rpe), makecore /
# makewrld (incgen public headers) and makeplug (inline plugin headers), plus
# the baequate.i offsets step from makecore.

##-------------------------------------------------------------------- rpe
# Preprocess src/plcore/rperror.h with the plugin's include dir on the path so
# the plugin's own rpplugin.h and rperror.def are picked up (makeopt
# "$(SDKINCDIR)/$(PLUGIN).rpe: $(SDKINCDIR)/rperror.h").
function(rw_generate_rpe)
  cmake_parse_arguments(RPE "" "NAME;PLUGIN_DIR;PLUGIN" "EXTRA_INCLUDES" ${ARGN})
  if(NOT RPE_NAME OR NOT RPE_PLUGIN_DIR OR NOT RPE_PLUGIN)
    message(FATAL_ERROR "rw_generate_rpe: NAME, PLUGIN_DIR and PLUGIN are required")
  endif()
  set(NAME "${RPE_NAME}")
  set(PLUGIN_DIR "${RPE_PLUGIN_DIR}")
  set(PLUGIN "${RPE_PLUGIN}")

  set(_input "${RW_SRC_ROOT}/src/plcore/rperror.h")
  set(_out "${RW_GEN_INCDIR}/${PLUGIN}.rpe")
  set(_incs "${PLUGIN_DIR}" "${RW_GEN_INCDIR}" ${RW_CODEGEN_INC}
            ${RPE_EXTRA_INCLUDES})
  set(_norm_incs "")
  foreach(_inc IN LISTS _incs)
    get_filename_component(_abs "${_inc}" ABSOLUTE BASE_DIR "${PLUGIN_DIR}")
    list(APPEND _norm_incs "${_abs}")
  endforeach()
  set(_incs ${_norm_incs})

  add_custom_command(OUTPUT "${_out}"
    COMMAND "${CMAKE_COMMAND}"
            "-DRW_CL=${CMAKE_C_COMPILER}"
            "-DRW_EP=ON"
            "-DRW_DEFINES=${RW_CODEGEN_DEFINES}"
            "-DRW_INCLUDES=${_incs}"
            "-DRW_INPUT=${_input}"
            "-DRW_OUTPUT=${_out}"
            -P "${RW_SRC_ROOT}/cmake/rw-run-cl.cmake"
    DEPENDS "${_input}"
            "${PLUGIN_DIR}/rpplugin.h"
            "${PLUGIN_DIR}/rperror.def"
            "${RW_GEN_INCDIR}/rwversion.h"
            "${RW_GEN_INCDIR}/rpcriter.h"
            "${RW_GEN_INCDIR}/rperror.h"
            "${RW_GEN_INCDIR}/rwplcore.h"
            "${RW_GEN_INCDIR}/rwcore.h"
    COMMENT "Generating ${PLUGIN}.rpe"
    VERBATIM)
  rw_record_output(RW_HEADER_OUTPUT_FILES "${_out}")
  add_custom_target("${NAME}" DEPENDS "${_out}")
  rw_record_output(RW_HEADER_TARGETS "${NAME}")
  set(RW_RPE_OUTPUT "${_out}" PARENT_SCOPE)
endfunction()

##----------------------------------------------------- incgen public header
function(rw_generate_incgen_header)
  cmake_parse_arguments(INC ""
    "NAME;PLUGIN;GUARD;INPUTS_FIRST;OUTPUT;LISTFILE"
    "INCLUDE_DIRS;INPUTS;SYS"
    ${ARGN})
  if(NOT INC_OUTPUT)
    message(FATAL_ERROR "rw_generate_incgen_header: OUTPUT is required")
  endif()
  set(NAME "${INC_NAME}")
  set(OUTPUT "${INC_OUTPUT}")
  set(LISTFILE "${INC_LISTFILE}")

  set(_args "")
  if(INC_INPUTS_FIRST)
    foreach(_f IN LISTS INC_INPUTS)
      list(APPEND _args "${_f}")
    endforeach()
  endif()
  foreach(_d IN LISTS INC_INCLUDE_DIRS)
    list(APPEND _args "-I${_d}")
  endforeach()
  if(NOT INC_INPUTS_FIRST)
    foreach(_f IN LISTS INC_INPUTS)
      list(APPEND _args "${_f}")
    endforeach()
  endif()
  foreach(_s IN LISTS INC_SYS)
    list(APPEND _args "-s${_s}")
  endforeach()
  if(INC_PLUGIN)
    list(APPEND _args "-p${INC_PLUGIN}")
  endif()
  list(APPEND _args "-o${OUTPUT}")
  if(LISTFILE)
    list(APPEND _args "-l${LISTFILE}")
  endif()
  if(INC_GUARD)
    list(APPEND _args "-g${INC_GUARD}")
  endif()

  # incgen prints "Unable to Open" and skips missing inputs; replicate that
  # behaviour instead of failing the configure.
  set(_existing_inputs "")
  foreach(_f IN LISTS INC_INPUTS)
    if(EXISTS "${_f}")
      list(APPEND _existing_inputs "${_f}")
    endif()
  endforeach()
  set(INC_INPUTS ${_existing_inputs})

  add_custom_command(OUTPUT "${OUTPUT}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_BINARY_DIR}/lists"
    COMMAND "$<TARGET_FILE:incgen>" ${_args}
    DEPENDS incgen ${INC_INPUTS}
    COMMENT "Generating ${OUTPUT}"
    VERBATIM)
  rw_record_output(RW_HEADER_OUTPUT_FILES "${OUTPUT}")
  add_custom_target("${NAME}" DEPENDS "${OUTPUT}")
  rw_record_output(RW_HEADER_TARGETS "${NAME}")
  set(RW_INCGEN_OUTPUT "${OUTPUT}" PARENT_SCOPE)
endfunction()

##----------------------------------------------------- inline plugin header
function(rw_generate_inline_header)
  cmake_parse_arguments(INL "" "NAME;API_FILE;OUTPUT;WORKING_DIR" "INC_DIRS" ${ARGN})
  if(NOT INL_API_FILE OR NOT INL_OUTPUT OR NOT INL_WORKING_DIR)
    message(FATAL_ERROR "rw_generate_inline_header: API_FILE, OUTPUT and WORKING_DIR are required")
  endif()
  set(NAME "${INL_NAME}")
  set(API_FILE "${INL_API_FILE}")
  set(OUTPUT "${INL_OUTPUT}")
  set(WORKING_DIR "${INL_WORKING_DIR}")
  set(_args "-I${API_FILE}" "-O${OUTPUT}" ${INL_INC_DIRS})
  add_custom_command(OUTPUT "${OUTPUT}"
    COMMAND "$<TARGET_FILE:inline>" ${_args}
    WORKING_DIRECTORY "${WORKING_DIR}"
    DEPENDS inline "${API_FILE}"
    COMMENT "Generating inline header ${OUTPUT}"
    VERBATIM)
  rw_record_output(RW_HEADER_OUTPUT_FILES "${OUTPUT}")
  add_custom_target("${NAME}" DEPENDS "${OUTPUT}")
  rw_record_output(RW_HEADER_TARGETS "${NAME}")
  set(RW_INLINE_OUTPUT "${OUTPUT}" PARENT_SCOPE)
endfunction()

##------------------------------------------------------------ file copies
function(rw_copy_generated_file)
  cmake_parse_arguments(CP "" "NAME;INPUT;OUTPUT" "DEPENDS" ${ARGN})
  if(NOT CP_INPUT OR NOT CP_OUTPUT)
    message(FATAL_ERROR "rw_copy_generated_file: INPUT and OUTPUT are required")
  endif()
  set(NAME "${CP_NAME}")
  set(INPUT "${CP_INPUT}")
  set(OUTPUT "${CP_OUTPUT}")
  add_custom_command(OUTPUT "${OUTPUT}"
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${INPUT}" "${OUTPUT}"
    DEPENDS "${INPUT}" ${CP_DEPENDS}
    COMMENT "Installing generated file ${OUTPUT}"
    VERBATIM)
  rw_record_output(RW_HEADER_OUTPUT_FILES "${OUTPUT}")
  add_custom_target("${NAME}" DEPENDS "${OUTPUT}")
  rw_record_output(RW_HEADER_TARGETS "${NAME}")
  set(RW_COPY_OUTPUT "${OUTPUT}" PARENT_SCOPE)
endfunction()

##----------------------------------------------------------------- equate
# makecore: compile driver/common/baequ.c to assembly then run findsyms to
# produce driver/<target>/baequate.i. The generated file lands under the build
# tree (the make system wrote it into the source tree); the MASM include path
# points at the build-tree copy.
function(rw_generate_equate)
  if(RW_NOASM)
    return()
  endif()
  set(_asm_dir "${CMAKE_BINARY_DIR}/driver/${RW_TARGET}")
  set(_asm "${CMAKE_BINARY_DIR}/obj/baequ.s")
  set(_out "${_asm_dir}/baequate.i")

  add_custom_command(OUTPUT "${_asm}"
    COMMAND "${CMAKE_COMMAND}"
            "-DRW_CL=${CMAKE_C_COMPILER}"
            "-DRW_EP=OFF"
            "-DRW_FA=${_asm}"
            "-DRW_DEFINES=${RW_CODEGEN_DEFINES}"
            "-DRW_INCLUDES=${RW_GEN_INCDIR};${RW_C_INC};${RW_DRV_INC};${RW_PIPE_INC}"
            "-DRW_INPUT=${RW_SRC_ROOT}/driver/common/baequ.c"
            -P "${RW_SRC_ROOT}/cmake/rw-run-cl.cmake"
    DEPENDS "${RW_SRC_ROOT}/driver/common/baequ.c"
            "${RW_GEN_INCDIR}/rwplcore.h"
            "${RW_GEN_INCDIR}/rwcore.h"
    COMMENT "Compiling baequ.c to assembly"
    VERBATIM)

  add_custom_command(OUTPUT "${_out}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${_asm_dir}"
    COMMAND "$<TARGET_FILE:findsyms>" "-Fi${_asm}" "-Fo${_out}" -Aml
    DEPENDS findsyms "${_asm}"
    COMMENT "Generating baequate.i (findsyms)"
    VERBATIM)
  rw_record_output(RW_EQUATE_OUTPUT_FILES "${_out}")
  add_custom_target(rw-equate-step DEPENDS "${_out}")
  rw_record_output(RW_EQUATE_TARGETS rw-equate-step)
  set(RW_EQUATE_OUTPUT "${_out}" PARENT_SCOPE)
endfunction()

##----------------------------------------------------- core header copies
# makecore COREHFILES: rwversion.h, rpcriter.h, rpdbgerr.c, rpdbgerr.h,
# rperror.h, errcom.def, errcore.def from src/plcore into the SDK include dir.
function(rw_copy_core_headers)
  set(_core_hfiles
    rwversion.h rpcriter.h rpdbgerr.c rpdbgerr.h rperror.h
    errcom.def errcore.def)
  foreach(_f IN LISTS _core_hfiles)
    set(_in "${RW_SRC_ROOT}/src/plcore/${_f}")
    set(_out "${RW_GEN_INCDIR}/${_f}")
    add_custom_command(OUTPUT "${_out}"
      COMMAND "${CMAKE_COMMAND}" -E copy_if_different "${_in}" "${_out}"
      DEPENDS "${_in}"
      VERBATIM)
    rw_record_output(RW_HEADER_OUTPUT_FILES "${_out}")
    add_custom_target("rw-corehdr-${_f}" DEPENDS "${_out}")
    rw_record_output(RW_HEADER_TARGETS "rw-corehdr-${_f}")
  endforeach()
endfunction()
