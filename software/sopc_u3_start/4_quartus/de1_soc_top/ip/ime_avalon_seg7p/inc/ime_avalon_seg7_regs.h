//------------------------------------------------------------------------------
// Filename: ime_avalon_seg7p_regs.h
// Author  : M. Pichler
// Date    : 14.11.2008
//------------------------------------------------------------------------------
#ifndef __IME_AVALON_SEG7P_REGS_H__
#define __IME_AVALON_SEG7P_REGS_H__

#include <io.h>

#define IOADDR_IME_AVALON_SEG7_DATA(base)      __IO_CALC_ADDRESS_NATIVE(base, 0)
#define IOWR_IME_AVALON_SEG7_DATA(base, data)  IOWR(base, 0, data)

#define IME_AVALON_SEG7_DATA_DIGIT0_MSK        (0xf)
#define IME_AVALON_SEG7_DATA_DIGIT0_OFST       (0)
#define IME_AVALON_SEG7_DATA_DIGIT1_MSK        (0xf0)
#define IME_AVALON_SEG7_DATA_DIGIT1_OFST       (4)
#define IME_AVALON_SEG7_DATA_DIGIT2_MSK        (0xf00)
#define IME_AVALON_SEG7_DATA_DIGIT2_OFST       (8)
#define IME_AVALON_SEG7_DATA_DIGIT3_MSK        (0xf000)
#define IME_AVALON_SEG7_DATA_DIGIT3_OFST       (12)
#define IME_AVALON_SEG7_DATA_DIGIT4_MSK        (0xf0000)
#define IME_AVALON_SEG7_DATA_DIGIT4_OFST       (16)
#define IME_AVALON_SEG7_DATA_DIGIT5_MSK        (0xf00000)
#define IME_AVALON_SEG7_DATA_DIGIT5_OFST       (20)
#define IME_AVALON_SEG7_DATA_DIGIT6_MSK        (0xf000000)
#define IME_AVALON_SEG7_DATA_DIGIT6_OFST       (24)
#define IME_AVALON_SEG7_DATA_DIGIT7_MSK        (0xf0000000)
#define IME_AVALON_SEG7_DATA_DIGIT7_OFST       (28)

#endif /* __IME_AVALON_SEG7P_REGS_H__ */
