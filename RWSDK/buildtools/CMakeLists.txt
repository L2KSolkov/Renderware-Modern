# Host build tools, compiled from source (Phase 2). Excluded from the install.
# incgen uses the checked-in lexer.c; flex is not required (lexer.l is kept
# for reference only).

add_executable(incgen
  incgen/main.c
  incgen/lexer.c
  incgen/main.h)

add_executable(inline inline/inline.cpp)

add_executable(findsyms findsyms/findsyms.c)

add_executable(cwpath cwpath/main.c)

set_target_properties(incgen inline findsyms cwpath PROPERTIES
  FOLDER "RenderWare host tools")
