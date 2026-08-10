/* Minimal replacement for the MFC-era afxres.h used by rwgdll.rc.
 * Modern Windows SDKs no longer ship afxres.h; the resource script only
 * references IDC_STATIC from it. */
#ifndef _AFXRES_H
#define _AFXRES_H

#ifndef IDC_STATIC
#define IDC_STATIC (-1)
#endif

#endif /* _AFXRES_H */
