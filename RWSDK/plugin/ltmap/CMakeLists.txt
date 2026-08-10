rw_add_plugin(rpltmap DIR plugin/ltmap
  PLUGIN rpltmap
  LIBNAME rpltmap
  PLUGINAPI rpltmap.h
  SOURCES generic.c
  TARGET_SOURCES
    "d3d8=d3d8/pipes.c"
    "d3d9=d3d9/pipes.c"
    "opengl=opengl/pipes.c"
    "null=null/pipes.c"
  EXTRA_INCLUDES "./${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpltmap PARENT_SCOPE)
