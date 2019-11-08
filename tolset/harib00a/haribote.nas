; haribote-os
; TAB=4

		ORG		0xc200			; 这个程序读到哪里？
fin:

		MOV		AL,[msg]
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		HLT
		JMP		fin

msg:
		DB  	"@"