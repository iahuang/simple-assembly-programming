	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 14
	.intel_syntax noprefix
	.globl	_square                 ## -- Begin function square
	.p2align	4, 0x90
_square:                                ## @square
## %bb.0:
	push	ebp
	mov	ebp, esp
	sub	esp, 8
	mov	eax, dword ptr [ebp + 8]
	mov	dword ptr [ebp - 4], 5
	mov	ecx, dword ptr [ebp + 8]
	imul	ecx, dword ptr [ebp + 8]
	mov	dword ptr [ebp - 8], eax ## 4-byte Spill
	mov	eax, ecx
	add	esp, 8
	pop	ebp
	ret
                                        ## -- End function
	.section	__DATA,__data
	.globl	_egg                    ## @egg
	.p2align	2
_egg:
	.long	4                       ## 0x4


.subsections_via_symbols
