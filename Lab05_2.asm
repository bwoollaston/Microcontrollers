

org 0
	
		clr p1.3
		clr p1.2
		clr p1.1
		setb p1.0
		orl p2,#0Fh
		
loop:	acall rdpins
		anl a,#0fh
		acall lookup
		cpl a					;converts active high seven seg values to active low
		
		mov P0,a				;sets seven segment to the value in acc
		sjmp loop
sjmp $
	
;**************************************************
;Moves 4 bits p2.0-p2.3 into a
;**************************************************
rdpins:	mov a,p2
		ret
;**************************************************
;looks up active high seven segment number values
;**************************************************
lookup:	inc a
		movc a,@a+pc
		ret
svnseg:	db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,4fh,77h,7bh,39h,5eh,79h,71h
end