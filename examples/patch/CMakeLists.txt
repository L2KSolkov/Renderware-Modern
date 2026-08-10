# patch - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(patch
  SOURCES src/main.c src/patch.c src/win/events.c
  RW_LIBS rpmatfx rppatch rtbezpat
  ASSET_DIRS textures)
