# rpworld from world/makefile + makeincl/makewrld.

set(RW_WORLD "${RW_SRC_ROOT}/world")

set(WORLD_CSRC
    "${RW_WORLD}/babinwor.c"
    "${RW_WORLD}/baclump.c"
    "${RW_WORLD}/bageomet.c"
    "${RW_WORLD}/balight.c"
    "${RW_WORLD}/bamateri.c"
    "${RW_WORLD}/bamatlst.c"
    "${RW_WORLD}/bamesh.c"
    "${RW_WORLD}/bameshop.c"
    "${RW_WORLD}/basector.c"
    "${RW_WORLD}/baworld.c"
    "${RW_WORLD}/baworobj.c")

set(RPWORLD_SRCS
    ${WORLD_CSRC}
    ${RW_WORLD_PIPE_CSRC}
    ${RW_WORLD_PIPE_PS_CSRC})
if(RW_DEBUG)
  list(APPEND RPWORLD_SRCS "${RW_GEN_INCDIR}/rpdbgerr.c")
endif()

# HSRC = CSRC .c->.h
set(HSRC_INPUTS "")
foreach(_c IN LISTS WORLD_CSRC RW_WORLD_PIPE_CSRC RW_WORLD_PIPE_PS_CSRC)
  string(REGEX REPLACE "\\.c$" ".h" _h "${_c}")
  list(APPEND HSRC_INPUTS "${_h}")
endforeach()

# makewrld: incgen $(HSRC) -I$(CURDIR) $(C_INC) -sstdlib -sstdarg
#           -prpworld -o$(RPHEAD) -lrpworld.lst -grwcore.h
# C_INC order: src, plcore, os, driver/common, $(DRVINC), world/pipe/p2,
# world/pipe/p2/<target>.
set(WORLD_INC_DIRS
    "${RW_SRC_ROOT}/src"
    "${RW_SRC_ROOT}/src/plcore"
    "${RW_SRC_ROOT}/os/${RW_OS}"
    "${RW_SRC_ROOT}/driver/common"
    ${RW_DRV_INC}
    "${RW_WORLD}/pipe/${RW_PIPETYPE}"
    "${RW_WORLD}/pipe/${RW_PIPETYPE}/${RW_TARGET}")

rw_generate_incgen_header(NAME rpworld_h
  OUTPUT "${RW_GEN_INCDIR}/rpworld.h"
  LISTFILE "${CMAKE_BINARY_DIR}/lists/rpworld.lst"
  INPUTS_FIRST
  INPUTS ${HSRC_INPUTS}
  INCLUDE_DIRS "${RW_WORLD}" ${WORLD_INC_DIRS}
  SYS stdlib stdarg
  PLUGIN rpworld
  GUARD rwcore.h)
set(RW_RPWORLD_HDR "${RW_GEN_INCDIR}/rpworld.h")

rw_generate_rpe(NAME rpworld_rpe PLUGIN_DIR "${RW_WORLD}" PLUGIN rpworld)
set(RW_RPWORLD_RPE "${RW_GEN_INCDIR}/rpworld.rpe")

add_library(rpworld STATIC ${RPWORLD_SRCS})
rw_setup_target(rpworld)
target_include_directories(rpworld PRIVATE ${RW_WORLD_PIPE_INC})
if(NOT RW_DLL AND RW_WORLD_LIBS)
  target_link_libraries(rpworld PRIVATE ${RW_WORLD_LIBS})
endif()
set_target_properties(rpworld PROPERTIES
  OUTPUT_NAME "${RW_LIB_PREFIX}rpworld${RW_LIB_SUFFIX}")
target_sources(rpworld PRIVATE
  "${RW_GEN_INCDIR}/rpworld.h"
  "${RW_GEN_INCDIR}/rpworld.rpe")
