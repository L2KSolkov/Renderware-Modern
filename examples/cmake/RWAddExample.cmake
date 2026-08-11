# rw_add_example() - analogue of shared/maketarg.
#
#   rw_add_example(camera
#     SOURCES        src/main.c src/camexamp.c src/viewer.c src/win/events.c
#     RW_LIBS        rtpng rtbmp
#     ASSET_DIRS     models)
#
# Sources are relative to the example directory (the directory owning this
# CMakeLists.txt). TARGET_SOURCES entries
# ("target=file1;file2", reconstructed because quoted semicolons are list
# separators) select per-render-target sources, e.g. vshader's D3D8/D3D9
# variants. SUPPORTED_TARGETS restricts an example to specific targets and
# prints a configure-time skip otherwise.

function(rw_add_example NAME)
  cmake_parse_arguments(X
    ""
    "DEMO"
    "SOURCES;RW_LIBS;ASSET_DIRS;SUPPORTED_TARGETS;TARGET_SOURCES"
    ${ARGN})

  if(NOT X_DEMO)
    set(X_DEMO "${NAME}")
  endif()

  if(X_SUPPORTED_TARGETS)
    list(FIND X_SUPPORTED_TARGETS "${RW_TARGET}" _idx)
    if(_idx EQUAL -1)
      message(STATUS "Skipping example ${NAME}: unsupported on RW_TARGET=${RW_TARGET}")
      return()
    endif()
  endif()

  set(_dir "${CMAKE_CURRENT_SOURCE_DIR}")

  # per-target source selection
  set(_selected "")
  set(_cur_target "")
  set(_cur_files "")
  foreach(_entry IN LISTS X_TARGET_SOURCES)
    if(_entry MATCHES "^([A-Za-z0-9_]+)=(.*)$")
      if(NOT _cur_target STREQUAL "" AND RW_TARGET STREQUAL _cur_target)
        set(_selected ${_cur_files})
      endif()
      set(_cur_target "${CMAKE_MATCH_1}")
      set(_cur_files "${CMAKE_MATCH_2}")
    else()
      list(APPEND _cur_files "${_entry}")
    endif()
  endforeach()
  if(NOT _cur_target STREQUAL "" AND RW_TARGET STREQUAL _cur_target)
    set(_selected ${_cur_files})
  endif()

  set(_srcs "")
  foreach(_s IN LISTS X_SOURCES)
    list(APPEND _srcs "${_dir}/${_s}")
  endforeach()
  foreach(_s IN LISTS _selected)
    list(APPEND _srcs "${_dir}/${_s}")
  endforeach()

  add_executable(${NAME} ${_srcs})
  rw_setup_example_target(${NAME})
  target_include_directories(${NAME} PRIVATE "${_dir}/src")
  if(RW_EXAMPLES_LOGO AND NOT "rplogo" IN_LIST X_RW_LIBS)
    list(APPEND X_RW_LIBS rplogo)
  endif()

  # The framework resource (device-selection dialog) must be linked into
  # every executable; a static library would drop it.
  set(_winrc "${RW_SRC_ROOT}/../shared/skel/win/win.rc")
  target_sources(${NAME} PRIVATE "${_winrc}")
  set_property(SOURCE "${_winrc}" APPEND PROPERTY
    INCLUDE_DIRECTORIES "${RW_SRC_ROOT}/../shared/skel/win")

  target_link_libraries(${NAME} PRIVATE rwskel)
  foreach(_lib IN LISTS X_RW_LIBS)
    target_link_libraries(${NAME} PRIVATE "${RW_EXAMPLE_LIB_PREFIX}${_lib}")
  endforeach()
  # The skeleton is a Win32 GUI app (WinMain, windows subsystem) and needs
  # winmm for timeGetTime in win.c.
  target_link_libraries(${NAME} PRIVATE winmm)
  if(RW_EXAMPLES_SPLASH)
    target_link_libraries(${NAME} PRIVATE vfw32)
  endif()
  # Under RW_DLL the driver libraries (d3d9.lib, d3dx9.lib, ...) are deferred
  # to the amalgamated DLL link, so examples linking the static libs must add
  # them explicitly.
  if(TARGET rwcore AND RW_DLL AND RW_DLL_DRV_LIBS)
    target_link_libraries(${NAME} PRIVATE ${RW_DLL_DRV_LIBS})
  endif()

  # <demo>_<platform>[suffix].exe, e.g. camera_d3d9.exe / camera_d3d9d.exe
  set_target_properties(${NAME} PROPERTIES
    OUTPUT_NAME "${X_DEMO}_${RW_EXAMPLES_PLATFORMEXE}${RW_EXAMPLES_EXE_SUFFIX}")
  set_target_properties(${NAME} PROPERTIES WIN32_EXECUTABLE TRUE)

  set_target_properties(${NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/examples/${NAME}/$<CONFIG>")
  foreach(_cfg IN ITEMS Debug Release RelWithDebInfo MinSizeRel)
    set_target_properties(${NAME} PROPERTIES
      "VS_DEBUGGER_WORKING_DIRECTORY_${_cfg}"
      "${CMAKE_BINARY_DIR}/examples/${NAME}/${_cfg}")
  endforeach()

  if(RW_EXAMPLES_STAGE_ASSETS)
    foreach(_a IN LISTS X_ASSET_DIRS)
      if(EXISTS "${_dir}/${_a}")
        add_custom_command(TARGET ${NAME} POST_BUILD
          COMMAND "${CMAKE_COMMAND}" -E copy_directory_if_different
                  "${_dir}/${_a}"
                  "$<TARGET_FILE_DIR:${NAME}>/${_a}"
          COMMENT "Staging ${_a} assets for ${NAME}"
          VERBATIM)
      endif()
    endforeach()
  endif()
endfunction()
