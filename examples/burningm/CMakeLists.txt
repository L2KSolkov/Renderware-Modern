# burningm - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(burningm
  SOURCES src/main.c src/prtsyst.c src/scene.c src/win/events.c src/win/prtwin.c
  RW_LIBS rpcollis rpskin rtanim rpptank rphanim
  ASSET_DIRS models)
