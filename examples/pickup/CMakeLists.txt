# pickup - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(pickup
  SOURCES src/main.c src/pickup.c src/win/events.c
  RW_LIBS rpptank rpmatfx
  ASSET_DIRS models textures)
