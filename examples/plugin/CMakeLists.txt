# plugin - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(plugin
  SOURCES src/main.c src/physics.c src/win/events.c
  RW_LIBS rprandom
  ASSET_DIRS models)
