/***************************************************************************
 *                                                                         *
 * Module  : d3d11texdic.c                                                 *
 *                                                                         *
 * Purpose : Texture dictionary support (D3D11)                            *
 *                                                                         *
 **************************************************************************/

#include <windows.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d11texdic.h"
#include "drvfns.h"
#include "drvmodel.h"

/* Phase 3 implements texture creation/destruction. */
