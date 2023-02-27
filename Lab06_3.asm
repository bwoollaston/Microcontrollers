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
	
	