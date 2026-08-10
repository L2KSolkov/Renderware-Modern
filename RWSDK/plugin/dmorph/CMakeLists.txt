rw_add_plugin(rpdmorph DIR plugin/dmorph
  PLUGINAPI dmorphapi.h
  SOURCES
    dmphanim.c
    dmphgeom.c
    dmphintp.c)
set(RW_PLUGIN_LIBS_IN_DIR rpdmorph PARENT_SCOPE)
