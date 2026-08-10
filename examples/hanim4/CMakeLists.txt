# hanim4 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(hanim4
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtcmpkey rtanim rphanim rtquat
  ASSET_DIRS models)
