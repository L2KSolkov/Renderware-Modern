rw_add_plugin(rpteam DIR plugin/team
  SOURCES
    team.c
    teamdictionary.c
    teamlod.c
    teammaterial.c
    teammatfx.c
    teamoptimize.c
    teampipes.c
    teamplayer.c
    teamshadow.c
    teamskin.c
    teamstatic.c
    teamstream.c
  TARGET_SOURCES
    "d3d8=d3d8/teamrenderd3d8.c;d3d8/teammatfxd3d8.c;d3d8/teamshadowd3d8.c;d3d8/teamskind3d8.c;d3d8/teamstaticd3d8.c;d3d8/teamd3d8.c"
    "d3d9=d3d9/teamrenderd3d9.c;d3d9/teammatfxd3d9.c;d3d9/teamshadowd3d9.c;d3d9/teamskind3d9.c;d3d9/teamstaticd3d9.c;d3d9/teamd3d9.c"
    "opengl=opengl/teamrenderopengl.c;opengl/teammatfxopengl.c;opengl/teamshadowopengl.c;opengl/teamskinopengl.c;opengl/teamstaticopengl.c;opengl/teamopengl.c"
    "null=null/teamnull.c"
  EXTRA_INCLUDES "./${RW_TARGET}")
set(RW_PLUGIN_LIBS_IN_DIR rpteam PARENT_SCOPE)
