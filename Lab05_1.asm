

org 0
	setb P2.0
	setb P2.1
	loop:acall ANDP
	sjmp loop
	
ANDP:	push psw
		mov c,P2.0
		anl c,P2.1
		cpl c
		mov p0.0,c
		pop psw
		ret