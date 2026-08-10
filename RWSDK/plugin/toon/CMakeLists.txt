rw_add_plugin(rptoon DIR plugin/toon
  PLUGIN rptoon
  PLUGINAPI toonapi.h
  SOURCES
    toonink.c
    toonpaint.c
    toongeo.c
    toonmaterial.c
  TARGET_SOURCES
    "d3d8=d3d8/brutesilhouette.c;d3d8/edgerender.c;d3d8/crease.c;d3d8/d3d8paint.c"
    "d3d9=d3d9/brutesilhouette.c;d3d9/edgerender.c;d3d9/crease.c;d3d9/d3d9paint.c"
    "opengl=generic/brutesilhouette.c;generic/genericedgerender.c;generic/crease.c;opengl/openglpaint.c"
    "null=generic/brutesilhouette.c;generic/genericedgerender.c;generic/crease.c;generic/genericpipes.c"
  EXTRA_INCLUDES "./generic" "./${RW_TARGET}"
  PLUGININCDIR "." "${RW_SRC_ROOT}/plugin/toon/${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rptoon PARENT_SCOPE)
