dl EQU -449 ;Correcting for 11.0597MHz clock and extra instructions between clock cycles


org 0
	
		clr p1.1
	
		mov tmod,#01h
loop:	mov th0,#HIGH dl
		mov tl0,#LOW dl
		setb tr0
		cpl p1.1
		jnb tf0,$
		clr tr0
		clr tf0
		sjmp loop
	
end