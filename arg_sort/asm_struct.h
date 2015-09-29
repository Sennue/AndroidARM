#ifndef ASM_STRUCT_H
#define ASM_STRUCT_H

#include <stddef.h>

#undef offsetof
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
#define SIZEOF(TYPE, MEMBER) (sizeof(((TYPE *)0)->MEMBER))
 
#define _DEFINE(sym, val) asm volatile(".set " #sym " %0 //" #val "\n" : : "i" (val))
#define DEFINE(s, m) \
	_DEFINE(offsetof_##s##_##m, offsetof(s, m)); \
	_DEFINE(sizeof_##s##_##m, SIZEOF(s, m));

#endif // ASM_STRUCT_H

