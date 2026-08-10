# rwplcore and rwcore from src/makefile + makeincl/makecore.
#
# rwplcore is an OBJECT library whose objects are archived into both
# rwplcore.lib and rwcore.lib, matching makecore:156-164 where both archives
# are cut from the same object set. No compilation is duplicated.

set(RW_SRC "${RW_SRC_ROOT}/src")
set(RW_OSDIR "${RW_SRC_ROOT}/os/${RW_OS}")
set(RW_DRVCOM "${RW_SRC_ROOT}/driver/common")
set(RW_DRVSPEC "${RW_SRC_ROOT}/driver/${RW_TARGET}")
set(RW_DRVSTUB "${RW_SRC_ROOT}/driver/stub")

set(PLCORE_SRCS
    "${RW_SRC}/plcore/babinary.c"
    "${RW_SRC}/plcore/babinmtx.c"
    "${RW_SRC}/plcore/bacolor.c"
    "${RW_SRC}/plcore/badebug.c"
    "${RW_SRC}/plcore/baerr.c"
    "${RW_SRC}/plcore/baimmedi.c"
    "${RW_SRC}/plcore/balist.c"
    "${RW_SRC}/plcore/bamatrix.c"
    "${RW_SRC}/plcore/bamemory.c"
    "${RW_SRC}/plcore/baresour.c"
    "${RW_SRC}/plcore/bastream.c"
    "${RW_SRC}/plcore/batkbin.c"
    "${RW_SRC}/plcore/batkreg.c"
    "${RW_SRC}/plcore/bavector.c"
    "${RW_SRC}/plcore/resmem.c"
    "${RW_SRC}/plcore/rwdbgerr.c"
    "${RW_SRC}/plcore/rwgrp.c"
    "${RW_SRC}/plcore/rwstring.c"
    "${RW_OSDIR}/osintf.c")

set(PLCORE_INIT_SRC "${RW_SRC}/plcore/baplcore.c")
set(STUB_DRV_SRC "${RW_DRVSTUB}/sbdevice.c")

set(CORE_SRCS
    "${RW_SRC}/babbox.c"
    "${RW_SRC}/babincam.c"
    "${RW_SRC}/babinfrm.c"
    "${RW_SRC}/babintex.c"
    "${RW_SRC}/bacamera.c"
    "${RW_SRC}/badevice.c"
    "${RW_SRC}/baframe.c"
    "${RW_SRC}/baimage.c"
    "${RW_SRC}/baimras.c"
    "${RW_SRC}/baraster.c"
    "${RW_SRC}/baresamp.c"
    "${RW_SRC}/basync.c"
    "${RW_SRC}/batextur.c"
    "${RW_SRC}/batypehf.c")

if(RW_EVALUATION)
  list(APPEND CORE_SRCS "${RW_SRC}/bacamval.c")
endif()

##------------------------------------------------------------ codegen
rw_copy_core_headers()

# PLCORE_INC from makecore + default maketarg:
# -I$(OSDIR) -I$(PLCOREDIR) -I$(DEVDIR)/common $(DRVINC)
set(PLCORE_INC_DIRS
    "${RW_OSDIR}"
    "${RW_SRC}/plcore"
    "${RW_DRVCOM}"
    ${RW_DRV_INC})

# HPLCORE = PLCORECSRC .c->.h minus src/badevice.h, then balibtyp.h batypes.h
set(HPLCORE_INPUTS
    "${RW_SRC}/plcore/babinary.h"
    "${RW_SRC}/plcore/babinmtx.h"
    "${RW_SRC}/plcore/bacolor.h"
    "${RW_SRC}/plcore/badebug.h"
    "${RW_SRC}/plcore/baerr.h"
    "${RW_SRC}/plcore/baimmedi.h"
    "${RW_SRC}/plcore/balist.h"
    "${RW_SRC}/plcore/bamatrix.h"
    "${RW_SRC}/plcore/bamemory.h"
    "${RW_SRC}/plcore/baresour.h"
    "${RW_SRC}/plcore/bastream.h"
    "${RW_SRC}/plcore/batkbin.h"
    "${RW_SRC}/plcore/batkreg.h"
    "${RW_SRC}/plcore/bavector.h"
    "${RW_SRC}/plcore/resmem.h"
    "${RW_SRC}/plcore/rwdbgerr.h"
    "${RW_SRC}/plcore/rwgrp.h"
    "${RW_SRC}/plcore/rwstring.h"
    "${RW_OSDIR}/osintf.h"
    "${RW_SRC}/plcore/balibtyp.h"
    "${RW_SRC}/plcore/batypes.h")

