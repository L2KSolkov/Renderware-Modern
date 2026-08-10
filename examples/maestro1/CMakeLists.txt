# maestro1 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(maestro1
  SOURCES src/main.c src/view.c src/button.c src/win/events.c
  RW_LIBS rt2d rt2danim
  ASSET_DIRS models font)
