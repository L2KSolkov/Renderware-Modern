/***************************************************************************
 *                                                                         *
 * Module  : d3d11metric.c                                                 *
 *                                                                         *
 * Purpose : Metrics for D3D11                                             *
 *                                                                         *
 **************************************************************************/

#include "rwcore.h"
#include "rpplugin.h"
#include "rpdbgerr.h"
#include "d3d11device.h"
#include "d3d11metric.h"
#include "drvfns.h"
#include "drvmodel.h"

RwD3D11Metrics *
_rwD3D11MetricsGet(void)
{
    static RwD3D11Metrics metrics;
    return (&metrics);
}
