// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Stage 0

	#include <stdlib.h>
	#include <stdint.h>
	#include <string.h>
	#include <cbm_petscii_charmap.h>
	#include "diagrom.h"
	#include "system.h"

void main(void) {
	puts_addr("zeropage:", 1, 4);
	if (test_zeropage())
		puts_addr("pass", 11, 4);
	else
		puts_addr("fail", 11, 4);

	puts_addr("stack:", 1, 5);
	if (test_stack())
		puts_addr("pass", 8, 5);
	else
		puts_addr("fail", 8, 5);

	return;
}

void puts_addr(const char str[], const char x, const char y) {
	char *i = (char*)SCREENMEM + (40*y)+x;
	char cnt = 0;
	while (str[cnt] != NULL) {
 		i[cnt] = get_screencode(str[cnt]);
		++cnt;
	}
}
