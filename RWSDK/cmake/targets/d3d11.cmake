# makeincl/rwtarget/d3d11/maketarg - D3D11 target.
#
# Unlike d3d8/d3d9 there is no legacy DirectX SDK dependency: d3d11.h,
# dxgi.h and d3dcompiler.h all ship in the modern Windows SDK.

set(RW_GENERIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/common/palquant.c"
    "${RW_SRC_ROOT}/driver/common/cpuext.c")
if(NOT RW_NOASM)
  list(APPEND RW_GENERIC_DRV_SRC "${RW_SRC_ROOT}/driver/common/ssematml.c")
endif()

set(RW_SPECIFIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/d3d11/d3d11device.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d112drend.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d11convrt.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d11dxttex.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d11raster.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d11rendst.c"
    "${RW_SRC_ROOT}/driver/d3d11/d3d11texdic.c")
if(RW_METRICS)
  list(APPEND RW_SPECIFIC_DRV_SRC "${RW_SRC_ROOT}/driver/d3d11/d3d11metric.c")
endif()

set(RW_GENERIC_DRV_ASM_SRC
    "${RW_SRC_ROOT}/driver/common/baprocfp.asm"
    "${RW_SRC_ROOT}/driver/common/x86matml.asm"
    "${RW_SRC_ROOT}/driver/common/x86matvc.asm")

set(RW_DRV_LIBS d3d11 dxgi dxguid)
if(RW_DLL)
  set(RW_DLL_DRV_LIBS ${RW_DRV_LIBS})
  set(RW_DRV_LIBS "")
endif()

set(RW_DRV_INC
    "${RW_SRC_ROOT}/driver/d3d11"
    "${RW_SRC_ROOT}/world")
set(RW_DRV_DEF "")

# No d3dx equivalent exists; the utilities d3dx9 supplied for D3D9 are
# replaced in the D3D11 pipeline sources themselves.
set(RW_WORLD_LIBS "")
