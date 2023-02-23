

org 0h
		clr p1.3
		clr p1.2
		clr p1.1
		setb p1.0
		orl p2,#01h
		mov a,#0
		
loop:	push acc
		acall lookup
		cpl a
		mov p0,a
		pop acc
		inc acc
		cjne a,#16,$+3
		jc wait1
		mov a,#00h
wait1:	jnb p2.0,wait1
wait2:	jb p2.0,wait2
		sjmp loop
		
sjmp $
;**************************************************
;looks up active high seven segment number values
;**************************************************
lookup:	inc a
		movc a,@a+pc
		ret
svnseg:	db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h
	
	
end