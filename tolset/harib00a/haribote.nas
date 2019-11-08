; haribote-os
; TAB=4

; 有关BOOT_INFO
CYLS	EQU		0x0ff0			;启动信息
LEDS	EQU		0x0ff1			;键盘状态
VMODE	EQU		0x0ff2			;颜色数目
SCRNX	EQU		0x0ff4			;分辨率x
SCRNY	EQU		0x0ff6			;分辨率y
VRAM	EQU		0x0ff8			;图像缓冲区的开始地址

		ORG		0xc200			; 这个程序读到哪里？
		MOV 	AL,0X13
		MOV		AH,0X00
		INT 	0X10
		MOV		BYTE [VMODE],8
		MOV		WORD [SCRNX],320
		MOV 	WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000
;0xa0000-0xafffff共64KB
;用bios获取键盘状态

		MOV		AH,0X02
		INT 	0X16
		MOV 	[LEDS],AL
		
fin:

		HLT
		JMP		fin
