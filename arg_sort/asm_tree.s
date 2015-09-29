.include "system.inc"
.include "tree.inc"
	.syntax unified
	.set ALIGNMENT,8
	.set EOF,-1

.text
	.align ALIGNMENT
	.global subroutine
subroutine:
	nop @ for gbd breakpoint

	@ backup registers
	push	{r4,r5,ip,lr}
	mov	r4,r0	@ function_ptr
	mov	r5,r1	@ caller_message

	@ body
	adr	r0,message
	bl	puts	@ result = puts(message)
	mov	r1,$EOF
	teq	r0,r1	@ if EOF != result
	movne	r0,r5
	blxne	r4	@ result = function_ptr(caller_message)
	popeq	{r4,r5,ip,pc}	@ return result

@ Data needs to be in .text for PIE
@.data
message:
	.asciz "[ASM Subroutine]"
	.align ALIGNMENT

