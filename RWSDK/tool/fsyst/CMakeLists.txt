# rtfsyst is built through makeplug in the make system (PLUGINAPI + rpe).
rw_add_plugin(rtfsyst DIR tool/fsyst
  PLUGIN rtfsyst
  PLUGINAPI fsystapi.h
  SOURCES
    rtfsyst.c
    rtfsmgr.c
    win/rtfswin.c
  EXTRA_INCLUDES "./win"
  PLUGININCDIR "." "./${RW_TARGET}" "./win")
set(RW_TOOLKIT_LIBS_IN_DIR rtfsyst PARENT_SCOPE)
