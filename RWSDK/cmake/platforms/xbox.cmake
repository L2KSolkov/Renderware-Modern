# RW_OS=xbox is not implemented in this port.
#
# Xbox sources are present under plugin/*/xbox/; they need the XDK
# (RW_XBOX_SDK) include/lib paths.
message(FATAL_ERROR
  "RW_OS=xbox is not implemented. Fill in cmake/platforms/xbox.cmake.")
