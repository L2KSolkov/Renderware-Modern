# fog - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(fog
  SOURCES src/main.c src/win/events.c
  RW_LIBS rprandom
  ASSET_DIRS models)
