/***************************************************************************
 *                                                                         *
 * Module  : drvfns.h (D3D11)                                              *
 *                                                                         *
 * Purpose : Driver functionality                                          *
 *                                                                         *
 **************************************************************************/

#ifndef DRVFNS_H
#define DRVFNS_H

/****************************************************************************
 Includes
 */

#include "batypes.h"
#include "batextur.h"
#include "d3d11dxttex.h"

/* RWPUBLIC */

#define RWD3D11_MAX_TEXTURE_STAGES  8

#define RWD3D11_MAX_VERTEX_STREAMS  2

typedef struct RxD3D11VertexStream RxD3D11VertexStream;
/**
 * \ingroup worldextensionsd3d11
 * \struct RxD3D11VertexStream
 * This structure contains D3D11 resource specific components.
 */
struct RxD3D11VertexStream
{
    void *vertexBuffer;     /**< Vertex buffer */
    RwUInt32 offset;        /**< Offset in bytes since the beginning
                                 of the Vertex buffer */
    RwUInt32 stride;        /**< Size of the components in bytes */
    RwUInt16 geometryFlags; /**< Geometry locked flags */
    RwUInt8 managed;        /**< Created by the Vertex Buffer Manager */
    RwUInt8 dynamicLock;    /**< Using RwD3D11DynamicVertexBufferLock */
};

#ifdef    __cplusplus
extern "C"
{
#endif                          /* __cplusplus */

/****************************************************************************
 Function prototypes
 */

/*******/
/* API */
/*******/

/* Reports on whether D3D11 can render S3TC textures */
extern RwBool
RwD3D11DeviceSupportsDXTTexture(void);

/* Get handle to D3D11 device - useful for setting D3D11 renderstate */
extern void *
RwD3D11GetCurrentD3D11Device(void);

/* Get handle to D3D11 immediate device context */
extern void *
RwD3D11GetCurrentD3D11DeviceContext(void);

/* Get the current D3D11 raster */
extern void *
RwD3D11GetCurrentRenderTarget(void);

/* Set the current D3D11 render target */
extern RwBool
RwD3D11SetRenderTarget(void *raster);

/* Vertex shader handling */
extern void *
RwD3D11CreateVertexShader(const RwChar *name);

extern void
RwD3D11DestroyVertexShader(void *shader);

/* Pixel shader handling */
extern void *
RwD3D11CreatePixelShader(const RwChar *name);

extern void
RwD3D11DestroyPixelShader(void *shader);

/* Texture handling */
extern RwBool
RwD3D11SetTexture(void *texture, RwInt32 stage);

extern RwBool
RwD3D11SetRenderState(RwRenderState nState, void *param);

extern RwBool
RwD3D11GetRenderState(RwRenderState nState, void *param);

/* Matrix handling */
extern void
RwD3D11SetTransform(RwMatrixTag *matrix);

/* Macro forms of the hot entry points (the non-macro pair is switched on
 * RWDEBUG, matching the drvfns.h convention). */
#define RwD3D11SetVertexShader _rwD3D11SetVertexShaderMacro
extern RwBool _rwD3D11SetVertexShaderMacro(void *shader);

#define RwD3D11SetPixelShader _rwD3D11SetPixelShaderMacro
extern RwBool _rwD3D11SetPixelShaderMacro(void *shader);

#ifdef    __cplusplus
}
#endif                          /* __cplusplus */

#endif /* DRVFNS_H */
/* RWPUBLICEND */
