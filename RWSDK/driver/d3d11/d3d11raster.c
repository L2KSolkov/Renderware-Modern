/***************************************************************************
 *                                                                         *
 * Module  : d3d11raster.c                                                 *
 *                                                                         *
 * Purpose : Raster and texture implementation for D3D11                  *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d11raster.h"
#include "drvfns.h"
#include "drvmodel.h"

/* Phase 3 implements these against staging resources. */

RwBool
_rwD3D11RasterCreate(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterCreate"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterDestroy(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterDestroy"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11ImageGetFromRaster(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11ImageGetFromRaster"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterSetFromImage(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterSetFromImage"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11ImageFindRasterFormat(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11ImageFindRasterFormat"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11TextureSetRaster(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11TextureSetRaster"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterLock(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterLock"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterUnlock(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterUnlock"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterLockPalette(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterLockPalette"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterUnlockPalette(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterUnlockPalette"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterClear(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterClear"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterClearRect(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterClearRect"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterRender(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterRender"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterRenderScaled(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterRenderScaled"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterRenderFast(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterRenderFast"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11SetRasterContext(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11SetRasterContext"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterSubRaster(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterSubRaster"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11NativeTextureGetSize(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11NativeTextureGetSize"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11NativeTextureWrite(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11NativeTextureWrite"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11NativeTextureRead(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11NativeTextureRead"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RasterGetMipLevels(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RasterGetMipLevels"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11RGBToPixel(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11RGBToPixel"));
    RWRETURN(TRUE);
}

RwBool
_rwD3D11PixelToRGB(void *pOut, void *pInOut, RwInt32 nI)
{
    RWFUNCTION(RWSTRING("_rwD3D11PixelToRGB"));
    RWRETURN(TRUE);
}
