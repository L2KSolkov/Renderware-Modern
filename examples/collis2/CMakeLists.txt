# collis2 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(collis2
  SOURCES src/main.c src/collis2.c src/win/events.c
  RW_LIBS rpcollis rtintsec rprandom
  ASSET_DIRS models)
