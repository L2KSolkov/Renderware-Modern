# rwsview - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(rwsview
  SOURCES src/main.c src/win/events.c
  RW_LIBS rtanim rtpitexd rttoc rphanim
  ASSET_DIRS models)
