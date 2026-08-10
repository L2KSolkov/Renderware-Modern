# hanim2 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(hanim2
  SOURCES src/main.c src/hanim.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)
