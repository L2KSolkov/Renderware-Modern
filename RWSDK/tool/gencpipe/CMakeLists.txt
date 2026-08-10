# rtgncpip is built through makeplug in the make system (no PLUGINAPI).
rw_add_plugin(rtgncpip DIR tool/gencpipe
  PLUGIN rtgncpip
  SOURCES
    rtgncpip.c
    p2clpcom.c
    p2stdclsw.c
    nodeClipLine.c
    nodeClipTriangle.c
    nodeCullTriangle.c
    nodeImmInstance.c
    nodeImmMangleLineIndices.c
    nodeImmMangleTriangleIndices.c
    nodeImmRenderSetup.c
    nodeImmStash.c
    nodeClone.c
    nodeScatter.c
    nodeSubmitLine.c
    nodeSubmitTriangle.c
    nodeTransform.c
    nodeUVInterp.c
    nodeRGBAInterp.c
    nodeAtomicEnumerateLights.c
    nodeAtomicInstance.c
    nodeFastPathSplitter.c
    nodeLight.c
    nodeMaterialScatter.c
    nodePostLight.c
    nodePreLight.c
    nodeWorldSectorEnumerateLights.c
    nodeWorldSectorInstance.c)
set(RW_TOOLKIT_LIBS_IN_DIR rtgncpip PARENT_SCOPE)
