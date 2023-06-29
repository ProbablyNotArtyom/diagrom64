// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Misc helpers userd by everything

	#include <stdlib.h>
	#include <stdint.h>
	#include <string.h>
	#include <cbm_petscii_charmap.h>
	#include "diagrom.h"
	#include "system.h"

//--------------------------------------------	

void __fastcall__ delay(void) {
	static unsigned char x, y;
	for (y = 0; y < 0xFF; ++y) {
		for (x = 0; x < 0xFF; ++x) {
			asm("nop");
		}
	}
}

void __fastcall__ microdelay(void) {
	static unsigned char x;
	for (x = 0; x < 0x20; ++x) {
		asm("nop");
	}
}


void puts_addr(const unsigned char *str, unsigned char *addr) {
	unsigned char cnt = 0;
	while (str[cnt] != NULL) {
		addr[cnt] = get_screencode(str[cnt]);
		++cnt;
	}
}
