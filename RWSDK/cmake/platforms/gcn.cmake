# RW_OS=gcn is not implemented in this port.
#
# GameCube sources are present under plugin/*/gcn/ and world/pipe/p2/gcn/.
message(FATAL_ERROR
  "RW_OS=gcn is not implemented. Fill in cmake/platforms/gcn.cmake.")
