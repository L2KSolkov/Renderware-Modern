# makeincl/rwos/win/makeos
#
# The makeos file mostly defines file-handling aliases (CP/MV/RM/MD/SED) that
# CMake replaces natively, plus SHELL=./bin/sh.exe which is not needed. The
# DXSDK include it adds is folded into the per-target DRVINC handling.
