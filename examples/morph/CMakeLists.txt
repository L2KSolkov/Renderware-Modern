# morph - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(morph
  SOURCES src/main.c src/clump.c src/morph.c src/win/events.c
  RW_LIBS rpmorph
  ASSET_DIRS models)
