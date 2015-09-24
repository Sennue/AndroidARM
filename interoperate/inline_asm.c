#include <stdio.h>

// this is an example of *how* to implement inline ARM ASM
// in this particular case, the stack overhead probably negates any benefits
int inline_asm(int (*pFunction)(const char *), const char *pMessage)
{
	const char *message = "[Inline ASM]";
	// reserving a register like this interferes with the optimizer
	register int result asm("r0");
	//asm(code : output operand list : input operand list : clobber list);
	asm volatile (
		"mov	r0,%[message]\n\t"
		"blx	%[puts]\n\t"		/* result = puts(message); */
		"teq	r0,%[eof]\n\t"		/* if EOF != result */
		"movne	r0,%[func_param]\n\t"
		"blxne	%[func]\n\t"		/*     result = pFunction(pMessage) */
		"mov	%[result],r0"		/* redundant, but how it would be done if result was no a reserved register */
		: [result] "=r" (result)
		: [puts] "r" (puts), [message] "r" (message), [func] "r" (pFunction), [func_param] "r" (pMessage), [eof] "r" (EOF)
		: "r0", "r1", "r2", "r3", "ip", "lr", "cc"	// much stack push & pop madness
	);
	return result;
}

