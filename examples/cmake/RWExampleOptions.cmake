# Example option surface - deliberately separate from the SDK's options.
#
# The SDK's RW_TARGET/RW_OS/RW_DEBUG/RW_METRICS/... cache options govern
# RWSDK/ only. The examples have their own RW_EXAMPLES_* surface below; the
# only coupling is that the examples link the SDK targets, so the superbuild
# always configures RWSDK/ first and each example depends on the SDK
# libraries (in-tree) or on an installed package (standalone mode).

##------------------------------------------------------------ selection
set(RW_EXAMPLES "" CACHE STRING
    "Semicolon list of example directories to build; empty means all")

option(RW_EXAMPLES_LOGO "RWLOGO: define RWLOGO and link rplogo" ON)
option(RW_EXAMPLES_SPLASH "RWSPLASH: device splash screen (links vfw32)" OFF)
option(RW_EXAMPLES_STAGE_ASSETS
       "Copy each example's models/textures/fonts beside its executable" ON)

##--------------------------------------------------------------- target
# Defaults to the SDK target; validated against it in-tree so the examples
# link libraries that actually match their RWTARGET_* define. In standalone
# mode it is free (the installed package is assumed to match).
set(RW_EXAMPLES_TARGET "" CACHE STRING
    "Render target for the examples (default: the SDK's RW_TARGET)")
if(RW_EXAMPLES_TARGET STREQUAL "")
  set(RW_EXAMPLES_TARGET "${RW_TARGET}"
      CACHE STRING "Render target for the examples" FORCE)
endif()
if(TARGET rwcore AND NOT RW_EXAMPLES_TARGET STREQUAL RW_TARGET)
  message(FATAL_ERROR
    "RW_EXAMPLES_TARGET=${RW_EXAMPLES_TARGET} does not match the configured "
    "SDK target RW_TARGET=${RW_TARGET}. Reconfigure the superbuild with the "
    "same target, or build examples standalone against an installed SDK for "
    "that target.")
endif()

if(RW_FULL_PLATFORM)
  set(RW_EXAMPLES_PLATFORMEXE
      "${RW_OS}_${RW_COMPILER}_${RW_EXAMPLES_TARGET}")
else()
  set(RW_EXAMPLES_PLATFORMEXE "${RW_EXAMPLES_TARGET}")
endif()

##------------------------------------------------------- build mode
# AUTO mirrors the make system defaults per CMake configuration; ON/OFF
# override explicitly. The choices drive the compile flags, the RWMETRICS
# define and the executable suffix (m > d > p > wst > none).
#
# Note: RW_EXAMPLES_DEBUG deliberately does NOT define RWDEBUG. That define
# changes the SDK public-header ABI (e.g. RwMatrixGetRight becomes an extern
# function implemented in the SDK libraries), so it must stay in the SDK's
# option domain. Examples compiled with debug flags still link the SDK
# libraries as configured.
set(RW_EXAMPLES_DEBUG "AUTO" CACHE STRING
    "Debug build of the examples. AUTO = Debug config; ON/OFF overrides.")
set(RW_EXAMPLES_PROFILE "AUTO" CACHE STRING
    "Profiling build of the examples. AUTO = RelWithDebInfo config; ON/OFF overrides.")
set(RW_EXAMPLES_MSWST "OFF" CACHE BOOL
    "Working Set Tuner build of the examples ('wst' suffix)")
set(RW_EXAMPLES_METRICS "OFF" CACHE BOOL
    "Compile the on-screen metrics overlay ('m' suffix)")
set(RW_EXAMPLES_OPTIMIZE "AUTO" CACHE STRING
    "Optimization of example code. AUTO = off for debug/profile/MSWST, else on; ON/OFF overrides.")
foreach(_v IN ITEMS RW_EXAMPLES_DEBUG RW_EXAMPLES_PROFILE RW_EXAMPLES_OPTIMIZE)
  set_property(CACHE ${_v} PROPERTY STRINGS AUTO ON OFF)
endforeach()

if(RW_EXAMPLES_DEBUG STREQUAL "ON")
  set(RW_EXAMPLES_DEBUG_ENABLED 1)
elseif(RW_EXAMPLES_DEBUG STREQUAL "OFF")
  set(RW_EXAMPLES_DEBUG_ENABLED 0)
else()
  set(RW_EXAMPLES_DEBUG_ENABLED "$<CONFIG:Debug>")
endif()
if(RW_EXAMPLES_PROFILE STREQUAL "ON")
  set(RW_EXAMPLES_PROFILE_ENABLED 1)
elseif(RW_EXAMPLES_PROFILE STREQUAL "OFF")
  set(RW_EXAMPLES_PROFILE_ENABLED 0)
else()
  set(RW_EXAMPLES_PROFILE_ENABLED "$<CONFIG:RelWithDebInfo>")
endif()
if(RW_EXAMPLES_MSWST)
  set(RW_EXAMPLES_MSWST_ENABLED 1)
else()
  set(RW_EXAMPLES_MSWST_ENABLED 0)
endif()
if(RW_EXAMPLES_METRICS)
  set(RW_EXAMPLES_METRICS_ENABLED 1)
