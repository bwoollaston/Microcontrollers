;Lab06_3 timer 2 counter

;******************************************
;Add directives for timer2
;******************************************
TR2 	 BIT 0CAh  				
TF2 	 BIT 0CFh		
EXF2	 BIT 0CEh
T2CON    DATA 0C8h
RCAP2L   DATA 0CAh
RCAP2H   DATA 0CBh
TL2 	 DATA 0CCh
TH2 	 DATA 0CDh

org 0
	
		setb p1.0			;initialize p1.0 for input, counts customer
		setb p1.1			;initialize p1.1 for input, trigger capture
		mov t2con,#00001011b;initialize timer2 con, EXEN HIGH, C/T2 HIGH, CP HIGH
		mov TL2,#0
		mov TH2,#0
	
wait1:	jnb p1.1,wait1
wait2:	jb p1.1,wait2
		acall rstTimer2
		sjmp wait1
	sjmp $

;*********************************************************************
;Subroutine to reset timer2 after caputre and put the value of RCAP2L 
;out to seven seg display
;Inputs: tl2,th2,t2con,rcap2l
;Outputs: Acc
;Destroys: Acc,tl2,th2,exf2
;*********************************************************************
rstTimer2:
		push psw
		mov tl2,#0
		mov th2,#0
		clr exf2
		mov a,rcap2l
		anl a,#0Fh
		acall lookup
		cpl a
		mov p0,a
		pop psw
		ret
;*********************************************************************
;Subroutine to lookup the value in a and return it in seven seg form
;Inputs: Acc,PC
;Outputs: Acc
;Destroys: Acc
;*********************************************************************
lookup:	inc a
		movc a,@a+pc
		ret
svnseg:	db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,4fh,77h,7bh,39h,5eh,79h,71h
	
end