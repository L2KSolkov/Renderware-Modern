/***************************************************************************
 *                                                                         *
 * Module  : d3d11device.c                                                 *
 *                                                                         *
 * Purpose : d3d11 device system, presentation and the standards contract  *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>
#include <dxgi.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "badevice.h"
#include "d3d11device.h"
#include "d3d11raster.h"
#include "d3d11rendst.h"
#include "d3d112drend.h"
#include "d3d11texdic.h"
#include "d3d11dxttex.h"
#include "d3d11metric.h"
#include "drvfns.h"
#include "drvmodel.h"

/****************************************************************************
 Local (Static) Prototypes
 */

static RwBool D3D11DeviceSystemOpen(void *out, void *inOut, RwInt32 in);
static RwBool D3D11DeviceSystemClose(void *out, void *inOut, RwInt32 in);
static RwBool D3D11DeviceSystemStart(void *out, void *inOut, RwInt32 in);
static RwBool D3D11DeviceSystemStop(void *out, void *inOut, RwInt32 in);
static RwBool D3D11DeviceSystemFinalizeStart(void *out, void *inOut, RwInt32 in);
static RwBool D3D11DeviceSystemStandards(void *out, void *inOut, RwInt32 in);
static void D3D11CreateDisplayModesList(void);

/****************************************************************************
 Global Variables
 */

HWND                         WindowHandle = NULL;
IDXGIFactory                *_RwD3D11Factory = NULL;
RwUInt32                     _RwD3D11AdapterIndex = 0;
RwUInt32                     _RwD3D11AdapterType = 0;
ID3D11Device                *_RwD3D11Device = NULL;
ID3D11DeviceContext         *_RwD3D11DeviceContext = NULL;
IDXGISwapChain              *_RwD3D11SwapChain = NULL;
ID3D11RenderTargetView      *_RwD3D11RenderTargetView = NULL;
ID3D11DepthStencilView      *_RwD3D11DepthStencilView = NULL;
D3D_FEATURE_LEVEL            _RwD3D11FeatureLevel = D3D_FEATURE_LEVEL_11_0;
_rwD3D11AdapterInformation   _RwD3D11AdapterInformation;
RwInt32                      _RwD3D11ZBufferDepth = 24;
RwRGBAReal                   AmbientSaturated = { 1.0f, 1.0f, 1.0f, 1.0f };

static RwInt32               NumDisplayModes = 0;
static RwVideoMode          *DisplayModes = NULL;
static RwInt32               _RwD3D11CurrentModeIndex = 0;
static RwBool                SystemStarted = FALSE;

/****************************************************************************
 Function prototypes
 */

static RwBool
D3D11System(RwInt32 request, void *out, void *inOut, RwInt32 in);

/****************************************************************************
 D3D11NullStandard

 Empty standard function - fills unused standard table entries.
 */

static RwBool
D3D11NullStandard(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                  RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11NullStandard"));
    RWRETURN(FALSE);
}

/****************************************************************************
 _rwD3D11CheckError
 */

#if defined(RWDEBUG)
HRESULT
_rwD3D11CheckError(HRESULT hr, const RwChar *function,
                   const RwChar *file, RwUInt32 line)
{
    if (FAILED(hr))
    {
        RwDebugSendMessage(rwDEBUGERROR,
                           "D3D11",
                           _rwdbsprintf("D3D11 call failed (%s, line %d): %s",
                                        function, line, file));
    }
    return (hr);
}
#endif

/****************************************************************************
 D3D11CameraBeginUpdate
 */

