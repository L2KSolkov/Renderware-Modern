# All plugin directories. RW_PLUGINS accepts either directory names (as the
# make system's PLUGINS) or the primary library name (e.g. rpskin for skin2).
# RW_ONLY_PLCORE prunes the whole tree, matching makefile:49-66.

set(RW_PLUGIN_DIRS
    adc anisot collis crowd dmorph env hanim id lodatm logo ltmap matfx
    mipkl morph normmap patch prtadv prtstd ptank pvs random skin2 spline
    team toon userdata uvanim)
set(RW_PLUGIN_LIBNAMES
    rpadc rpanisot rpcollis rpcrowd rpdmorph rpenv rphanim rpid rplodatm
    rplogo rpltmap rpmatfx rpmipkl rpmorph rpnormmap rppatch rpprtadv rpprtstd
    rpptank rppvs rprandom rpskin rpspline rpteam rptoon rpusrdat rpuvanim)

set(_sel_dir "${RW_PLUGINS}")
set(RW_PLUGIN_LIB_TARGETS "")
list(LENGTH RW_PLUGIN_DIRS _ndirs)
math(EXPR _nlibs "${_ndirs}")
set(_i 0)
foreach(_dir IN LISTS RW_PLUGIN_DIRS)
  list(GET RW_PLUGIN_LIBNAMES ${_i} _lib)
  math(EXPR _i "${_i} + 1")
  set(_selected FALSE)
  if(NOT _sel_dir)
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
    list(APPEND RW_PLUGIN_LIB_TARGETS ${RW_PLUGIN_LIBS_IN_DIR})
  endif()
endforeach()

set(RW_PLUGIN_LIB_TARGETS ${RW_PLUGIN_LIB_TARGETS} PARENT_SCOPE)
