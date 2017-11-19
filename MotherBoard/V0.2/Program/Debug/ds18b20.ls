   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  75                     ; 3 void Delay_10us(uint8_t t)
  75                     ; 4 {
  77                     .text:	section	.text,new
  78  0000               _Delay_10us:
  80  0000 88            	push	a
  81  0001 89            	pushw	x
  82       00000002      OFST:	set	2
  85                     ; 6 	for(i = 0; i < t; i++)
  87  0002 0f01          	clr	(OFST-1,sp)
  89  0004 200d          	jra	L34
  90  0006               L73:
  91                     ; 8 		for(j = 0; j < 16; j++)
  93  0006 0f02          	clr	(OFST+0,sp)
  94  0008               L74:
  95                     ; 9 			NOP();                //Nothing to do for waitting
  98  0008 9d            nop
 100                     ; 8 		for(j = 0; j < 16; j++)
 102  0009 0c02          	inc	(OFST+0,sp)
 105  000b 7b02          	ld	a,(OFST+0,sp)
 106  000d a110          	cp	a,#16
 107  000f 25f7          	jrult	L74
 108                     ; 6 	for(i = 0; i < t; i++)
 111  0011 0c01          	inc	(OFST-1,sp)
 112  0013               L34:
 115  0013 7b01          	ld	a,(OFST-1,sp)
 116  0015 1103          	cp	a,(OFST+1,sp)
 117  0017 25ed          	jrult	L73
 118                     ; 11 }
 121  0019 5b03          	addw	sp,#3
 122  001b 81            	ret
 160                     ; 13 uint8_t DS18B20_Reset(void)
 160                     ; 14 {
 161                     .text:	section	.text,new
 162  0000               _DS18B20_Reset:
 164  0000 89            	pushw	x
 165       00000002      OFST:	set	2
 168                     ; 16 	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_SLOW);
 170  0001 4bd0          	push	#208
 171  0003 4b20          	push	#32
 172  0005 ae5000        	ldw	x,#20480
 173  0008 cd0000        	call	_GPIO_Init
 175  000b 85            	popw	x
 176                     ; 17 	GPIO_WriteLow(GPIOA, GPIO_PIN_5);
 178  000c 4b20          	push	#32
 179  000e ae5000        	ldw	x,#20480
 180  0011 cd0000        	call	_GPIO_WriteLow
 182  0014 84            	pop	a
 183                     ; 18 	Delay_10us(70);
 185  0015 a646          	ld	a,#70
 186  0017 cd0000        	call	_Delay_10us
 188                     ; 19 	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
 190  001a 4b40          	push	#64
 191  001c 4b20          	push	#32
 192  001e ae5000        	ldw	x,#20480
 193  0021 cd0000        	call	_GPIO_Init
 195  0024 85            	popw	x
 196                     ; 20 	j = 0;
 198  0025 5f            	clrw	x
 199  0026 1f01          	ldw	(OFST-1,sp),x
 201  0028 2005          	jra	L77
 202  002a               L37:
 203                     ; 22 		Delay_10us(1);
 205  002a a601          	ld	a,#1
 206  002c cd0000        	call	_Delay_10us
 208  002f               L77:
 209                     ; 21 	while(GPIO_ReadInputPin(GPIOA, GPIO_PIN_5) && ((j++) < 100))
 211  002f 4b20          	push	#32
 212  0031 ae5000        	ldw	x,#20480
 213  0034 cd0000        	call	_GPIO_ReadInputPin
 215  0037 5b01          	addw	sp,#1
 216  0039 4d            	tnz	a
 217  003a 270f          	jreq	L301
 219  003c 1e01          	ldw	x,(OFST-1,sp)
 220  003e 1c0001        	addw	x,#1
 221  0041 1f01          	ldw	(OFST-1,sp),x
 222  0043 1d0001        	subw	x,#1
 223  0046 a30064        	cpw	x,#100
 224  0049 25df          	jrult	L37
 225  004b               L301:
 226                     ; 23 	if(j >= 10000)
 228  004b 1e01          	ldw	x,(OFST-1,sp)
 229  004d a32710        	cpw	x,#10000
 230  0050 2504          	jrult	L501
 231                     ; 24 		return DS18B20_RESET_FAILED;
 233  0052 a601          	ld	a,#1
 235  0054 202f          	jra	L01
 236  0056               L501:
 237                     ; 25 	j = 0;
 239  0056 5f            	clrw	x
 240  0057 1f01          	ldw	(OFST-1,sp),x
 242  0059 2005          	jra	L311
 243  005b               L701:
 244                     ; 27 		Delay_10us(1);
 246  005b a601          	ld	a,#1
 247  005d cd0000        	call	_Delay_10us
 249  0060               L311:
 250                     ; 26 	while(!GPIO_ReadInputPin(GPIOA, GPIO_PIN_5) && ((j++) < 5000))
 252  0060 4b20          	push	#32
 253  0062 ae5000        	ldw	x,#20480
 254  0065 cd0000        	call	_GPIO_ReadInputPin
 256  0068 5b01          	addw	sp,#1
 257  006a 4d            	tnz	a
 258  006b 260f          	jrne	L711
 260  006d 1e01          	ldw	x,(OFST-1,sp)
 261  006f 1c0001        	addw	x,#1
 262  0072 1f01          	ldw	(OFST-1,sp),x
 263  0074 1d0001        	subw	x,#1
 264  0077 a31388        	cpw	x,#5000
 265  007a 25df          	jrult	L701
 266  007c               L711:
 267                     ; 28 	if(j >= 5000)
 269  007c 1e01          	ldw	x,(OFST-1,sp)
 270  007e a31388        	cpw	x,#5000
 271  0081 2504          	jrult	L121
 272                     ; 29 		return DS18B20_RESET_FAILED;
 274  0083 a601          	ld	a,#1
 276  0085               L01:
 278  0085 85            	popw	x
 279  0086 81            	ret
 280  0087               L121:
 281                     ; 30 	Delay_10us(50);
 283  0087 a632          	ld	a,#50
 284  0089 cd0000        	call	_Delay_10us
 286                     ; 31 	return NULL;
 288  008c 4f            	clr	a
 290  008d 20f6          	jra	L01
 336                     ; 34 uint8_t DS18B20_Read_Byte(void)
 336                     ; 35 {
 337                     .text:	section	.text,new
 338  0000               _DS18B20_Read_Byte:
 340  0000 89            	pushw	x
 341       00000002      OFST:	set	2
 344                     ; 36 	uint8_t i, Byte = 0x00;
 346  0001 0f02          	clr	(OFST+0,sp)
 347                     ; 37 	for(i = 0; i < 8; i++)
 349  0003 0f01          	clr	(OFST-1,sp)
 350  0005               L541:
 351                     ; 39 		Byte >>= 1;
 353  0005 0402          	srl	(OFST+0,sp)
 354                     ; 40 		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_SLOW);
 356  0007 4bc0          	push	#192
 357  0009 4b20          	push	#32
 358  000b ae5000        	ldw	x,#20480
 359  000e cd0000        	call	_GPIO_Init
 361  0011 85            	popw	x
 362                     ; 41 		Delay_10us(1);
 364  0012 a601          	ld	a,#1
 365  0014 cd0000        	call	_Delay_10us
 367                     ; 42 		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
 369  0017 4b40          	push	#64
 370  0019 4b20          	push	#32
 371  001b ae5000        	ldw	x,#20480
 372  001e cd0000        	call	_GPIO_Init
 374  0021 85            	popw	x
 375                     ; 43 		if(GPIO_ReadInputPin(GPIOA, GPIO_PIN_5))
 377  0022 4b20          	push	#32
 378  0024 ae5000        	ldw	x,#20480
 379  0027 cd0000        	call	_GPIO_ReadInputPin
 381  002a 5b01          	addw	sp,#1
 382  002c 4d            	tnz	a
 383  002d 2706          	jreq	L351
 384                     ; 44 			Byte |= 0x80;
 386  002f 7b02          	ld	a,(OFST+0,sp)
 387  0031 aa80          	or	a,#128
 388  0033 6b02          	ld	(OFST+0,sp),a
 389  0035               L351:
 390                     ; 45 		Delay_10us(5);
 392  0035 a605          	ld	a,#5
 393  0037 cd0000        	call	_Delay_10us
 395                     ; 37 	for(i = 0; i < 8; i++)
 397  003a 0c01          	inc	(OFST-1,sp)
 400  003c 7b01          	ld	a,(OFST-1,sp)
 401  003e a108          	cp	a,#8
 402  0040 25c3          	jrult	L541
 403                     ; 47 	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
 405  0042 4b40          	push	#64
 406  0044 4b20          	push	#32
 407  0046 ae5000        	ldw	x,#20480
 408  0049 cd0000        	call	_GPIO_Init
 410  004c 85            	popw	x
 411                     ; 48 	return Byte;
 413  004d 7b02          	ld	a,(OFST+0,sp)
 416  004f 85            	popw	x
 417  0050 81            	ret
 464                     ; 51 void DS18B20_Write_Byte(uint8_t Byte)
 464                     ; 52 {
 465                     .text:	section	.text,new
 466  0000               _DS18B20_Write_Byte:
 468  0000 88            	push	a
 469  0001 88            	push	a
 470       00000001      OFST:	set	1
 473                     ; 54 	for(i = 0; i < 8; i++)
 475  0002 0f01          	clr	(OFST+0,sp)
 476  0004               L771:
 477                     ; 56 		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_SLOW);
 479  0004 4bc0          	push	#192
 480  0006 4b20          	push	#32
 481  0008 ae5000        	ldw	x,#20480
 482  000b cd0000        	call	_GPIO_Init
 484  000e 85            	popw	x
 485                     ; 57 		Delay_10us(1);
 487  000f a601          	ld	a,#1
 488  0011 cd0000        	call	_Delay_10us
 490                     ; 58 		if(Byte & 0x01)
 492  0014 7b02          	ld	a,(OFST+1,sp)
 493  0016 a501          	bcp	a,#1
 494  0018 270b          	jreq	L502
 495                     ; 59 			GPIO_WriteHigh(GPIOA, GPIO_PIN_5);
 497  001a 4b20          	push	#32
 498  001c ae5000        	ldw	x,#20480
 499  001f cd0000        	call	_GPIO_WriteHigh
 501  0022 84            	pop	a
 503  0023 2009          	jra	L702
 504  0025               L502:
 505                     ; 61 			GPIO_WriteLow(GPIOA, GPIO_PIN_5);
 507  0025 4b20          	push	#32
 508  0027 ae5000        	ldw	x,#20480
 509  002a cd0000        	call	_GPIO_WriteLow
 511  002d 84            	pop	a
 512  002e               L702:
 513                     ; 62 		Delay_10us(3);
 515  002e a603          	ld	a,#3
 516  0030 cd0000        	call	_Delay_10us
 518                     ; 63 		Byte >>= 1;
 520  0033 0402          	srl	(OFST+1,sp)
 521                     ; 64 		GPIO_WriteHigh(GPIOA, GPIO_PIN_5);
 523  0035 4b20          	push	#32
 524  0037 ae5000        	ldw	x,#20480
 525  003a cd0000        	call	_GPIO_WriteHigh
 527  003d 84            	pop	a
 528                     ; 54 	for(i = 0; i < 8; i++)
 530  003e 0c01          	inc	(OFST+0,sp)
 533  0040 7b01          	ld	a,(OFST+0,sp)
 534  0042 a108          	cp	a,#8
 535  0044 25be          	jrult	L771
 536                     ; 66 	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
 538  0046 4b40          	push	#64
 539  0048 4b20          	push	#32
 540  004a ae5000        	ldw	x,#20480
 541  004d cd0000        	call	_GPIO_Init
 543  0050 85            	popw	x
 544                     ; 67 }
 547  0051 85            	popw	x
 548  0052 81            	ret
 601                     .const:	section	.text
 602  0000               L02:
 603  0000 000f4240      	dc.l	1000000
 604  0004               L22:
 605  0004 000186a0      	dc.l	100000
 606  0008               L42:
 607  0008 00002710      	dc.l	10000
 608  000c               L62:
 609  000c 000003e8      	dc.l	1000
 610                     ; 69 uint16_t DS18B20_Math_Temperture(uint16_t Original_Value)
 610                     ; 70 {
 611                     .text:	section	.text,new
 612  0000               _DS18B20_Math_Temperture:
 614  0000 520a          	subw	sp,#10
 615       0000000a      OFST:	set	10
 618                     ; 73 	Temperture = (long int)Original_Value * 625;
 620  0002 90ae0271      	ldw	y,#625
 621  0006 cd0000        	call	c_umul
 623  0009 96            	ldw	x,sp
 624  000a 1c0007        	addw	x,#OFST-3
 625  000d cd0000        	call	c_rtol
 627                     ; 74 	Real_Value = (uint16_t)(( Temperture % 1000000 / 100000) * 100) + (uint16_t)((Temperture % 100000 / 10000) * 10) + (uint16_t)((Temperture % 10000 / 1000));
 629  0010 96            	ldw	x,sp
 630  0011 1c0007        	addw	x,#OFST-3
 631  0014 cd0000        	call	c_ltor
 633  0017 ae0008        	ldw	x,#L42
 634  001a cd0000        	call	c_lmod
 636  001d ae000c        	ldw	x,#L62
 637  0020 cd0000        	call	c_ldiv
 639  0023 be02          	ldw	x,c_lreg+2
 640  0025 1f03          	ldw	(OFST-7,sp),x
 641  0027 96            	ldw	x,sp
 642  0028 1c0007        	addw	x,#OFST-3
 643  002b cd0000        	call	c_ltor
 645  002e ae0004        	ldw	x,#L22
 646  0031 cd0000        	call	c_lmod
 648  0034 ae0008        	ldw	x,#L42
 649  0037 cd0000        	call	c_ldiv
 651  003a a60a          	ld	a,#10
 652  003c cd0000        	call	c_smul
 654  003f be02          	ldw	x,c_lreg+2
 655  0041 1f01          	ldw	(OFST-9,sp),x
 656  0043 96            	ldw	x,sp
 657  0044 1c0007        	addw	x,#OFST-3
 658  0047 cd0000        	call	c_ltor
 660  004a ae0000        	ldw	x,#L02
 661  004d cd0000        	call	c_lmod
 663  0050 ae0004        	ldw	x,#L22
 664  0053 cd0000        	call	c_ldiv
 666  0056 a664          	ld	a,#100
 667  0058 cd0000        	call	c_smul
 669  005b be02          	ldw	x,c_lreg+2
 670  005d 72fb01        	addw	x,(OFST-9,sp)
 671  0060 72fb03        	addw	x,(OFST-7,sp)
 672  0063 1f05          	ldw	(OFST-5,sp),x
 673                     ; 75 	return Real_Value;
 675  0065 1e05          	ldw	x,(OFST-5,sp)
 678  0067 5b0a          	addw	sp,#10
 679  0069 81            	ret
 746                     ; 78 uint16_t DS18B20_Get_Temperture(void)
 746                     ; 79 {
 747                     .text:	section	.text,new
 748  0000               _DS18B20_Get_Temperture:
 750  0000 5204          	subw	sp,#4
 751       00000004      OFST:	set	4
 754                     ; 82 	DS18B20_Reset();
 756  0002 cd0000        	call	_DS18B20_Reset
 758                     ; 83 	DS18B20_Write_Byte(0xcc);
 760  0005 a6cc          	ld	a,#204
 761  0007 cd0000        	call	_DS18B20_Write_Byte
 763                     ; 84 	DS18B20_Write_Byte(0x44);
 765  000a a644          	ld	a,#68
 766  000c cd0000        	call	_DS18B20_Write_Byte
 768                     ; 85 	Delay_10us(100);
 770  000f a664          	ld	a,#100
 771  0011 cd0000        	call	_Delay_10us
 773                     ; 86 	DS18B20_Reset();
 775  0014 cd0000        	call	_DS18B20_Reset
 777                     ; 87 	DS18B20_Write_Byte(0xcc);
 779  0017 a6cc          	ld	a,#204
 780  0019 cd0000        	call	_DS18B20_Write_Byte
 782                     ; 88 	DS18B20_Write_Byte(0xbe);
 784  001c a6be          	ld	a,#190
 785  001e cd0000        	call	_DS18B20_Write_Byte
 787                     ; 89 	Bytel = DS18B20_Read_Byte();
 789  0021 cd0000        	call	_DS18B20_Read_Byte
 791  0024 6b01          	ld	(OFST-3,sp),a
 792                     ; 90 	Byteh = DS18B20_Read_Byte();
 794  0026 cd0000        	call	_DS18B20_Read_Byte
 796  0029 6b02          	ld	(OFST-2,sp),a
 797                     ; 91 	Int = Byteh;
 799  002b 7b02          	ld	a,(OFST-2,sp)
 800  002d 5f            	clrw	x
 801  002e 97            	ld	xl,a
 802  002f 1f03          	ldw	(OFST-1,sp),x
 803                     ; 92 	Int <<= 8;
 805  0031 7b04          	ld	a,(OFST+0,sp)
 806  0033 6b03          	ld	(OFST-1,sp),a
 807  0035 0f04          	clr	(OFST+0,sp)
 808                     ; 93 	Int = Int | Bytel;
 810  0037 7b01          	ld	a,(OFST-3,sp)
 811  0039 5f            	clrw	x
 812  003a 97            	ld	xl,a
 813  003b 01            	rrwa	x,a
 814  003c 1a04          	or	a,(OFST+0,sp)
 815  003e 01            	rrwa	x,a
 816  003f 1a03          	or	a,(OFST-1,sp)
 817  0041 01            	rrwa	x,a
 818  0042 1f03          	ldw	(OFST-1,sp),x
 819                     ; 94 	Temperture = DS18B20_Math_Temperture(Int);
 821  0044 1e03          	ldw	x,(OFST-1,sp)
 822  0046 cd0000        	call	_DS18B20_Math_Temperture
 824  0049 1f03          	ldw	(OFST-1,sp),x
 825                     ; 95 	return Temperture;
 827  004b 1e03          	ldw	x,(OFST-1,sp)
 830  004d 5b04          	addw	sp,#4
 831  004f 81            	ret
 844                     	xdef	_DS18B20_Math_Temperture
 845                     	xdef	_DS18B20_Write_Byte
 846                     	xdef	_DS18B20_Read_Byte
 847                     	xdef	_Delay_10us
 848                     	xdef	_DS18B20_Get_Temperture
 849                     	xdef	_DS18B20_Reset
 850                     	xref	_GPIO_ReadInputPin
 851                     	xref	_GPIO_WriteLow
 852                     	xref	_GPIO_WriteHigh
 853                     	xref	_GPIO_Init
 854                     	xref.b	c_lreg
 855                     	xref.b	c_x
 856                     	xref.b	c_y
 875                     	xref	c_smul
 876                     	xref	c_ldiv
 877                     	xref	c_lmod
 878                     	xref	c_ltor
 879                     	xref	c_rtol
 880                     	xref	c_umul
 881                     	end
