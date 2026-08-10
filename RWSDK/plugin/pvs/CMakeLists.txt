rw_add_plugin(rppvs DIR plugin/pvs
  SOURCES
    rppvs.c
    rppvsaux.c)
set(RW_PLUGIN_LIBS_IN_DIR rppvs PARENT_SCOPE)
