# anim - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(anim
  SOURCES src/main.c src/anim.c src/lights.c src/win/events.c
  RW_LIBS rtanim
  ASSET_DIRS models)
