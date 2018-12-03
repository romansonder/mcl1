/*----------------------------------------------------
 * File    : ime_avalon_seg7.h
 * Author  : michael.pichler@fhnw.ch
 * Date    : Dec 18 2014
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
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

/*----------------------------------------------------
 * Function: void show_hex (alt_u32 base, alt_u32 data)
 * Purpose : show Hex-Value on the Seg7-Display
 * Return  : none
 *--------------------------------------------------*/
void show_hex (alt_u32 base, alt_u32 data);
  
/*----------------------------------------------------
 * Function: void show_dec (alt_u32 base, alt_u32 data)
 * Purpose : show Dec-Value on the Seg7-Display
 * Return  : none
 *--------------------------------------------------*/
void show_dec (alt_u32 base, alt_u32 data);
  
/*----------------------------------------------------
 * Function: void show_time (alt_u32 base, alt_u32 data)
 * Purpose : show time on the Seg7-Display
 *           MM:SS:HH (minuts:seconds:hundredth)
 * Return  : none
 *--------------------------------------------------*/
void show_time (alt_u32 base, alt_u32 data);
        
#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __IME_AVALON_SEG7_H__ */
