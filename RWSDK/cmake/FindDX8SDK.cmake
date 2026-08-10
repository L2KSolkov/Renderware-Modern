# Locates the legacy DirectX 8 SDK (d3d8.h, d3d8.lib, dxguid.lib) required by
# RW_TARGET=d3d8. Also used by d3d9, which additionally needs d3dx9.h/d3dx9.lib.
#
# Search order:
#   1. RW_DXSDK_DIR cache variable (the make system's DXSDK)
#   2. DXSDK_DIR environment variable
#   3. Common installation locations of the June 2010 DirectX SDK

function(find_legacy_dxsdk)
  set(_hint "")
  if(RW_DXSDK_DIR)
    list(APPEND _hint "${RW_DXSDK_DIR}")
  endif()
  if(DEFINED ENV{DXSDK_DIR} AND NOT ENV{DXSDK_DIR} STREQUAL "")
    list(APPEND _hint "$ENV{DXSDK_DIR}")
  endif()
  list(APPEND _hint
    "C:/Program Files (x86)/Microsoft DirectX SDK (June 2010)"
    "C:/Program Files/Microsoft DirectX SDK (June 2010)"
    "C:/dxsdk")

  find_path(RW_DXSDK_DIR_INC d3d9.h
    HINTS ${_hint}
    PATH_SUFFIXES include Include
    NO_DEFAULT_PATH)
  if(NOT RW_DXSDK_DIR_INC)
    # d3d9.h also ships in the Windows SDK; only the d3dx9.h check below is
    # fatal for d3d9.
    set(RW_DXSDK_DIR_INC "" CACHE INTERNAL "legacy DX SDK include dir" FORCE)
  endif()

  if(NOT RW_DXSDK_DIR)
    get_filename_component(_root "${RW_DXSDK_DIR_INC}" DIRECTORY)
    set(RW_DXSDK_DIR "${_root}" CACHE PATH "DXSDK: legacy DirectX SDK" FORCE)
  endif()

  set(RW_DXSDK_INC "${RW_DXSDK_DIR_INC}" CACHE INTERNAL "DX SDK include dir" FORCE)

  set(_libdir "${RW_DXSDK_DIR}/lib")
  if(EXISTS "${_libdir}/x86")
    set(_libdir "${_libdir}/x86")
  endif()
  if(NOT EXISTS "${_libdir}" AND EXISTS "${RW_DXSDK_DIR}/Lib/x86")
    set(_libdir "${RW_DXSDK_DIR}/Lib/x86")
  endif()
  set(RW_DXSDK_LIB "${_libdir}" CACHE INTERNAL "DX SDK lib dir" FORCE)

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
