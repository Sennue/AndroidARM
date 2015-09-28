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
	ldr	r10,.Lgot	@ got_ptr = &GOT - X
	add	r10,r10,pc	@ got_ptr += X
	ldr	r9,.Lprintf	@ printf_offset
.Lpie0:	ldr	r9,[r9,r10]	@ printf = printf_ptr

	@ backup argv
	mov	r4,r1		@ argv

	@ printf(message, argvn)
	ldr	r1,[r4],$4	@ argvn = argv++ (argv[0]) backup
	teq	r1,$0		@ argvn, NULL test
	beq	done		@ return if argvn == NULL
	adr	r0,message	@ format
	blx	r9		@ printf

	@ alloc_node(argvn) if NULL != argvn
	ldr	r0,[r4],$4	@ argvn = argv++ (argv[1]) backup
	teq	r0,$0		@ argvn, NULL test
	beq	done		@ return if argvn == NULL
	bl	alloc_node	@ alloc_node
	mov	r5,r0		@ root = alloc_node(argv[1])

	@	load insert_value
	ldr	r9,.Linsert_value

	@ while (NULL != argvn) find_node(root, insert_value, argvn) arvn = argv++
	b	loop_test
loop_top:
	ldr	r1,[r9,r10]	@ insert_value
	mov	r0,r5		@ root
	bl	find_node	@ find_node(root, insert_value, argvn)
loop_test:
	ldr	r2,[r4],$4	@ argvn = argv++ (argv[1]) backup
	teq	r2,$0		@ restore argvn, NULL test
	bne	loop_top

	@ walk_tree(root, print_tree)
	ldr	r9,.Lprint_tree
	ldr	r1,[r9,r10]	@ print_tree
	mov	r0,r5		@ root
	bl	walk_tree	@ walk_tree(root, print_tree)

	@ walk_tree(root, free_tree)
	ldr	r9,.Lfree_tree
	ldr	r1,[r9,r10]	@ free_tree
	mov	r0,r5		@ root
	bl	walk_tree	@ walk_tree(root, free_tree)

done:
	@ return(0)
	mov	r0,$0
	bx	r11

@ Data needs to be in .text for PIE
@.data
message:
	.asciz	"[ASM Caller] %s\n"
.Lgot:
	.long	_GLOBAL_OFFSET_TABLE_-.Lpie0
.Lprintf:
	.word	printf(GOT)
.Linsert_value:
	.word	insert_value(GOT)
.Lprint_tree:
	.word	print_tree(GOT)
.Lfree_tree:
	.word	free_tree(GOT)
	.align	ALIGNMENT

