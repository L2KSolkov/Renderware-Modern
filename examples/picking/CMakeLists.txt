# picking - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(picking
  SOURCES src/main.c src/pick.c src/win/events.c
  RW_LIBS rtpick rpcollis rtintsec
  ASSET_DIRS models)
