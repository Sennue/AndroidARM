.include "system.inc"
        .syntax unified
	.set ALIGNMENT,8
	.set BUFFER_SIZE,2048

.bss
	.comm buffer,BUFFER_SIZE,ALIGNMENT

.text
	.align ALIGNMENT
        .global _start
_start:
	nop @ for gbd breakpoint

	@ Intro Message
	@ sys.write(stdout, message, length)
	mov	r0,$stdout
	adr	r1,message
	mov	r2,$length
	sys.write

	@ Load Buffer via Global Offset Table
	ldr	r0,.Lgot	@ got_ptr = &GOT - X
	add	r0,r0,pc	@ got_ptr += X
	ldr	r4,.Lbuffer	@ buffer_offset
.Lpie0:	ldr	r4,[r4,r0]	@ buffer = *(got_ptr+buffer_offset)

	@ Write Args
	pop	{r0,r1}	@ pop argc, argvn_ptr = argv[0]
proc_arg:
	teq	r1,$0	@ if NULL != argvn_ptr
	beq	done
	mov	r2,r4	@ buffer_ptr = buffer
copy_char:
	ldrb	r0,[r1],$1	@ c = *argv_ptr++
	teq	r0,$0
	beq	output
	strb	r0,[r2],$1	@ *buffer_ptr++ = c
	b	copy_char
output:
	mov	r0,$0x0A	@ c = '\n'
	strb	r0,[r2],$1	@ *buffer_ptr++ = '\n'
	mov	r0,$stdout
	mov	r1,r4		@ buffer
	sub	r2,r2,r1	@ length = buffer - buffer_ptr
	sys.write
	pop	{r1}	@ argv_ptr = argv[n]
	b	proc_arg
done:
	@ sys.exit(0)
	mov	r0,$0
	sys.exit

@ Data needs to be in .text for PIE
@.data
message:
        .asciz "Args: [ASM]\n"
length = . - message
	.align ALIGNMENT

	@ Global Offset Table
.Lgot:
	.long	_GLOBAL_OFFSET_TABLE_-.Lpie0
.Lbuffer:
	.word	buffer(GOT)
	.align ALIGNMENT

