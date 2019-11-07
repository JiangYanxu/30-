; hello-os
; TAB=4

		ORG		0x7c00			; 指明程序的装载地址
; 把机器语言装载到内存中的位置，同时改变了$符号的值：0x7c00

; 以下技术用于标准FAT12格式的软盘
	JMP entry
	DB	0x90			;短跳转指令，指向操作系统引导代码部分
	DB	"HELLOIPL"		;启动区名称
	DW	512				;每个扇区字节数
	DB	1				;每个簇扇区数
	DW	1				;Boot记录占+表
	DB	2
	DW	224				;根目录区文件最大数
	DW	2880			;扇区总数
	DB	0xf0			;介质描述符
	DW	9				;每个FAT表所占扇区数
	DW	18				;每个磁道扇区数
	DW	2				;磁头数
	DD	0				;隐藏扇区数
	DD	2880			;扇区总数
	DB	0,0,0x29		;INT 13H的驱动器号，保留未用，扩展引导标记
	DD	0xffffffff		;卷序列号
	DB	"HELLO - OS "	;卷标
	DB	"FAT12   "		;文件系统名称
	RESB	18			;空了18字节

; 程序核心

entry:
		MOV		AX,0			; 初始化寄存器
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		
;磁盘第二个扇区读到内存0x0820
		
		MOV		AX,0X0820
		MOV		ES,AX			;缓冲区地址段(加上AX)
		MOV 	CH,0			;柱面
		MOV		DH,0			;磁头
		MOV 	CL,2			;扇区
		
		MOV		SI,0			;失败计数
retry:	
		MOV		AH,0X02			;读磁盘
		MOV		AL,1			;1个扇区
		MOV		BX,0			;缓冲的偏移地址
		MOV		DL,0X00			;驱动器
		INT		0x13			;调用BIOS磁盘操作
		JNC		good				;BIOS返回值不为0跳转
		ADD		SI,1
		CMP		SI,5
		JAE		error
		MOV		AH,0x00
		MOV		DL,0x00
		INT 	0x13			;复位软盘状态
		JMP		retry
		


fin:	
		HLT
		JMP		fin

error:
		MOV 	SI,msg
		JMP		putloop
good:
		MOV		SI,msg1
putloop:
		MOV		AL,[SI]
		ADD		SI,1			; 给SI加1
		CMP		AL,0			; 结束条件
		JE		fin
		MOV		AH,0x0e			; 显示一个文字
		MOV		BX,15			; 指定字符颜色
		INT		0x10			; 调用显卡BIOS
		JMP		putloop
msg:
		DB		0x0a, 0x0a		; 换行2次
		DB		"load error"
		DB		0x0a			; 换行
		DB		0
msg1:
		DB		0x0a, 0x0a		; 换行2次
		DB		"good"
		DB		0x0a			; 换行
		DB		0
		RESB	0x7dfe-$		; 填写0x00直到0x7dfe-0x7c00

		DB		0x55, 0xaa
