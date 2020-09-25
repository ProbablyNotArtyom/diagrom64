
	.import _IRQ_VEC
	.import _NMI_VEC
	.import _RESET_VEC

;----------------------------------------------------------------------------------------
.segment	"VECTORS"	;================================================================

	.word _NMI_VEC
	.word _RESET_VEC
	.word _IRQ_VEC
