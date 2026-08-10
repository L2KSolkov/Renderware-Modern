# makeincl/rwtarget/d3d9/maketarg

find_legacy_dxsdk()

# Same compat staging as d3d8: keep the legacy SDK's d3d9/d3dx9 headers only,
# so the modern Windows SDK supplies the system headers.
set(RW_D3D9_COMPAT "${CMAKE_BINARY_DIR}/dxsdk-compat-d3d9")
file(MAKE_DIRECTORY "${RW_D3D9_COMPAT}")
file(GLOB _d3d9_sdk_hdrs
  "${RW_DXSDK_INC}/d3d9.h"
  "${RW_DXSDK_INC}/d3d9caps.h"
  "${RW_DXSDK_INC}/d3d9types.h"
  "${RW_DXSDK_INC}/d3dx9*.h"
  "${RW_DXSDK_INC}/d3dx9*.inl"
  "${RW_DXSDK_INC}/dxfile.h")
file(COPY ${_d3d9_sdk_hdrs} DESTINATION "${RW_D3D9_COMPAT}")

set(RW_GENERIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/common/palquant.c"
    "${RW_SRC_ROOT}/driver/common/cpuext.c")
if(NOT RW_NOASM)
  list(APPEND RW_GENERIC_DRV_SRC "${RW_SRC_ROOT}/driver/common/ssematml.c")
endif()

set(RW_SPECIFIC_DRV_SRC
    "${RW_SRC_ROOT}/driver/d3d9/d3d9device.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d92drend.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9convrt.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9dxttex.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9raster.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9rendst.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9vertexbuffer.c"
    "${RW_SRC_ROOT}/driver/d3d9/d3d9texdic.c")
if(RW_METRICS)
  list(APPEND RW_SPECIFIC_DRV_SRC "${RW_SRC_ROOT}/driver/d3d9/d3d9metric.c")
endif()

set(RW_GENERIC_DRV_ASM_SRC
    "${RW_SRC_ROOT}/driver/common/baprocfp.asm"
    "${RW_SRC_ROOT}/driver/common/x86matml.asm"
    "${RW_SRC_ROOT}/driver/common/x86matvc.asm")

set(RW_DRV_LIBS "${RW_DXSDK_LIB}/d3d9.lib")
if(RW_DLL)
  # For DLL builds the driver libs are deferred to the DLL link so that no
  # non-RenderWare symbols leak into the export table.
  set(RW_DLL_DRV_LIBS ${RW_DRV_LIBS})
  set(RW_DRV_LIBS "")
endif()

set(RW_DRV_INC
    "${RW_SRC_ROOT}/driver/d3d9"
    "${RW_SRC_ROOT}/world"
    "${RW_D3D9_COMPAT}")
set(RW_DRV_DEF "")

# d3dx9 (legacy DirectX SDK utility library) is required by rpworld for the
# D3D9 pipeline (vertex declaration/shader utilities). Static builds archive
# it with rpworld; DLL builds defer it to the DLL link.
set(RW_WORLD_LIBS "${RW_DXSDK_LIB}/d3dx9.lib")
if(RW_DLL)
  list(APPEND RW_DLL_DRV_LIBS "${RW_DXSDK_LIB}/d3dx9.lib")
  set(RW_WORLD_LIBS "")
endif()
