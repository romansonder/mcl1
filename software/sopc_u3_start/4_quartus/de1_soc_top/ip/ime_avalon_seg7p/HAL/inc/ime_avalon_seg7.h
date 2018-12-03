//------------------------------------------------------------------------------
// Filename: ime_avalon_seg7p.h
// Author  : M. Pichler
// Date    : 14.11.2008
//------------------------------------------------------------------------------
#ifndef __IME_AVALON_SEG7P_H__
#define __IME_AVALON_SEG7P_H__

#include <stddef.h>
#include "alt_types.h"
#include "ime_avalon_seg7p_regs.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define IME_AVALON_SEG7P_INSTANCE(name, device) extern int alt_no_storage
#define IME_AVALON_SEG7P_INIT(name, device) while (0)

#define C_DIGITS 8        /* Number of 7-Segment-Digits on the board */

void seg7_show_digits (alt_u32 base, alt_u32* digits);

void seg7_show_hex (alt_u32 base, alt_u32 data);
        
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __IME_AVALON_SEG7_H__ */
