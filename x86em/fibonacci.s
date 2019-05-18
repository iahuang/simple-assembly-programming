	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 14	sdk_version 10, 14
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
	push	edi
	push	esi
	call	L2$pb
L2$pb:
	pop	ecx
	mov	esi, dword ptr [ecx + _n-L2$pb]
	test	esi, esi
	jle	LBB2_1
## %bb.2:
	lea	eax, [esi - 1]
	mov	edx, esi
	and	edx, 7
	cmp	eax, 7
	jae	LBB2_4
## %bb.3:
	xor	esi, esi
	mov	edi, 1
	jmp	LBB2_6
LBB2_1:
	xor	eax, eax
	jmp	LBB2_9
LBB2_4:
	mov	eax, edx
	sub	eax, esi
	xor	esi, esi
	mov	edi, 1
	.p2align	4, 0x90
LBB2_5:                                 ## =>This Inner Loop Header: Depth=1
	add	esi, edi
	add	edi, esi
	add	esi, edi
	add	edi, esi
	add	esi, edi
	add	edi, esi
	add	esi, edi
	add	edi, esi
	add	eax, 8
	jne	LBB2_5
LBB2_6:
	mov	eax, esi
	test	edx, edx
	je	LBB2_9
## %bb.7:
	neg	edx
	.p2align	4, 0x90
LBB2_8:                                 ## =>This Inner Loop Header: Depth=1
	mov	eax, edi
	add	esi, edi
	mov	edi, esi
	mov	esi, eax
	inc	edx
	jne	LBB2_8
LBB2_9:
	mov	ecx, dword ptr [ecx + L_final$non_lazy_ptr-L2$pb]
	mov	dword ptr [ecx], eax
	pop	esi
	pop	edi
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

	.comm	_final,4,2              ## @final

	.section	__IMPORT,__pointers,non_lazy_symbol_pointers
L_final$non_lazy_ptr:
	.indirect_symbol	_final
	.long	0

.subsections_via_symbols
