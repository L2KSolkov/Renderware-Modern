rw_add_plugin(rpuvanim DIR plugin/uvanim
  SOURCES
    stdkey.c
    linear.c
    param.c)
set(RW_PLUGIN_LIBS_IN_DIR rpuvanim PARENT_SCOPE)
