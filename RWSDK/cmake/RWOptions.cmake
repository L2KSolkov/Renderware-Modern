# RenderWare 3.7.2 option surface.
#
# Direct port of RWSDK/makeincl/makeopt and options.mak.sample: every make
# variable maps to a cache entry, nothing is silently dropped. The one
# deliberate removal is RWDEPEND - CMake tracks header dependencies natively.

if(RW_OPTIONS_INCLUDED)
  return()
endif()
set(RW_OPTIONS_INCLUDED TRUE)

get_filename_component(RW_SRC_ROOT "${CMAKE_CURRENT_LIST_DIR}/.." ABSOLUTE)

##----------------------------------------------------------------- feature
## defines (makeopt lines 276-349)
option(RW_DEBUG "RWDEBUG: turn on RenderWare debug" OFF)
if(NOT DEFINED CACHE{RW_VALIDATE_PARAM})
  set(RW_VALIDATE_PARAM "${RW_DEBUG}"
      CACHE BOOL "RWVALIDATEPARAM: parameter validation (defaults to RW_DEBUG)"
      FORCE)
endif()
option(RW_TRACE "RWTRACE: trace stack of function calls to debug log" OFF)
option(RW_METRICS "RWMETRICS: metrics" OFF)
option(RW_MEMDEBUG "RWMEMDEBUG: memory debug (internal/CSL use)" OFF)
option(RW_VERBOSE "RWVERBOSE: verbose debug (internal/CSL use)" OFF)
option(RW_STACK_DEPTH_CHECKING "RWSTACKDEPTHCHECKING: stack depth checks" OFF)
option(RW_EVALUATION "RWEVALUATION: evaluation build" OFF)
option(RW_USE_SPF "RW_USE_SPF: single precision floating point maths" OFF)
option(RW_SUPPRESS_INLINE "RWSUPPRESSINLINE: inline suppression" OFF)
option(RW_SUPPRESS_OPTIMIZATION_PRAGMAS
       "RWSUPPRESSOPTIMIZATIONPRAGMAS: optimization pragma suppression" OFF)
option(RW_IBM_CHAR "_IBM_CHAR" OFF)
option(RW_ONLY_PLCORE
       "RWONLYPLCORE: only build rwplcore plus the rtfsyst toolkit" OFF)
option(RW_SW15 "RWSW15: 15 bit rasterisation (defines FB1555)" OFF)
option(RW_COLOUR_DMA "COLOURDMA: PS2 colour DMA (stub)" OFF)
option(RW_PS2MANAGER "PS2MANAGER: PS2 manager (stub)" OFF)
option(RW_NOASM "NOASM: use C implementations of assembler sources" OFF)
option(RW_NOSSEASM "NOSSEASM: do not compile SSE assembler" OFF)

set(RW_FEATURE_DEFINES "")
if(RW_DEBUG)
  list(APPEND RW_FEATURE_DEFINES RWDEBUG)
endif()
if(RW_VALIDATE_PARAM)
  list(APPEND RW_FEATURE_DEFINES RWVALIDATEPARAM)
endif()
if(RW_TRACE)
  list(APPEND RW_FEATURE_DEFINES RWTRACE)
endif()
if(RW_METRICS)
  list(APPEND RW_FEATURE_DEFINES RWMETRICS)
endif()
if(RW_MEMDEBUG)
  list(APPEND RW_FEATURE_DEFINES RWMEMDEBUG)
endif()
if(RW_VERBOSE)
  list(APPEND RW_FEATURE_DEFINES RWVERBOSE)
endif()
if(RW_STACK_DEPTH_CHECKING)
  list(APPEND RW_FEATURE_DEFINES RWSTACKDEPTHCHECKING)
endif()
if(RW_EVALUATION)
  list(APPEND RW_FEATURE_DEFINES RWEVALUATION)
endif()
if(RW_USE_SPF)
  list(APPEND RW_FEATURE_DEFINES RW_USE_SPF)
endif()
if(RW_SUPPRESS_INLINE)
  list(APPEND RW_FEATURE_DEFINES RWSUPPRESSINLINE)
endif()
if(RW_SUPPRESS_OPTIMIZATION_PRAGMAS)
  list(APPEND RW_FEATURE_DEFINES RWSUPPRESSOPTIMIZATIONPRAGMAS)
endif()
if(RW_IBM_CHAR)
  list(APPEND RW_FEATURE_DEFINES _IBM_CHAR)
endif()
if(RW_ONLY_PLCORE)
  list(APPEND RW_FEATURE_DEFINES RWONLYPLCORE)
endif()
if(RW_SW15)
  list(APPEND RW_FEATURE_DEFINES FB1555)
endif()
if(RW_COLOUR_DMA)
  list(APPEND RW_FEATURE_DEFINES DMA_COLOUR)
