/***************************************************************************
 *                                                                         *
 * Module  : d3d11device.h                                                 *
 *                                                                         *
 * Purpose : d3d11 device header                                           *
 *                                                                         *
 **************************************************************************/

#ifndef D3D11DEVICE_H
#define D3D11DEVICE_H

/****************************************************************************
 Includes
 */

#include <d3d11.h>
#include <dxgi.h>

/****************************************************************************
 Defines
 */

#define MINZBUFFERVALUE 0.0f
#define MAXZBUFFERVALUE 1.0f

/****************************************************************************
 Global Types
 */

typedef struct _rwD3D11AdapterInformation _rwD3D11AdapterInformation;
struct _rwD3D11AdapterInformation
{
    RwChar          name[MAX_DEVICE_IDENTIFIER_STRING];
    RwInt32         modeCount;
    DXGI_MODE_DESC  mode;
    RwInt32         displayDepth;
    RwInt32         flags;
};

extern HWND                         WindowHandle;
extern IDXGIFactory                *_RwD3D11Factory;
extern RwUInt32                     _RwD3D11AdapterIndex;
extern RwUInt32                     _RwD3D11AdapterType;
extern ID3D11Device                *_RwD3D11Device;
extern ID3D11DeviceContext         *_RwD3D11DeviceContext;
extern IDXGISwapChain              *_RwD3D11SwapChain;
extern ID3D11RenderTargetView      *_RwD3D11RenderTargetView;
extern ID3D11DepthStencilView      *_RwD3D11DepthStencilView;
extern D3D_FEATURE_LEVEL            _RwD3D11FeatureLevel;
extern _rwD3D11AdapterInformation   _RwD3D11AdapterInformation;
extern RwInt32                      _RwD3D11ZBufferDepth;
extern RwRGBAReal                   AmbientSaturated;

/****************************************************************************
 Function prototypes
 */

#ifdef    __cplusplus
extern "C"
{
#endif                          /* __cplusplus */

#if defined(RWDEBUG)
extern HRESULT  _rwD3D11CheckError(HRESULT hr, const RwChar *function,
                                   const RwChar *file, RwUInt32 line);
#define DXCHECK(fn) (_rwD3D11CheckError(fn, #fn, __FILE__, __LINE__))
#else
#define DXCHECK(fn) (fn)
#endif

extern RwBool
_rwD3D11BeginScene(void);

extern RwBool
_rwD3D11SetRenderTarget(RwUInt32 index, void *rendertarget);

extern RwBool   _rwD3D11CameraClear(void *camera, void *color, RwInt32 clearFlags);
extern RwBool   _rwD3D11CameraBeginUpdate(void *out, void *cameraIn, RwInt32 in);
extern RwBool   _rwD3D11CameraEndUpdate(void *out, void *inOut, RwInt32 nIn);
extern RwBool   _rwD3D11RasterShowRaster(void *out, void *inOut, RwInt32 flags);

extern RwBool   _rwD3D11ForceLight(RwInt32 index, const void *light);

#ifdef    __cplusplus
}
#endif                          /* __cplusplus */

#endif /* D3D11DEVICE_H */
