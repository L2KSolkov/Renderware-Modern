cmake_minimum_required(VERSION 3.21)

project(RenderWare37
  VERSION 3.7.2
  DESCRIPTION "RenderWare Graphics 3.7.2 SDK and examples (Win32)"
  LANGUAGES C CXX ASM_MASM)

set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING
    "MSVC runtime (overridden per-option by RWOptions.cmake)")
set(CMAKE_DEBUG_POSTFIX "" CACHE STRING "No debug postfix: names must match the make system")

option(RW_BUILD_EXAMPLES "Build the 66 example programs" ON)

add_subdirectory(RWSDK)

if(RW_BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()
