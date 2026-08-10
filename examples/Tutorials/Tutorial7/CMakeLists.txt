# Tutorial7 - standalone CMake file for this tutorial.
#
# Added automatically by the examples/ superbuild.

rw_add_example(Tutorial7
  DEMO tutorial7
  SOURCES src/main.c src/utils.c src/RpAName.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis rttoc
  ASSET_DIRS models)
