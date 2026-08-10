# world - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(world
  SOURCES src/main.c src/world.c src/win/events.c
  RW_LIBS rtimport rtgcond rtwing
  ASSET_DIRS textures)
