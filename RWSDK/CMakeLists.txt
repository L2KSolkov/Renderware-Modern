cmake_minimum_required(VERSION 3.21)

project(RenderWare37
  VERSION 3.7.2
  DESCRIPTION "RenderWare Graphics 3.7.2 SDK (Win32)"
  LANGUAGES C CXX ASM_MASM)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING
    "MSVC runtime (overridden per-option by RWOptions.cmake)")
set(CMAKE_DEBUG_POSTFIX "" CACHE STRING "No debug postfix: names must match the make system")

include(cmake/RWOptions.cmake)
include(cmake/FindDX8SDK.cmake)
include(cmake/RWTargets.cmake)
include(cmake/RWTargetUtils.cmake)
include(cmake/RWCodegen.cmake)
include(cmake/RWAddPlugin.cmake)
include(cmake/RWAddToolkit.cmake)

# Banner reproduced from RWSDK/makefile:27-31.
message(STATUS "")
message(STATUS "Building RenderWare target - ${RW_TARGET}")
message(STATUS "Using compiler - ${RW_COMPILER}")
message(STATUS "Using operating system - ${RW_OS}")
message(STATUS "")

set(RW_INSTALL_PREFIX "${RW_SRC_ROOT}" CACHE PATH
    "Where lib/<platform>/<config>/, include/<platform>/ and dll/... land.
    Defaults to the SDK root so the make-system layout is reproduced next to
    the sources.")

# `make header` / `make equate` equivalents, defined early so subdirectories
# can add_dependencies onto them.
add_custom_target(rw-headers)
add_custom_target(rw-equate)

add_subdirectory(buildtools)

add_subdirectory(src)

if(RW_ONLY_PLCORE)
  # makefile:49-66 - only rwplcore and the rtfsyst toolkit are built
  if(RW_BUILD_TOOLKITS)
    add_subdirectory(tool)
  endif()
else()
  add_subdirectory(world)
  if(RW_BUILD_PLUGINS)
    add_subdirectory(plugin)
  endif()
  if(RW_BUILD_TOOLKITS)
    add_subdirectory(tool)
  endif()
endif()

if(RW_DLL)
  add_subdirectory(dllsrc)
endif()

##---------------------------------------------------------- docs / QA
if(RW_BUILD_DOCS)
  add_custom_target(doxy
    COMMAND ${CMAKE_COMMAND} -E echo "doxy: doxycfg/doxygen/hhc are not available; skipping."
    VERBATIM)
  add_custom_target(doc
    COMMAND ${CMAKE_COMMAND} -E echo "doc: doxycfg/doxygen/hhc are not available; skipping."
    VERBATIM)
else()
  add_custom_target(doxy
    COMMAND ${CMAKE_COMMAND} -E echo "RW_BUILD_DOCS=OFF; the doxy/doc chain is not built."
    VERBATIM)
  add_custom_target(doc
    COMMAND ${CMAKE_COMMAND} -E echo "RW_BUILD_DOCS=OFF; the doxy/doc chain is not built."
    VERBATIM)
endif()

if(RW_BUILD_QA_TARGETS)
  add_custom_target(verify
    COMMAND ${CMAKE_COMMAND} -E echo "verify: rwcheck is not available; skipping."
    VERBATIM)
  add_custom_target(longline
    COMMAND ${CMAKE_COMMAND} -E echo "longline: egrep is not available; skipping."
    VERBATIM)
  add_custom_target(tabs
    COMMAND ${CMAKE_COMMAND} -E echo "tabs: egrep is not available; skipping."
    VERBATIM)
  add_custom_target(defgroup
    COMMAND ${CMAKE_COMMAND} -E echo "defgroup: egrep is not available; skipping."
    VERBATIM)
  add_custom_target(csrc
    COMMAND ${CMAKE_COMMAND} -E echo "csrc: source list is visible in the CMake target sources."
    VERBATIM)
  add_custom_target(maintainers
    COMMAND ${CMAKE_COMMAND} -E echo "maintainers: see the per-library makefiles in the tree."
    VERBATIM)
endif()

##---------------------------------------------------------------- install
# Reproduce the make-system layout under RWSDK/lib/<platform>/<suffix>,
# RWSDK/include/<platform> and RWSDK/dll/<platform>/<suffix> so existing
# consumers of those paths keep working. `cmake --install` materializes them.
set(RW_INSTALL_LIBDIR "lib/${RW_PLATFORM}/${RW_OUTPUT_COMPONENT}${RW_CONFIG_SUFFIX_GENEX}")
set(RW_INSTALL_DLLDIR "dll/${RW_PLATFORM}/${RW_OUTPUT_COMPONENT}${RW_CONFIG_SUFFIX_GENEX}")

set(RW_INSTALL_TARGETS rwplcore rwcore)
if(NOT RW_ONLY_PLCORE)
  list(APPEND RW_INSTALL_TARGETS rpworld ${RW_PLUGIN_LIB_TARGETS})
endif()
list(APPEND RW_INSTALL_TARGETS ${RW_TOOLKIT_LIB_TARGETS})

install(TARGETS ${RW_INSTALL_TARGETS}
  EXPORT RenderWareTargets
  ARCHIVE DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_LIBDIR}"
  LIBRARY DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_LIBDIR}"
  RUNTIME DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_LIBDIR}")

install(DIRECTORY "${RW_GEN_INCDIR}/"
  DESTINATION "${RW_INSTALL_PREFIX}/include/${RW_PLATFORM}")

if(RW_DLL)
  install(TARGETS rwgdll
    EXPORT RenderWareTargets
    RUNTIME DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_DLLDIR}"
    LIBRARY DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_DLLDIR}"
    ARCHIVE DESTINATION "${RW_INSTALL_PREFIX}/${RW_INSTALL_LIBDIR}")
endif()

# OBJECT library backing rwplcore/rwcore: export it so the export set is
# self-contained.
install(TARGETS rwplcore_obj
  EXPORT RenderWareTargets)

##---------------------------------------------------------------- export
install(EXPORT RenderWareTargets
  FILE RenderWareTargets.cmake
  NAMESPACE RenderWare::
  DESTINATION "lib/cmake/RenderWare")

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/RenderWareConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)
configure_package_config_file(
  "${RW_SRC_ROOT}/cmake/RenderWareConfig.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/RenderWareConfig.cmake"
  INSTALL_DESTINATION "lib/cmake/RenderWare")
install(FILES
  "${CMAKE_CURRENT_BINARY_DIR}/RenderWareConfig.cmake"
  "${CMAKE_CURRENT_BINARY_DIR}/RenderWareConfigVersion.cmake"
  DESTINATION "lib/cmake/RenderWare")
