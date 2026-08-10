# RenderWare examples - dual mode.
#
# In-tree (the root superbuild, or an SDK source tree next to examples/):
# links the live rwcore/rpworld/rt* targets and the rwskel framework.
# Standalone (installed SDK): consumes RenderWare via find_package and links
# the exported RenderWare:: targets.

if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
  cmake_minimum_required(VERSION 3.21)
  project(RenderWareExamples LANGUAGES C)
endif()

if(NOT TARGET rwcore)
  find_package(RenderWare REQUIRED)
  set(RW_EXAMPLE_LIB_PREFIX "RenderWare::")
  # minimal standalone defaults (the SDK config drives the installed package)
  if(NOT RW_TARGET)
    set(RW_TARGET "d3d9")
  endif()
  set(RW_PLATFORMEXE "${RW_TARGET}")
  set(RW_EXE_SUFFIX "")
  set(RW_SRC_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/../RWSDK")
  set(RW_GEN_INCDIR "${RenderWare_INCLUDE_DIRS}")
  set(RW_BASE_C_FLAGS /nologo /W3)
  set(RW_BASE_DEFINES WIN32 _WINDOWS _MBCS __MSC__ VC_EXTRALEAN
      WIN32_EXTRA_LEAN WIN32_LEAN_AND_MEAN)
  set(RW_FEATURE_DEFINES "")
  set(RW_CONFIG_FLAGS "")
  set(RW_DRV_DEF "")
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

if(NOT TARGET rwskel)
  add_subdirectory("${CMAKE_CURRENT_SOURCE_DIR}/../shared" "${CMAKE_BINARY_DIR}/shared")
endif()

# Demos
rw_add_example(alphasrt
  SOURCES src/main.c src/alpha.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(anim
  SOURCES src/main.c src/anim.c src/lights.c src/win/events.c
  RW_LIBS rtanim
  ASSET_DIRS models)

rw_add_example(blending
  SOURCES src/main.c src/blend.c src/win/events.c)

rw_add_example(bounding
  SOURCES src/main.c src/bounding.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(burningm
  SOURCES src/main.c src/prtsyst.c src/scene.c src/win/events.c src/win/prtwin.c
  RW_LIBS rpcollis rpskin rtanim rpptank rphanim
  ASSET_DIRS models)

rw_add_example(camera
  SOURCES src/main.c src/camexamp.c src/viewer.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(camtex
  SOURCES src/main.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(collis1
  SOURCES src/main.c src/collis1.c src/win/events.c
  RW_LIBS rpcollis rtintsec
  ASSET_DIRS models)

rw_add_example(collis2
  SOURCES src/main.c src/collis2.c src/win/events.c
  RW_LIBS rpcollis rtintsec rprandom
  ASSET_DIRS models)

rw_add_example(collis3
  SOURCES src/main.c src/collis3.c src/win/events.c
  RW_LIBS rprandom rpcollis rtintsec
  ASSET_DIRS models)

rw_add_example(decal
  SOURCES src/main.c src/decal.c src/win/events.c
  RW_LIBS rpptank rpcollis rtintsec
  ASSET_DIRS models)

rw_add_example(dmorph
  SOURCES src/main.c src/dmorph.c src/geom.c src/win/events.c
  RW_LIBS rpdmorph
  ASSET_DIRS models)

rw_add_example(fog
  SOURCES src/main.c src/win/events.c
  RW_LIBS rprandom
  ASSET_DIRS models)

rw_add_example(font
  SOURCES src/main.c src/font.c src/win/events.c
  RW_LIBS rt2d
  ASSET_DIRS fonts)

rw_add_example(frame
  SOURCES src/main.c src/frame.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(gcond
  SOURCES src/main.c src/gcond.c src/win/events.c
  RW_LIBS rtimport rtgcond rtwing
  ASSET_DIRS textures)

rw_add_example(geometry
  SOURCES src/main.c src/geometry.c src/win/events.c
  ASSET_DIRS textures)

rw_add_example(hanim1
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)

rw_add_example(hanim2
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)

rw_add_example(hanim3
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim rtquat
  ASSET_DIRS models)

rw_add_example(hanim4
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtcmpkey rtanim rphanim rtquat
  ASSET_DIRS models)

rw_add_example(hanimkey
  SOURCES src/main.c src/hanim.c src/keyframe.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)

rw_add_example(hanimsub
  SOURCES src/main.c src/hanimsub.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)

rw_add_example(im2d
  SOURCES src/main.c src/im2d.c src/linelist.c src/polyline.c src/trilist.c
          src/tristrip.c src/trifan.c src/win/events.c
  ASSET_DIRS textures)

rw_add_example(im3d
  SOURCES src/main.c src/im3d.c src/linelist.c src/polyline.c src/trilist.c
          src/tristrip.c src/trifan.c src/win/events.c
  ASSET_DIRS textures)

rw_add_example(imagetex
  SOURCES src/main.c src/win/events.c
  ASSET_DIRS textures)

rw_add_example(imgformt
  SOURCES src/main.c src/tga.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(imlight
  SOURCES src/main.c src/imlight.c src/win/events.c)

rw_add_example(impick
  SOURCES src/main.c src/impick.c src/win/events.c)

rw_add_example(imshadow
  SOURCES src/main.c src/scene.c src/shadow.c src/win/events.c
  TARGET_SOURCES
    "d3d8=src/d3d8/pipeline.c"
    "d3d9=src/d3d9/pipeline.c"
  RW_LIBS rpcollis rtintsec rpskin rtanim rphanim
  SUPPORTED_TARGETS d3d8;d3d9
  ASSET_DIRS models)

rw_add_example(lightmap
  SOURCES src/main.c src/lightmap.c src/win/events.c
  RW_LIBS rtpitexd rpltmap rpmipkl rppvs rtltmap rprandom rtbary rpcollis rtintsec
  ASSET_DIRS models)

rw_add_example(lights
  SOURCES src/main.c src/lights.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(lights2
  SOURCES src/main.c src/lights.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(lodatom
  SOURCES src/main.c src/lodatom.c src/win/events.c
  RW_LIBS rplodatm
  ASSET_DIRS models)

rw_add_example(maestro1
  SOURCES src/main.c src/view.c src/button.c src/win/events.c
  RW_LIBS rt2d rt2danim
  ASSET_DIRS models font)

rw_add_example(matfx1
  SOURCES src/main.c src/win/events.c
  RW_LIBS rpmatfx
  ASSET_DIRS models)

rw_add_example(memhints
  SOURCES src/main.c src/memheap.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(mipmap
  SOURCES src/main.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(morph
  SOURCES src/main.c src/clump.c src/morph.c src/win/events.c
  RW_LIBS rpmorph
  ASSET_DIRS models)

rw_add_example(normmap
  SOURCES src/main.c src/normalmapgen.c src/hanim.c src/win/events.c
  RW_LIBS rtnormmap rtquat rtslerp rtanim rpskin rphanim rpnormmapskin
  SUPPORTED_TARGETS d3d9
  ASSET_DIRS models)

rw_add_example(pakfile
  SOURCES src/main.c src/pakfile.c src/win/events.c
  ASSET_DIRS misc)

rw_add_example(patch
  SOURCES src/main.c src/patch.c src/win/events.c
  RW_LIBS rpmatfx rppatch rtbezpat
  ASSET_DIRS textures)

rw_add_example(pblaster
  SOURCES src/main.c src/blaster.c src/burst.c src/shot.c src/win/events.c
  RW_LIBS rpptank
  ASSET_DIRS models textures)

rw_add_example(picking
  SOURCES src/main.c src/pick.c src/win/events.c
  RW_LIBS rtpick rpcollis rtintsec
  ASSET_DIRS models)

rw_add_example(pickup
  SOURCES src/main.c src/pickup.c src/win/events.c
  RW_LIBS rpptank rpmatfx
  ASSET_DIRS models textures)

rw_add_example(plugin
  SOURCES src/main.c src/physics.c src/win/events.c
  RW_LIBS rprandom
  ASSET_DIRS models)

rw_add_example(prtstd
  SOURCES src/main.c src/prtstd.c src/win/events.c
  RW_LIBS rpprtstd rpptank
  ASSET_DIRS textures)

rw_add_example(prtstd2
  SOURCES src/main.c src/prtstd2.c src/win/events.c
  RW_LIBS rpprtstd rpptank
  ASSET_DIRS textures)

rw_add_example(pshader
  SOURCES src/main.c src/win/events.c
  TARGET_SOURCES
    "d3d8=src/pshaderD3D8.c"
    "d3d9=src/pshaderD3D9.c"
  SUPPORTED_TARGETS d3d8;d3d9
  ASSET_DIRS models)

rw_add_example(ptank2
  SOURCES src/main.c src/ptank.c src/win/events.c
  RW_LIBS rpptank)

rw_add_example(ptank3
  SOURCES src/main.c src/ptank.c src/win/events.c
  RW_LIBS rpptank
  ASSET_DIRS textures)

rw_add_example(rwsview
  SOURCES src/main.c src/win/events.c
  RW_LIBS rtanim rtpitexd rttoc rphanim
  ASSET_DIRS models)

rw_add_example(subrast
  SOURCES src/main.c src/subrast.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(template
  SOURCES src/main.c src/win/events.c)

rw_add_example(texadrss
  SOURCES src/main.c src/clump.c src/texadrss.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(texdict
  SOURCES src/main.c src/texdict.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(uvanim
  SOURCES src/main.c src/win/events.c
  RW_LIBS rtanim rtdict rpuvanim rpmatfx
  ASSET_DIRS models)

rw_add_example(vshader
  SOURCES src/main.c src/win/events.c
  TARGET_SOURCES
    "d3d8=src/vshaderD3D8.c"
    "d3d9=src/vshaderD3D9.c"
  SUPPORTED_TARGETS d3d8;d3d9
  ASSET_DIRS models)

rw_add_example(world
  SOURCES src/main.c src/world.c src/win/events.c
  RW_LIBS rtimport rtgcond rtwing
  ASSET_DIRS textures)

if(RW_TARGET STREQUAL "d3d8")
  # vshader/pshader need the legacy d3dx8 utility library on d3d8
  target_link_libraries(vshader PRIVATE "${RW_D3DX8_LIB}" gdi32 uuid advapi32)
  target_link_libraries(pshader PRIVATE "${RW_D3DX8_LIB}" gdi32 uuid advapi32)
  # the legacy d3dx8 import library references the old C++ runtime names
  # (makefile: /NODEFAULTLIB:libci + libcp/libcpd)
  target_link_options(vshader PRIVATE
    /NODEFAULTLIB:libci
    "$<$<BOOL:${RW_CDEBUG_ENABLED}>:/NODEFAULTLIB:libcpd>"
    "$<$<NOT:$<BOOL:${RW_CDEBUG_ENABLED}>>:/NODEFAULTLIB:libcp>")
  target_link_options(pshader PRIVATE
    /NODEFAULTLIB:libci
    "$<$<BOOL:${RW_CDEBUG_ENABLED}>:/NODEFAULTLIB:libcpd>"
    "$<$<NOT:$<BOOL:${RW_CDEBUG_ENABLED}>>:/NODEFAULTLIB:libcp>")
endif()

add_subdirectory(Tutorials)
