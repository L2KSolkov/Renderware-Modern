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
  # /LINKERMEMBER:1 emits one line per symbol: "<offset> <name>"
  if(NOT _line MATCHES "^[ \t]*[0-9A-Fa-f]+[ \t]+(.+)$")
    continue()
  endif()
  set(_name "${CMAKE_MATCH_1}")
  string(STRIP "${_name}" _name)
  if(_name STREQUAL "")
    continue()
  endif()
  # "N public symbols" style summary lines
  if(_name MATCHES " ")
    continue()
  endif()
  # section-name pseudo symbols (.text, .data, .bss, ...)
  string(SUBSTRING "${_name}" 0 1 _first)
  if(_first STREQUAL ".")
    continue()
  endif()
  # archive member header fields from dumpbin output (uid, gid, mode, size)
  if(_name STREQUAL "mode" OR _name STREQUAL "size" OR
     _name STREQUAL "uid" OR _name STREQUAL "gid")
    continue()
  endif()
  # /\_real@\([0-9a-fA-f]\)/d  (note the original regex character class)
  if(_name MATCHES "_real@[0-9a-fA-f]")
    continue()
  endif()
  # /\"/d
  if(_first STREQUAL "\"")
    continue()
  endif()
  # /AVexception/d /length_error/d /logic_error/d /out_of_range/d
  if(_name MATCHES "AVexception|length_error|logic_error|out_of_range")
    continue()
  endif()
  # compiler-generated artifacts that are not exportable API symbols:
  # XMM constant data, RTTI catch/type-info descriptors
  if(_name MATCHES "_xmm@" OR _name MATCHES "^_?_?CT" OR
     _name MATCHES "^_?_?CTA[0-9]" OR _name MATCHES "^_?_?TI[0-9]" OR
     _name MATCHES "^_?_?R0\\?")
    continue()
  endif()
  # dlltool --export-all-symbols emits undecorated names for i386 COFF: one
  # leading underscore is stripped and the linker re-adds it when matching.
  if(_name MATCHES "^_")
    string(SUBSTRING "${_name}" 1 -1 _name)
  endif()
  # MASM segment pseudo-symbols from the driver .asm sources are not
  # exportable API symbols (dlltool would not have exported them either).
  if(_name STREQUAL "rwcseg" OR _name STREQUAL "rwdseg")
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
