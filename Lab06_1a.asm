dl EQU -46 ;Correcting for 11.0597MHz clock
	
org 0
	
		clr p1.1
		mov tmod,#02h
		mov th0,#dl
		setb tr0
loop:	jnb tf0,loop
		clr tf0
		cpl p1.1
		sjmp loop
	
sjmp $
	
end