/***************************************************************************
 *                                                                         *
 * Module  : drvmodel.h (D3D11)                                            *
 *                                                                         *
 * Purpose : Driver model description (device specific vertices/polys)     *
 *                                                                         *
 **************************************************************************/

/* RWPUBLIC */
#ifndef D3D11_DRVMODEL_H
#define D3D11_DRVMODEL_H

/* RWPUBLICEND */

/****************************************************************************
 Includes
 */

#include "batypes.h"
#include "baraster.h"
#include "bamatrix.h"

/* RWPUBLIC */
/****************************************************************************
 Defines
 */

/* Set true depth information (for fogging, eg) */
#define RwIm2DVertexSetCameraX(vert, camx)          /* Nothing */
#define RwIm2DVertexSetCameraY(vert, camy)          /* Nothing */
#define RwIm2DVertexSetCameraZ(vert, camz)          /* Nothing */

#define RwIm2DVertexSetRecipCameraZ(vert, recipz)   ((vert)->rhw = recipz)

#define RwIm2DVertexGetCameraX(vert)                (cause an error)
#define RwIm2DVertexGetCameraY(vert)                (cause an error)
#define RwIm2DVertexGetCameraZ(vert)                (cause an error)
#define RwIm2DVertexGetRecipCameraZ(vert)           ((vert)->rhw)

/* Set screen space coordinates in a device vertex */
#define RwIm2DVertexSetScreenX(vert, scrnx)         ((vert)->x = (scrnx))
#define RwIm2DVertexSetScreenY(vert, scrny)         ((vert)->y = (scrny))
#define RwIm2DVertexSetScreenZ(vert, scrnz)         ((vert)->z = (scrnz))
#define RwIm2DVertexGetScreenX(vert)                ((vert)->x)
#define RwIm2DVertexGetScreenY(vert)                ((vert)->y)
#define RwIm2DVertexGetScreenZ(vert)                ((vert)->z)

/* Set texture coordinates in a device vertex */
#define RwIm2DVertexSetU(vert, texU, recipz)        ((vert)->u = (texU))
#define RwIm2DVertexSetV(vert, texV, recipz)        ((vert)->v = (texV))
#define RwIm2DVertexGetU(vert)                      ((vert)->u)
#define RwIm2DVertexGetV(vert)                      ((vert)->v)

/* Modify the luminance stuff */
#define RwIm2DVertexSetRealRGBA(vert, red, green, blue, alpha)  \
    ((vert)->emissiveColor =                                    \
     (((RwFastRealToUInt32(alpha)) << 24) |                        \
      ((RwFastRealToUInt32(red)) << 16) |                          \
      ((RwFastRealToUInt32(green)) << 8) |                         \
      ((RwFastRealToUInt32(blue)))))

#define RwIm2DVertexSetIntRGBA(vert, red, green, blue, alpha)   \
    ((vert)->emissiveColor =                                    \
     ((((RwUInt32)(alpha)) << 24) |                             \
      (((RwUInt32)(red)) << 16) |                               \
      (((RwUInt32)(green)) << 8) |                              \
      (((RwUInt32)(blue)))))

#define RwIm2DVertexGetRed(vert)    \
    (RwUInt8)(((vert)->emissiveColor & 0x00ff0000) >> 16)
#define RwIm2DVertexGetGreen(vert)  \
    (RwUInt8)(((vert)->emissiveColor & 0x0000ff00) >> 8)
#define RwIm2DVertexGetBlue(vert)   \
    (RwUInt8)(((vert)->emissiveColor & 0x000000ff))
#define RwIm2DVertexGetAlpha(vert)  \
    (RwUInt8)(((vert)->emissiveColor & 0xff000000) >> 24)

/****************************************************************************
 Global Types
 */

/*
 * D3D11 vertex structure definition for 2D geometry
 *
 * The field layout is identical to RwD3D9Vertex (x y z rhw emissiveColor
 * u v) so the RwIm2DVertexSet*/Get* macro family ports unchanged. In D3D11
 * there is no fixed-function pipeline: rhw, emissiveColor and u/v are
 * consumed by the explicit shaders in the d3d11 driver.
 */
#if !defined(RWADOXYGENEXTERNAL)
typedef struct RwD3D11Vertex RwD3D11Vertex;
/**
 * \ingroup rwcoredriverd3d11
 * \struct RwD3D11Vertex
 * D3D11 vertex structure definition for 2D geometry
 */
struct RwD3D11Vertex
{
    RwReal      x;              /**< Screen X */
    RwReal      y;              /**< Screen Y */
    RwReal      z;              /**< Screen Z */
    RwReal      rhw;            /**< Reciprocal of homogeneous W */

    RwUInt32    emissiveColor;  /**< Vertex color */

    RwReal      u;              /**< Texture coordinate U */
    RwReal      v;              /**< Texture coordinate V */
};
#endif /* !defined(RWADOXYGENEXTERNAL) */

/* Define types used */

#if !defined(RWADOXYGENEXTERNAL)
/**
 * \ingroup rwcoredriverd3d11
 * \ref RwIm2DVertex
 * Typedef for a RenderWare Graphics Immediate Mode 2D Vertex
 */
typedef RwD3D11Vertex    RwIm2DVertex;
#endif /* !defined(RWADOXYGENEXTERNAL) */

#if !defined(RWADOXYGENEXTERNAL)
/**
 * \ingroup rwcoredriverd3d11
 * \ref RxVertexIndex
 *
 * Typedef for a RenderWare Graphics PowerPipe Immediate
 * Mode Vertex
 */
typedef RwUInt16        RxVertexIndex;
#endif /* !defined(RWADOXYGENEXTERNAL) */

#if !defined(RWADOXYGENEXTERNAL)
/**
 * \ingroup rwcoredriverd3d11
 * \ref RwImVertexIndex
 * Typedef for a RenderWare Graphics Immediate Mode Vertex.
 */
typedef RxVertexIndex   RwImVertexIndex;
#endif /* !defined(RWADOXYGENEXTERNAL) */

#if !defined(RWADOXYGENEXTERNAL)
/**
 * \ingroup rwcoredriverd3d11
 * \struct RwD3D11Metrics
 * Structure containing metrics counters
 */
typedef struct
{
    RwUInt32    numRenderStateChanges;          /**< Number of Render States changed */
    RwUInt32    numStateObjectChanges;          /**< Number of D3D11 state objects changed */
    RwUInt32    numShaderChanges;               /**< Number of shader changes */
    RwUInt32    numConstantBufferUpdates;       /**< Number of constant buffer updates */
    RwUInt32    numMaterialChanges;             /**< Number of Material changes */
    RwUInt32    numLightsChanged;               /**< Number of Lights changed */
    RwUInt32    numVBSwitches;                  /**< Number of Vertex Buffer switches */
}
RwD3D11Metrics;
#endif /* !defined(RWADOXYGENEXTERNAL) */

#endif /* D3D11_DRVMODEL_H */
/* RWPUBLICEND */
