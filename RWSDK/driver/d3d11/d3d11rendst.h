/***************************************************************************
 *                                                                         *
 * Module  : d3d11rendst.h                                                 *
 *                                                                         *
 * Purpose : Render state implementation for D3D11                        *
 *                                                                         *
 **************************************************************************/

#ifndef D3D11RENDST_H
#define D3D11RENDST_H

/****************************************************************************
 Function prototypes
 */

#ifdef    __cplusplus
extern "C"
{
#endif                          /* __cplusplus */

extern RwBool
_rwD3D11RWSetRenderState(RwRenderState nState, void *param);

extern RwBool
_rwD3D11RWGetRenderState(RwRenderState nState, void *param);

#ifdef    __cplusplus
}
#endif                          /* __cplusplus */

#endif /* D3D11RENDST_H */
