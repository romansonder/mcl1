//------------------------------------------------------------------------------
// Filename: ime_avalon_seg7.c
// Author  : M. Pichler
// Date    : 14.11.2008
//------------------------------------------------------------------------------
#include <stddef.h>
#include "alt_types.h"
#include "ime_avalon_seg7.h"

void show_digits (alt_u32 base,
                  char d7, char d6,
				  char d5, char d4,
				  char d3, char d2,
				  char d1, char d0) {
	
	static int seg7_data;
	// 3322 2222 2222 1111 1111 1100 0000 0000
	// 1098 7654 3210 9876 5432 1098 7654 3210
	// -d7- -d6- -d5- -d4- -d3- -d2- -d1- -d0-
	seg7_data = ((d7 << IME_AVALON_SEG7_DATA_DIGIT7_OFST) & IME_AVALON_SEG7_DATA_DIGIT7_MSK) |
	            ((d6 << IME_AVALON_SEG7_DATA_DIGIT6_OFST) & IME_AVALON_SEG7_DATA_DIGIT6_MSK) |
	            ((d5 << IME_AVALON_SEG7_DATA_DIGIT5_OFST) & IME_AVALON_SEG7_DATA_DIGIT5_MSK) |
	            ((d4 << IME_AVALON_SEG7_DATA_DIGIT4_OFST) & IME_AVALON_SEG7_DATA_DIGIT4_MSK) |
	            ((d3 << IME_AVALON_SEG7_DATA_DIGIT3_OFST) & IME_AVALON_SEG7_DATA_DIGIT3_MSK) |
	            ((d2 << IME_AVALON_SEG7_DATA_DIGIT2_OFST) & IME_AVALON_SEG7_DATA_DIGIT2_MSK) |
	            ((d1 << IME_AVALON_SEG7_DATA_DIGIT1_OFST) & IME_AVALON_SEG7_DATA_DIGIT1_MSK) |
	            ((d0 << IME_AVALON_SEG7_DATA_DIGIT0_OFST) & IME_AVALON_SEG7_DATA_DIGIT0_MSK);
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
