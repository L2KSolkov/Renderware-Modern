# Runs cl for a code-generation step (rpe preprocessing or assembly output).
# Invoked from add_custom_command with -DRW_* arguments.

set(_args /nologo)
if(RW_EP)
  list(APPEND _args /EP)
else()
  list(APPEND _args /c)
  if(NOT RW_FA)
    message(FATAL_ERROR "rw-run-cl.cmake: RW_FA output required when RW_EP is off")
  endif()
  list(APPEND _args "/Fa${RW_FA}")
endif()

foreach(_d IN LISTS RW_DEFINES)
  list(APPEND _args "/D${_d}")
endforeach()
foreach(_i IN LISTS RW_INCLUDES)
  list(APPEND _args "/I${_i}")
endforeach()
list(APPEND _args "${RW_INPUT}")

set(_out "")
if(RW_EP)
  set(_out OUTPUT_FILE "${RW_OUTPUT}")
endif()

execute_process(COMMAND "${RW_CL}" ${_args} ${_out}
  RESULT_VARIABLE _res)
if(NOT _res EQUAL 0)
  message(FATAL_ERROR "cl codegen step failed with exit code ${_res}")
endif()
