
;  Color defines
COLOR_BLACK             = $00
COLOR_WHITE             = $01
COLOR_RED               = $02
COLOR_CYAN              = $03
COLOR_VIOLET            = $04
COLOR_GREEN             = $05
COLOR_BLUE              = $06
COLOR_YELLOW            = $07
COLOR_ORANGE            = $08
COLOR_BROWN             = $09
COLOR_LIGHTRED          = $0A
COLOR_GRAY1             = $0B
COLOR_GRAY2             = $0C
COLOR_LIGHTGREEN        = $0D
COLOR_LIGHTBLUE         = $0E
COLOR_GRAY3             = $0F

;;----------------- macros -------------------

.macpack cbm

.macro scrstrz str
	scrcode str
	.byte $00
.endmacro

.macro s_puts str, addr
.scope
		ldx #$00
:		lda str,x
		beq :+
		sta addr,x
		inx
		jmp :-
:
.endscope
.endmacro
