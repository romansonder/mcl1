/*----------------------------------------------------
 * File    : ime_avalon_seg7.c
 * Author  : michael.pichler@fhnw.ch
 * Date    : Dec 18 2014
 * Company : Institute of Microelectronics (IME) FHNW
 * Content : 
 *--------------------------------------------------*/
#include <stddef.h>
#include "alt_types.h"
#include "ime_avalon_seg7.h"

/*----------------------------------------------------
 * Function: void show_hex (alt_u32 base, alt_u32 data)
 * Purpose : show Hex-Value on the Seg7-Display
 * Return  : none
 *--------------------------------------------------*/
void show_hex (alt_u32 base, alt_u32 data) {

	/* write to IME_AVALON_SEG7 */
	IOWR_IME_AVALON_SEG7_DATA(base, data);
}
  
/*----------------------------------------------------
 * Function: void show_dec (alt_u32 base, alt_u32 data)
 * Purpose : show Dec-Value on the Seg7-Display
 * Return  : none
 *--------------------------------------------------*/
void show_dec (alt_u32 base, alt_u32 data) {
  
  static alt_u32 digit;
  static alt_u32 temp;
  static alt_u32 dec_data;
  
  /* init */
  temp = data;
  dec_data = 0;
  /* process six times */
  for (i=0; i<6; i++) {
    digit = temp % 10;
    temp = temp / 10;
    dec_data = dec_data | (digit << i*4);
  }

	/* write to IME_AVALON_SEG7 */
	IOWR_IME_AVALON_SEG7_DATA(base, dec_data);
}
  
/*----------------------------------------------------
 * Function: void show_time (alt_u32 base, alt_u32 data)
 * Purpose : show time on the Seg7-Display
 *           MM:SS:HH (minuts:seconds:hundredth)
 * Return  : none
 *--------------------------------------------------*/
void show_time (alt_u32 base, alt_u32 data) {
  
  static alt_u32 digit;
  static alt_u32 temp;
  static alt_u32 time_data;
  static alt_u32 divisor;
  
  /* init */
  temp = data;
  time_data = 0;
  /* process six times */
  for (i=0; i<6; i++) {
    if (i==3 || i==5)
      divisor = 6;
    else
      divisor = 10;
    digit = temp % divisor;
    temp = temp / divisor;
    time_data = time_data | (digit << i*4);
  }

	/* write to IME_AVALON_SEG7 */
	IOWR_IME_AVALON_SEG7_DATA(base, time_data);
}
