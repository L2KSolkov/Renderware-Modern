# font - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(font
  SOURCES src/main.c src/font.c src/win/events.c
  RW_LIBS rt2d
  ASSET_DIRS fonts)
