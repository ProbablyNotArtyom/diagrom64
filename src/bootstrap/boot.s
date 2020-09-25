;; Diagnostic ROM for the Commodore 64
;; NotArtyom 05/08/19
;;--------------------------------------------
;; First boot tests, dead test stuff

	.include	"c64.inc"
	.include	"system.inc"
	.include 	"zeropage.inc"

	.export 	_RESET_VEC, static_screen
	.import		MEMTEST, _stage_0

;----------------------------------------------------------------------------------------
.segment	"SCREEN"	;================================================================
; This segment holds the uncompressed screen map for the diagnostic display
; Having the entire screen uncompressed in memory allows us the have a nice display during the dead test
; Since all the display memory is in ROM, we can enable the VIC without risking a crash due to bad RAM

static_screen:
	.include "assets/frame-map.inc"

;----------------------------------------------------------------------------------------
.segment	"STARTUP"	;================================================================

_RESET_VEC:
		ldx	#$FF			; Do all the usual CPU init stuff
		sei					; If the CPU can't complete this before haulting then it's likely physical damage to the system
		txs
		cld

		lda #$E7			; Setup the 6510 IO port
		sta $01
		lda	#$37
		sta	$00

		lda	#$9B			; Enable the VIC as soon as possible to get something on the screen
		sta $D011
		lda #$37
		sta $D012
		lda #$08

		sta $D016			; Setup our the VIC banks for Ultimax mode
		lda #%11101100
		sta $D018

		lda #COLOR_RED
		sta VIC_BORDERCOLOR
		lda #COLOR_WHITE
		sta VIC_BG_COLOR0

		.ifdef SKIP_BOOT
			jmp MEMPASS
		.endif

		jmp MEMTEST
