.include "system.inc"
	.syntax unified
	.set ALIGNMENT,8

.text
	.align ALIGNMENT
	.global main
main:
	nop @ for gbd breakpoint

	@ backup return address
	mov	r11,lr

	@ Hello World
	@ puts(message)
	adr	r0,message
	bl	puts

	@ return(0)
	mov	r0,$0
	bx	r11

@ Data needs to be in .text for PIE
@.data
message:
	.asciz "Hello, World! [ASM]"
	.align ALIGNMENT

