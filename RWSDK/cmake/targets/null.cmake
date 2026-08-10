# makeincl/rwtarget/null/maketarg

set(RW_GENERIC_DRV_SRC "${RW_SRC_ROOT}/driver/common/palquant.c")
set(RW_SPECIFIC_DRV_SRC "${RW_SRC_ROOT}/driver/null/banull.c")
set(RW_GENERIC_DRV_ASM_SRC "")
set(RW_DRV_LIBS "")
set(RW_DRV_INC
    "${RW_SRC_ROOT}/driver/null"
    "${RW_SRC_ROOT}/world")
set(RW_DRV_DEF "")
