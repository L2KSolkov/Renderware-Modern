# decal - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(decal
  SOURCES src/main.c src/decal.c src/win/events.c
  RW_LIBS rpptank rpcollis rtintsec
  ASSET_DIRS models)
