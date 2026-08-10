# rtfsyst is built through makeplug in the make system (PLUGINAPI + rpe).
if(RW_FSYST_HEADERS_ONLY)
  rw_add_plugin(rtfsyst_hdrs DIR tool/fsyst
    PLUGIN rtfsyst
    PLUGINAPI fsystapi.h
    SKIP_LIBRARY
    SOURCES
      rtfsyst.c
      rtfsmgr.c
      win/rtfswin.c
    EXTRA_INCLUDES "./win"
    PLUGININCDIR "." "./${RW_TARGET}" "./win")
  set(RW_TOOLKIT_LIBS_IN_DIR "" PARENT_SCOPE)
else()
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
endif()
