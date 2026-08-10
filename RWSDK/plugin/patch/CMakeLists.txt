rw_add_plugin(rppatch DIR plugin/patch
  PLUGIN rppatch
  LIBNAME rppatch
  PLUGINAPI patchapi.h
  SOURCES
    patchmesh.c
    patchmaterial.c
    patchatomic.c
    patchgeometry.c
    patchnoskin.c
    patchstream.c
    patchsmooth.c
    patchhelper.c
    patchlod.c
  TARGET_SOURCES
    "d3d8=patchexpander.c;d3d8/patchd3d8.c;d3d8/patchd3d8plain.c;d3d8/noded3d8patchatomicinstance.c"
    "d3d9=patchexpander.c;d3d9/patchd3d9.c;d3d9/patchd3d9plain.c;d3d9/noded3d9patchatomicinstance.c"
    "opengl=patchexpander.c;patchgeom.c;opengl/patchplatform.c;opengl/patchopengl.c;opengl/patchopenglgeneric.c"
    "null=null/patchplatform.c;null/patchnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}")

rw_add_plugin(rppatchmatfx DIR plugin/patch
  PLUGIN rppatch
  LIBNAME rppatchmatfx
  PLUGINAPI patchapi.h
  GENERATE_HEADERS OFF
  SOURCES
    patchmesh.c
    patchmatfx.c
    patchmaterial.c
    patchatomic.c
    patchgeometry.c
    patchnoskin.c
    patchstream.c
    patchsmooth.c
    patchhelper.c
    patchlod.c
  TARGET_SOURCES
    "d3d8=patchexpander.c;d3d8/patchd3d8.c;d3d8/patchd3d8matfx.c;d3d8/noded3d8patchatomicinstance.c"
    "d3d9=patchexpander.c;d3d9/patchd3d9.c;d3d9/patchd3d9matfx.c;d3d9/noded3d9patchatomicinstance.c"
    "opengl=patchexpander.c;patchgeom.c;opengl/patchplatform.c;opengl/patchopengl.c;opengl/patchopenglmatfx.c"
    "null=null/patchplatform.c;null/patchmatfxnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}")

rw_add_plugin(rppatchskin DIR plugin/patch
  PLUGIN rppatch
  LIBNAME rppatchskin
  PLUGINAPI patchapi.h
  GENERATE_HEADERS OFF
  SOURCES
    patchmesh.c
    patchmaterial.c
    patchatomic.c
    patchgeometry.c
    patchskin.c
    patchstream.c
    patchsmooth.c
    patchhelper.c
    patchlod.c
  TARGET_SOURCES
    "d3d8=patchexpander.c;d3d8/patchd3d8.c;d3d8/patchd3d8skin.c;d3d8/noded3d8patchatomicinstance.c;d3d8/noded3d8patchskinatomicinstance.c"
    "d3d9=patchexpander.c;d3d9/patchd3d9.c;d3d9/patchd3d9skin.c;d3d9/noded3d9patchatomicinstance.c;d3d9/noded3d9patchskinatomicinstance.c"
    "opengl=patchexpander.c;patchgeom.c;opengl/patchplatform.c;opengl/patchopengl.c;opengl/patchopenglskinrender.c;opengl/patchopenglskin.c"
    "null=null/patchplatform.c;null/patchskinnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}")

rw_add_plugin(rppatchskinmatfx DIR plugin/patch
  PLUGIN rppatch
  LIBNAME rppatchskinmatfx
  PLUGINAPI patchapi.h
  GENERATE_HEADERS OFF
  SOURCES
    patchmesh.c
    patchmatfx.c
    patchmaterial.c
    patchatomic.c
    patchgeometry.c
    patchskin.c
    patchstream.c
    patchsmooth.c
    patchhelper.c
    patchlod.c
  TARGET_SOURCES
    "d3d8=patchexpander.c;d3d8/patchd3d8.c;d3d8/patchd3d8skinmatfx.c;d3d8/noded3d8patchatomicinstance.c;d3d8/noded3d8patchskinatomicinstance.c"
    "d3d9=patchexpander.c;d3d9/patchd3d9.c;d3d9/patchd3d9skinmatfx.c;d3d9/noded3d9patchatomicinstance.c;d3d9/noded3d9patchskinatomicinstance.c"
    "opengl=patchexpander.c;patchgeom.c;opengl/patchplatform.c;opengl/patchopengl.c;opengl/patchopenglskinrender.c;opengl/patchopenglskinmatfx.c"
    "null=null/patchplatform.c;null/patchskinmatfxnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rppatch rppatchmatfx rppatchskin rppatchskinmatfx PARENT_SCOPE)
