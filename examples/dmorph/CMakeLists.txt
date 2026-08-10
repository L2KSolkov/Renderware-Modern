# dmorph - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(dmorph
  SOURCES src/main.c src/dmorph.c src/geom.c src/win/events.c
  RW_LIBS rpdmorph
  ASSET_DIRS models)