else()
  set(RW_EXAMPLES_METRICS_ENABLED 0)
endif()
if(RW_EXAMPLES_OPTIMIZE STREQUAL "ON")
  set(RW_EXAMPLES_OPTIMIZE_ENABLED 1)
elseif(RW_EXAMPLES_OPTIMIZE STREQUAL "OFF")
  set(RW_EXAMPLES_OPTIMIZE_ENABLED 0)
else()
  set(RW_EXAMPLES_OPTIMIZE_ENABLED
      "$<IF:$<OR:$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>,$<BOOL:${RW_EXAMPLES_PROFILE_ENABLED}>,$<BOOL:${RW_EXAMPLES_MSWST_ENABLED}>>,0,1>")
endif()

# Executable suffix: <demo>_<platform>[m|d|p|wst].exe
if(RW_EXAMPLES_METRICS_ENABLED)
  set(RW_EXAMPLES_EXE_SUFFIX "m")
elseif(RW_EXAMPLES_MSWST_ENABLED)
  set(RW_EXAMPLES_EXE_SUFFIX "wst")
else()
  set(RW_EXAMPLES_EXE_SUFFIX
      "$<$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>:d>$<$<BOOL:${RW_EXAMPLES_PROFILE_ENABLED}>:p>")
endif()

##------------------------------------------------------- compile flags
set(_rw_ex_dbg "/Zi;/D_DEBUG;/UNDEBUG;/MTd")
set(_rw_ex_prf "/Zi;/U_DEBUG;/DNDEBUG;/MT")
set(_rw_ex_wst "/DNDEBUG;/EHsc;/Gh;/Gs;/Ob1;/Zi;/U_CRTDBG_MAP_ALLOC;/U_DEBUG;/MT")
set(_rw_ex_rel "/U_DEBUG;/DNDEBUG;/MT")
set(_rw_ex_opt "/O2;/Ob2")
set(_rw_ex_noopt "/Od;/Ob0;/Oy-")
set(_rw_ex_optchoice
    "$<$<BOOL:${RW_EXAMPLES_OPTIMIZE_ENABLED}>:${_rw_ex_opt}>$<$<NOT:$<BOOL:${RW_EXAMPLES_OPTIMIZE_ENABLED}>>:${_rw_ex_noopt}>")
set(RW_EXAMPLE_CONFIG_FLAGS
    "$<$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>:${_rw_ex_dbg}>"
    "$<$<BOOL:${RW_EXAMPLES_PROFILE_ENABLED}>:${_rw_ex_prf}>"
    "$<$<BOOL:${RW_EXAMPLES_MSWST_ENABLED}>:${_rw_ex_wst}>"
    "$<$<NOT:$<OR:$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>,$<BOOL:${RW_EXAMPLES_PROFILE_ENABLED}>,$<BOOL:${RW_EXAMPLES_MSWST_ENABLED}>>>:${_rw_ex_rel}>"
    "$<$<NOT:$<BOOL:${RW_EXAMPLES_MSWST_ENABLED}>>:${_rw_ex_optchoice}>")

# Include dirs: the SDK's generated include tree plus the base SDK include
# dirs. Set up by examples/CMakeLists.txt for the current mode (in-tree vs
# installed package).
set(RW_EXAMPLE_INCLUDE_DIRS ${RW_GEN_INCDIR} ${RW_C_INC} ${RW_DRV_INC})

# Shared per-target setup for examples and the rwskel framework: base Win32
# defines, the RWTARGET_* define and the example-scoped compile flags. No /Zl
# (executables need the CRT default-library directives) and no SDK feature
# defines - those belong to the SDK build.
function(rw_setup_example_target tgt)
  target_compile_definitions(${tgt} PRIVATE
    WIN32 _WINDOWS _MBCS __MSC__ VC_EXTRALEAN
    WIN32_EXTRA_LEAN WIN32_LEAN_AND_MEAN
    "RWTARGET_${RW_EXAMPLES_PLATFORMEXE}"
    "$<$<BOOL:${RW_EXAMPLES_METRICS_ENABLED}>:RWMETRICS>")
  if(RW_EXAMPLES_LOGO)
    target_compile_definitions(${tgt} PRIVATE RWLOGO)
  endif()
  if(RW_EXAMPLES_SPLASH)
    target_compile_definitions(${tgt} PRIVATE RWSPLASH)
  endif()
  target_include_directories(${tgt} PRIVATE ${RW_EXAMPLE_INCLUDE_DIRS})
  target_compile_options(${tgt} PRIVATE /nologo /W3 ${RW_EXAMPLE_CONFIG_FLAGS})
endfunction()

# d3dx8 for the vshader/pshader d3d8 variants (legacy DX SDK utility lib).
# Debug picks the d3dx8dt debug variant via the example debug switch.
if(DEFINED RW_DXSDK_LIB)
  set(RW_EXAMPLES_D3DX8_LIB
      "$<$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>:${RW_DXSDK_LIB}/d3dx8dt.lib>$<$<NOT:$<BOOL:${RW_EXAMPLES_DEBUG_ENABLED}>>:${RW_DXSDK_LIB}/d3dx8.lib>")
endif()
