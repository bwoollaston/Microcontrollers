REL EQU -3									;Reload value for timer for 9600 baud

org 0
		
		mov scon,#40h					;sets sp to mode 1, 8bit uart baud rate set by timer
		mov tmod,#20h					;timer 1 mode 2  ****must use timer 1
		anl pcon,#7Fh					;clear smod, pcon not bit addressable
		mov th1,#REL					;set reload value for 9600 baud with 11.059MHz oscillator
	
		setb tr1						;start timer
		setb ti							;jumpstart
		acall clear						;clear terminal

		mov R7,#00h						;set r7 to incriment through 10 name writing sequence
repeat:	mov a,#00h						;set a to first character in lookup table
nmloop:	push acc						;save a to incriment after running OUTCHAR
		acall lookup
		acall OUTCHAR
		pop acc							
		inc a							;incriment to next item of lookup table
		cjne a,#9h,nmloop				;check if whole name+newline sequence has run
		inc R7							;incriment to next iteration of name write
		cjne R7,#0Ah,repeat				;check if name has written 10 times
		sjmp $

;******************************************************************************
;Subroutine to clear the screen on attached monitor through string of characters
;stores at data locations 0-3
;Uses outchar
;Inputs: 00h,01h,02h,03h
;Outputs: acc
;Destroys: acc
;******************************************************************************
clear:	mov a,#1bh
		acall OUTCHAR
		mov a,#5bh
		acall OUTCHAR
		mov a,#32h
		acall OUTCHAR
		mov a,#4ah
		acall OUTCHAR
		ret

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
			
;******************************************************************************
;Subroutine to use PC to navigate a lookup table containing name characters
;Inputs: acc,PC
;Outputs: acc
;Destroys: acc
;******************************************************************************	
lookup:		inc a
			movc a,@a+pc
			ret
nametable:	db 'B','r','o','d','i','e',0Dh,0Ah,0
end