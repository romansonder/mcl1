//------------------------------------------------------------------------------
// Filename: ime_avalon_seg7.h
// Author  : M. Pichler
// Date    : 14.11.2008
//------------------------------------------------------------------------------
#ifndef __IME_AVALON_SEG7_H__
#define __IME_AVALON_SEG7_H__

#include <stddef.h>
#include "alt_types.h"
#include "ime_avalon_seg7_regs.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_sys_init
 */
#define IME_AVALON_SEG7_INSTANCE(name, device) extern int alt_no_storage
#define IME_AVALON_SEG7_INIT(name, device) while (0)

void show_digits (alt_u32 base,
                char d7, char d6,
				char d5, char d4,
				char d3, char d2,
				char d1, char d0);

void seg7_show_hex (alt_u32 base, alt_u32 data);
        
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __IME_AVALON_SEG7_H__ */
