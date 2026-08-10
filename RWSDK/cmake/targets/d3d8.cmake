# makeincl/rwtarget/d3d8/maketarg

find_legacy_dxsdk()

# The legacy SDK's Include directory also ships stale system headers
# (rpcndr.h, objidlbase.h, ...) that clash with the modern Windows SDK. Stage
# only the d3d8 headers into a compat dir so system headers resolve from the
# Kits while d3d8.h still comes from the legacy SDK.
set(RW_D3D8_COMPAT "${CMAKE_BINARY_DIR}/dxsdk-compat-d3d8")
file(MAKE_DIRECTORY "${RW_D3D8_COMPAT}")
foreach(_h IN ITEMS d3d8.h d3d8caps.h d3d8types.h)
  file(COPY "${RW_DXSDK_INC}/${_h}" DESTINATION "${RW_D3D8_COMPAT}")
endforeach()

set(RW_GENERIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/common/palquant.c"
    "${RW_SRC_ROOT}/driver/common/cpuext.c")
if(NOT RW_NOASM)
  list(APPEND RW_GENERIC_DRV_SRC "${RW_SRC_ROOT}/driver/common/ssematml.c")
endif()

set(RW_SPECIFIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/d3d8/d3d82drend.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8convrt.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8device.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8dxttex.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8raster.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8rendst.c"
    "${RW_SRC_ROOT}/driver/d3d8/d3d8texdic.c")
if(RW_METRICS)
  list(APPEND RW_SPECIFIC_DRV_SRC "${RW_SRC_ROOT}/driver/d3d8/d3d8metric.c")
endif()

set(RW_GENERIC_DRV_ASM_SRC
    "${RW_SRC_ROOT}/driver/common/baprocfp.asm"
    "${RW_SRC_ROOT}/driver/common/x86matml.asm"
    "${RW_SRC_ROOT}/driver/common/x86matvc.asm")

set(RW_DRV_LIBS
    "${RW_DXSDK_LIB}/dxguid.lib"
    "${RW_DXSDK_LIB}/d3d8.lib")
if(RW_DLL)
  set(RW_DLL_DRV_LIBS ${RW_DRV_LIBS})
  set(RW_DRV_LIBS "")
endif()

set(RW_DRV_INC
    "${RW_SRC_ROOT}/driver/d3d8"
    "${RW_D3D8_COMPAT}"
    "${RW_SRC_ROOT}/world")
set(RW_DRV_DEF "")
