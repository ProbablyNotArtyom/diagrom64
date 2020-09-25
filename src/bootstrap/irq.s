
	.export _IRQ_VEC
	.export _NMI_VEC

_IRQ_VEC:
	nop
	jmp _IRQ_VEC

_NMI_VEC:
	nop
	jmp _NMI_VEC
