# Selects the operating-system and render-target definitions, mirroring
#   makeincl/rwos/$(RWOS)/makeos
#   makeincl/rwtarget/$(RWTARGET)/maketarg
#   makeincl/rwtarget/pipe/$(PIPETYPE)/maketarg

set(RW_PLATFORM_CMAKE "${CMAKE_CURRENT_LIST_DIR}/platforms/${RW_OS}.cmake")
if(NOT EXISTS "${RW_PLATFORM_CMAKE}")
  message(FATAL_ERROR
    "RW_OS=${RW_OS} is unknown. Implement cmake/platforms/${RW_OS}.cmake.")
endif()
include("${RW_PLATFORM_CMAKE}")

set(RW_TARGET_CMAKE "${CMAKE_CURRENT_LIST_DIR}/targets/${RW_TARGET}.cmake")
if(NOT EXISTS "${RW_TARGET_CMAKE}")
  message(FATAL_ERROR
    "RW_TARGET=${RW_TARGET} is not implemented. "
    "Fill in cmake/targets/${RW_TARGET}.cmake (see makeincl/rwtarget/${RW_TARGET}/maketarg).")
endif()
include("${RW_TARGET_CMAKE}")

if(RW_PIPETYPE STREQUAL "p2")
  include("${CMAKE_CURRENT_LIST_DIR}/pipes-p2.cmake")
elseif(RW_PIPETYPE STREQUAL "generic")
  message(FATAL_ERROR
    "RW_PIPETYPE=generic is reserved; no generic pipeline sources ship in this drop.")
else()
  message(FATAL_ERROR "RW_PIPETYPE=${RW_PIPETYPE} is unknown.")
endif()

# Full include list used for code generation (rpe preprocessing and incgen).
# Matches CFLAGS = -I. -I$(SDKINCDIR) $(C_INC) with the per-call "." and
# SDKINCDIR entries added by the callers.
set(RW_CODEGEN_INC ${RW_C_INC} ${RW_DRV_INC})
set(RW_CODEGEN_DEFINES ${RW_BASE_DEFINES} ${RW_FEATURE_DEFINES})
