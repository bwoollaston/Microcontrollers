RED DATA 11111110b		;Variable to set light red
YEL DATA 11111101b		;Variable to set light yellow
GRE DATA 11111011b		;variable to set light green
count EQU -9216			;variable to reset counter for 1s delay corrected for 11.0592MHz
repeat EQU 100			;counter repearts until 1s delay is complete
org 0
		mov P0,#RED		;initialize trafic light
		mov P1,#GRE
		mov TMOD,#01h	;set timer to timer 0 mode 1
		
loop:	acall DELAY
		mov P1,#YEL
		acall DELAY
		mov P1,#RED
		mov P0,#GRE
		acall DELAY
		mov P0,#YEL
		acall DELAY
		mov P0,#RED
		mov P1,#GRE
		sjmp loop
;************************************************************
;Subroutine for 1 second counter delay
;Inputs: 	TMOD,TL0,TH0
;Outputs:	TF0
;Destroys:	TCON(TF0),TL0,TF0
;************************************************************
DELAY:	mov r7,#repeat
again:	mov TH0,#HIGH count
		mov TL0,#LOW count
		setb TR0
wait:	jnb TF0,wait
		clr TF0
		clr TR0
		djnz r7,again
		ret

end