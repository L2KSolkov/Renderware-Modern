# hanimkey - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(hanimkey
  SOURCES src/main.c src/hanim.c src/keyframe.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)
