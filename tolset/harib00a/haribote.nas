; haribote-os
; TAB=4

		ORG		0xc200			; 这个程序读到哪里？
		MOV 	AL,0X13
		MOV		AH,0X00
		INT 	0X10

fin:

		HLT
		JMP		fin
