rw_add_plugin(rpcrowd DIR plugin/crowd
  TARGET_SOURCES
    "d3d8=d3d8/crowdd3d8.c;crowdstaticbb.c"
    "d3d9=d3d9/crowdd3d9.c;crowdstaticbb.c"
    "opengl=opengl/crowdopengl.c;crowdstaticbb.c"
    "null=null/crowdnull.c"
  GENERIC_SOURCES
    crowdgeneric.c
    crowdstaticbb.c
  EXTRA_INCLUDES "./${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpcrowd PARENT_SCOPE)
