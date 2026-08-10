# RW_OS=linux is not implemented in this port.
#
# See makeincl/rwos/linux/makeos and the linux source lists in
# makeincl/rwtarget/opengl/maketarg (baunxogl.c).
message(FATAL_ERROR
  "RW_OS=linux is not implemented. Fill in cmake/platforms/linux.cmake.")
