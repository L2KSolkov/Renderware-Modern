# makeincl/rwtarget/opengl/maketarg (Windows build)

set(RW_GENERIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/common/datblkcb.c"
    "${RW_SRC_ROOT}/driver/common/palquant.c"
    "${RW_SRC_ROOT}/driver/common/cpuext.c")
if(NOT RW_NOASM AND NOT RW_NOSSEASM)
  list(APPEND RW_GENERIC_DRV_SRC "${RW_SRC_ROOT}/driver/common/ssematml.c")
endif()

set(RW_SPECIFIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/opengl/baim2dgl.c"
    "${RW_SRC_ROOT}/driver/opengl/barstate.c"
    "${RW_SRC_ROOT}/driver/opengl/baconvgl.c"
    "${RW_SRC_ROOT}/driver/opengl/baintogl.c"
    "${RW_SRC_ROOT}/driver/opengl/barastgl.c"
    "${RW_SRC_ROOT}/driver/opengl/bantexgl.c"
    "${RW_SRC_ROOT}/driver/opengl/badxtgl.c"
    "${RW_SRC_ROOT}/driver/opengl/basprigl.c"
    "${RW_SRC_ROOT}/driver/opengl/bastdogl.c"
    "${RW_SRC_ROOT}/driver/opengl/bautilgl.c"
    "${RW_SRC_ROOT}/driver/opengl/bavagl.c"
    "${RW_SRC_ROOT}/driver/opengl/bawinogl.c")

set(RW_GENERIC_DRV_ASM_SRC
    "${RW_SRC_ROOT}/driver/common/baprocfp.asm"
    "${RW_SRC_ROOT}/driver/common/x86matml.asm"
    "${RW_SRC_ROOT}/driver/common/x86matvc.asm")

if(RW_OGL_LIB_PATH)
  set(RW_DRV_LIBS "${RW_OGL_LIB_PATH}/opengl32.lib")
else()
  set(RW_DRV_LIBS opengl32)
endif()
if(RW_DLL)
  set(RW_DLL_DRV_LIBS ${RW_DRV_LIBS})
  set(RW_DRV_LIBS "")
endif()

set(RW_DRV_INC
    "${RW_SRC_ROOT}/driver/opengl"
    "${RW_SRC_ROOT}/world")
set(RW_DRV_DEF USE_OGL_PIPE)