static RwBool
D3D11CameraBeginUpdate(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                       RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11CameraBeginUpdate"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11CameraEndUpdate
 */

static RwBool
D3D11CameraEndUpdate(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                     RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11CameraEndUpdate"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11CameraClear
 */

static RwBool
D3D11CameraClear(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                 RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11CameraClear"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11RasterShowRaster
 */

static RwBool
D3D11RasterShowRaster(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                      RwInt32 nI __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11RasterShowRaster"));
    if (_RwD3D11SwapChain)
    {
        DXCHECK(_RwD3D11SwapChain->lpVtbl->Present(_RwD3D11SwapChain, 0, 0));
    }
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11DeviceSystemStandards
 */

static RwBool
D3D11DeviceSystemStandards(void *out, void *inOut __RWUNUSED__, RwInt32 in)
{
    RwInt32             i;
    RwInt32             numDriverFunctions;
    RwStandardFunc     *standardFunctions;
    RwStandard          rwD3D11Standards[] = {
        /* Camera ops */
        {rwSTANDARDCAMERABEGINUPDATE, D3D11CameraBeginUpdate},
        {rwSTANDARDCAMERAENDUPDATE, D3D11CameraEndUpdate},
        {rwSTANDARDCAMERACLEAR, D3D11CameraClear},

        /* Raster/Pixel operations */
        {rwSTANDARDRASTERSHOWRASTER, D3D11RasterShowRaster},
        {rwSTANDARDRGBTOPIXEL, _rwD3D11RGBToPixel},
        {rwSTANDARDPIXELTORGB, _rwD3D11PixelToRGB},
        {rwSTANDARDRASTERSETIMAGE, _rwD3D11RasterSetFromImage},
        {rwSTANDARDIMAGEGETRASTER, _rwD3D11ImageGetFromRaster},

        /* Raster creation and destruction */
        {rwSTANDARDRASTERDESTROY, _rwD3D11RasterDestroy},
        {rwSTANDARDRASTERCREATE, _rwD3D11RasterCreate},

        /* Finding about a raster type */
        {rwSTANDARDIMAGEFINDRASTERFORMAT, _rwD3D11ImageFindRasterFormat},

        /* Texture operations */
        {rwSTANDARDTEXTURESETRASTER, _rwD3D11TextureSetRaster},

        /* Locking and releasing */
        {rwSTANDARDRASTERLOCK, _rwD3D11RasterLock},
        {rwSTANDARDRASTERUNLOCK, _rwD3D11RasterUnlock},
        {rwSTANDARDRASTERLOCKPALETTE, _rwD3D11RasterLockPalette},
        {rwSTANDARDRASTERUNLOCKPALETTE, _rwD3D11RasterUnlockPalette},

        /* Raster operations */
        {rwSTANDARDRASTERCLEAR, _rwD3D11RasterClear},
        {rwSTANDARDRASTERCLEARRECT, _rwD3D11RasterClearRect},

        /* !! */
        {rwSTANDARDRASTERRENDER, _rwD3D11RasterRender},
        {rwSTANDARDRASTERRENDERSCALED, _rwD3D11RasterRenderScaled},
        {rwSTANDARDRASTERRENDERFAST, _rwD3D11RasterRenderFast},

        /* Setting the context */
        {rwSTANDARDSETRASTERCONTEXT, _rwD3D11SetRasterContext},

        /* Creating sub rasters */
        {rwSTANDARDRASTERSUBRASTER, _rwD3D11RasterSubRaster},

        /* Native texture serialization */
        {rwSTANDARDNATIVETEXTUREGETSIZE, _rwD3D11NativeTextureGetSize},
        {rwSTANDARDNATIVETEXTUREWRITE, _rwD3D11NativeTextureWrite},
        {rwSTANDARDNATIVETEXTUREREAD, _rwD3D11NativeTextureRead},

        /* Raster Mip Levels */
        {rwSTANDARDRASTERGETMIPLEVELS, _rwD3D11RasterGetMipLevels}
    };

    RWFUNCTION(RWSTRING("D3D11DeviceSystemStandards"));

    standardFunctions = (RwStandardFunc *) out;
    numDriverFunctions = sizeof(rwD3D11Standards) / sizeof(RwStandard);

    /* Clear out all of the standards initially */
    for (i = 0; i < in; ++i)
    {
        standardFunctions[i] = D3D11NullStandard;
    }

    /* Fill in all of the standards */
    while (numDriverFunctions--)
    {
        if ((rwD3D11Standards->nStandard < in) &&
            (rwD3D11Standards->nStandard >= 0))
        {
            standardFunctions[rwD3D11Standards[numDriverFunctions].nStandard] =
                rwD3D11Standards[numDriverFunctions].fpStandard;
        }
    }

    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11CreateDisplayModesList
 */

static void
D3D11CreateDisplayModesList(void)
{
    RWFUNCTION(RWSTRING("D3D11CreateDisplayModesList"));

    /* Phase 1: a single default desktop-sized mode, expanded in Phase 2. */
    NumDisplayModes = 1;
    DisplayModes = (RwVideoMode *)RwMalloc(sizeof(RwVideoMode));
    if (DisplayModes)
    {
        DisplayModes[0].width = 640;
        DisplayModes[0].height = 480;
        DisplayModes[0].depth = 32;
        DisplayModes[0].flags = 0;
        DisplayModes[0].refRate = 60;
        DisplayModes[0].format = rwRASTERFORMAT8888;
    }

    RWRETURNVOID();
}

/****************************************************************************
 D3D11DeviceSystemOpen
 */

static RwBool
D3D11DeviceSystemOpen(void *out __RWUNUSED__, void *inOut __RWUNUSED__,
                      RwInt32 in __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11DeviceSystemOpen"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11DeviceSystemClose
 */

static RwBool
D3D11DeviceSystemClose(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                       RwInt32 in __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11DeviceSystemClose"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11DeviceSystemStart
 */

static RwBool
D3D11DeviceSystemStart(void *out __RWUNUSED__, void *inOut __RWUNUSED__,
                       RwInt32 in __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11DeviceSystemStart"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11DeviceSystemStop
 */

static RwBool
D3D11DeviceSystemStop(void *pOut __RWUNUSED__, void *pInOut __RWUNUSED__,
                      RwInt32 in __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11DeviceSystemStop"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11DeviceSystemFinalizeStart
 */

static RwBool
D3D11DeviceSystemFinalizeStart(void *out __RWUNUSED__,
                               void *inOut __RWUNUSED__,
                               RwInt32 in __RWUNUSED__)
{
    RWFUNCTION(RWSTRING("D3D11DeviceSystemFinalizeStart"));
    RWRETURN(TRUE);
}

/****************************************************************************
 D3D11System
 */

static RwBool
D3D11System(RwInt32 request, void *out, void *inOut, RwInt32 in)
{
    RWFUNCTION(RWSTRING("D3D11System"));

    switch (request)
    {
        case rwDEVICESYSTEMUSEMODE:
            if (!SystemStarted && (in >= 0) && (in < NumDisplayModes))
            {
                _RwD3D11CurrentModeIndex = in;
                RWRETURN(TRUE);
            }
            RWRETURN(FALSE);

        case rwDEVICESYSTEMGETNUMMODES:
            if (!DisplayModes)
            {
                D3D11CreateDisplayModesList();
            }
            *((RwInt32 *) out) = NumDisplayModes;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMGETMODEINFO:
            if (!DisplayModes)
            {
                D3D11CreateDisplayModesList();
            }
            if ((in >= 0) && (in < NumDisplayModes))
            {
                *((RwVideoMode *) out) = DisplayModes[in];
                RWRETURN(TRUE);
            }
            RWRETURN(FALSE);

        case rwDEVICESYSTEMGETMODE:
            *((RwInt32 *) out) = _RwD3D11CurrentModeIndex;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMFOCUS:
            RWRETURN(TRUE);

        case rwDEVICESYSTEMREGISTER:
            {
                RwDevice           *D3D11DriverDevice = _rwDeviceGetHandle();
                RwDevice           *deviceOut = (RwDevice *) out;
                RwMemoryFunctions  *memoryFunctions = (RwMemoryFunctions *) inOut;

                *deviceOut = *D3D11DriverDevice;
                if (memoryFunctions)
                {
                    /* remember allocators for later phases */
                    (void)memoryFunctions;
                }
                RWRETURN(TRUE);
            }

        case rwDEVICESYSTEMOPEN:
            RWRETURN(D3D11DeviceSystemOpen(out, inOut, in));

        case rwDEVICESYSTEMCLOSE:
            RWRETURN(D3D11DeviceSystemClose(out, inOut, in));

        case rwDEVICESYSTEMGETNUMSUBSYSTEMS:
            {
                RwInt32            *numSubSystems = (RwInt32 *) out;

                *numSubSystems = 1;
                RWRETURN(TRUE);
            }

        case rwDEVICESYSTEMGETSUBSYSTEMINFO:
            {
                RwSubSystemInfo    *subSystemInfo = (RwSubSystemInfo *) out;

                rwstrcpy(subSystemInfo->name, "RenderWare D3D11");
                RWRETURN(TRUE);
            }

        case rwDEVICESYSTEMGETCURRENTSUBSYSTEM:
            *((RwInt32 *) out) = _RwD3D11AdapterIndex;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMSETSUBSYSTEM:
            _RwD3D11AdapterIndex = in;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMSTART:
            SystemStarted = D3D11DeviceSystemStart(out, inOut, in);
            RWRETURN(SystemStarted);

        case rwDEVICESYSTEMSTOP:
            RWRETURN(D3D11DeviceSystemStop(out, inOut, in));

        case rwDEVICESYSTEMSTANDARDS:
            RWRETURN(D3D11DeviceSystemStandards(out, inOut, in));

        case rwDEVICESYSTEMINITPIPELINE:
            break;

        case rwDEVICESYSTEMGETTEXMEMSIZE:
            *((RwUInt32 *)out) = 128 * 1024 * 1024;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMFINALIZESTART:
            RWRETURN(D3D11DeviceSystemFinalizeStart(out, inOut, in));

        case rwDEVICESYSTEMINITIATESTOP:
            break;

        case rwDEVICESYSTEMGETMAXTEXTURESIZE:
            *((RwInt32 *) out) = 8192;
            RWRETURN(TRUE);

        case rwDEVICESYSTEMRXPIPELINEREQUESTPIPE:
            break;

#if defined( RWMETRICS )
        case rwDEVICESYSTEMGETMETRICBLOCK:
            {
                *((RwD3D11Metrics **) (out)) = _rwD3D11MetricsGet();
                RWRETURN(TRUE);
            }
            break;
#endif /* defined( RWMETRICS ) */
        case rwDEVICESYSTEMGETID:
            *(RwUInt16*)out = rwDEVICE_D3D11;
            RWRETURN(TRUE);
    }

    RWRETURN(FALSE);
}

/****************************************************************************
 D3D11DeviceClose / _rwD3D11DeviceClose
 */

static void
D3D11DeviceClose(void)
{
    RWFUNCTION(RWSTRING("D3D11DeviceClose"));

    if (_RwD3D11RenderTargetView)
    {
        _RwD3D11RenderTargetView->lpVtbl->Release(_RwD3D11RenderTargetView);
        _RwD3D11RenderTargetView = NULL;
    }
    if (_RwD3D11DepthStencilView)
    {
        _RwD3D11DepthStencilView->lpVtbl->Release(_RwD3D11DepthStencilView);
        _RwD3D11DepthStencilView = NULL;
    }
    if (_RwD3D11SwapChain)
    {
        _RwD3D11SwapChain->lpVtbl->Release(_RwD3D11SwapChain);
        _RwD3D11SwapChain = NULL;
    }
    if (_RwD3D11DeviceContext)
    {
        _RwD3D11DeviceContext->lpVtbl->Release(_RwD3D11DeviceContext);
        _RwD3D11DeviceContext = NULL;
    }
    if (_RwD3D11Device)
    {
        _RwD3D11Device->lpVtbl->Release(_RwD3D11Device);
        _RwD3D11Device = NULL;
    }
    if (_RwD3D11Factory)
    {
        _RwD3D11Factory->lpVtbl->Release(_RwD3D11Factory);
        _RwD3D11Factory = NULL;
    }

    RWRETURNVOID();
}

/****************************************************************************
 D3D11DeviceOpen / plugin attach
 */

static RwBool
D3D11DeviceOpen(void)
{
    RWFUNCTION(RWSTRING("D3D11DeviceOpen"));
    RWRETURN(TRUE);
}

static RwBool
D3D11DeviceCloseReal(void)
{
    RWFUNCTION(RWSTRING("D3D11DeviceCloseReal"));
    D3D11DeviceClose();
    RWRETURN(TRUE);
}

/****************************************************************************
 RwD3D11 API
 */

RwBool
RwD3D11DeviceSupportsDXTTexture(void)
{
    RWRETURN(TRUE);
}

void *
RwD3D11GetCurrentD3D11Device(void)
{
    return ((void *)_RwD3D11Device);
}

void *
RwD3D11GetCurrentD3D11DeviceContext(void)
{
    return ((void *)_RwD3D11DeviceContext);
}

void *
RwD3D11GetCurrentRenderTarget(void)
{
    return ((void *)_RwD3D11RenderTargetView);
}

RwBool
RwD3D11SetRenderTarget(void *raster __RWUNUSED__)
{
    RWRETURN(TRUE);
}

void *
RwD3D11CreateVertexShader(const RwChar *name __RWUNUSED__)
{
    return (NULL);
}

void
RwD3D11DestroyVertexShader(void *shader __RWUNUSED__)
{
    return;
}

void *
RwD3D11CreatePixelShader(const RwChar *name __RWUNUSED__)
{
    return (NULL);
}

void
RwD3D11DestroyPixelShader(void *shader __RWUNUSED__)
{
    return;
}

RwBool
RwD3D11SetTexture(void *texture __RWUNUSED__, RwInt32 stage __RWUNUSED__)
{
    RWRETURN(TRUE);
}

RwBool
RwD3D11SetRenderState(RwRenderState nState, void *param)
{
    RWRETURN(_rwD3D11RWSetRenderState(nState, param));
}

RwBool
RwD3D11GetRenderState(RwRenderState nState, void *param)
{
    RWRETURN(_rwD3D11RWGetRenderState(nState, param));
}

void
RwD3D11SetTransform(RwMatrixTag *matrix __RWUNUSED__)
{
    return;
}

RwBool
_rwD3D11SetVertexShaderMacro(void *shader __RWUNUSED__)
{
    RWRETURN(TRUE);
}

RwBool
_rwD3D11SetPixelShaderMacro(void *shader __RWUNUSED__)
{
    RWRETURN(TRUE);
}

/****************************************************************************
 _rwD3D11DeviceOpen / plugin attach entry points
 */

RwBool
_rwD3D11DeviceOpen(void)
{
    return (D3D11DeviceOpen());
}

RwBool
_rwD3D11DeviceClose(void)
{
    return (D3D11DeviceCloseReal());
}

void *
_rwD3D11System(void)
{
    return ((void *)D3D11System);
}

void
_rwD3D11SetIm2DRenderState(RwBool enable __RWUNUSED__)
{
    return;
}
