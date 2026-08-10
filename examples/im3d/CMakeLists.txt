# im3d - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(im3d
  SOURCES src/main.c src/im3d.c src/linelist.c src/polyline.c src/trilist.c
          src/tristrip.c src/trifan.c src/win/events.c
  ASSET_DIRS textures)
