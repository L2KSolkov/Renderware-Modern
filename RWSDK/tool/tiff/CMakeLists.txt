rw_add_toolkit(rttiff DIR tool/tiff
  SOURCES
    libtiff/fax3sm_winnt.c
    libtiff/tif_aux.c
    libtiff/tif_close.c
    libtiff/tif_codec.c
    libtiff/tif_compress.c
    libtiff/tif_dir.c
    libtiff/tif_dirinfo.c
    libtiff/tif_dirread.c
    libtiff/tif_dirwrite.c
    libtiff/tif_dumpmode.c
    libtiff/tif_error.c
    libtiff/tif_fax3.c
    libtiff/tif_flush.c
    libtiff/tif_getimage.c
    libtiff/tif_jpeg.c
    libtiff/tif_luv.c
    libtiff/tif_lzw.c
    libtiff/tif_next.c
    libtiff/tif_open.c
    libtiff/tif_packbits.c
    libtiff/tif_pixarlog.c
    libtiff/tif_predict.c
    libtiff/tif_print.c
    libtiff/tif_read.c
    libtiff/tif_rw.c
    libtiff/tif_strip.c
    libtiff/tif_swab.c
    libtiff/tif_thunder.c
    libtiff/tif_tile.c
    libtiff/tif_version.c
    libtiff/tif_warning.c
    libtiff/tif_write.c
    libtiff/tif_zip.c
  EXTRA_DEFINES TIF_PLATFORM_CONSOLE
  EXTRA_INCLUDES "./libtiff")
set(RW_TOOLKIT_LIBS_IN_DIR rttiff PARENT_SCOPE)
