/***************************************************************************
 *                                                                         *
 * Module  : d3d11raster.h                                                 *
 *                                                                         *
 * Purpose : Raster and texture implementation for D3D11                  *
 *                                                                         *
 **************************************************************************/

#ifndef D3D11RASTER_H
#define D3D11RASTER_H

#ifdef    __cplusplus
extern "C"
{
#endif                          /* __cplusplus */

extern RwBool _rwD3D11RasterCreate(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterDestroy(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11ImageGetFromRaster(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterSetFromImage(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11ImageFindRasterFormat(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11TextureSetRaster(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterLock(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterUnlock(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterLockPalette(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterUnlockPalette(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterClear(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterClearRect(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterRender(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterRenderScaled(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterRenderFast(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11SetRasterContext(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterSubRaster(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11NativeTextureGetSize(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11NativeTextureWrite(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11NativeTextureRead(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RasterGetMipLevels(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11RGBToPixel(void *pOut, void *pInOut, RwInt32 nI);
extern RwBool _rwD3D11PixelToRGB(void *pOut, void *pInOut, RwInt32 nI);

#ifdef    __cplusplus
}
#endif                          /* __cplusplus */

#endif /* D3D11RASTER_H */
