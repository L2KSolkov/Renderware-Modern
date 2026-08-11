/***************************************************************************
 *                                                                         *
 * Module  : d3d112drend.c                                                 *
 *                                                                         *
 * Purpose : Immediate mode 2D rendering through the D3D11 shader system   *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d112drend.h"
#include "drvfns.h"
#include "drvmodel.h"

/* Phase 4 implements these through the shader library. */

RwBool
_rwD3D11Im2DRenderLine(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                       RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("_rwD3D11Im2DRenderLine"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11Im2DRenderTriangle(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                           RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("_rwD3D11Im2DRenderTriangle"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11Im2DRenderPrimitive(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                            RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("_rwD3D11Im2DRenderPrimitive"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11Im2DRenderIndexedPrimitive(void *pOut __RWUNUSED__,
                                   void *pInOut __RWUNUSED__,
                                   RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("_rwD3D11Im2DRenderIndexedPrimitive"));
    RWRETURN(TRUE);
}
