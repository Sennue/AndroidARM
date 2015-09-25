.include "system.inc"
	.syntax	unified
	.set	ALIGNMENT,8
	.set	EOF,-1

.text
	.align	ALIGNMENT
	.global	main
main:
	nop @ for gbd breakpoint

	mov	r11,lr		@ backup return address
	ldr	r9,.Lgot	@ got_ptr = &GOT - X
	add	r9,r9,pc	@ got_ptr += X
	ldr	r10,.Lputs	@ puts_offset
.Lpie0:	ldr	r9,[r9,r10]	@ buffer = *(got_ptr+puts_offset)
	mov	r10,$EOF	@ preload const EOF

	@ result = function(message)
	mov	r0,r9
	adr	r1,message
	bl	function

	@ if EOF != result
	@   result = subroutine(message)
	teq	r0,r10
	movne	r0,r9
	adrne	r1,message
	blne	subroutine

	@ if EOF != result
	@   result = inline_asm(message)
	teq	r0,r10
	movne	r0,r9
	adrne	r1,message
	blne	inline_asm

	@ if EOF != result
	@   return(0)
	@ else
	@   return(1)
	teq	r0,r10
	movne	r0,$0
	moveq	r0,$1
	bx	r11

@ Data needs to be in .text for PIE
@.data
message:
	.asciz	"[ASM Caller]"
.Lgot:
	.long	_GLOBAL_OFFSET_TABLE_-.Lpie0
.Lputs:
	.word	puts(GOT)
	.align	ALIGNMENT

