# RW_OS=sky is not implemented in this port.
#
# PS2 (sky) sources are present under plugin/*/sky2/ and tool/*/sky2/; see
# the sky2 conditional sections of the per-library makefiles.
message(FATAL_ERROR
  "RW_OS=sky is not implemented. Fill in cmake/platforms/sky.cmake.")
