rw_add_plugin(rpptank DIR plugin/ptank
  PLUGIN rpptank
  PLUGINAPI ptankapi.h
  TARGET_SOURCES
    "d3d8=d3d8/ptankd3d8.c;ptank.c"
    "d3d9=d3d9/ptankd3d9.c;ptank.c"
    "opengl=opengl/ptankopengl.c;ptank.c"
    "null=generic/ptankgen.c;ptank.c"
  EXTRA_INCLUDES "./generic" "./${RW_TARGET}"
  PLUGININCDIR "." "${RW_SRC_ROOT}/plugin/ptank/${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpptank PARENT_SCOPE)
