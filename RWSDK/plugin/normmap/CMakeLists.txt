rw_add_plugin(rpnormmap DIR plugin/normmap
  PLUGIN rpnormmap
  LIBNAME rpnormmap
  SOURCES rpnormmap.c
  TARGET_SOURCES
    "d3d9=d3d9/normmapd3d9.c;d3d9/normmapd3d9plain.c"
    "d3d8=null/normmapnull.c;null/normmapnullplain.c"
    "opengl=null/normmapnull.c;null/normmapnullplain.c"
    "null=null/normmapnull.c;null/normmapnullplain.c"
  EXTRA_INCLUDES "./d3d9")

rw_add_plugin(rpnormmapskin DIR plugin/normmap
  PLUGIN rpnormmap
  LIBNAME rpnormmapskin
  GENERATE_HEADERS OFF
  SOURCES rpnormmap.c
  TARGET_SOURCES
    "d3d9=d3d9/normmapd3d9.c;d3d9/normmapd3d9skin.c"
    "d3d8=null/normmapnull.c;null/normmapnullskin.c"
    "opengl=null/normmapnull.c;null/normmapnullskin.c"
    "null=null/normmapnull.c;null/normmapnullskin.c"
  EXTRA_INCLUDES "./d3d9")
set(RW_PLUGIN_LIBS_IN_DIR rpnormmap rpnormmapskin PARENT_SCOPE)
