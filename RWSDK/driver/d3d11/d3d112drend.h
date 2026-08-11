/***************************************************************************
 *                                                                         *
 * Module  : d3d112drend.h                                                 *
 *                                                                         *
 * Purpose : Immediate mode 2D rendering through the D3D11 shader system   *
 *                                                                         *
 **************************************************************************/

#ifndef D3D112DREND_H
#define D3D112DREND_H

#ifdef    __cplusplus
extern "C"
{
#endif                          /* __cplusplus */

extern RwBool
_rwD3D11Im2DRenderLine(void *pOut, void *pInOut, RwInt32 nI);

extern RwBool
_rwD3D11Im2DRenderTriangle(void *pOut, void *pInOut, RwInt32 nI);

extern RwBool
_rwD3D11Im2DRenderPrimitive(void *pOut, void *pInOut, RwInt32 nI);

extern RwBool
_rwD3D11Im2DRenderIndexedPrimitive(void *pOut, void *pInOut, RwInt32 nI);

#ifdef    __cplusplus
}
#endif                          /* __cplusplus */

#endif /* D3D112DREND_H */
