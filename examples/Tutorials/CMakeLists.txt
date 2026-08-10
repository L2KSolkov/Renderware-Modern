# The seven tutorials, each with its own CMakeLists.txt in its directory.
# RW_EXAMPLES accepts the TutorialN directory names to select a subset.

set(RW_TUTORIAL_DIRS Tutorial1 Tutorial2 Tutorial3 Tutorial4 Tutorial5
    Tutorial6 Tutorial7)

foreach(_dir IN LISTS RW_TUTORIAL_DIRS)
  if(NOT RW_EXAMPLES OR _dir IN_LIST RW_EXAMPLES)
    add_subdirectory("${_dir}")
  endif()
endforeach()
