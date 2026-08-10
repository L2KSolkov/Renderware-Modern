# RenderWare examples - dual mode.
#
# In-tree (the root superbuild, or an SDK source tree next to examples/):
# the SDK is configured first (add_subdirectory(RWSDK)) and the examples link
# its live targets. Standalone (installed SDK): consumes RenderWare via
# find_package and links the exported RenderWare:: targets.
#
# Every example owns a CMakeLists.txt in its own directory
# (examples/<name>/CMakeLists.txt); this file just adds the selected ones.

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  cmake_minimum_required(VERSION 3.21)
  project(RenderWareExamples LANGUAGES C)
endif()

if(NOT TARGET rwcore)
  find_package(RenderWare REQUIRED)
  set(RW_EXAMPLE_LIB_PREFIX "RenderWare::")
  # minimal standalone defaults (the installed SDK package drives the rest)
  if(NOT RW_TARGET)
    set(RW_TARGET "d3d9")
  endif()
  set(RW_SRC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../RWSDK")
  set(RW_GEN_INCDIR "${RenderWare_INCLUDE_DIRS}")
  set(RW_C_INC "")
  set(RW_DRV_INC "")
  include("${RW_SRC_ROOT}/cmake/RWTargetUtils.cmake")
else()
  set(RW_EXAMPLE_LIB_PREFIX "")
  get_filename_component(RW_SRC_ROOT
    "${CMAKE_CURRENT_SOURCE_DIR}/../RWSDK" ABSOLUTE)
  include("${RW_SRC_ROOT}/cmake/RWOptions.cmake")
  include("${RW_SRC_ROOT}/cmake/FindDX8SDK.cmake")
  include("${RW_SRC_ROOT}/cmake/RWTargets.cmake")
  include("${RW_SRC_ROOT}/cmake/RWTargetUtils.cmake")
endif()

include(cmake/RWExampleOptions.cmake)
include(cmake/RWAddExample.cmake)

# The shared Rs* framework, required by every example. Built with the example
# option surface; depends on the SDK targets (in-tree) or the installed
# package (standalone).
if(NOT TARGET rwskel)
  add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../shared" "${CMAKE_BINARY_DIR}/shared")
endif()

# All demo directories. RW_EXAMPLES accepts directory names; empty = all.
set(RW_EXAMPLE_DIRS
    alphasrt anim blending bounding burningm camera camtex collis1 collis2
    collis3 decal dmorph fog font frame gcond geometry hanim1 hanim2 hanim3
    hanim4 hanimkey hanimsub im2d im3d imagetex imgformt imlight impick
    imshadow lightmap lights lights2 lodatom maestro1 matfx1 memhints mipmap
    morph normmap pakfile patch pblaster picking pickup plugin prtstd prtstd2
    pshader ptank2 ptank3 rwsview subrast template texadrss texdict uvanim
    vshader world)

foreach(_dir IN LISTS RW_EXAMPLE_DIRS)
  if(NOT RW_EXAMPLES OR _dir IN_LIST RW_EXAMPLES)
    add_subdirectory("${_dir}")
  endif()
endforeach()

add_subdirectory(Tutorials)

if(RW_EXAMPLES_TARGET STREQUAL "d3d8" AND (TARGET vshader OR TARGET pshader))
  # vshader/pshader need the legacy d3dx8 utility library on d3d8, and the
  # legacy d3dx8 import library references the old C++ runtime names
  # (makefile: /NODEFAULTLIB:libci + libcp/libcpd).
  set(_d3dx8_flags
      /NODEFAULTLIB:libci
      "$<$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>:/NODEFAULTLIB:libcpd>"
      "$<$<NOT:$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>>:/NODEFAULTLIB:libcp>")
  foreach(_t IN ITEMS vshader pshader)
    if(TARGET ${_t})
      target_link_libraries(${_t} PRIVATE
        "${RW_EXAMPLES_D3DX8_LIB}" gdi32 uuid advapi32)
      target_link_options(${_t} PRIVATE ${_d3dx8_flags})
    endif()
  endforeach()
endif()
