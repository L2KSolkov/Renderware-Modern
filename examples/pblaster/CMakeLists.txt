# pblaster - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(pblaster
  SOURCES src/main.c src/blaster.c src/burst.c src/shot.c src/win/events.c
  RW_LIBS rpptank
  ASSET_DIRS models textures)
