
.export IRQ_VEC
.export NMI_VEC

IRQ_VEC:
	nop
	jmp IRQ_VEC

NMI_VEC:
	nop
	jmp NMI_VEC
