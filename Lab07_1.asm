REL EQU -3								;Reload value for timer for 9600 baud

org 0
	
		mov scon,#40h					;sets sp to mode 1, 8bit uart baud rate set by timer
		mov tmod,#20h					;timer 1 mode 2  ****must use timer 1
		anl pcon,#7Fh					;clear smod, pcon not bit addressable
		mov th1,#REL					;set reload value for 9600 baud with 11.059MHz oscillator
	
		setb tr1						;start timer
		setb ti
loop2: 	mov a,#20h
loop:	acall OUTCHAR
		inc a
		cjne a,#7Fh,loop
		sjmp loop2


;******************************************************************************
;Subroutine to send ascii character via serial port
;Inputs: psw
;Outputs: acc
;Destroys:
;******************************************************************************

OUTCHAR:	push acc
			push psw
			mov c,p					;move parity to c so it can be operatred on
			cpl c					;change to odd parity
			mov acc.7,c				;mov c to parity bit to be sent out
AGAIN:		jnb ti,AGAIN			;holdup until ti is set
			clr ti					;clear flag for next character
			mov sbuf,a				;send a to sbuf
			clr acc.7				;strip parity bit
			pop psw
			pop acc
			ret
end