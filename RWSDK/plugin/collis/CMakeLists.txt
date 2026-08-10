rw_add_plugin(rpcollis DIR plugin/collis
  PLUGIN rpcollis
  PLUGINAPI rpcollis.h
  PLUGININCDIR "."
  SOURCES
    ctdata.c
    ctbuild.c
    ctquery.c
    colldata.c
    collbuild.c
    collquery.c)
set(RW_PLUGIN_LIBS_IN_DIR rpcollis PARENT_SCOPE)
