rw_add_plugin(rpprtstd DIR plugin/prtstd
  PLUGIN rpprtstd
  PLUGINAPI prtstdapi.h
  SOURCES
    eclass.c
    emitter.c
    pclass.c
    prop.c
    pptank.c
    standard.c
  EXTRA_INCLUDES "./generic" "./${RW_TARGET}"
  PLUGININCDIR "." "${RW_SRC_ROOT}/plugin/prtstd/${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpprtstd PARENT_SCOPE)
