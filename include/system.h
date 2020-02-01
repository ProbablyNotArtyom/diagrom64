// Diagnostic ROM for the Commodore 64
// NotArtyom 05/08/19
//--------------------------------------------
// Definitions of more meta things

#ifndef _HEADER_SYSTEM
#define _HEADER_SYSTEM

#define __force 				__attribute__((force))
#define __inline__      		__attribute__((always_inline))
#define __noreturn__      		__attribute__((no_return))
#define __deprecated			__attribute__((deprecated))
#define __no_optimize			__attribute__((optimize("O0")))
#define __attribute_used__		__attribute__((__used__))
#define __attribute_const__		__attribute__((__const__))
#define __weak__				__attribute__((__weak__))
#define __must_check			__attribute__((warn_unused_result))

#endif
