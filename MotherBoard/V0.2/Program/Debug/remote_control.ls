   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  17                     	bsct
  18  0000               _TIM2_Cap_End_Val:
  19  0000 0000          	dc.w	0
  20  0002               _TIM2_Cap_Flag:
  21  0002 00            	dc.b	0
  22  0003               _Signal_Cap_Start_Flag:
  23  0003 00            	dc.b	0
  24  0004               _Signal_Cap_Counter:
  25  0004 00            	dc.b	0
  69                     ; 7 void Remote_Control_Init(void)
  69                     ; 8 {
  71                     .text:	section	.text,new
  72  0000               _Remote_Control_Init:
  74  0000 88            	push	a
  75       00000001      OFST:	set	1
  78                     ; 10 	for(i = 0; i < 22; i++)
  80  0001 0f01          	clr	(OFST+0,sp)
  81  0003               L72:
  82                     ; 12 		Signal_Tem_Buffer[i] = 0x00;
  84  0003 7b01          	ld	a,(OFST+0,sp)
  85  0005 5f            	clrw	x
  86  0006 97            	ld	xl,a
  87  0007 6f0b          	clr	(_Signal_Tem_Buffer,x)
  88                     ; 10 	for(i = 0; i < 22; i++)
  90  0009 0c01          	inc	(OFST+0,sp)
  93  000b 7b01          	ld	a,(OFST+0,sp)
  94  000d a116          	cp	a,#22
  95  000f 25f2          	jrult	L72
  96                     ; 14 	for(i = 0; i < 11; i++)
  98  0011 0f01          	clr	(OFST+0,sp)
  99  0013               L53:
 100                     ; 16 		Remote_Pack[i] = 0x00;
 102  0013 7b01          	ld	a,(OFST+0,sp)
 103  0015 5f            	clrw	x
 104  0016 97            	ld	xl,a
 105  0017 6f00          	clr	(_Remote_Pack,x)
 106                     ; 14 	for(i = 0; i < 11; i++)
 108  0019 0c01          	inc	(OFST+0,sp)
 111  001b 7b01          	ld	a,(OFST+0,sp)
 112  001d a10b          	cp	a,#11
 113  001f 25f2          	jrult	L53
 114                     ; 18 	TIM2_Capture_Init();
 116  0021 cd0000        	call	_TIM2_Capture_Init
 118                     ; 19 }
 121  0024 84            	pop	a
 122  0025 81            	ret
 178                     ; 21 void Remote_Control_Cmd(FunctionalState Status)
 178                     ; 22 {
 179                     .text:	section	.text,new
 180  0000               _Remote_Control_Cmd:
 182  0000 88            	push	a
 183       00000000      OFST:	set	0
 186                     ; 23 	if(Status == ENABLE)
 188  0001 a101          	cp	a,#1
 189  0003 2607          	jrne	L17
 190                     ; 24 		TIM2_Cmd(ENABLE);
 192  0005 a601          	ld	a,#1
 193  0007 cd0000        	call	_TIM2_Cmd
 196  000a 2008          	jra	L37
 197  000c               L17:
 198                     ; 25 	else if(Status == DISABLE)
 200  000c 0d01          	tnz	(OFST+1,sp)
 201  000e 2604          	jrne	L37
 202                     ; 26 		TIM2_Cmd(DISABLE);
 204  0010 4f            	clr	a
 205  0011 cd0000        	call	_TIM2_Cmd
 207  0014               L37:
 208                     ; 27 }
 211  0014 84            	pop	a
 212  0015 81            	ret
 240                     ; 29 void TIM2_Capture_Init(void)
 240                     ; 30 {
 241                     .text:	section	.text,new
 242  0000               _TIM2_Capture_Init:
 246                     ; 31 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);
 248  0000 ae0001        	ldw	x,#1
 249  0003 a605          	ld	a,#5
 250  0005 95            	ld	xh,a
 251  0006 cd0000        	call	_CLK_PeripheralClockConfig
 253                     ; 32 	TIM2_TimeBaseInit(TIM2_PRESCALER_32, 0xffff);
 255  0009 aeffff        	ldw	x,#65535
 256  000c 89            	pushw	x
 257  000d a605          	ld	a,#5
 258  000f cd0000        	call	_TIM2_TimeBaseInit
 260  0012 85            	popw	x
 261                     ; 33 	TIM2_ARRPreloadConfig(DISABLE);
 263  0013 4f            	clr	a
 264  0014 cd0000        	call	_TIM2_ARRPreloadConfig
 266                     ; 34 	TIM2_ICInit(TIM2_CHANNEL_3,
 266                     ; 35 							TIM2_ICPOLARITY_FALLING,	
 266                     ; 36 							TIM2_ICSELECTION_DIRECTTI, 
 266                     ; 37 							TIM2_ICPSC_DIV1,
 266                     ; 38 							5);
 268  0017 4b05          	push	#5
 269  0019 4b00          	push	#0
 270  001b 4b01          	push	#1
 271  001d ae0044        	ldw	x,#68
 272  0020 a602          	ld	a,#2
 273  0022 95            	ld	xh,a
 274  0023 cd0000        	call	_TIM2_ICInit
 276  0026 5b03          	addw	sp,#3
 277                     ; 40 	TIM2_ITConfig(TIM2_IT_CC3, ENABLE);
 279  0028 ae0001        	ldw	x,#1
 280  002b a608          	ld	a,#8
 281  002d 95            	ld	xh,a
 282  002e cd0000        	call	_TIM2_ITConfig
 284                     ; 41 }
 287  0031 81            	ret
 361                     ; 43 Remote_Command_Typedf Remote_Control_Get_Command(void)
 361                     ; 44 {
 362                     .text:	section	.text,new
 363  0000               _Remote_Control_Get_Command:
 365  0000 89            	pushw	x
 366       00000002      OFST:	set	2
 369                     ; 48 	if(Signal_Cap_Counter > 22)
 371  0001 b604          	ld	a,_Signal_Cap_Counter
 372  0003 a117          	cp	a,#23
 373  0005 2403          	jruge	L02
 374  0007 cc008c        	jp	L151
 375  000a               L02:
 376                     ; 50 		for(i = 0; i < 11; i ++)
 378  000a 0f02          	clr	(OFST+0,sp)
 379  000c               L351:
 380                     ; 52 			switch(Signal_Tem_Buffer[i * 2] + Signal_Tem_Buffer[(i * 2) + 1])
 382  000c 7b02          	ld	a,(OFST+0,sp)
 383  000e 5f            	clrw	x
 384  000f 97            	ld	xl,a
 385  0010 58            	sllw	x
 386  0011 e60b          	ld	a,(_Signal_Tem_Buffer,x)
 387  0013 6b01          	ld	(OFST-1,sp),a
 388  0015 7b02          	ld	a,(OFST+0,sp)
 389  0017 5f            	clrw	x
 390  0018 97            	ld	xl,a
 391  0019 58            	sllw	x
 392  001a e60c          	ld	a,(_Signal_Tem_Buffer+1,x)
 393  001c 5f            	clrw	x
 394  001d 1b01          	add	a,(OFST-1,sp)
 395  001f 2401          	jrnc	L41
 396  0021 5c            	incw	x
 397  0022               L41:
 398  0022 02            	rlwa	x,a
 400                     ; 63 				default: 
 400                     ; 64 				break;
 401  0023 1d0002        	subw	x,#2
 402  0026 2708          	jreq	L701
 403  0028 5a            	decw	x
 404  0029 270d          	jreq	L111
 405  002b 5a            	decw	x
 406  002c 2714          	jreq	L311
 407  002e 201a          	jra	L361
 408  0030               L701:
 409                     ; 54 				case 2:
 409                     ; 55 					Remote_Pack[i] = 0;
 411  0030 7b02          	ld	a,(OFST+0,sp)
 412  0032 5f            	clrw	x
 413  0033 97            	ld	xl,a
 414  0034 6f00          	clr	(_Remote_Pack,x)
 415                     ; 56 					break;
 417  0036 2012          	jra	L361
 418  0038               L111:
 419                     ; 57 				case 3:
 419                     ; 58 					Remote_Pack[i] = 2;
 421  0038 7b02          	ld	a,(OFST+0,sp)
 422  003a 5f            	clrw	x
 423  003b 97            	ld	xl,a
 424  003c a602          	ld	a,#2
 425  003e e700          	ld	(_Remote_Pack,x),a
 426                     ; 59 					break;
 428  0040 2008          	jra	L361
 429  0042               L311:
 430                     ; 60 				case 4:
 430                     ; 61 					Remote_Pack[i] = 1;
 432  0042 7b02          	ld	a,(OFST+0,sp)
 433  0044 5f            	clrw	x
 434  0045 97            	ld	xl,a
 435  0046 a601          	ld	a,#1
 436  0048 e700          	ld	(_Remote_Pack,x),a
 437                     ; 62 					break;
 439  004a               L511:
 440                     ; 63 				default: 
 440                     ; 64 				break;
 442  004a               L361:
 443                     ; 50 		for(i = 0; i < 11; i ++)
 445  004a 0c02          	inc	(OFST+0,sp)
 448  004c 7b02          	ld	a,(OFST+0,sp)
 449  004e a10b          	cp	a,#11
 450  0050 25ba          	jrult	L351
 451                     ; 68 		Signal_Cap_Counter = 0;
 453  0052 3f04          	clr	_Signal_Cap_Counter
 454                     ; 69 		TIM2_Cmd(ENABLE);
 456  0054 a601          	ld	a,#1
 457  0056 cd0000        	call	_TIM2_Cmd
 459                     ; 72 		for(i = 0; i < 8; i++)
 461  0059 0f02          	clr	(OFST+0,sp)
 462  005b               L561:
 463                     ; 74 			if(Remote_Pack[i] != 0x00)
 465  005b 7b02          	ld	a,(OFST+0,sp)
 466  005d 5f            	clrw	x
 467  005e 97            	ld	xl,a
 468  005f 6d00          	tnz	(_Remote_Pack,x)
 469  0061 2703          	jreq	L371
 470                     ; 75 				return NO_REMOTE_COMMAND;
 472  0063 4f            	clr	a
 474  0064 2010          	jra	L61
 475  0066               L371:
 476                     ; 72 		for(i = 0; i < 8; i++)
 478  0066 0c02          	inc	(OFST+0,sp)
 481  0068 7b02          	ld	a,(OFST+0,sp)
 482  006a a108          	cp	a,#8
 483  006c 25ed          	jrult	L561
 484                     ; 78 		if(Remote_Pack[10] == 1)
 486  006e b60a          	ld	a,_Remote_Pack+10
 487  0070 a101          	cp	a,#1
 488  0072 2604          	jrne	L571
 489                     ; 79 			return START_FIRE;
 491  0074 a601          	ld	a,#1
 493  0076               L61:
 495  0076 85            	popw	x
 496  0077 81            	ret
 497  0078               L571:
 498                     ; 80 		else if(Remote_Pack[9] == 1)
 500  0078 b609          	ld	a,_Remote_Pack+9
 501  007a a101          	cp	a,#1
 502  007c 2604          	jrne	L102
 503                     ; 81 			return STOP_FIRE;
 505  007e a602          	ld	a,#2
 507  0080 20f4          	jra	L61
 508  0082               L102:
 509                     ; 82 		else if(Remote_Pack[8] == 1)
 511  0082 b608          	ld	a,_Remote_Pack+8
 512  0084 a101          	cp	a,#1
 513  0086 2607          	jrne	L702
 514                     ; 83 			return PUMP_ALCOHOL;
 516  0088 a603          	ld	a,#3
 518  008a 20ea          	jra	L61
 519  008c               L151:
 520                     ; 86 		return NO_REMOTE_COMMAND;
 522  008c 4f            	clr	a
 524  008d 20e7          	jra	L61
 525  008f               L702:
 526                     ; 87 }
 528  008f 20e5          	jra	L61
 561                     ; 89 @far @interrupt void TIM2_Cap_IRQHanndler(void)
 561                     ; 90 { 
 563                     .text:	section	.text,new
 564  0000               f_TIM2_Cap_IRQHanndler:
 566  0000 3b0002        	push	c_x+2
 567  0003 be00          	ldw	x,c_x
 568  0005 89            	pushw	x
 569  0006 3b0002        	push	c_y+2
 570  0009 be00          	ldw	x,c_y
 571  000b 89            	pushw	x
 574                     ; 91 	if(TIM2_GetITStatus(TIM2_IT_CC3) == SET)
 576  000c a608          	ld	a,#8
 577  000e cd0000        	call	_TIM2_GetITStatus
 579  0011 a101          	cp	a,#1
 580  0013 2623          	jrne	L122
 581                     ; 93 		if(!TIM2_Cap_Flag)
 583  0015 3d02          	tnz	_TIM2_Cap_Flag
 584  0017 260e          	jrne	L322
 585                     ; 95 			TIM2_Cap_Flag = 1;
 587  0019 35010002      	mov	_TIM2_Cap_Flag,#1
 588                     ; 96 			TIM2_SetCounter(0);
 590  001d 5f            	clrw	x
 591  001e cd0000        	call	_TIM2_SetCounter
 593                     ; 98 			TIM2->CCER2 &= ~0x02;
 595  0021 72135309      	bres	21257,#1
 597  0025 2011          	jra	L122
 598  0027               L322:
 599                     ; 101 		else if(TIM2_Cap_Flag == 1)
 601  0027 b602          	ld	a,_TIM2_Cap_Flag
 602  0029 a101          	cp	a,#1
 603  002b 260b          	jrne	L122
 604                     ; 103 			TIM2_Cap_Flag = 0;
 606  002d 3f02          	clr	_TIM2_Cap_Flag
 607                     ; 104 			TIM2_Cap_End_Val = TIM2_GetCapture3();
 609  002f cd0000        	call	_TIM2_GetCapture3
 611  0032 bf00          	ldw	_TIM2_Cap_End_Val,x
 612                     ; 106 			TIM2->CCER2 |= 0x02;
 614  0034 72125309      	bset	21257,#1
 615  0038               L122:
 616                     ; 109 	if(Signal_Cap_Counter == 0 && TIM2_Cap_Flag != 1)
 618  0038 3d04          	tnz	_Signal_Cap_Counter
 619  003a 261a          	jrne	L132
 621  003c b602          	ld	a,_TIM2_Cap_Flag
 622  003e a101          	cp	a,#1
 623  0040 2714          	jreq	L132
 624                     ; 111 		if(TIM2_Cap_End_Val <= 3800 && TIM2_Cap_End_Val >= 3100)
 626  0042 be00          	ldw	x,_TIM2_Cap_End_Val
 627  0044 a30ed9        	cpw	x,#3801
 628  0047 2461          	jruge	L532
 630  0049 be00          	ldw	x,_TIM2_Cap_End_Val
 631  004b a30c1c        	cpw	x,#3100
 632  004e 255a          	jrult	L532
 633                     ; 113 			Signal_Cap_Counter = 1;
 635  0050 35010004      	mov	_Signal_Cap_Counter,#1
 636  0054 2054          	jra	L532
 637  0056               L132:
 638                     ; 116 	else if((Signal_Cap_Counter > 0) && (Signal_Cap_Counter < 23) && TIM2_Cap_Flag != 1)
 640  0056 3d04          	tnz	_Signal_Cap_Counter
 641  0058 2746          	jreq	L732
 643  005a b604          	ld	a,_Signal_Cap_Counter
 644  005c a117          	cp	a,#23
 645  005e 2440          	jruge	L732
 647  0060 b602          	ld	a,_TIM2_Cap_Flag
 648  0062 a101          	cp	a,#1
 649  0064 273a          	jreq	L732
 650                     ; 118 		if((TIM2_Cap_End_Val <= 500) && (TIM2_Cap_End_Val >= 250))
 652  0066 be00          	ldw	x,_TIM2_Cap_End_Val
 653  0068 a301f5        	cpw	x,#501
 654  006b 2414          	jruge	L142
 656  006d be00          	ldw	x,_TIM2_Cap_End_Val
 657  006f a300fa        	cpw	x,#250
 658  0072 250d          	jrult	L142
 659                     ; 120 			Signal_Tem_Buffer[Signal_Cap_Counter - 1] = 1;
 661  0074 b604          	ld	a,_Signal_Cap_Counter
 662  0076 5f            	clrw	x
 663  0077 97            	ld	xl,a
 664  0078 5a            	decw	x
 665  0079 a601          	ld	a,#1
 666  007b e70b          	ld	(_Signal_Tem_Buffer,x),a
 667                     ; 121 			Signal_Cap_Counter++;
 669  007d 3c04          	inc	_Signal_Cap_Counter
 671  007f 2029          	jra	L532
 672  0081               L142:
 673                     ; 123 		else if((TIM2_Cap_End_Val <= 200) && (TIM2_Cap_End_Val >= 50))
 675  0081 be00          	ldw	x,_TIM2_Cap_End_Val
 676  0083 a300c9        	cpw	x,#201
 677  0086 2414          	jruge	L542
 679  0088 be00          	ldw	x,_TIM2_Cap_End_Val
 680  008a a30032        	cpw	x,#50
 681  008d 250d          	jrult	L542
 682                     ; 125 			Signal_Tem_Buffer[Signal_Cap_Counter - 1] = 2;
 684  008f b604          	ld	a,_Signal_Cap_Counter
 685  0091 5f            	clrw	x
 686  0092 97            	ld	xl,a
 687  0093 5a            	decw	x
 688  0094 a602          	ld	a,#2
 689  0096 e70b          	ld	(_Signal_Tem_Buffer,x),a
 690                     ; 126 			Signal_Cap_Counter++;
 692  0098 3c04          	inc	_Signal_Cap_Counter
 694  009a 200e          	jra	L532
 695  009c               L542:
 696                     ; 129 			Signal_Cap_Counter = 0;
 698  009c 3f04          	clr	_Signal_Cap_Counter
 699  009e 200a          	jra	L532
 700  00a0               L732:
 701                     ; 131 	else if(Signal_Cap_Counter >= 23)
 703  00a0 b604          	ld	a,_Signal_Cap_Counter
 704  00a2 a117          	cp	a,#23
 705  00a4 2504          	jrult	L532
 706                     ; 132 		TIM2_Cmd(DISABLE);
 708  00a6 4f            	clr	a
 709  00a7 cd0000        	call	_TIM2_Cmd
 711  00aa               L532:
 712                     ; 134 	TIM2_ClearITPendingBit(TIM2_IT_CC3);
 714  00aa a608          	ld	a,#8
 715  00ac cd0000        	call	_TIM2_ClearITPendingBit
 717                     ; 135 }
 720  00af 85            	popw	x
 721  00b0 bf00          	ldw	c_y,x
 722  00b2 320002        	pop	c_y+2
 723  00b5 85            	popw	x
 724  00b6 bf00          	ldw	c_x,x
 725  00b8 320002        	pop	c_x+2
 726  00bb 80            	iret
 752                     ; 137 @far @interrupt void TIM2_Update_IRQHanndler(void)
 752                     ; 138 {
 753                     .text:	section	.text,new
 754  0000               f_TIM2_Update_IRQHanndler:
 756  0000 3b0002        	push	c_x+2
 757  0003 be00          	ldw	x,c_x
 758  0005 89            	pushw	x
 759  0006 3b0002        	push	c_y+2
 760  0009 be00          	ldw	x,c_y
 761  000b 89            	pushw	x
 764                     ; 139 	TIM2_Cap_Flag = 0;
 766  000c 3f02          	clr	_TIM2_Cap_Flag
 767                     ; 140 	Signal_Cap_Counter = 0;
 769  000e 3f04          	clr	_Signal_Cap_Counter
 770                     ; 141 	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
 772  0010 a601          	ld	a,#1
 773  0012 cd0000        	call	_TIM2_ClearITPendingBit
 775                     ; 142 }
 778  0015 85            	popw	x
 779  0016 bf00          	ldw	c_y,x
 780  0018 320002        	pop	c_y+2
 781  001b 85            	popw	x
 782  001c bf00          	ldw	c_x,x
 783  001e 320002        	pop	c_x+2
 784  0021 80            	iret
 855                     	xdef	f_TIM2_Update_IRQHanndler
 856                     	xdef	f_TIM2_Cap_IRQHanndler
 857                     	switch	.ubsct
 858  0000               _Remote_Pack:
 859  0000 000000000000  	ds.b	11
 860                     	xdef	_Remote_Pack
 861  000b               _Signal_Tem_Buffer:
 862  000b 000000000000  	ds.b	22
 863                     	xdef	_Signal_Tem_Buffer
 864                     	xdef	_Signal_Cap_Counter
 865                     	xdef	_Signal_Cap_Start_Flag
 866                     	xdef	_TIM2_Cap_Flag
 867                     	xdef	_TIM2_Cap_End_Val
 868                     	xdef	_Remote_Control_Cmd
 869                     	xdef	_Remote_Control_Init
 870                     	xdef	_Remote_Control_Get_Command
 871                     	xdef	_TIM2_Capture_Init
 872                     	xref	_TIM2_ClearITPendingBit
 873                     	xref	_TIM2_GetITStatus
 874                     	xref	_TIM2_GetCapture3
 875                     	xref	_TIM2_SetCounter
 876                     	xref	_TIM2_ARRPreloadConfig
 877                     	xref	_TIM2_ITConfig
 878                     	xref	_TIM2_Cmd
 879                     	xref	_TIM2_ICInit
 880                     	xref	_TIM2_TimeBaseInit
 881                     	xref	_CLK_PeripheralClockConfig
 882                     	xref.b	c_x
 883                     	xref.b	c_y
 903                     	end
