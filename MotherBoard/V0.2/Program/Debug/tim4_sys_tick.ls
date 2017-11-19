   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  17                     	bsct
  18  0000               _Tick_Counter:
  19  0000 0000          	dc.w	0
  20  0002               _WWDG_Counter:
  21  0002 00            	dc.b	0
  55                     ; 6 void TIM4_Tick_Init(void)
  55                     ; 7 {
  57                     .text:	section	.text,new
  58  0000               _TIM4_Tick_Init:
  62                     ; 8 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4 , ENABLE);
  64  0000 ae0001        	ldw	x,#1
  65  0003 a604          	ld	a,#4
  66  0005 95            	ld	xh,a
  67  0006 cd0000        	call	_CLK_PeripheralClockConfig
  69                     ; 10 	TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
  71  0009 ae007d        	ldw	x,#125
  72  000c a607          	ld	a,#7
  73  000e 95            	ld	xh,a
  74  000f cd0000        	call	_TIM4_TimeBaseInit
  76                     ; 11 	TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
  78  0012 ae0001        	ldw	x,#1
  79  0015 a601          	ld	a,#1
  80  0017 95            	ld	xh,a
  81  0018 cd0000        	call	_TIM4_ITConfig
  83                     ; 12 	TIM4_Cmd(ENABLE);
  85  001b a601          	ld	a,#1
  86  001d cd0000        	call	_TIM4_Cmd
  88                     ; 13 	rim();
  91  0020 9a            rim
  93                     ; 14 }
  97  0021 81            	ret
 132                     ; 16 void Delay_ms(uint16_t t)
 132                     ; 17 {
 133                     .text:	section	.text,new
 134  0000               _Delay_ms:
 136  0000 89            	pushw	x
 137       00000000      OFST:	set	0
 140                     ; 18 	Tick_Counter = 0;
 142  0001 5f            	clrw	x
 143  0002 bf00          	ldw	_Tick_Counter,x
 145  0004               L34:
 146                     ; 19 	while(t > Tick_Counter);
 148  0004 1e01          	ldw	x,(OFST+1,sp)
 149  0006 b300          	cpw	x,_Tick_Counter
 150  0008 22fa          	jrugt	L34
 151                     ; 20 }
 154  000a 85            	popw	x
 155  000b 81            	ret
 183                     ; 22 @far @interrupt void TIM4_Tick_IRQHandler(void)
 183                     ; 23 {
 185                     .text:	section	.text,new
 186  0000               f_TIM4_Tick_IRQHandler:
 188  0000 3b0002        	push	c_x+2
 189  0003 be00          	ldw	x,c_x
 190  0005 89            	pushw	x
 191  0006 3b0002        	push	c_y+2
 192  0009 be00          	ldw	x,c_y
 193  000b 89            	pushw	x
 196                     ; 24 	Tick_Counter++;
 198  000c be00          	ldw	x,_Tick_Counter
 199  000e 1c0001        	addw	x,#1
 200  0011 bf00          	ldw	_Tick_Counter,x
 201                     ; 25 	WWDG_Counter++;
 203  0013 3c02          	inc	_WWDG_Counter
 204                     ; 26 	if(WWDG_Counter == 35 )
 206  0015 b602          	ld	a,_WWDG_Counter
 207  0017 a123          	cp	a,#35
 208  0019 2607          	jrne	L75
 209                     ; 28 		WWDG_SetCounter(0x7F);
 211  001b a67f          	ld	a,#127
 212  001d cd0000        	call	_WWDG_SetCounter
 214                     ; 29 		WWDG_Counter = 0;
 216  0020 3f02          	clr	_WWDG_Counter
 217  0022               L75:
 218                     ; 31 	TIM4_ClearITPendingBit(TIM4_IT_UPDATE);
 220  0022 a601          	ld	a,#1
 221  0024 cd0000        	call	_TIM4_ClearITPendingBit
 223                     ; 32 }
 226  0027 85            	popw	x
 227  0028 bf00          	ldw	c_y,x
 228  002a 320002        	pop	c_y+2
 229  002d 85            	popw	x
 230  002e bf00          	ldw	c_x,x
 231  0030 320002        	pop	c_x+2
 232  0033 80            	iret
 264                     	xdef	f_TIM4_Tick_IRQHandler
 265                     	xdef	_WWDG_Counter
 266                     	xdef	_Tick_Counter
 267                     	xdef	_Delay_ms
 268                     	xdef	_TIM4_Tick_Init
 269                     	xref	_WWDG_SetCounter
 270                     	xref	_TIM4_ClearITPendingBit
 271                     	xref	_TIM4_ITConfig
 272                     	xref	_TIM4_Cmd
 273                     	xref	_TIM4_TimeBaseInit
 274                     	xref	_CLK_PeripheralClockConfig
 275                     	xref.b	c_x
 276                     	xref.b	c_y
 295                     	end
