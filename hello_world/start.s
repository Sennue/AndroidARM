.include "system.inc"
	.syntax unified
	.set ALIGNMENT,8

.text
	.align ALIGNMENT
	.global _start
_start:
	nop @ for gbd breakpoint

	@ Hello World
	@ sys.write(stdout, message, length)
	mov	r0,$stdout
	adr	r1,message
	mov	r2,$length
	sys.write

	@ sys.exit(0)
	mov	r0,$0
	sys.exit

@ Data needs to be in .text for PIE
@.data
message:
	.asciz "Hello, World! [ASM]\n"
length = . - message
	.align ALIGNMENT

