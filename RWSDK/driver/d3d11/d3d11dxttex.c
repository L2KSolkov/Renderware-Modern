/***************************************************************************
 *                                                                         *
 * Module  : d3d11dxttex.c                                                 *
 *                                                                         *
 * Purpose : DXT (BC) texture support for D3D11                            *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d11dxttex.h"
#include "drvfns.h"
#include "drvmodel.h"

/* Phase 3 implements BC1-BC3 texture creation. */
