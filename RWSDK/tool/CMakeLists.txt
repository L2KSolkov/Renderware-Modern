# All toolkit directories. RW_TOOLKITS accepts directory names or primary
# library names. Under RW_ONLY_PLCORE only fsyst is built (makefile:49-66).

set(RW_TOOLKIT_DIRS
    2d 2danim anim bezpatch bmp brycntrc charse cmpkey dict fsyst gencpipe
    geomcond import intsec ltmap ltmapcnv mipmapk normmap pick pitexd png
    quat ras ray sknsplit slerp splpvs tiff tilerd toc toon vcat wing world)
set(RW_TOOLKIT_LIBNAMES
    rt2d rt2danim rtanim rtbezpat rtbmp rtbary rtcharse rtcmpkey rtdict
    rtfsyst rtgncpip rtgcond rtimport rtintsec rtltmap rtltmapcnv rtmipk
    rtnormmap rtpick rtpitexd rtpng rtquat rtras rtray rtskinsp rtslerp
    rtsplpvs rttiff rttilerd rttoc rttoon rtvcat rtwing rtworld)

set(_sel_dir "${RW_TOOLKITS}")
set(RW_TOOLKIT_LIB_TARGETS "")
set(_i 0)
foreach(_dir IN LISTS RW_TOOLKIT_DIRS)
  list(GET RW_TOOLKIT_LIBNAMES ${_i} _lib)
  math(EXPR _i "${_i} + 1")
  set(_selected FALSE)
  if(RW_ONLY_PLCORE)
    if(_dir STREQUAL "fsyst")
      set(_selected TRUE)
    endif()
  elseif(NOT _sel_dir)
    set(_selected TRUE)
  else()
    foreach(_name IN LISTS _sel_dir)
      if(_dir STREQUAL _name OR _lib STREQUAL _name)
        set(_selected TRUE)
      endif()
    endforeach()
  endif()
  if(_selected)
    add_subdirectory("${_dir}")
    list(APPEND RW_TOOLKIT_LIB_TARGETS ${RW_TOOLKIT_LIBS_IN_DIR})
  endif()
endforeach()

set(RW_TOOLKIT_LIB_TARGETS ${RW_TOOLKIT_LIB_TARGETS} PARENT_SCOPE)
