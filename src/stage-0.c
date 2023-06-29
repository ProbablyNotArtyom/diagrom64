// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Stage 0

	#include <stdlib.h>
	#include <stdint.h>
	#include <stdbool.h>
	#include <string.h>
	#include <c64.h>
	#include <cbm_petscii_charmap.h>
	#include "diagrom.h"
	#include "system.h"

//--------------------------------------------
	
#define	MEMPAT_COLOR_LEN	12
const unsigned char MEMPAT_COLOR[MEMPAT_COLOR_LEN] = { 0x07, 0x0B, 0x0D, 0x0E, 0x08, 0x04, 0x02, 0x01, 0x0F, 0x0A, 0x05, 0x00 };

#define	MEMPAT_LEN	0x12
extern const unsigned char MEMPAT[];

//--------------------------------------------

char test_screen(void);
char test_color(void);
void mem_fail(void);

//--------------------------------------------

static unsigned char *global_fault_addr;

void main(void) {
	global_fault_addr = 0;

	puts_xy("zeropage:", 1, 4);
	if (test_zeropage())
		puts_xy("pass", 11, 4);
	else {
		puts_xy("fail", 11, 4);
		mem_fail();
	}

	puts_xy("stack:", 1, 5);
	if (test_stack())
		puts_xy("pass", 8, 5);
	else {
		puts_xy("fail", 8, 5);
		mem_fail();
	}

	puts_xy("screen:", 1, 6);
	if (test_screen())
		puts_xy("pass", 9, 6);
	else {
		puts_xy("fail", 9, 6);
		mem_fail();
	}

	puts_xy("color:", 1, 7);
	if (test_color())
		puts_xy("pass", 8, 7);
	else {
		puts_xy("fail", 8, 7);
		mem_fail();
	}
	return;
}

char test_screen() {
	unsigned char save, mempat_index;
	unsigned char *i = SCREENMEM;
	while (i < SCREENMEM+25*40) {
		save = *i;
		mempat_index = 0;
		while (mempat_index < MEMPAT_LEN) {
			*i = MEMPAT[mempat_index];
			if (MEMPAT[mempat_index] != *i) {
				global_fault_addr = i;
				return false;
			}
			++mempat_index;
		}
		*i = save;
		++i;
	}
	return true;
}

char test_color() {
	unsigned char save, mempat_index;
	unsigned char *i = COLORMEM;
	while (i < COLORMEM+25*40) {
		save = *i;
		mempat_index = 0;
		while (mempat_index < MEMPAT_COLOR_LEN) {
			*i = MEMPAT_COLOR[mempat_index];
			if (MEMPAT_COLOR[mempat_index] != (*i & 0x0F)) {
				global_fault_addr = i;
				return false;
			}
			++mempat_index;
		}
		*i = save;
		++i;
	}
	return true;
}

void mem_fail() {
	*((unsigned char *)0xD020) = COLOR_RED;	// set border to red
	while (1);
}
