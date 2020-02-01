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

#define	MEMPAT_COLOR_LEN	12
const char MEMPAT_COLOR[MEMPAT_COLOR_LEN] = { 0x07, 0x0B, 0x0D, 0x0E, 0x08, 0x04, 0x02, 0x01, 0x0F, 0x0A, 0x05, 0x00 };

#define	MEMPAT_LEN	0x12
extern const char MEMPAT[];


char test_screen(void);
char test_color(void);
void puts_addr(const char str[], const char x, const char y);
void mem_fail(void);

//--------------------------------------------

static char *global_fault_addr;

void main(void) {
	global_fault_addr = 0;

	puts_addr("zeropage:", 1, 4);
	if (test_zeropage())
		puts_addr("pass", 11, 4);
	else {
		puts_addr("fail", 8, 7);
		mem_fail();
	}

	puts_addr("stack:", 1, 5);
	if (test_stack())
		puts_addr("pass", 8, 5);
	else {
		puts_addr("fail", 8, 7);
		mem_fail();
	}

	puts_addr("screen:", 1, 6);
	if (test_screen())
		puts_addr("pass", 9, 6);
	else {
		puts_addr("fail", 8, 7);
		mem_fail();
	}

	puts_addr("color:", 1, 7);
	if (test_color())
		puts_addr("pass", 8, 7);
	else {
		puts_addr("fail", 8, 7);
		mem_fail();
	}
	return;
}

char test_screen() {
	char *screen_data = (char *)SCREENMEM;
	char *mem_pattern = (char *)MEMPAT;
	char save, y;
	int x = 0;
	while (x < 25*40) {
		save = screen_data[x];
		y = 0;
		while (y < MEMPAT_LEN) {
			screen_data[x] = mem_pattern[y];
			microdelay();
			if (mem_pattern[y] != screen_data[x]) {
				global_fault_addr = (char *)(SCREENMEM + x);
				return false;
			}
			++y;
		}
		screen_data[x] = save;
		++x;
	}
	return true;
}

char test_color() {
	char *color_data = (char *)0xD800;
	char *mem_pattern = (char *)MEMPAT_COLOR;
	char save, y;
	int x = 0;
	while (x < 25*40) {
		save = color_data[x];
		y = 0;
		while (y < MEMPAT_COLOR_LEN) {
			color_data[x] = mem_pattern[y];
			microdelay();
			if (mem_pattern[y] != (color_data[x] & 0x0F)) {
				global_fault_addr = (char *)(0xD800 + x);
				return false;
			}
			++y;
		}
		color_data[x] = save;
		++x;
	}
	return true;
}

void puts_addr(const char str[], const char x, const char y) {
	char *i = (char *)SCREENMEM + (40*y)+x;
	char cnt = 0;
	while (str[cnt] != NULL) {
 		i[cnt] = get_screencode(str[cnt]);
		++cnt;
	}
}

void mem_fail() {
	*((char *)0xD020) = COLOR_RED;
}
