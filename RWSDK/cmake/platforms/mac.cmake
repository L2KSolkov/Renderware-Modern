# RW_OS=mac is not implemented in this port.
#
# makeincl/rwos/mac/makeos would define the Mac library handling and file
# aliases. See also the mac-specific source lists already discoverable in
# makeincl/rwtarget/opengl/maketarg (bamacogl.c, macmatbl.c).
message(FATAL_ERROR
  "RW_OS=mac is not implemented. Fill in cmake/platforms/mac.cmake.")
