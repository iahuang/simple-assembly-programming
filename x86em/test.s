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
	push	edi
	push	esi
	call	L2$pb
L2$pb:
	pop	eax
	cmp	dword ptr [eax + _n-L2$pb], 0
	jle	LBB2_1
## %bb.2:
	mov	edi, 1
	xor	ecx, ecx
	mov	edx, dword ptr [eax + _n-L2$pb]
	xor	esi, esi
	.p2align	4, 0x90
LBB2_3:                                 ## =>This Inner Loop Header: Depth=1
	mov	eax, edi
	add	esi, eax
	inc	ecx
	mov	edi, esi
	mov	esi, eax
	cmp	ecx, edx
	jl	LBB2_3
	jmp	LBB2_4
LBB2_1:
	xor	eax, eax
LBB2_4:
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


.subsections_via_symbols
