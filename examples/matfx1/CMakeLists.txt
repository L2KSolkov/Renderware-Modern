# matfx1 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(matfx1
  SOURCES src/main.c src/win/events.c
  RW_LIBS rpmatfx
  ASSET_DIRS models)
