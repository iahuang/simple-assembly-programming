	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 14
	.intel_syntax noprefix
	.globl	_print                  ## -- Begin function print
	.p2align	4, 0x90
_print:                                 ## @print
## %bb.0:
	push	ebp
	mov	ebp, esp
	pop	ebp
	ret
                                        ## -- End function
	.globl	_printi                 ## -- Begin function printi
	.p2align	4, 0x90
_printi:                                ## @printi
## %bb.0:
	push	ebp
	mov	ebp, esp
	pop	ebp
	ret
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
## %bb.0:
	push	ebp
	mov	ebp, esp
	push	esi
	call	L2$pb
L2$pb:
	pop	eax
	mov	edx, dword ptr [eax + _n-L2$pb]
	test	edx, edx
	jle	LBB2_1
## %bb.2:
	lea	eax, [edx - 1]
	mov	ecx, edx
	and	ecx, 7
	cmp	eax, 7
	jae	LBB2_4
## %bb.3:
	xor	edx, edx
	mov	esi, 1
	jmp	LBB2_6
LBB2_1:
	xor	eax, eax
	jmp	LBB2_9
LBB2_4:
	mov	eax, ecx
	sub	eax, edx
	xor	edx, edx
	mov	esi, 1
	.p2align	4, 0x90
LBB2_5:                                 ## =>This Inner Loop Header: Depth=1
	add	edx, esi
	add	esi, edx
	add	edx, esi
	add	esi, edx
	add	edx, esi
	add	esi, edx
	add	edx, esi
	add	esi, edx
	add	eax, 8
	jne	LBB2_5
LBB2_6:
	mov	eax, edx
	test	ecx, ecx
	je	LBB2_9
## %bb.7:
	neg	ecx
	.p2align	4, 0x90
LBB2_8:                                 ## =>This Inner Loop Header: Depth=1
	mov	eax, esi
	add	edx, eax
	mov	esi, edx
	mov	edx, eax
	inc	ecx
	jne	LBB2_8
LBB2_9:
	pop	esi
	pop	ebp
	ret
                                        ## -- End function
	.section	__DATA,__data
	.globl	_n                      ## @n
	.p2align	2
_n:
	.long	5                       ## 0x5

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"hmmm"

	.section	__DATA,__data
	.globl	_hmm                    ## @hmm
	.p2align	2
_hmm:
	.long	L_.str


.subsections_via_symbols
