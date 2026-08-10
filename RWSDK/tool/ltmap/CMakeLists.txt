# rtltmap is built through makeplug (PLUGINAPI rtltmap.h).
rw_add_plugin(rtltmap DIR tool/ltmap
  PLUGIN rtltmap
  PLUGINAPI rtltmap.h
  SOURCES
    area.c
    alwcren.c
    lmrgbren.c
    lmwcren.c
    ltmapps2.c
    sample.c
    vis.c
    polypack.c
    image.c)
set(RW_TOOLKIT_LIBS_IN_DIR rtltmap PARENT_SCOPE)
