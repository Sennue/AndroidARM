.include "system.inc"
.include "tree.inc"
	.syntax unified
	.set ALIGNMENT,8
	.set EOF,-1

.text
	.align ALIGNMENT
	.global alloc_node
alloc_node:
@ node_t *alloc_node(const char *pValue)
	push	{r0,lr}	@ backup lr and pValue
	mov	r0,$sizeof_node_t	@ sizeof(node_t)
	bl	malloc	@ result = malloc(sizeof(node_t))
	pop	{r1,lr}	@ restore lr and pValue
	mov	r2,$0	@ NULL
	str	r1,[r0,$offsetof_node_t_value]	@ result->value = pValue
	str	r2,[r0,$offsetof_node_t_left]	@ result->left = NULL
	str	r2,[r0,$offsetof_node_t_right]	@ result->right = NULL
	bx	lr	@ return result

	.global walk_tree
walk_tree:
@ node_t *walk_tree(node_t *pNode, node_t *(*pProc)(node_t *pNode))
	@ backup registers and lr
	push	{r4-r8,lr}
	mov	r4,r0	@ pNode
	mov	r5,r1	@ pProc
	mov	r6,$0	@ left
	mov	r7,$0	@ right
	mov	r8,$0	@ result

	@ pProc may be destructive
	@ cache left and right
	teq	r0,$0	@ if NULL != pNode
	ldrne	r6,[r4,$offsetof_node_t_left]	@ left = pNode->left
	ldrne	r7,[r4,$offsetof_node_t_right]	@ right = pNode->right

.left:
	teq	r6,$0	@ if NULL != left
	beq	.proc
	teq	r8,$0	@ if NULL == result
	bne	.proc
	mov	r0,r6	@ left
	mov	r1,r5	@ pProc
	bl	walk_tree	@ result = walk_tree(left, pProc)
	mov	r8,r0

.proc:
	teq	r5,$0	@ if NULL != pProc
	beq	.right
	teq	r8,$0	@ if NULL == result
	bne	.right
	mov	r0,r4	@ pNode
	blx	r5	@ result = pProc(pNode)
	mov	r8,r0

.right:
	teq	r7,$0	@ if NULL != right
	beq	.done
	teq	r8,$0	@ if NULL == result
	bne	.done
	mov	r0,r7	@ right
	mov	r1,r5	@ pProc
	bl	walk_tree	@ result = walk_tree(right, pProc)
	mov	r8,r0

.done:
	@ return result (restore registers)
	mov	r0,r8	@result
	pop	{r4-r8,pc}	@ return result

	.global find_node
@ node_t *find_node(
@	node_t *pNode,
@	node_t *(*pProc)(node_t *pNode, const char *pValue),
@	const char *pValue
@ )
find_node:
	@ backup registers and lr
	push	{r4-r8,lr}
	mov	r4,r0	@ pNode
	mov	r5,r1	@ pProc
	mov	r6,r2	@ pValue
	@	r7	@ compare

	@ if NULL == pNode return pProc(pNode, pValue)
	teq	r4,$0
	beq	.default_proc

.compare:
	mov	r0,r6	@ pValue
	ldr	r1,[r4,$offsetof_node_t_value]	@ pNode->value
	bl	strcmp	@ strcmp(pValue, pNode->value)
	mov	r7,r0	@ compare

	@ if 0 == compare
	teq	r7,$0
	bne	.proc_left
.default_proc:
	mov	r0,r4	@ pNode
	mov	r1,r6	@ pValue
	blx	r5	@ return pProc(pNode, pValue)
	pop	{r4-r8,pc}

.proc_left:
	cmn	r7,$0	@ if compare < 0
	bgt	.proc_right
	ldr	r0,[r4,$offsetof_node_t_left]	@ pNode->left
	cmp	r0,$0	@ if NULL == pNode->left
	bne	.search_left
	@	r0	@ pNode->left
	mov	r1,r6	@ pValue
	blx	r5	@ return pNode->left = pProc(pNode->left, pValue)
	str	r0,[r4,$offsetof_node_t_left]
	pop	{r4-r8,pc}
.search_left:
	@	r0	@ pNode->left
	mov	r1,r5	@ pProc
	mov	r2,r6	@ pValue
	bl	find_node	@ return find_node(pNode->left, pProc, pValue)
	pop	{r4-r8,pc}

.proc_right:
	ldr	r0,[r4,$offsetof_node_t_right]	@ pNode->right
	cmp	r0,$0	@ if NULL == pNode->right
	bne	.search_right
	@	r0	@ pNode->right
	mov	r1,r6	@ pValue
	blx	r5	@ return pNode->right = pProc(pNode->right, pValue)
	str	r0,[r4,$offsetof_node_t_right]
	pop	{r4-r8,pc}
.search_right:
	@	r0	@ pNode->right
	mov	r1,r5	@ pProc
	mov	r2,r6	@ pValue
	bl	find_node	@ return find_node(pNode->right, pProc, pValue)
	pop	{r4-r8,pc}

.no_match:
	@ return NULL
	mov	r0,$0
	pop	{r4-r8,pc}

	.global insert_value
@ node_t *insert_value(node_t *pNode, const char *pValue)
insert_value:
	push	{r0,lr}	@ backup lr and potential return value
	teq	r0,$0	@ if NULL != pNode
	popne	{r0,pc}	@ return pNode
	mov	r0,r1	@ pValue
	bl	alloc_node	@ return alloc_node(pValue)
	pop	{ip,pc}

	.global free_tree
@ node_t *free_tree(node_t *pNode)
free_tree:
	mov	ip,$0	@ wll return NULL
	push	{ip,lr}	@ backup lr and return value
	teq	r0,$0	@ if NULL != pNode
	blne	free	@ free(pNode)
	pop	{r0,pc}	@ return NULL

	.global print_tree
@ node_t *print_tree(node_t *pNode)
print_tree:
	mov	ip,$0	@ wll return NULL
	push	{ip,lr}	@ backup lr and return value
	teq	r0,$0	@ if NULL != pNode
	ldrne	r0,[r0,$offsetof_node_t_value]
	blne	puts	@ puts(pNode->value)
	pop	{r0,pc}	@ return NULL

@ Data needs to be in .text for PIE
@.data
message:
	.asciz "[ASM Subroutine]"
	.align ALIGNMENT

