REL EQU -3									;Reload value for timer for 9600 baud

org 0
			mov scon,#52h					;sets sp to mode 1, 8bit uart baud rate set by timer
			mov tmod,#20h					;timer 1 mode 2  ****must use timer 1
			anl pcon,#7Fh					;clear smod, pcon not bit addressable
			mov th1,#REL					;set reload value for 9600 baud with 11.059MHz oscillator
			setb tr1
		
loop:		acall INCHAR					;read ascii charater
			cjne a,#60h,$+3					;test for lower case ascii character
			jb cy,skip1
			cjne a,#7Bh,$+3
			jnb cy,skip1
			clr c
			subb a,#20h						;convert lower case ascii to upper case
skip1:		setb ti							;start transmit
			acall OUTCHAR					;write ascii to terminal
			sjmp loop						;repeat for consecutive characters

;******************************************************************************
;Subroutine to recieve odd parity ascii character via serial port
;Inputs: psw,acc
;Outputs: acc
;Destroys:
;******************************************************************************
INCHAR: 	push psw
			jnb RI,$						;wait for a character
			clr RI							;clr recieve flag
			mov a,sbuf						;read char into a
			mov c,p							;need to reverse parity bit for odd parity
			cpl c
			clr acc.7						;strip parity bit
			pop psw
			ret

;******************************************************************************
;Subroutine to send odd parity ascii character via serial port
;Inputs: psw,acc
;Outputs: acc
;Destroys:
;******************************************************************************

OUTCHAR:	push psw
			mov c,p					;move parity to c so it can be operatred on
			cpl c					;change to odd parity
			mov acc.7,c				;mov c to parity bit to be sent out
AGAIN:		jnb ti,AGAIN			;holdup until ti is set
			clr ti					;clear flag for next character
			mov sbuf,a				;send a to sbuf
			clr acc.7				;strip parity bit
			pop psw
			ret
end