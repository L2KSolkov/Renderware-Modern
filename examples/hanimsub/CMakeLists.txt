# hanimsub - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(hanimsub
  SOURCES src/main.c src/hanimsub.c src/win/events.c
  RW_LIBS rpskin rtanim rphanim
  ASSET_DIRS models)
