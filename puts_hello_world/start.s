.include "system.inc"
	.syntax unified
	.set ALIGNMENT,8

.text
	.align ALIGNMENT
	.global _start
_start:
	nop @ for gbd breakpoint

	@ Hello World
	@ puts(message)
	adr	r0,message
	bl puts

	@ sys.exit(0)
	mov	r0,$0
	sys.exit

@ Data needs to be in .text for PIE
@.data
message:
	.asciz "Hello, World! [ASM]"
	.align ALIGNMENT

