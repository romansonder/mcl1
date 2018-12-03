//------------------------------------------------------------------------------
// Filename: ime_avalon_seg7p.c
// Author  : M. Pichler
// Date    : 14.11.2008
//------------------------------------------------------------------------------
#include <stddef.h>
#include "alt_types.h"
#include "ime_avalon_seg7p.h"

void seg7_show_digits (alt_u32 base, alt_u32* digits) {
	
	int i;
  static int seg7_data;
	// 3322 2222 2222 1111 1111 1100 0000 0000
	// 1098 7654 3210 9876 5432 1098 7654 3210
	// -d7- -d6- -d5- -d4- -d3- -d2- -d1- -d0-

  seg7_data = 0;
  for (i=0; i<C_DIGITS; i++) {
    seg7_data = seg7_data | ((digits[i] & 0xf) << 4*i);
  }

	// write to IME_AVALON_SEG7
	IOWR_IME_AVALON_SEG7_DATA(base, seg7_data);
}

//------------------------------------------------------------------------------
// Function to show Hex-Value on the Seg7-Display						
//------------------------------------------------------------------------------
void seg7_show_hex (alt_u32 base, alt_u32 data) {
	
	// write to IME_AVALON_SEG7
	IOWR_IME_AVALON_SEG7_DATA(base, data);
}
