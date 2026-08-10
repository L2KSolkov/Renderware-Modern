# Four libraries generated from one source family. makefile.sharedskin
# contributes the platform-independent and per-target shared sources; the
# makefile.skin* files add the variant-specific bits. The rpskin.h/rpskin.rpe
# outputs are generated once (rpskin) and shared by all four variants.
set(_skin_shared_srcs bsplit.c)
set(_skin_d3d9_shared
    "d3d9/skinplatform.c;d3d9/skind3d9.c;d3d9/skind3d9generic.c;d3d9/skind3d9instance.c;d3d9/skind3d9pipesshared.c;win/ssematbl.c;win/x86matbl.c")
set(_skin_d3d8_shared
    "d3d8/skinplatform.c;d3d8/skind3d8.c;d3d8/skind3d8pipesshared.c;win/ssematbl.c;win/x86matbl.c")
set(_skin_opengl_shared
    "opengl/skinplatform.c;opengl/skinopengl.c;win/x86matbl.c;win/ssematbl.c")
set(_skin_null_shared
    "null/skinplatform.c;null/skinnullshared.c")

rw_add_plugin(rpskin DIR plugin/skin2
  PLUGIN rpskin
  LIBNAME rpskin
  PLUGINAPI skinapi.h
  SOURCES ${_skin_shared_srcs}
  TARGET_SOURCES
    "d3d8=${_skin_d3d8_shared};d3d8/skind3d8plain.c"
    "d3d9=${_skin_d3d9_shared};d3d9/skind3d9plain.c"
    "opengl=${_skin_opengl_shared};opengl/skinopenglplain.c"
    "null=${_skin_null_shared};null/skinnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}" "./win")

rw_add_plugin(rpskinmatfx DIR plugin/skin2
  PLUGIN rpskin
  LIBNAME rpskinmatfx
  PLUGINAPI skinapi.h
  GENERATE_HEADERS OFF
  SOURCES ${_skin_shared_srcs}
  TARGET_SOURCES
    "d3d8=${_skin_d3d8_shared};d3d8/skind3d8matfxshared.c;d3d8/skind3d8matfx.c"
    "d3d9=${_skin_d3d9_shared};d3d9/skind3d9matfxshared.c;d3d9/skind3d9matfx.c"
    "opengl=${_skin_opengl_shared};opengl/skinopenglmatfx.c"
    "null=${_skin_null_shared};null/skinmatfxnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}" "./win")

rw_add_plugin(rpskintoon DIR plugin/skin2
  PLUGIN rpskin
  LIBNAME rpskintoon
  PLUGINAPI skinapi.h
  GENERATE_HEADERS OFF
  SOURCES ${_skin_shared_srcs}
  TARGET_SOURCES
    "d3d8=${_skin_d3d8_shared};d3d8/skind3d8toonshared.c;d3d8/skind3d8toon.c"
    "d3d9=${_skin_d3d9_shared};d3d9/skind3d9toonshared.c;d3d9/skind3d9toon.c"
    "opengl=${_skin_opengl_shared};opengl/skinopengltoon.c"
    "null=${_skin_null_shared};null/skintoonnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}" "./win")

rw_add_plugin(rpskinmatfxtoon DIR plugin/skin2
  PLUGIN rpskin
  LIBNAME rpskinmatfxtoon
  PLUGINAPI skinapi.h
  GENERATE_HEADERS OFF
  SOURCES ${_skin_shared_srcs}
  TARGET_SOURCES
    "d3d8=${_skin_d3d8_shared};d3d8/skind3d8matfxshared.c;d3d8/skind3d8toonshared.c;d3d8/skind3d8matfxtoon.c"
    "d3d9=${_skin_d3d9_shared};d3d9/skind3d9matfxshared.c;d3d9/skind3d9toonshared.c;d3d9/skind3d9matfxtoon.c"
    "opengl=${_skin_opengl_shared};opengl/skinopenglmatfxtoon.c"
    "null=${_skin_null_shared};null/skinmatfxtoonnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}" "./win")
set(RW_PLUGIN_LIBS_IN_DIR rpskin rpskinmatfx rpskintoon rpskinmatfxtoon PARENT_SCOPE)
