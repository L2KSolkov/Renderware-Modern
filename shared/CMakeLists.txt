# rwskel: the shared Rs* skeleton framework, replacing the per-example
# compiles of shared/maketarg. Every example links this library.

set(RW_SKEL "${CMAKE_CURRENT_SOURCE_DIR}")

set(_skel_srcs
    "${RW_SKEL}/skel/skeleton.c"
    "${RW_SKEL}/skel/win/win.c"
    "${RW_SKEL}/democom/camera.c"
    "${RW_SKEL}/democom/menu.c")
if(RW_METRICS)
  list(APPEND _skel_srcs
    "${RW_SKEL}/skel/vecfont.c"
    "${RW_SKEL}/skel/metrics.c")
endif()
if(RW_EXAMPLES_SPLASH)
  list(APPEND _skel_srcs "${RW_SKEL}/skel/win/splash.c")
endif()

add_library(rwskel STATIC ${_skel_srcs})
rw_setup_target(rwskel)
target_include_directories(rwskel PUBLIC
    "${RW_SKEL}/skel"
    "${RW_SKEL}/skel/win"
    "${RW_SKEL}/democom")
target_link_libraries(rwskel PUBLIC
    rwcore
    rpworld
    rtcharse
    rtfsyst
    rtpng
    rtbmp
    rppatch)
set_target_properties(rwskel PROPERTIES
    OUTPUT_NAME "rwskel")
