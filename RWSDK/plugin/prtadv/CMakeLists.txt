rw_add_plugin(rpprtadv DIR plugin/prtadv
  PLUGIN rpprtadv
  PLUGINAPI prtadvapi.h
  SOURCES
    rpprtadv.c
    prtemt.c
    prtmcol.c
    prttexst.c
    circle.c
    sphere.c
    plist.c
  EXTRA_INCLUDES "./generic" "./${RW_TARGET}"
  PLUGININCDIR "." "${RW_SRC_ROOT}/plugin/prtadv/${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpprtadv PARENT_SCOPE)
