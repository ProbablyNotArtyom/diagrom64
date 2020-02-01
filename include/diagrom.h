// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Main definitions header

#ifndef _HEADER_DIAGROM
#define _HEADER_DIAGROM

#define SCREENMEM	0x800


void __fastcall__ delay(void);
void __fastcall__ microdelay(void);
void puts_addr(const char str[], const char x, const char y);
char get_screencode(const char c);
char test_zeropage();
char test_stack();

#endif
