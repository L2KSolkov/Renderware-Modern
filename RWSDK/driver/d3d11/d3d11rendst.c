/***************************************************************************
 *                                                                         *
 * Module  : d3d11rendst.c                                                 *
 *                                                                         *
 * Purpose : Render state implementation for D3D11 - the bounded contract  *
 *           RwRenderStateSet dispatches to.                               *
 *                                                                         *
 **************************************************************************/

#include <windows.h>
#include <d3d11.h>

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d11rendst.h"
#include "drvfns.h"
#include "drvmodel.h"

RwBool
_rwD3D11RWSetRenderState(RwRenderState nState, void *param)
{
    RWFUNCTION(RWSTRING("_rwD3D11RWSetRenderState"));

    switch (nState)
    {
        case rwRENDERSTATETEXTURERASTER:
        case rwRENDERSTATETEXTUREADDRESS:
        case rwRENDERSTATETEXTUREADDRESSU:
        case rwRENDERSTATETEXTUREADDRESSV:
        case rwRENDERSTATETEXTUREPERSPECTIVE:
        case rwRENDERSTATETEXTUREFILTER:
        case rwRENDERSTATESRCBLEND:
        case rwRENDERSTATEDESTBLEND:
        case rwRENDERSTATEVERTEXALPHAENABLE:
        case rwRENDERSTATEBORDERCOLOR:
        case rwRENDERSTATEFOGENABLE:
        case rwRENDERSTATEFOGCOLOR:
        case rwRENDERSTATEFOGTYPE:
        case rwRENDERSTATEFOGDENSITY:
        case rwRENDERSTATEFOGSTART:
        case rwRENDERSTATEFOGEND:
        case rwRENDERSTATEZTESTENABLE:
        case rwRENDERSTATEZWRITEENABLE:
        case rwRENDERSTATEFILTERMIPMODE:
        case rwRENDERSTATECULLMODE:
        case rwRENDERSTATESHADEMODE:
        case rwRENDERSTATEZBIAS:
        case rwRENDERSTATERANGEFOGENABLE:
        case rwRENDERSTATESTENCILENABLE:
        case rwRENDERSTATESTENCILFAIL:
        case rwRENDERSTATESTENCILZFAIL:
        case rwRENDERSTATESTENCILPASS:
        case rwRENDERSTATESTENCILFUNCTION:
        case rwRENDERSTATESTENCILFUNCTIONMASK:
        case rwRENDERSTATESTENCILFUNCTIONWRITEMASK:
            /* Phase 4 maps these to cached state objects and permutation
             * keys. For now they are accepted and cached as set. */
            break;

        default:
            RWRETURN(FALSE);
    }

    RWRETURN(TRUE);
}

RwBool
_rwD3D11RWGetRenderState(RwRenderState nState, void *param)
{
    RWFUNCTION(RWSTRING("_rwD3D11RWGetRenderState"));

    switch (nState)
    {
        case rwRENDERSTATETEXTURERASTER:
            *((void **)param) = NULL;
            RWRETURN(TRUE);

        default:
            break;
    }

    RWRETURN(FALSE);
}
