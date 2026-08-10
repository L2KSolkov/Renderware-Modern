# imshadow - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(imshadow
  SOURCES src/main.c src/scene.c src/shadow.c src/win/events.c
  TARGET_SOURCES
    "d3d8=src/d3d8/pipeline.c"
    "d3d9=src/d3d9/pipeline.c"
  RW_LIBS rpcollis rtintsec rpskin rtanim rphanim
  SUPPORTED_TARGETS d3d8;d3d9
  ASSET_DIRS models)
