// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Main definitions header

#ifndef _HEADER_DIAGROM
#define _HEADER_DIAGROM

#define SCREENMEM	((unsigned char *)0x800)
#define COLORMEM	((unsigned char *)0xD800)

//--------------------------------------------

void puts_addr(const unsigned char *str, unsigned char *addr);
#define puts_xy(str, x, y) puts_addr(str, (SCREENMEM + (40*y)+x))	// Compile time conversion of X/Y coordinates to memory offsets

char get_screencode(const char c);
char test_zeropage();
char test_stack();

//--------------------------------------------

#endif
