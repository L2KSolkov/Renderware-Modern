# The seven tutorials, same shape as the demos.

rw_add_example(Tutorial1
  DEMO tutorial1
  SOURCES src/main.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(Tutorial2
  DEMO tutorial2
  SOURCES src/main.c src/utils.c src/win/events.c
  ASSET_DIRS models)

rw_add_example(Tutorial3
  DEMO tutorial3
  SOURCES src/main.c src/utils.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)

rw_add_example(Tutorial4
  DEMO tutorial4
  SOURCES src/main.c src/utils.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)

rw_add_example(Tutorial5
  DEMO tutorial5
  SOURCES src/main.c src/utils.c src/RpAName.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)

rw_add_example(Tutorial6
  DEMO tutorial6
  SOURCES src/main.c src/utils.c src/RpAName.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis
  ASSET_DIRS models)

rw_add_example(Tutorial7
  DEMO tutorial7
  SOURCES src/main.c src/utils.c src/RpAName.c src/win/events.c
  RW_LIBS rtintsec rtpick rpcollis rttoc
  ASSET_DIRS models)
