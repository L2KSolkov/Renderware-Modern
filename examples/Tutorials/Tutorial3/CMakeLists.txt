# Tutorial3 - standalone CMake file for this tutorial.
#
# Added automatically by the examples/ superbuild.

rw_add_example(Tutorial3
  DEMO tutorial3
  SOURCES src/main.c src/utils.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)
