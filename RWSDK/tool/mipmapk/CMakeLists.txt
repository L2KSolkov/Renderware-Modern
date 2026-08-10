rw_add_toolkit(rtmipk DIR tool/mipmapk
  PLUGIN rtmipk
  SOURCES
    mipkcalc.c
    mipkgeneric.c
    mipkworld.c)

rw_add_toolkit(rtmipkmatfx DIR tool/mipmapk
  PLUGIN rtmipk
  LIBNAME rtmipkmatfx
  GENERATE_HEADERS OFF
  SOURCES
    mipkcalc.c
    mipkworldmatfx.c
    mipkmatfx.c)

rw_add_toolkit(rtmipkpatch DIR tool/mipmapk
  PLUGIN rtmipk
  LIBNAME rtmipkpatch
  GENERATE_HEADERS OFF
  SOURCES
    mipkcalc.c
    mipkworld.c
    mipkpatch.c
    mipkcalcpatch.c)

rw_add_toolkit(rtmipkpatchmatfx DIR tool/mipmapk
  PLUGIN rtmipk
  LIBNAME rtmipkpatchmatfx
  GENERATE_HEADERS OFF
  SOURCES
    mipkcalc.c
    mipkworldmatfx.c
    mipkpatchmatfx.c
    mipkcalcpatch.c)
set(RW_TOOLKIT_LIBS_IN_DIR rtmipk rtmipkmatfx rtmipkpatch rtmipkpatchmatfx PARENT_SCOPE)
