/***************************************************************************
 *                                                                         *
 * Module  : d3d11convrt.c                                                 *
 *                                                                         *
 * Purpose : Format conversion between RW and D3D11 (DXGI) formats         *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "drvfns.h"
#include "drvmodel.h"

/* Phase 3 maps D3DFMT_* equivalents to DXGI_FORMAT_*. */
