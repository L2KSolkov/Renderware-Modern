# Tutorial4 - standalone CMake file for this tutorial.
#
# Added automatically by the examples/ superbuild.

rw_add_example(Tutorial4
  DEMO tutorial4
  SOURCES src/main.c src/utils.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)
