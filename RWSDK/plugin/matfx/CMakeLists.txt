rw_add_plugin(rpmatfx DIR plugin/matfx
  PLUGIN rpmatfx
  PLUGINAPI matfxapi.h
  TARGET_SOURCES
    "d3d8=d3d8/effectPipesD3D8.c"
    "d3d9=d3d9/effectPipesD3D9.c"
    "opengl=opengl/effectPipesOpenGL.c"
    "null=null/effectPipesNull.c;null/multiTexNull.c;multiTex.c;multiTexEffect.c"
  EXTRA_INCLUDES "./${RW_TARGET}"
  PLUGININCDIR "." "${RW_SRC_ROOT}/plugin/matfx/${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpmatfx PARENT_SCOPE)
