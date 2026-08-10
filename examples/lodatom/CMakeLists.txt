# lodatom - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(lodatom
  SOURCES src/main.c src/lodatom.c src/win/events.c
  RW_LIBS rplodatm
  ASSET_DIRS models)
