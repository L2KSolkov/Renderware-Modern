# Generates the DLL .def from `dumpbin /LINKERMEMBER:1` output, replacing the
# bundled Cygwin dlltool + sed pipeline (makedll). The filter reproduces the
# rules encoded in dllsrc/rwgdllfx.sed exactly:
#   - drop names containing _real@<hex-ish char>
#   - drop lines beginning with a double quote
#   - drop .NET/exception culls: AVexception, length_error, logic_error,
#     out_of_range
# The ' @ <n> ;' tail-trims apply to dlltool's def format and are not needed
# for the dumpbin-derived lines.

if(NOT RW_DUMPBIN_OUTPUT OR NOT RW_DEF_OUTPUT)
  message(FATAL_ERROR "rw-gendef.cmake: RW_DUMPBIN_OUTPUT/RW_DEF_OUTPUT required")
endif()

file(READ "${RW_DUMPBIN_OUTPUT}" _dumpbin)
string(REPLACE "\r\n" "\n" _dumpbin "${_dumpbin}")
string(REPLACE "\n" ";" _lines "${_dumpbin}")

set(_exports "")
foreach(_line IN LISTS _lines)
  # symbol names in /LINKERMEMBER output follow the '|' separator
  string(FIND "${_line}" "|" _bar)
  if(_bar EQUAL -1)
    continue()
  endif()
  string(SUBSTRING "${_line}" 0 ${_bar} _prefix)
  string(SUBSTRING "${_line}" ${_bar} -1 _rest)
  string(REGEX REPLACE "^\\| *" "" _name "${_rest}")
  string(STRIP "${_name}" _name)
  if(_name STREQUAL "")
    continue()
  endif()
  # /\_real@\([0-9a-fA-f]\)/d  (note the original regex character class)
  if(_name MATCHES "_real@[0-9a-fA-f]")
    continue()
  endif()
  # /\"/d
  string(SUBSTRING "${_name}" 0 1 _first)
  if(_first STREQUAL "\"")
    continue()
  endif()
  # /AVexception/d /length_error/d /logic_error/d /out_of_range/d
  if(_name MATCHES "AVexception|length_error|logic_error|out_of_range")
    continue()
  endif()
  list(APPEND _exports "${_name}")
endforeach()

list(REMOVE_DUPLICATES _exports)
list(SORT _exports)

set(_def "EXPORTS\n")
foreach(_name IN LISTS _exports)
  string(APPEND _def "    ${_name}\n")
endforeach()

file(WRITE "${RW_DEF_OUTPUT}" "${_def}")
list(LENGTH _exports _count)
message(STATUS "rw-gendef: ${RW_DEF_OUTPUT} has ${_count} exports")
