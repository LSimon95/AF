   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  66                     ; 53 void WWDG_Init(uint8_t Counter, uint8_t WindowValue)
  66                     ; 54 {
  68                     .text:	section	.text,new
  69  0000               _WWDG_Init:
  71  0000 89            	pushw	x
  72       00000000      OFST:	set	0
  75                     ; 56   assert_param(IS_WWDG_WINDOWLIMITVALUE_OK(WindowValue));
  77  0001 9f            	ld	a,xl
  78  0002 a180          	cp	a,#128
  79  0004 2403          	jruge	L6
  80  0006 4f            	clr	a
  81  0007 2010          	jra	L01
  82  0009               L6:
  83  0009 ae0038        	ldw	x,#56
  84  000c 89            	pushw	x
  85  000d ae0000        	ldw	x,#0
  86  0010 89            	pushw	x
  87  0011 ae0000        	ldw	x,#L33
  88  0014 cd0000        	call	_assert_failed
  90  0017 5b04          	addw	sp,#4
  91  0019               L01:
  92                     ; 58   WWDG->WR = WWDG_WR_RESET_VALUE;
  94  0019 357f50d2      	mov	20690,#127
  95                     ; 59   WWDG->CR = (uint8_t)((uint8_t)(WWDG_CR_WDGA | WWDG_CR_T6) | (uint8_t)Counter);
  97  001d 7b01          	ld	a,(OFST+1,sp)
  98  001f aac0          	or	a,#192
  99  0021 c750d1        	ld	20689,a
 100                     ; 60   WWDG->WR = (uint8_t)((uint8_t)(~WWDG_CR_WDGA) & (uint8_t)(WWDG_CR_T6 | WindowValue));
 102  0024 7b02          	ld	a,(OFST+2,sp)
 103  0026 aa40          	or	a,#64
 104  0028 a47f          	and	a,#127
 105  002a c750d2        	ld	20690,a
 106                     ; 61 }
 109  002d 85            	popw	x
 110  002e 81            	ret
 145                     ; 69 void WWDG_SetCounter(uint8_t Counter)
 145                     ; 70 {
 146                     .text:	section	.text,new
 147  0000               _WWDG_SetCounter:
 149  0000 88            	push	a
 150       00000000      OFST:	set	0
 153                     ; 72   assert_param(IS_WWDG_COUNTERVALUE_OK(Counter));
 155  0001 a180          	cp	a,#128
 156  0003 2403          	jruge	L41
 157  0005 4f            	clr	a
 158  0006 2010          	jra	L61
 159  0008               L41:
 160  0008 ae0048        	ldw	x,#72
 161  000b 89            	pushw	x
 162  000c ae0000        	ldw	x,#0
 163  000f 89            	pushw	x
 164  0010 ae0000        	ldw	x,#L33
 165  0013 cd0000        	call	_assert_failed
 167  0016 5b04          	addw	sp,#4
 168  0018               L61:
 169                     ; 76   WWDG->CR = (uint8_t)(Counter & (uint8_t)BIT_MASK);
 171  0018 7b01          	ld	a,(OFST+1,sp)
 172  001a a47f          	and	a,#127
 173  001c c750d1        	ld	20689,a
 174                     ; 77 }
 177  001f 84            	pop	a
 178  0020 81            	ret
 201                     ; 86 uint8_t WWDG_GetCounter(void)
 201                     ; 87 {
 202                     .text:	section	.text,new
 203  0000               _WWDG_GetCounter:
 207                     ; 88   return(WWDG->CR);
 209  0000 c650d1        	ld	a,20689
 212  0003 81            	ret
 235                     ; 96 void WWDG_SWReset(void)
 235                     ; 97 {
 236                     .text:	section	.text,new
 237  0000               _WWDG_SWReset:
 241                     ; 98   WWDG->CR = WWDG_CR_WDGA; /* Activate WWDG, with clearing T6 */
 243  0000 358050d1      	mov	20689,#128
 244                     ; 99 }
 247  0004 81            	ret
 283                     ; 108 void WWDG_SetWindowValue(uint8_t WindowValue)
 283                     ; 109 {
 284                     .text:	section	.text,new
 285  0000               _WWDG_SetWindowValue:
 287  0000 88            	push	a
 288       00000000      OFST:	set	0
 291                     ; 111   assert_param(IS_WWDG_WINDOWLIMITVALUE_OK(WindowValue));
 293  0001 a180          	cp	a,#128
 294  0003 2403          	jruge	L62
 295  0005 4f            	clr	a
 296  0006 2010          	jra	L03
 297  0008               L62:
 298  0008 ae006f        	ldw	x,#111
 299  000b 89            	pushw	x
 300  000c ae0000        	ldw	x,#0
 301  000f 89            	pushw	x
 302  0010 ae0000        	ldw	x,#L33
 303  0013 cd0000        	call	_assert_failed
 305  0016 5b04          	addw	sp,#4
 306  0018               L03:
 307                     ; 113   WWDG->WR = (uint8_t)((uint8_t)(~WWDG_CR_WDGA) & (uint8_t)(WWDG_CR_T6 | WindowValue));
 309  0018 7b01          	ld	a,(OFST+1,sp)
 310  001a aa40          	or	a,#64
 311  001c a47f          	and	a,#127
 312  001e c750d2        	ld	20690,a
 313                     ; 114 }
 316  0021 84            	pop	a
 317  0022 81            	ret
 330                     	xdef	_WWDG_SetWindowValue
 331                     	xdef	_WWDG_SWReset
 332                     	xdef	_WWDG_GetCounter
 333                     	xdef	_WWDG_SetCounter
 334                     	xdef	_WWDG_Init
 335                     	xref	_assert_failed
 336                     .const:	section	.text
 337  0000               L33:
 338  0000 73746d38735f  	dc.b	"stm8s_stdperiph_li"
 339  0012 625c6c696272  	dc.b	"b\libraries\stm8s_"
 340  0024 737464706572  	dc.b	"stdperiph_driver\s"
 341  0036 72635c73746d  	dc.b	"rc\stm8s_wwdg.c",0
 361                     	end
