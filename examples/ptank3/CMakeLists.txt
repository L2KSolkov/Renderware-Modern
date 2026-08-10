# ptank3 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(ptank3
  SOURCES src/main.c src/ptank.c src/win/events.c
  RW_LIBS rpptank
  ASSET_DIRS textures)
