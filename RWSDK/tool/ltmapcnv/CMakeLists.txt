rw_add_toolkit(rtltmapcnv DIR tool/ltmapcnv
  SOURCES
    rasterg.c
    fillerg.c
    rasterng.c
    fillerng.c
    atmcnv.c
    worldcnv.c
    rtltmapcnv.c)
set(RW_TOOLKIT_LIBS_IN_DIR rtltmapcnv PARENT_SCOPE)
