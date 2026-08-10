# Amalgamated RenderWare DLL, porting makeincl/makedll. Gated on RW_DLL.
# The Cygwin dlltool+sed .def pipeline is replaced by
#   dumpbin /LINKERMEMBER:1  ->  cmake/rw-gendef.cmake (rwgdllfx.sed rules)

if(NOT RW_DLL)
  return()
endif()

if(NOT RW_TARGET MATCHES "^(null|d3d8|d3d9|opengl)$")
  message(FATAL_ERROR
    "DLL generation is only available for the null, d3d8, d3d9 and opengl "
    "targets (makedll:17-28).")
endif()

# locate dumpbin (not on PATH outside a VS developer prompt)
set(RW_DUMPBIN "" CACHE FILEPATH "dumpbin.exe used for DLL .def generation")
if(NOT RW_DUMPBIN)
  find_program(RW_DUMPBIN_AUTO dumpbin)
  if(NOT RW_DUMPBIN_AUTO)
    file(GLOB RW_DUMPBIN_AUTO
      "$ENV{VSINSTALLDIR}/VC/Tools/MSVC/*/bin/Hostx64/x86/dumpbin.exe"
      "$ENV{VSINSTALLDIR}/VC/Tools/MSVC/*/bin/Hostx86/x86/dumpbin.exe"
      "C:/Program Files/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx64/x86/dumpbin.exe"
      "C:/Program Files/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx86/x86/dumpbin.exe"
      "C:/Program Files (x86)/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx64/x86/dumpbin.exe"
      "C:/Program Files (x86)/Microsoft Visual Studio/*/*/VC/Tools/MSVC/*/bin/Hostx86/x86/dumpbin.exe")
    list(GET RW_DUMPBIN_AUTO 0 RW_DUMPBIN_AUTO)
  endif()
  if(RW_DUMPBIN_AUTO)
    set(RW_DUMPBIN "${RW_DUMPBIN_AUTO}" CACHE FILEPATH "" FORCE)
  else()
    message(FATAL_ERROR
      "dumpbin.exe not found; set RW_DUMPBIN to its full path (needed for DLL "
      ".def generation, replacing the bundled Cygwin dlltool).")
  endif()
endif()

set(_rwgdllname "rwg${RW_TARGET}$<$<CONFIG:Debug>:d>")

# makedll:62-151 - most-combined variant of each family to avoid duplicate
# symbols; target-conditional entries included.
set(_dlllibs
    rwcore rpworld
    rpanisot rpadc rpcollis rpdmorph rpenv rphanim rplodatm rpltmap rpmatfx
    rpmipkl rpmorph rppatchskinmatfx rpprtstd rpprtadv rpptank rppvs rprandom
    rpskinmatfx rpspline rpusrdat rpuvanim rpid)
if(RW_TARGET STREQUAL "null")
  list(APPEND _dlllibs rpnormmapskin)
else()
  list(APPEND _dlllibs rplogo)
endif()
if(RW_TARGET STREQUAL "d3d9")
  list(APPEND _dlllibs rpnormmapskin)
endif()
list(APPEND _dlllibs
    rt2d rt2danim rtanim rtdict rtbary rtbezpat rtbmp rtcharse rtcmpkey
    rtfsyst rtgcond rtimport rtintsec rtltmap rtltmapcnv rtmipkpatchmatfx
    rtnormmap rtpick rtpitexd rtpng rtquat rtras rtray rtslerp rtskinsp
    rtsplpvs rttiff rttilerd rttoc rtwing rtworld)
if(RW_TARGET STREQUAL "null")
  list(APPEND _dlllibs rtvcatmd)
else()
  list(APPEND _dlllibs rtvcat)
endif()
list(APPEND _dlllibs rpcrowd rpteam rptoon rttoon)

foreach(_lib IN LISTS _dlllibs)
  if(NOT TARGET ${_lib})
    message(FATAL_ERROR
      "DLL library ${_lib} is not built. Build all plugins/toolkits or drop RW_DLL.")
  endif()
endforeach()

set(_lib_paths "")
foreach(_lib IN LISTS _dlllibs)
  list(APPEND _lib_paths "$<TARGET_FILE:${_lib}>")
endforeach()

set(_def "${CMAKE_CURRENT_BINARY_DIR}/${_rwgdllname}.def")
set(_dumpbin_out "${CMAKE_CURRENT_BINARY_DIR}/linkermember.txt")
add_custom_command(OUTPUT "${_def}"
  COMMAND "${RW_DUMPBIN}" /LINKERMEMBER:1 ${_lib_paths} > "${_dumpbin_out}"
  COMMAND "${CMAKE_COMMAND}"
          "-DRW_DUMPBIN_OUTPUT=${_dumpbin_out}"
          "-DRW_DEF_OUTPUT=${_def}"
          -P "${RW_SRC_ROOT}/cmake/rw-gendef.cmake"
  DEPENDS ${_dlllibs}
  COMMENT "Generating ${_rwgdllname}.def from archive symbols"
  VERBATIM)

set(_rc_out "${CMAKE_CURRENT_BINARY_DIR}/rwgdll.res")
if(CMAKE_RC_COMPILER)
  add_custom_command(OUTPUT "${_rc_out}"
    COMMAND "${CMAKE_RC_COMPILER}"
            /nologo
            "/i${RW_GEN_INCDIR}"
            "/d$<$<CONFIG:Debug>:_DEBUG:NDEBUG>"
            "/fo${_rc_out}"
            "${RW_SRC_ROOT}/dllsrc/rwgdll.rc"
    DEPENDS "${RW_SRC_ROOT}/dllsrc/rwgdll.rc"
            "${RW_SRC_ROOT}/dllsrc/resource.h"
            "${RW_GEN_INCDIR}/rwversion.h"
    COMMENT "Compiling rwgdll.rc"
    VERBATIM)
else()
  message(FATAL_ERROR "rc.exe (CMAKE_RC_COMPILER) not available for the DLL build.")
endif()

# target-specific link dependencies (makedll ADDITIONALTARGETDEPS)
set(_target_deps "")
if(RW_TARGET MATCHES "d3d8|d3d9|opengl")
  list(APPEND _target_deps user32)
  list(APPEND _target_deps ${RW_DLL_DRV_LIBS})
endif()
if(RW_TARGET STREQUAL "opengl")
  list(APPEND _target_deps gdi32)
elseif(RW_TARGET STREQUAL "d3d9")
  list(APPEND _target_deps gdi32 advapi32)
endif()

set(_rtlib "$<$<CONFIG:Debug>:MSVCRTd.lib>")
string(APPEND _rtlib "$<$<NOT:$<CONFIG:Debug>>:MSVCRT.lib>")

add_library(rwgdll SHARED
  rwgdllep.c
  "${_rc_out}"
  ${_lib_paths})
rw_setup_target(rwgdll)
set_target_properties(rwgdll PROPERTIES
  OUTPUT_NAME "${_rwgdllname}"
  PREFIX "")
target_link_options(rwgdll PRIVATE
  /dll /fixed:no /largeaddressaware /incremental:no "/def:${_def}")
target_link_libraries(rwgdll PRIVATE ${_target_deps} "${_rtlib}")

set(RW_DLL_TARGET rwgdll PARENT_SCOPE)
