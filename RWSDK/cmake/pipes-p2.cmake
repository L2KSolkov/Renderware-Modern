# makeincl/rwtarget/pipe/p2/maketarg - core and world pipeline source sets.
# Only the four implemented Win32 targets are ported; the console targets
# (d3d, softras, sky2, gcn, xbox, nullsky, nullxbox, nullgcn) are rejected by
# their target stub files before this point.

set(RW_PIPE_CSRC
    "${RW_SRC_ROOT}/src/pipe/p2/baim3d.c"
    "${RW_SRC_ROOT}/src/pipe/p2/bapipe.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2altmdl.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2core.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2define.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2dep.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2heap.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2macros.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2renderstate.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2resort.c"
    "${RW_SRC_ROOT}/src/pipe/p2/p2stdcls.c")

set(RW_PIPE_INC
    "${RW_SRC_ROOT}/src/pipe/p2"
    "${RW_SRC_ROOT}/src/pipe/p2/${RW_TARGET}")

set(RW_WORLD_PIPE_CSRC "${RW_SRC_ROOT}/world/pipe/p2/bapipew.c")
set(RW_WORLD_PIPE_INC
    "${RW_SRC_ROOT}/world/pipe/p2"
    "${RW_SRC_ROOT}/world/pipe/p2/${RW_TARGET}")

if(RW_TARGET STREQUAL "null")
  set(RW_PIPE_PS_CSRC "${RW_SRC_ROOT}/src/pipe/p2/null/im3dpipe.c")
  set(RW_WORLD_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/world/pipe/p2/null/wrldpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/null/native.c")
elseif(RW_TARGET STREQUAL "opengl")
  set(RW_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/src/pipe/p2/opengl/im3dpipe.c"
      "${RW_SRC_ROOT}/src/pipe/p2/opengl/nodeOpenGLSubmitNoLight.c")
  set(RW_WORLD_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/opengllights.c"
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/openglpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/nodeOpenGLAtomicAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/nodeOpenGLWorldSectorAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/wrldpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/opengl/native.c")
elseif(RW_TARGET STREQUAL "d3d8")
  set(RW_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/src/pipe/p2/d3d8/im3dpipe.c"
      "${RW_SRC_ROOT}/src/pipe/p2/d3d8/nodeD3D8SubmitNoLight.c")
  set(RW_WORLD_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/D3D8lights.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/D3D8pipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/D3D8VertexBufferManager.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/nodeD3D8AtomicAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/nodeD3D8WorldSectorAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/wrldpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d8/native.c")
elseif(RW_TARGET STREQUAL "d3d9")
  set(RW_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/src/pipe/p2/d3d9/im3dpipe.c"
      "${RW_SRC_ROOT}/src/pipe/p2/d3d9/nodeD3D9SubmitNoLight.c")
  set(RW_WORLD_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/D3D9lights.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/D3D9pipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/nodeD3D9AtomicAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/nodeD3D9WorldSectorAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/d3d9vertexdeclaration.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/d3d9vertexshader.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/d3d9vertexshaderutils.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/d3d9usage.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/wrldpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d9/native.c")
elseif(RW_TARGET STREQUAL "d3d11")
  set(RW_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/src/pipe/p2/d3d11/im3dpipe.c"
      "${RW_SRC_ROOT}/src/pipe/p2/d3d11/nodeD3D11SubmitNoLight.c")
  set(RW_WORLD_PIPE_PS_CSRC
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/D3D11lights.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/D3D11pipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/nodeD3D11AtomicAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/nodeD3D11WorldSectorAllInOne.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/d3d11inputlayout.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/d3d11vertexshader.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/d3d11vertexshaderutils.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/d3d11usage.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/wrldpipe.c"
      "${RW_SRC_ROOT}/world/pipe/p2/d3d11/native.c")
endif()
