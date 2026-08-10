# pshader - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(pshader
  SOURCES src/main.c src/win/events.c
  TARGET_SOURCES
    "d3d8=src/pshaderD3D8.c"
    "d3d9=src/pshaderD3D9.c"
  SUPPORTED_TARGETS d3d8;d3d9
  ASSET_DIRS models)
