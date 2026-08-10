# collis1 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(collis1
  SOURCES src/main.c src/collis1.c src/win/events.c
  RW_LIBS rpcollis rtintsec
  ASSET_DIRS models)
