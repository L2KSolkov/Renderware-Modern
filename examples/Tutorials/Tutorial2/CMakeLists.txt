# Tutorial2 - standalone CMake file for this tutorial.
#
# Added automatically by the examples/ superbuild.

rw_add_example(Tutorial2
  DEMO tutorial2
  SOURCES src/main.c src/utils.c src/win/events.c
  ASSET_DIRS models)
