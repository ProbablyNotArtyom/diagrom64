;; Diagnostic ROM for the Commodore 64
;; NotArtyom 05/08/19
;;--------------------------------------------
;; Performs the dead test 

	.include	"c64.inc"
	.include	"system.inc"
	.include 	"zeropage.inc"

	.export 	MEMTEST, _MEMPAT
	.export		_get_screencode, _test_zeropage, _test_stack
	.import		static_screen, _stage_0

;----------------------------------------------------------------------------------------
.segment	"RODATA"	;================================================================

PASS:	scrstrz "pass"
FAIL:	scrstrz "fail"

_MEMPAT:
	.byte $00, $55, $AA, $00, $01, $02, $04, $08
	.byte $10, $20, $40, $80, $FE, $FD, $FB, $F7
	.byte $EF, $DF, $BF, $7F
	.byte $00, $05, $0A, $0F, $01, $02, $04, $08
	.byte $0E, $0D, $0B, $07

;----------------------------------------------------------------------------------------
.segment	"STARTUP"	;================================================================

MEMTEST:
		ldx #$15
		ldy #$00
testloop:
		inc VIC_BORDERCOLOR
		lda _MEMPAT,x
		sta $0100,y
		sta $0200,y
		sta $0300,y
		sta $0400,y
		sta $0500,y
		sta $0600,y
		sta $0700,y
		sta $0800,y
		sta $0900,y
		sta $0A00,y
		sta $0B00,y
		sta $0C00,y
		sta $0D00,y
		sta $0E00,y
		sta $0F00,y
		iny
		bne testloop

		lda #COLOR_BLUE
		sta VIC_BORDERCOLOR
		txa
		ldx	#$55
		ldy	#$00
:		dey
		bne :-
		dex
		bne :-
		tax

:		inc VIC_BORDERCOLOR
		lda $0100,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0200,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0300,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0400,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0500,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0600,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0700,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0800,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0900,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0A00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0B00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0C00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0D00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0E00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		lda $0F00,y
		cmp _MEMPAT,x      ;testloop pattern
		bne :+
		iny
		beq	:++
		jmp :-
:		jmp MEMFAIL

:		dex
		bmi	:+
		ldy	#$00
		jmp testloop
:		jmp MEMPASS

MEMFAIL:
		ldy #COLOR_BLACK
		sty VIC_BORDERCOLOR
		jmp MEMFAIL

		eor _MEMPAT,X      ;testloop pattern
        tax
        and #$FE
        bne IE267
        ldx #$08
        jmp IE2A5        ;mem error flash

IE267:  txa
        and #$FD
        bne IE271
        ldx #$07
        jmp IE2A5        ;mem error flash

IE271:  txa
        and #$FB
        bne IE27B
        ldx #$06
        jmp IE2A5        ;mem error flash

IE27B:  txa
        and #$F7
        bne IE285
        ldx #$05
        jmp IE2A5        ;mem error flash

IE285:  txa
        and #$EF
        bne IE28F
        ldx #$04
        jmp IE2A5        ;mem error flash

IE28F:  txa
        and #$DF
        bne IE299
        ldx #$03
        jmp IE2A5        ;mem error flash

IE299:  txa
        and #$BF
        bne IE2A3
        ldx #$02
        jmp IE2A5        ;mem error flash

IE2A3:  ldx #$01         ;mem error flash
IE2A5:  txs
IE2A6:  lda #$01
        sta $D020
        sta $D021
        txa
        ldx #$7F
        ldy #$00
IE2B3:  dey
        bne IE2B3
        dex
        bne IE2B3
        tax
        lda #$00
        sta $D020
        sta $D021
        txa
        ldx #$7F
        ldy #$00
IE2C7:  dey
        bne IE2C7
        dex
        bne IE2C7
IE2CD:  dey
        bne IE2CD
        dex
        bne IE2CD
        tax
        dex
        beq IE2DA
        jmp IE2A6

IE2DA:	ldx #$00
		ldy #$00
IE2DE:	dey
    	bne IE2DE
    	dex
    	bne IE2DE
IE2E4:  dey
    	bne IE2E4
    	dex
    	bne IE2E4
IE2EA:  dey
    	bne IE2EA
    	dex
    	bne IE2EA
IE2F0:  dey
    	bne IE2F0
    	dex
    	bne IE2F0
    	tsx
    	jmp IE2A6

MEMPASS:
		ldx #$00			; Copy the screen into RAM
:		lda static_screen,x
		sta $800,x
		lda static_screen+$100,x
		sta $900,x
		lda static_screen+$200,x
		sta $A00,x
		lda static_screen+$300,x
		sta $B00,x
		lda static_screen+$400,x
		sta $C00,x
		lda static_screen+$500,x
		sta $D00,x
		lda static_screen+$600,x
		sta $E00,x
		lda static_screen+$700,x
		sta $F00,x
		inx
		bne :-

		ldx #$FF
		ldy #$FF
:		dex
		bne :-
		dey
		bne :-

		s_puts PASS, $883

		lda #%00101100
		sta $D018
		lda #COLOR_GREEN
		sta VIC_BORDERCOLOR

		jmp Start

_test_zeropage:
		ldx #$00
:		lda $00,x
		sta BBUF,x
		dex
		bne :-

		ldx #$13
:		lda _MEMPAT,x
		ldy #$12
:		sta $00,y
		iny
		bne :-

		txa
		ldx	#$55
		ldy	#$00
:		dey
		bne :-
		dex
		bne :-
		tax

		lda _MEMPAT,x
		ldy #$12
:		cmp $00,y
		bne :+
		iny
		bne :-
		dex
		bpl :----

		ldx #$00
z0:		lda BBUF,x
		sta $00,x
		dex
		bne z0
		lda #$01
		ldx #$00
		rts
:
		ldx #$00
z1:		lda BBUF,x
		sta $00,x
		dex
		bne z1
		lda #$00
		ldx #$00
		rts

_test_stack:
		ldx #$00
:		lda $100,x
		sta BBUF,x
		dex
		bne :-

		ldx #$13
:		lda _MEMPAT,x
		ldy #$12
:		sta $100,y
		iny
		bne :-

		txa
		ldx	#$55
		ldy	#$00
:		dey
		bne :-
		dex
		bne :-
		tax

		lda _MEMPAT,x
		ldy #$12
:		cmp $100,y
		bne :+
		iny
		bne :-
		dex
		bpl :----

		ldx #$00
s0:		lda BBUF,x
		sta $100,x
		dex
		bne s0
		lda #$01
		ldx #$00
		rts
:
		ldx #$00
s1:		lda BBUF,x
		sta $100,x
		dex
		bne s1
		lda #$00
		ldx #$00
		rts

_get_screencode:
		cmp #' '
		bcc cputdirect ; Other control char
	    tay
	    bmi L10
	    cmp #$60
	    bcc L2
	    and #$DF
	    bne cputdirect ; Branch always
L2: 	and #$3F

cputdirect:
		ldx #$00
	    rts

L10:
		and #$7F
	    cmp #$7E   ; PI?
	    bne L11
	    lda #$5E   ; Load screen code for PI
	    bne cputdirect
L11:
		ora #$40
	    bne cputdirect
		jmp cputdirect

;----------------------------------------------------------------------------------------
.segment	"BSS"	;====================================================================

BBUF:	.res $FF