endif()
if(RW_PS2MANAGER)
  list(APPEND RW_FEATURE_DEFINES PS2MANAGER)
endif()
if(RW_NOASM)
  list(APPEND RW_FEATURE_DEFINES NOASM)
endif()
if(RW_NOSSEASM)
  list(APPEND RW_FEATURE_DEFINES NOSSEASM)
endif()

##------------------------------------------------------- platform / target
set(RW_OS "win" CACHE STRING
    "RWOS: win (implemented); mac linux sky gcn xbox are stubs")
set_property(CACHE RW_OS PROPERTY STRINGS win mac linux sky gcn xbox)

set(RW_TARGET "d3d9" CACHE STRING
    "RWTARGET: d3d9 d3d8 opengl null implemented; the rest are stubs")
set_property(CACHE RW_TARGET PROPERTY STRINGS
    d3d9 d3d8 opengl null sky2 gcn xbox softras nullsky nullxbox nullgcn)

set(RW_PIPETYPE "p2" CACHE STRING
    "PIPETYPE: p2 is the only pipeline in the tree; generic is reserved")
set_property(CACHE RW_PIPETYPE PROPERTY STRINGS p2 generic)

if(NOT CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  message(FATAL_ERROR
    "RenderWare CMake port supports MSVC (RWCOMPILER=visualc) only. "
    "The 11 makecom files for other compilers are not ported.")
endif()
# RWCOMPILER is derived and read-only; exported only so output paths and the
# banner match the make system.
set(RW_COMPILER "visualc")

##--------------------------------------------------------- output layout
## makeopt lines 155-248
option(RW_FULL_PLATFORM
       "RWFULLPLATFORM: lib/<os>/<compiler>/<target> instead of lib/<target>"
       OFF)
option(RW_31_DIRS "RW31DIRS: RW3.1-style flat output directories" OFF)
option(RW_MSWST "MSWST: Microsoft Working Set Tuner build" OFF)
set(RW_OUTPUT "" CACHE STRING "RWOUTPUT: extra path component under lib/<platform>")
set(RW_LIB_PREFIX "" CACHE STRING "LIBPREFIX: library name prefix")
set(RW_LIB_SUFFIX "" CACHE STRING "OPTEXT: library name suffix (md/mt/cw/...)")

if(RW_FULL_PLATFORM)
  set(RW_PLATFORM "${RW_OS}/${RW_COMPILER}/${RW_TARGET}")
else()
  set(RW_PLATFORM "${RW_TARGET}")
endif()

# Config suffix follows the make precedence exactly: metrics -> debug ->
# profile -> mswst -> flat (RW31DIRS) -> release.
if(RW_METRICS)
  set(RW_CONFIG_SUFFIX_GENEX "metrics")
elseif(RW_MSWST)
  set(RW_CONFIG_SUFFIX_GENEX
      "$<$<CONFIG:Debug>:debug>$<$<CONFIG:RelWithDebInfo>:profile>$<$<CONFIG:Release>:mswst>$<$<CONFIG:MinSizeRel>:mswst>")
else()
  set(RW_CONFIG_SUFFIX_GENEX
      "$<$<CONFIG:Debug>:debug>$<$<CONFIG:RelWithDebInfo>:profile>$<$<CONFIG:Release>:release>$<$<CONFIG:MinSizeRel>:release>")
endif()
if(RW_31_DIRS)
  set(RW_CONFIG_SUFFIX_GENEX "")
endif()

set(RW_OUTPUT_COMPONENT "")
if(NOT RW_OUTPUT STREQUAL "")
  set(RW_OUTPUT_COMPONENT "${RW_OUTPUT}/")
endif()

set(RW_SDK_LIBDIR
    "${RW_SRC_ROOT}/lib/${RW_PLATFORM}/${RW_OUTPUT_COMPONENT}${RW_CONFIG_SUFFIX_GENEX}")
set(RW_SDK_DLLDIR
    "${RW_SRC_ROOT}/dll/${RW_PLATFORM}/${RW_OUTPUT_COMPONENT}${RW_CONFIG_SUFFIX_GENEX}")

set(RW_SDK_INCDIR "${RW_SRC_ROOT}/include/${RW_PLATFORM}")
set(RW_GEN_INCDIR "${CMAKE_BINARY_DIR}/include/${RW_PLATFORM}")

##------------------------------------------------------------ library form
option(RW_DLL "RWDLL: build the amalgamated rwg<target>[d].dll" OFF)
option(RW_VCAT_RUNTIME_VARIANTS
       "Build rtvcatmd/rtvcatmt runtime variants (null target only)" OFF)

##--------------------------------------------------------------- selection
set(RW_PLUGINS "" CACHE STRING
    "PLUGINS: semicolon list of plugin names; empty means all")
set(RW_TOOLKITS "" CACHE STRING
    "TOOLKITS: semicolon list of toolkit names; empty means all")
option(RW_BUILD_PLUGINS "Build the plugin libraries" ON)
option(RW_BUILD_TOOLKITS "Build the toolkit libraries" ON)
option(RW_BUILD_BUILDTOOLS
       "Build incgen/inline/findsyms/cwpath host tools from source" ON)
option(RW_ARCHIVE_PLUGINS "APLUGINS: archive plugins (none ship in this drop)"
       OFF)

##------------------------------------------------------ external SDK paths
set(RW_DXSDK_DIR "" CACHE PATH
    "DXSDK: legacy DirectX SDK. Required for d3d8; d3d9 needs its d3dx9.h/d3dx9.lib")
set(RW_OGL_LIB_PATH "" CACHE PATH "OGLLIBPATH: OpenGL library path")
set(RW_APPLEGL_SDK_PATH "" CACHE PATH "APPLEGLSDKPATH (stub)")
set(RW_IOP_PATH "" CACHE PATH "IOPPATH (stub)")
set(RW_XBOX_SDK "" CACHE PATH "XBOXSDK (stub)")

##------------------------------------------------------------ docs / QA
option(RW_BUILD_DOCS
       "doxy/doc chain; needs doxycfg/doxygen/hhc and skips with a warning"
       OFF)
option(RW_BUILD_QA_TARGETS
       "verify/longline/tabs/defgroup/csrc/maintainers custom targets" ON)

##------------------------------------------------------ compiler flag sets
## visualc/makecom with legacy /ML(/MLd) mapped to /MT(/MTd), /GX to /EHsc,
## and the combined -Oity/-Ob0gity forms replaced by their modern equivalents.
set(RW_BASE_C_FLAGS /nologo /W3 /Zl)
set(RW_BASE_DEFINES WIN32 _WINDOWS _MBCS __MSC__ VC_EXTRALEAN
    WIN32_EXTRA_LEAN WIN32_LEAN_AND_MEAN)

set(RW_DBG_FLAGS "/Od;/Ob0;/Oy-;/Zi;/D_DEBUG;/UNDEBUG")
set(RW_PRF_FLAGS "/O2;/Zi;/U_DEBUG;/DNDEBUG")
set(RW_MIN_FLAGS "/O1;/Ob2;/U_DEBUG;/DNDEBUG")
set(RW_REL_FLAGS "/O2;/Ob2;/U_DEBUG;/DNDEBUG")
set(RW_WST_FLAGS "/DNDEBUG;/EHsc;/Gh;/Gs;/O2;/Ob1;/Zi;/U_CRTDBG_MAP_ALLOC;/U_DEBUG")

set(RW_RT_DBG "$<IF:$<BOOL:${RW_DLL}>,/MDd,/MTd>")
set(RW_RT_REL "$<IF:$<BOOL:${RW_DLL}>,/MD,/MT>")

if(RW_MSWST)
  set(RW_CONFIG_FLAGS
      "$<$<CONFIG:Debug>:${RW_DBG_FLAGS};${RW_RT_DBG}>"
      "$<$<CONFIG:RelWithDebInfo>:${RW_PRF_FLAGS};${RW_RT_REL}>"
      "$<$<CONFIG:Release>:${RW_WST_FLAGS}>"
      "$<$<CONFIG:MinSizeRel>:${RW_WST_FLAGS}>")
else()
  set(RW_CONFIG_FLAGS
      "$<$<CONFIG:Debug>:${RW_DBG_FLAGS};${RW_RT_DBG}>"
      "$<$<CONFIG:RelWithDebInfo>:${RW_PRF_FLAGS};${RW_RT_REL}>"
      "$<$<CONFIG:MinSizeRel>:${RW_MIN_FLAGS};/MD>"
      "$<$<CONFIG:Release>:${RW_REL_FLAGS};${RW_RT_REL}>")
endif()

##---------------------------------------------------------------- include dirs
## base C_INC from makeincl/rwtarget/default/maketarg plus the pipe includes
## makecore/makewrld add. Order is significant for code generation parity.
set(RW_C_INC
    "${RW_SRC_ROOT}/src"
    "${RW_SRC_ROOT}/src/plcore"
    "${RW_SRC_ROOT}/os/${RW_OS}"
    "${RW_SRC_ROOT}/driver/common")
# DRVINC is appended by the per-target file

##--------------------------------------------------------------- validation
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  message(FATAL_ERROR
    "RenderWare 3.7.2 is Win32-only. The MASM sources and the inline __asm "
    "in cpuext.c, ssematml.c, ptank*.c, ssematbl.c, x86matbl.c and ostypes.h "
    "are 32-bit only and MSVC rejects inline assembly on x64.")
endif()

if(RW_ARCHIVE_PLUGINS)
  message(WARNING "RW_ARCHIVE_PLUGINS is ON but no archive plugin ships in this drop.")
endif()
