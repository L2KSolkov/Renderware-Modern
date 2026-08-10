rw_add_toolkit(rt2d DIR tool/2d
  SOURCES
    brush.c
    fill.c
    font.c
    gstate.c
    path.c
    stroke.c
    2dstr.c
    object.c
    pickreg.c
    scene.c
    shape.c
    tri.c)
set(RW_TOOLKIT_LIBS_IN_DIR rt2d PARENT_SCOPE)
