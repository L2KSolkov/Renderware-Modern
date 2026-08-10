# uvanim - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(uvanim
  SOURCES src/main.c src/win/events.c
  RW_LIBS rtanim rtdict rpuvanim rpmatfx
  ASSET_DIRS models)
