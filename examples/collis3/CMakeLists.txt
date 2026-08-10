# collis3 - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(collis3
  SOURCES src/main.c src/collis3.c src/win/events.c
  RW_LIBS rprandom rpcollis rtintsec
  ASSET_DIRS models)
