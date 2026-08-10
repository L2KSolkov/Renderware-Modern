# prtstd - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(prtstd
  SOURCES src/main.c src/prtstd.c src/win/events.c
  RW_LIBS rpprtstd rpptank
  ASSET_DIRS textures)
