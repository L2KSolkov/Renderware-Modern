# lightmap - standalone CMake file for this example.
#
# Added automatically by the examples/ superbuild.

rw_add_example(lightmap
  SOURCES src/main.c src/lightmap.c src/win/events.c
  RW_LIBS rtpitexd rpltmap rpmipkl rppvs rtltmap rprandom rtbary rpcollis rtintsec
  ASSET_DIRS models)
