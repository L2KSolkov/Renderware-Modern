# normmap - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(normmap
  SOURCES src/main.c src/normalmapgen.c src/hanim.c src/win/events.c
  RW_LIBS rtnormmap rtquat rtslerp rtanim rpskin rphanim rpnormmapskin
  SUPPORTED_TARGETS d3d9
  ASSET_DIRS models)
