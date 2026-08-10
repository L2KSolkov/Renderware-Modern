# Example-specific option surface, porting shared/makeopt.
#
# The SDK option surface (RWOptions.cmake) is reused for RW_TARGET, RW_OS,
# RW_DEBUG, RW_METRICS, RW_MEMDEBUG, RW_VERBOSE, RW_SUPPRESS_INLINE,
# RW_SUPPRESS_OPTIMIZATION_PRAGMAS, RW_FULL_PLATFORM, RW_OUTPUT, RW_31_DIRS
# and the CDEBUG/COPTIMIZE/CPROFILE/SMALLCODE decoupling. The entries below
# are genuinely new to the examples.

option(RW_EXAMPLES_LOGO "RWLOGO: define RWLOGO and link rplogo" ON)
option(RW_EXAMPLES_SPLASH "RWSPLASH: device splash screen (links vfw32)" OFF)
option(RW_EXAMPLES_STAGE_ASSETS
       "Copy each example's models/textures/fonts beside its executable" ON)

# makeopt:159-171 - RWTARGET_$(RWPLATFORMEXE) define
if(RW_FULL_PLATFORM)
  set(RW_PLATFORMEXE "${RW_OS}_${RW_COMPILER}_${RW_TARGET}")
else()
  set(RW_PLATFORMEXE "${RW_TARGET}")
endif()

# Executable config suffix: m / d / p / wst / none, mirroring the directory
# suffix logic (RW_CONFIG_SUFFIX_GENEX) but with the short letters.
if(RW_METRICS)
  set(RW_EXE_SUFFIX "m")
elseif(RW_MSWST)
  set(RW_EXE_SUFFIX "wst")
else()
  # AUTO mode: derive from the build type. MinSizeRel and Release both land
  # in the flat release dir with no suffix, exactly like the make system.
  set(RW_EXE_SUFFIX
      "$<$<CONFIG:Debug>:d>$<$<CONFIG:RelWithDebInfo>:p>$<$<CONFIG:Release>:>$<$<CONFIG:MinSizeRel>:>")
endif()
if(RW_MANUAL_FLAGS)
  # manual mode: the resolved switches decide
  if(RW_METRICS)
    set(RW_EXE_SUFFIX "m")
  elseif(RW_CDEBUG_ENABLED)
    set(RW_EXE_SUFFIX "d")
  elseif(RW_CPROFILE_ENABLED)
    set(RW_EXE_SUFFIX "p")
  elseif(RW_MSWST)
    set(RW_EXE_SUFFIX "wst")
  else()
    set(RW_EXE_SUFFIX "")
  endif()
endif()

# d3dx8 for the vshader/pshader d3d8 variants (legacy DX SDK utility lib).
# Debug picks the d3dx8dt debug variant via CDEBUG.
set(RW_D3DX8_LIB
    "$<$<BOOL:${RW_CDEBUG_ENABLED}>:${RW_DXSDK_LIB}/d3dx8dt.lib>$<$<NOT:$<BOOL:${RW_CDEBUG_ENABLED}>>:${RW_DXSDK_LIB}/d3dx8.lib>")
