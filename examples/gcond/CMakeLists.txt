# gcond - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(gcond
  SOURCES src/main.c src/gcond.c src/win/events.c
  RW_LIBS rtimport rtgcond rtwing
  ASSET_DIRS textures)
