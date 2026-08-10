# prtstd2 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(prtstd2
  SOURCES src/main.c src/prtstd2.c src/win/events.c
  RW_LIBS rpprtstd rpptank
  ASSET_DIRS textures)
