;
; Startup code for cc65 (C64 version)
;

    .export		_exit
    .export		__STARTUP__ : absolute = 1		; Mark as startup
	.export		Start

    .import		initlib, donelib
    .import		zerobss, callmain
    .import		BSOUT
    .import		__STACK__, __STACKSIZE__		; from configure file
    .importzp	ST

	.import		__DATA_SIZE__, __DATA__START__

    .include	"zeropage.inc"
    .include	"c64.inc"

;----------------------------------------------------------------------------------------
.segment	"STARTUP"	;================================================================

Start:
    tsx
    stx spsave          ; Save the system stack ptr

    jsr init
    jsr zerobss
	jsr copydata

    jsr callmain		; Push the command-line arguments and call main().

	; Back from main() [this is also the exit() entry].
	; Run the module destructors.

_exit:
	pha					; Save the return code on stack
    jsr donelib

    ldx #zpspace-1		; Copy back the zero-page stuff.
:	lda zpsave,x
    sta sp,x
    dex
    bpl :-

    ldx spsave			; Restore stack pointer
    txs
    rts


;----------------------------------------------------------------------------------------
.segment	"ONCE"	;====================================================================

init:
    ldx #zpspace-1		; Save the zero-page locations that we need.
:	lda sp,x
    sta zpsave,x
    dex
    bpl :-

    lda #<(__STACK__)	; Set up the stack.
    ldx #>(__STACK__)
    sta sp
    stx sp+1

    jmp initlib			; Call the module constructors.

;----------------------------------------------------------------------------------------
.segment	"INIT"	;====================================================================

mmusave:	.res 1
spsave:		.res 1
zpsave:		.res zpspace