rw_generate_incgen_header(NAME rwplcore_h
  OUTPUT "${RW_GEN_INCDIR}/rwplcore.h"
  LISTFILE "${CMAKE_BINARY_DIR}/lists/rwplcore.lst"
  INCLUDE_DIRS ${PLCORE_INC_DIRS}
  INPUTS ${HPLCORE_INPUTS}
  SYS stdlib stdio stddef stdarg)
set(RW_PLCORE_HDR "${RW_GEN_INCDIR}/rwplcore.h")

# HCORE = CSRC .c->.h plus src/pipe/p2/<target>/pip2model.h. CSRC is the 14
# src files followed by GENERICDRVCSRC, SPECIFICDRVCSRC, PIPECSRC, PIPEPSCSRC
# (makecore ordering).
set(HCORE_INPUTS
    "${RW_SRC}/babbox.h"
    "${RW_SRC}/babincam.h"
    "${RW_SRC}/babinfrm.h"
    "${RW_SRC}/babintex.h"
    "${RW_SRC}/bacamera.h"
    "${RW_SRC}/badevice.h"
    "${RW_SRC}/baframe.h"
    "${RW_SRC}/baimage.h"
    "${RW_SRC}/baimras.h"
    "${RW_SRC}/baraster.h"
    "${RW_SRC}/baresamp.h"
    "${RW_SRC}/basync.h"
    "${RW_SRC}/batextur.h"
    "${RW_SRC}/batypehf.h")
foreach(_c IN LISTS RW_GENERIC_DRV_SRC RW_SPECIFIC_DRV_SRC RW_PIPE_CSRC RW_PIPE_PS_CSRC)
  string(REGEX REPLACE "\\.c$" ".h" _h "${_c}")
  list(APPEND HCORE_INPUTS "${_h}")
endforeach()
list(APPEND HCORE_INPUTS "${RW_SRC}/pipe/p2/${RW_TARGET}/pip2model.h")

# CORE_INC = -I$(SRCDIR) -I$(DEVDIR)/common $(DRVINC) -I$(BASEDIR)/src
#            -I../os/$(RWOS) -I$(BASEDIR)/src/pipe/$(PIPETYPE)
#            [-I$(BASEDIR)/src/pipe/$(PIPETYPE)/$(RWTARGET)]
set(CORE_INC_DIRS
    "${RW_SRC}"
    "${RW_DRVCOM}"
    ${RW_DRV_INC}
    "${RW_SRC}"
    "${RW_OSDIR}"
    "${RW_SRC}/pipe/${RW_PIPETYPE}"
    "${RW_SRC}/pipe/${RW_PIPETYPE}/${RW_TARGET}")

rw_generate_incgen_header(NAME rwcore_h
  OUTPUT "${RW_GEN_INCDIR}/rwcore.h"
  LISTFILE "${CMAKE_BINARY_DIR}/lists/rwcore.lst"
  INCLUDE_DIRS ${CORE_INC_DIRS}
  INPUTS ${HCORE_INPUTS}
  SYS rwplcore)
set(RW_CORE_HDR "${RW_GEN_INCDIR}/rwcore.h")

add_custom_target(rw-core-headers DEPENDS
  rw-corehdr-rwversion.h
  rw-corehdr-rpcriter.h
  rw-corehdr-rpdbgerr.c
  rw-corehdr-rpdbgerr.h
  rw-corehdr-rperror.h
  rw-corehdr-errcom.def
  rw-corehdr-errcore.def
  rwplcore_h
  rwcore_h)

