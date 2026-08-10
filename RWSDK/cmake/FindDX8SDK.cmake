# Locates the legacy DirectX 8 SDK (d3d8.h, d3d8.lib, dxguid.lib) required by
# RW_TARGET=d3d8. Also used by d3d9, which additionally needs d3dx9.h/d3dx9.lib.
#
# Search order:
#   1. RW_DXSDK_DIR cache variable (the make system's DXSDK)
#   2. DXSDK_DIR environment variable
#   3. Common installation locations of the June 2010 DirectX SDK

function(find_legacy_dxsdk)
  set(_root "")
  if(RW_DXSDK_DIR)
    set(_root "${RW_DXSDK_DIR}")
  elseif(DEFINED ENV{DXSDK_DIR} AND NOT ENV{DXSDK_DIR} STREQUAL "")
    set(_root "$ENV{DXSDK_DIR}")
  else()
    foreach(_candidate IN ITEMS
        "C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)"
        "C:/Program Files/Microsoft DirectX SDK (June 2010)"
        "C:/dxsdk")
      if(EXISTS "${_candidate}/Include/d3d9.h")
        set(_root "${_candidate}")
        break()
      endif()
    endforeach()
  endif()

  set(RW_DXSDK_INC "")
  set(RW_DXSDK_LIB "")
  if(_root)
    if(EXISTS "${_root}/Include")
      set(RW_DXSDK_INC "${_root}/Include")
    elseif(EXISTS "${_root}/include")
      set(RW_DXSDK_INC "${_root}/include")
    else()
      set(RW_DXSDK_INC "${_root}")
    endif()
    if(EXISTS "${_root}/Lib/x86")
      set(RW_DXSDK_LIB "${_root}/Lib/x86")
    elseif(EXISTS "${_root}/lib/x86")
      set(RW_DXSDK_LIB "${_root}/lib/x86")
    elseif(EXISTS "${_root}/Lib")
      set(RW_DXSDK_LIB "${_root}/Lib")
    elseif(EXISTS "${_root}/lib")
      set(RW_DXSDK_LIB "${_root}/lib")
    endif()
  endif()

  if(NOT RW_DXSDK_DIR)
    set(RW_DXSDK_DIR "${_root}" CACHE PATH "DXSDK: legacy DirectX SDK" FORCE)
  endif()
  set(RW_DXSDK_INC "${RW_DXSDK_INC}" PARENT_SCOPE)
  set(RW_DXSDK_LIB "${RW_DXSDK_LIB}" PARENT_SCOPE)

  if(RW_TARGET STREQUAL "d3d8")
    if(NOT EXISTS "${RW_DXSDK_INC}/d3d8.h" OR
       NOT EXISTS "${RW_DXSDK_LIB}/d3d8.lib" OR
       NOT EXISTS "${RW_DXSDK_LIB}/dxguid.lib")
      message(FATAL_ERROR
        "RW_TARGET=d3d8 requires the legacy DirectX 8 SDK (d3d8.h, d3d8.lib, "
        "dxguid.lib). Set RW_DXSDK_DIR to the SDK root (or DXSDK_DIR in the "
        "environment), e.g. 'C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)'.")
    endif()
  elseif(RW_TARGET STREQUAL "d3d9")
    if(NOT EXISTS "${RW_DXSDK_INC}/d3dx9.h" OR
       NOT EXISTS "${RW_DXSDK_LIB}/d3dx9.lib")
      message(FATAL_ERROR
        "RW_TARGET=d3d9 requires the legacy DirectX SDK for its d3dx9.h/d3dx9.lib "
        "(world/pipe/p2/d3d9 uses D3DXAssembleShader and the D3DX math helpers). "
        "Set RW_DXSDK_DIR to the SDK root (or DXSDK_DIR in the environment). "
        "d3d9.h/d3d9.lib themselves come from the Windows SDK.")
    endif()
  endif()
endfunction()
