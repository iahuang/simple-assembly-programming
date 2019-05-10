	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 10, 14
	.intel_syntax noprefix
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
## %bb.0:
	push	ebp
	mov	ebp, esp
	call	L0$pb
L0$pb:
	pop	eax
	mov	eax, dword ptr [eax + L_bees$non_lazy_ptr-L0$pb]
	mov	dword ptr [eax], 69420
	mov	eax, 69420
	pop	ebp
	ret
                                        ## -- End function
	.comm	_bees,4,2               ## @bees

	.section	__IMPORT,__pointers,non_lazy_symbol_pointers
L_bees$non_lazy_ptr:
	.indirect_symbol	_bees
	.long	0

.subsections_via_symbols