##-------------------------------------------------------------- equate
rw_generate_equate()

##------------------------------------------------------------ libraries
# PLCOREOBJ (makecore) = the 18 plcore objects plus osintf; these objects are
# archived into BOTH rwplcore.lib and rwcore.lib. baplcore.c and sbdevice.c
# go into rwplcore.lib only, so the two archives do not duplicate the engine
# globals (RwEngineInit etc. live in baplcore.c).
add_library(rwplcore_obj OBJECT ${PLCORE_SRCS})
rw_setup_target(rwplcore_obj)
target_include_directories(rwplcore_obj PRIVATE ${RW_PIPE_INC})
add_dependencies(rwplcore_obj rw-headers)
target_sources(rwplcore_obj PRIVATE
  "${RW_GEN_INCDIR}/rwplcore.h"
  "${RW_GEN_INCDIR}/rwcore.h")

add_library(rwplcore STATIC
  $<TARGET_OBJECTS:rwplcore_obj>
  ${PLCORE_INIT_SRC}
  ${STUB_DRV_SRC})
rw_setup_target(rwplcore)
target_include_directories(rwplcore PRIVATE ${RW_PIPE_INC})
add_dependencies(rwplcore rw-headers)
set_target_properties(rwplcore PROPERTIES
  OUTPUT_NAME "${RW_LIB_PREFIX}rwplcore${RW_LIB_SUFFIX}")
target_sources(rwplcore PRIVATE
  "${RW_GEN_INCDIR}/rwplcore.h"
  "${RW_GEN_INCDIR}/rwcore.h")

set(RW_CORE_ASM_SRC "")
if(NOT RW_NOASM)
  set(RW_CORE_ASM_SRC ${RW_GENERIC_DRV_ASM_SRC})
endif()

add_library(rwcore STATIC
  $<TARGET_OBJECTS:rwplcore_obj>
  ${CORE_SRCS}
  ${RW_GENERIC_DRV_SRC}
  ${RW_SPECIFIC_DRV_SRC}
  ${RW_PIPE_CSRC}
  ${RW_PIPE_PS_CSRC}
  ${RW_CORE_ASM_SRC})
rw_setup_target(rwcore)
target_include_directories(rwcore PRIVATE ${RW_PIPE_INC})
add_dependencies(rwcore rw-headers)
target_link_libraries(rwcore PRIVATE ${RW_DRV_LIBS})
set_target_properties(rwcore PROPERTIES
  OUTPUT_NAME "${RW_LIB_PREFIX}rwcore${RW_LIB_SUFFIX}")
target_sources(rwcore PRIVATE
  "${RW_GEN_INCDIR}/rwplcore.h"
  "${RW_GEN_INCDIR}/rwcore.h")

if(NOT RW_NOASM)
  target_sources(rwcore PRIVATE "${RW_EQUATE_OUTPUT}")
endif()

##---------------------------------------------------------- MASM flags
# visualc/makecom:84-94 plus the baequate.i include directory (build tree).
set(CMAKE_ASM_MASM_FLAGS
    "/nologo /c /W2 /Cp /Zm /DBCC /DSTACK /coff /I${RW_SRC_ROOT}/driver/common /I${RW_SRC_ROOT}/os/${RW_OS}/masm /I${RW_SRC_ROOT}/src /I${RW_SRC_ROOT}/driver/${RW_TARGET} /I${RW_GEN_INCDIR}")
if(NOT RW_NOASM)
  # baequate.i is generated into the build tree, not the source tree
  string(APPEND CMAKE_ASM_MASM_FLAGS
    " /I${CMAKE_BINARY_DIR}/driver/${RW_TARGET}")
endif()
if(RW_SW15)
  string(APPEND CMAKE_ASM_MASM_FLAGS " /DFB1555")
endif()

# The equate file is a build-tree artifact; keep the tree pristine.
set(CMAKE_ASM_MASM_FLAGS_DEBUG "")
set(CMAKE_ASM_MASM_FLAGS_RELEASE "")
