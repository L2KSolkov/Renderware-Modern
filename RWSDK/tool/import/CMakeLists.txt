rw_add_toolkit(rtimport DIR tool/import
  SOURCES
    nhssplit.c
    nhsstats.c
    nhsutil.c
    nhsscheme.c
    nullkd.c
    nhsworld.c)
set(RW_TOOLKIT_LIBS_IN_DIR rtimport PARENT_SCOPE)
