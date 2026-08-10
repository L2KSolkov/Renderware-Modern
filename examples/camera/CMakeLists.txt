# camera - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(camera
  SOURCES src/main.c src/camexamp.c src/viewer.c src/win/events.c
  ASSET_DIRS models)
