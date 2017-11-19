   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  17                     	bsct
  18  0000               _High_Alcohol_Concentration_Ctr:
  19  0000 00            	dc.b	0
  20  0001               _Get_Alcohol_Concentration_Failed:
  21  0001 00            	dc.b	0
  22  0002               _High_Temperture_Ctr:
  23  0002 00            	dc.b	0
  24  0003               _Get_Temperture_Failed_Ctr:
  25  0003 00            	dc.b	0
  26  0004               _ALDHL_Detect_Ctr:
  27  0004 00            	dc.b	0
  28  0005               _FireH_Detect_Ctr:
  29  0005 00            	dc.b	0
  30  0006               _ALD_Detetc_Ctr:
  31  0006 00            	dc.b	0
  67                     ; 14 uint8_t Safe_Check_Init(void)
  67                     ; 15 {
  69                     .text:	section	.text,new
  70  0000               _Safe_Check_Init:
  74                     ; 17 	GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
  76  0000 4b40          	push	#64
  77  0002 4b08          	push	#8
  78  0004 ae5005        	ldw	x,#20485
  79  0007 cd0000        	call	_GPIO_Init
  81  000a 85            	popw	x
  82                     ; 18 	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
  84  000b 4b00          	push	#0
  85  000d 4b10          	push	#16
  86  000f ae5005        	ldw	x,#20485
  87  0012 cd0000        	call	_GPIO_Init
  89  0015 85            	popw	x
  90                     ; 20 	Alcohol_ADC_Init();
  92  0016 cd0000        	call	_Alcohol_ADC_Init
  94                     ; 22 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER3 , ENABLE);
  96  0019 ae0001        	ldw	x,#1
  97  001c a606          	ld	a,#6
  98  001e 95            	ld	xh,a
  99  001f cd0000        	call	_CLK_PeripheralClockConfig
 101                     ; 23 	TIM3_TimeBaseInit(TIM3_PRESCALER_128, 12500);
 103  0022 ae30d4        	ldw	x,#12500
 104  0025 89            	pushw	x
 105  0026 a607          	ld	a,#7
 106  0028 cd0000        	call	_TIM3_TimeBaseInit
 108  002b 85            	popw	x
 109                     ; 24 	TIM3_ITConfig(TIM3_IT_UPDATE, ENABLE);
 111  002c ae0001        	ldw	x,#1
 112  002f a601          	ld	a,#1
 113  0031 95            	ld	xh,a
 114  0032 cd0000        	call	_TIM3_ITConfig
 116                     ; 25 	TIM3_Cmd(ENABLE);
 118  0035 a601          	ld	a,#1
 119  0037 cd0000        	call	_TIM3_Cmd
 121                     ; 26 	rim();
 124  003a 9a            rim
 126                     ; 27 	return NULL;
 129  003b 4f            	clr	a
 132  003c 81            	ret
 159                     ; 30 void Alcohol_ADC_Init(void)
 159                     ; 31 {
 160                     .text:	section	.text,new
 161  0000               _Alcohol_ADC_Init:
 165                     ; 32 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
 167  0000 ae0001        	ldw	x,#1
 168  0003 a613          	ld	a,#19
 169  0005 95            	ld	xh,a
 170  0006 cd0000        	call	_CLK_PeripheralClockConfig
 172                     ; 33 	ADC1_Init(ADC1_CONVERSIONMODE_SINGLE, 
 172                     ; 34 						ADC1_CHANNEL_9,
 172                     ; 35 						ADC1_PRESSEL_FCPU_D18, 
 172                     ; 36 						ADC1_EXTTRIG_TIM, 
 172                     ; 37 						DISABLE, 
 172                     ; 38 						ADC1_ALIGN_RIGHT, 
 172                     ; 39 						ADC1_SCHMITTTRIG_CHANNEL9, 
 172                     ; 40 						DISABLE
 172                     ; 41 						);
 174  0009 4b00          	push	#0
 175  000b 4b09          	push	#9
 176  000d 4b08          	push	#8
 177  000f 4b00          	push	#0
 178  0011 4b00          	push	#0
 179  0013 4b70          	push	#112
 180  0015 ae0009        	ldw	x,#9
 181  0018 4f            	clr	a
 182  0019 95            	ld	xh,a
 183  001a cd0000        	call	_ADC1_Init
 185  001d 5b06          	addw	sp,#6
 186                     ; 42 	ADC1_AWDChannelConfig(ADC1_CHANNEL_9, ENABLE);
 188  001f ae0001        	ldw	x,#1
 189  0022 a609          	ld	a,#9
 190  0024 95            	ld	xh,a
 191  0025 cd0000        	call	_ADC1_AWDChannelConfig
 193                     ; 49 	ADC1_Cmd(ENABLE);
 195  0028 a601          	ld	a,#1
 196  002a cd0000        	call	_ADC1_Cmd
 198                     ; 50 }
 201  002d 81            	ret
 249                     .const:	section	.text
 250  0000               L41:
 251  0000 0000c350      	dc.l	50000
 252                     ; 52 uint8_t Alcohol_Concentration_Check(void)
 252                     ; 53 {
 253                     .text:	section	.text,new
 254  0000               _Alcohol_Concentration_Check:
 256  0000 5204          	subw	sp,#4
 257       00000004      OFST:	set	4
 260  0002               L55:
 261                     ; 56 	while((! ADC1_GetFlagStatus(ADC1_FLAG_EOC)) && (Ctr++) < 50000);
 263  0002 a680          	ld	a,#128
 264  0004 cd0000        	call	_ADC1_GetFlagStatus
 266  0007 4d            	tnz	a
 267  0008 2614          	jrne	L16
 269  000a 9c            	rvf
 270  000b 1603          	ldw	y,(OFST-1,sp)
 271  000d 0c04          	inc	(OFST+0,sp)
 272  000f 2602          	jrne	L21
 273  0011 0c03          	inc	(OFST-1,sp)
 274  0013               L21:
 275  0013 cd0000        	call	c_uitoly
 277  0016 ae0000        	ldw	x,#L41
 278  0019 cd0000        	call	c_lcmp
 280  001c 2fe4          	jrslt	L55
 281  001e               L16:
 282                     ; 57 	ADC1_ClearFlag(ADC1_FLAG_EOC);
 284  001e a680          	ld	a,#128
 285  0020 cd0000        	call	_ADC1_ClearFlag
 287                     ; 58 	ADC_Val = ADC1_GetConversionValue();
 289  0023 cd0000        	call	_ADC1_GetConversionValue
 291  0026 1f01          	ldw	(OFST-3,sp),x
 292                     ; 60 	ADC1_StartConversion();
 294  0028 cd0000        	call	_ADC1_StartConversion
 296                     ; 61 	if(Ctr >= 50000)
 298  002b 9c            	rvf
 299  002c 1e03          	ldw	x,(OFST-1,sp)
 300  002e cd0000        	call	c_uitolx
 302  0031 ae0000        	ldw	x,#L41
 303  0034 cd0000        	call	c_lcmp
 305  0037 2f04          	jrslt	L36
 306                     ; 62 		return GET_CONCENTRATION_FAILED;
 308  0039 a602          	ld	a,#2
 310  003b 2009          	jra	L61
 311  003d               L36:
 312                     ; 63 	if(ADC_Val >= 0x0300)
 314  003d 1e01          	ldw	x,(OFST-3,sp)
 315  003f a30300        	cpw	x,#768
 316  0042 2505          	jrult	L56
 317                     ; 64 		return HIGH_CONCENTRATION;
 319  0044 a601          	ld	a,#1
 321  0046               L61:
 323  0046 5b04          	addw	sp,#4
 324  0048 81            	ret
 325  0049               L56:
 326                     ; 70 	return NULL;
 328  0049 4f            	clr	a
 330  004a 20fa          	jra	L61
 365                     ; 73 uint8_t Temperture_Check(void)
 365                     ; 74 {
 366                     .text:	section	.text,new
 367  0000               _Temperture_Check:
 369  0000 89            	pushw	x
 370       00000002      OFST:	set	2
 373                     ; 76 	Temperture = DS18B20_Get_Temperture();
 375  0001 cd0000        	call	_DS18B20_Get_Temperture
 377  0004 1f01          	ldw	(OFST-1,sp),x
 378                     ; 78 	if((Temperture > 1200) || (Temperture <= 0))         //if the temperture lower than 0'C, system will sound a warning
 380  0006 1e01          	ldw	x,(OFST-1,sp)
 381  0008 a304b1        	cpw	x,#1201
 382  000b 2404          	jruge	L701
 384  000d 1e01          	ldw	x,(OFST-1,sp)
 385  000f 2604          	jrne	L501
 386  0011               L701:
 387                     ; 80 		return GET_TEMPERTURE_FAILED;
 389  0011 a602          	ld	a,#2
 391  0013 200a          	jra	L22
 392  0015               L501:
 393                     ; 82 	if(DS18B20_Get_Temperture() > 800)
 395  0015 cd0000        	call	_DS18B20_Get_Temperture
 397  0018 a30321        	cpw	x,#801
 398  001b 2504          	jrult	L111
 399                     ; 84 		return HIGH_TEMPERTURE;
 401  001d a601          	ld	a,#1
 403  001f               L22:
 405  001f 85            	popw	x
 406  0020 81            	ret
 407  0021               L111:
 408                     ; 86 	return NULL;
 410  0021 4f            	clr	a
 412  0022 20fb          	jra	L22
 568                     ; 89 Safe_Check_Typedef Safe_Check(void)
 568                     ; 90 {
 569                     .text:	section	.text,new
 570  0000               _Safe_Check:
 572  0000 89            	pushw	x
 573       00000002      OFST:	set	2
 576                     ; 92 	sim();
 579  0001 9b            sim
 581                     ; 93 	TIM3_Cmd(DISABLE);
 584  0002 4f            	clr	a
 585  0003 cd0000        	call	_TIM3_Cmd
 587                     ; 95 	switch(Alcohol_Concentration_Check())
 589  0006 cd0000        	call	_Alcohol_Concentration_Check
 592                     ; 120 		break;
 593  0009 4d            	tnz	a
 594  000a 2730          	jreq	L711
 595  000c a004          	sub	a,#4
 596  000e 2717          	jreq	L511
 597  0010 4a            	dec	a
 598  0011 262d          	jrne	L112
 599                     ; 97 		case GET_ALCOHOL_CONCENTRATION_FAILED:
 599                     ; 98 			Get_Alcohol_Concentration_Failed++;
 601  0013 3c01          	inc	_Get_Alcohol_Concentration_Failed
 602                     ; 99 			if(Get_Alcohol_Concentration_Failed >= 20)
 604  0015 b601          	ld	a,_Get_Alcohol_Concentration_Failed
 605  0017 a114          	cp	a,#20
 606  0019 2525          	jrult	L112
 607                     ; 101 				Safe_Check_Result.Unsafe_Type = GET_ALCOHOL_CONCENTRATION_FAILED;
 609  001b a605          	ld	a,#5
 610  001d 6b02          	ld	(OFST+0,sp),a
 611                     ; 102 				Safe_Check_Result.Safe_Flag = UNSAFE;
 613  001f a601          	ld	a,#1
 614  0021 6b01          	ld	(OFST-1,sp),a
 615                     ; 104 				return Safe_Check_Result;
 617  0023 1e01          	ldw	x,(OFST-1,sp)
 619  0025 2012          	jra	L62
 620  0027               L511:
 621                     ; 107 		case HIGH_ALCOHOL_CONCENTRATION:
 621                     ; 108 			High_Alcohol_Concentration_Ctr++;
 623  0027 3c00          	inc	_High_Alcohol_Concentration_Ctr
 624                     ; 109 			if(High_Alcohol_Concentration_Ctr >= 20)
 626  0029 b600          	ld	a,_High_Alcohol_Concentration_Ctr
 627  002b a114          	cp	a,#20
 628  002d 2511          	jrult	L112
 629                     ; 111 				Safe_Check_Result.Unsafe_Type = HIGH_ALCOHOL_CONCENTRATION;
 631  002f a604          	ld	a,#4
 632  0031 6b02          	ld	(OFST+0,sp),a
 633                     ; 112 				Safe_Check_Result.Safe_Flag = UNSAFE;
 635  0033 a601          	ld	a,#1
 636  0035 6b01          	ld	(OFST-1,sp),a
 637                     ; 114 				return Safe_Check_Result;
 639  0037 1e01          	ldw	x,(OFST-1,sp)
 641  0039               L62:
 643  0039 5b02          	addw	sp,#2
 644  003b 81            	ret
 645  003c               L711:
 646                     ; 117 		case NULL:
 646                     ; 118 			Get_Alcohol_Concentration_Failed = 0;
 648  003c 3f01          	clr	_Get_Alcohol_Concentration_Failed
 649                     ; 119 			High_Alcohol_Concentration_Ctr = 0;
 651  003e 3f00          	clr	_High_Alcohol_Concentration_Ctr
 652                     ; 120 		break;
 654  0040               L112:
 655                     ; 123 	switch(Temperture_Check())
 657  0040 cd0000        	call	_Temperture_Check
 660                     ; 148 		break;
 661  0043 4d            	tnz	a
 662  0044 2730          	jreq	L521
 663  0046 4a            	dec	a
 664  0047 2705          	jreq	L121
 665  0049 4a            	dec	a
 666  004a 2716          	jreq	L321
 667  004c 202c          	jra	L122
 668  004e               L121:
 669                     ; 125 		case HIGH_TEMPERTURE:
 669                     ; 126 			High_Temperture_Ctr++;
 671  004e 3c02          	inc	_High_Temperture_Ctr
 672                     ; 127 			if(High_Temperture_Ctr >= 20)
 674  0050 b602          	ld	a,_High_Temperture_Ctr
 675  0052 a114          	cp	a,#20
 676  0054 2524          	jrult	L122
 677                     ; 129 				Safe_Check_Result.Unsafe_Type = HIGH_TEMPERTURE;
 679  0056 a601          	ld	a,#1
 680  0058 6b02          	ld	(OFST+0,sp),a
 681                     ; 130 				Safe_Check_Result.Safe_Flag = UNSAFE;
 683  005a a601          	ld	a,#1
 684  005c 6b01          	ld	(OFST-1,sp),a
 685                     ; 132 				return Safe_Check_Result;
 687  005e 1e01          	ldw	x,(OFST-1,sp)
 689  0060 20d7          	jra	L62
 690  0062               L321:
 691                     ; 135 		case GET_TEMPERTURE_FAILED:
 691                     ; 136 			Get_Temperture_Failed_Ctr++;
 693  0062 3c03          	inc	_Get_Temperture_Failed_Ctr
 694                     ; 137 			if(Get_Temperture_Failed_Ctr >= 20)
 696  0064 b603          	ld	a,_Get_Temperture_Failed_Ctr
 697  0066 a114          	cp	a,#20
 698  0068 2510          	jrult	L122
 699                     ; 139 				Safe_Check_Result.Unsafe_Type = GET_TEMPERTURE_FAILED;
 701  006a a602          	ld	a,#2
 702  006c 6b02          	ld	(OFST+0,sp),a
 703                     ; 140 				Safe_Check_Result.Safe_Flag = UNSAFE;
 705  006e a601          	ld	a,#1
 706  0070 6b01          	ld	(OFST-1,sp),a
 707                     ; 142 				return Safe_Check_Result;
 709  0072 1e01          	ldw	x,(OFST-1,sp)
 711  0074 20c3          	jra	L62
 712  0076               L521:
 713                     ; 145 		case NULL:
 713                     ; 146 			High_Temperture_Ctr = 0;
 715  0076 3f02          	clr	_High_Temperture_Ctr
 716                     ; 147 			Get_Temperture_Failed_Ctr = 0;
 718  0078 3f03          	clr	_Get_Temperture_Failed_Ctr
 719                     ; 148 		break;
 721  007a               L122:
 722                     ; 151 	if(!ALDHL)
 724  007a 4b01          	push	#1
 725  007c ae5005        	ldw	x,#20485
 726  007f cd0000        	call	_GPIO_ReadInputPin
 728  0082 5b01          	addw	sp,#1
 729  0084 4d            	tnz	a
 730  0085 2614          	jrne	L722
 731                     ; 153 		ALDHL_Detect_Ctr++;
 733  0087 3c04          	inc	_ALDHL_Detect_Ctr
 734                     ; 154 		if(ALDHL_Detect_Ctr >= 10)
 736  0089 b604          	ld	a,_ALDHL_Detect_Ctr
 737  008b a10a          	cp	a,#10
 738  008d 250e          	jrult	L332
 739                     ; 156 			Safe_Check_Result.Unsafe_Type = STORE_ALCOHOL_LEVE_LOW;
 741  008f a606          	ld	a,#6
 742  0091 6b02          	ld	(OFST+0,sp),a
 743                     ; 157 			Safe_Check_Result.Safe_Flag = UNSAFE;
 745  0093 a601          	ld	a,#1
 746  0095 6b01          	ld	(OFST-1,sp),a
 747                     ; 158 			return Safe_Check_Result;
 749  0097 1e01          	ldw	x,(OFST-1,sp)
 751  0099 209e          	jra	L62
 752  009b               L722:
 753                     ; 162 		ALDHL_Detect_Ctr = 0;
 755  009b 3f04          	clr	_ALDHL_Detect_Ctr
 756  009d               L332:
 757                     ; 164 	if(!FireDH)
 759  009d 4b08          	push	#8
 760  009f ae5005        	ldw	x,#20485
 761  00a2 cd0000        	call	_GPIO_ReadInputPin
 763  00a5 5b01          	addw	sp,#1
 764  00a7 4d            	tnz	a
 765  00a8 2614          	jrne	L532
 766                     ; 166 		FireH_Detect_Ctr++;
 768  00aa 3c05          	inc	_FireH_Detect_Ctr
 769                     ; 167 		if(FireH_Detect_Ctr >= 10)
 771  00ac b605          	ld	a,_FireH_Detect_Ctr
 772  00ae a10a          	cp	a,#10
 773  00b0 250c          	jrult	L532
 774                     ; 169 			Safe_Check_Result.Unsafe_Type = ALCOHOL_REACH_2nd_LEVEL;
 776  00b2 a603          	ld	a,#3
 777  00b4 6b02          	ld	(OFST+0,sp),a
 778                     ; 170 			Safe_Check_Result.Safe_Flag = UNSAFE;
 780  00b6 a601          	ld	a,#1
 781  00b8 6b01          	ld	(OFST-1,sp),a
 782                     ; 171 			return Safe_Check_Result;
 784  00ba 1e01          	ldw	x,(OFST-1,sp)
 786  00bc 201f          	jra	L03
 787  00be               L532:
 788                     ; 175 	if(!ALD)
 790  00be 4b20          	push	#32
 791  00c0 ae5005        	ldw	x,#20485
 792  00c3 cd0000        	call	_GPIO_ReadInputPin
 794  00c6 5b01          	addw	sp,#1
 795  00c8 4d            	tnz	a
 796  00c9 2615          	jrne	L142
 797                     ; 177 		ALD_Detetc_Ctr++;
 799  00cb 3c06          	inc	_ALD_Detetc_Ctr
 800                     ; 178 		if(ALD_Detetc_Ctr >= 10)
 802  00cd b606          	ld	a,_ALD_Detetc_Ctr
 803  00cf a10a          	cp	a,#10
 804  00d1 250f          	jrult	L542
 805                     ; 180 			Safe_Check_Result.Unsafe_Type = ALCOHOL_LEAKAGE;
 807  00d3 a609          	ld	a,#9
 808  00d5 6b02          	ld	(OFST+0,sp),a
 809                     ; 181 			Safe_Check_Result.Safe_Flag = UNSAFE;
 811  00d7 a601          	ld	a,#1
 812  00d9 6b01          	ld	(OFST-1,sp),a
 813                     ; 182 			return Safe_Check_Result;
 815  00db 1e01          	ldw	x,(OFST-1,sp)
 817  00dd               L03:
 819  00dd 5b02          	addw	sp,#2
 820  00df 81            	ret
 821  00e0               L142:
 822                     ; 186 		ALD_Detetc_Ctr = 0;
 824  00e0 3f06          	clr	_ALD_Detetc_Ctr
 825  00e2               L542:
 826                     ; 188 	Safe_Check_Result.Unsafe_Type = SAFE;
 828  00e2 0f02          	clr	(OFST+0,sp)
 829                     ; 189 	Safe_Check_Result.Safe_Flag = SAFE;
 831  00e4 0f01          	clr	(OFST-1,sp)
 832                     ; 190 	rim();
 835  00e6 9a            rim
 837                     ; 191 	TIM3_Cmd(ENABLE);
 840  00e7 a601          	ld	a,#1
 841  00e9 cd0000        	call	_TIM3_Cmd
 843                     ; 192 	return Safe_Check_Result;
 845  00ec 1e01          	ldw	x,(OFST-1,sp)
 847  00ee 20ed          	jra	L03
 884                     ; 195 @far @interrupt void TIM3_Safe_Check_IRQHandler(void)
 884                     ; 196 {
 886                     .text:	section	.text,new
 887  0000               f_TIM3_Safe_Check_IRQHandler:
 889       00000002      OFST:	set	2
 890  0000 3b0002        	push	c_x+2
 891  0003 be00          	ldw	x,c_x
 892  0005 89            	pushw	x
 893  0006 3b0002        	push	c_y+2
 894  0009 be00          	ldw	x,c_y
 895  000b 89            	pushw	x
 896  000c 89            	pushw	x
 899                     ; 197 	TIM3_ClearITPendingBit(TIM3_IT_UPDATE);
 901  000d a601          	ld	a,#1
 902  000f cd0000        	call	_TIM3_ClearITPendingBit
 904                     ; 198 	Safe_Check_Result = Safe_Check();
 906  0012 cd0000        	call	_Safe_Check
 908  0015 bf00          	ldw	_Safe_Check_Result,x
 909                     ; 199 	if(Safe_Check_Result.Safe_Flag != SAFE)
 911  0017 3d00          	tnz	_Safe_Check_Result
 912  0019 2604          	jrne	L43
 913  001b acad00ad      	jpf	L752
 914  001f               L43:
 915                     ; 201 		if((Safe_Check_Result.Unsafe_Type == STORE_ALCOHOL_LEVE_LOW))
 917  001f b601          	ld	a,_Safe_Check_Result+1
 918  0021 a106          	cp	a,#6
 919  0023 262c          	jrne	L162
 920                     ; 203 			System_Status.System_Status = STATUS_UNSAFE;
 922  0025 35010000      	mov	_System_Status,#1
 923                     ; 204 			UART_Send_Char(Safe_Check_Result.Unsafe_Type);
 925  0029 b601          	ld	a,_Safe_Check_Result+1
 926  002b cd0000        	call	_UART_Send_Char
 928                     ; 205 			LOW_ALCOHOL();
 930  002e 4b40          	push	#64
 931  0030 ae5005        	ldw	x,#20485
 932  0033 cd0000        	call	_GPIO_WriteLow
 934  0036 84            	pop	a
 938  0037 4b80          	push	#128
 939  0039 ae5005        	ldw	x,#20485
 940  003c cd0000        	call	_GPIO_WriteHigh
 942  003f 84            	pop	a
 946  0040 4b40          	push	#64
 947  0042 ae5000        	ldw	x,#20480
 948  0045 cd0000        	call	_GPIO_WriteLow
 950  0048 84            	pop	a
 951                     ; 206 			rim();
 955  0049 9a            rim
 957                     ; 207 			TIM3_Cmd(ENABLE);
 960  004a a601          	ld	a,#1
 961  004c cd0000        	call	_TIM3_Cmd
 964  004f 205c          	jra	L752
 965  0051               L162:
 966                     ; 209 		else if((Safe_Check_Result.Unsafe_Type == ALCOHOL_REACH_2nd_LEVEL))
 968  0051 b601          	ld	a,_Safe_Check_Result+1
 969  0053 a103          	cp	a,#3
 970  0055 264f          	jrne	L562
 971                     ; 211 			System_Status.System_Status = STATUS_UNSAFE;
 973  0057 35010000      	mov	_System_Status,#1
 974                     ; 212 			FIRE_DETECT_2ndLevel_ERROR();
 976  005b 4b40          	push	#64
 977  005d ae5005        	ldw	x,#20485
 978  0060 cd0000        	call	_GPIO_WriteLow
 980  0063 84            	pop	a
 984  0064 4b80          	push	#128
 985  0066 ae5005        	ldw	x,#20485
 986  0069 cd0000        	call	_GPIO_WriteLow
 988  006c 84            	pop	a
 992  006d 4b40          	push	#64
 993  006f ae5000        	ldw	x,#20480
 994  0072 cd0000        	call	_GPIO_WriteHigh
 996  0075 84            	pop	a
 997                     ; 213 			STOP_WORKING();
1000  0076 4b02          	push	#2
1001  0078 ae500a        	ldw	x,#20490
1002  007b cd0000        	call	_GPIO_WriteHigh
1004  007e 84            	pop	a
1008  007f 4b04          	push	#4
1009  0081 ae500a        	ldw	x,#20490
1010  0084 cd0000        	call	_GPIO_WriteHigh
1012  0087 84            	pop	a
1016  0088 4b10          	push	#16
1017  008a ae5000        	ldw	x,#20480
1018  008d cd0000        	call	_GPIO_WriteHigh
1020  0090 84            	pop	a
1021                     ; 214 			UART_Send_Char(Safe_Check_Result.Unsafe_Type);
1024  0091 b601          	ld	a,_Safe_Check_Result+1
1025  0093 cd0000        	call	_UART_Send_Char
1027  0096               L762:
1028                     ; 217 				if((WWDG_GetCounter() & 0x7f) < 0x50)
1030  0096 cd0000        	call	_WWDG_GetCounter
1032  0099 a47f          	and	a,#127
1033  009b a150          	cp	a,#80
1034  009d 24f7          	jruge	L762
1035                     ; 219 					WWDG_SetCounter(0x7F);
1037  009f a67f          	ld	a,#127
1038  00a1 cd0000        	call	_WWDG_SetCounter
1040  00a4 20f0          	jra	L762
1041  00a6               L562:
1042                     ; 225 			System_Status.System_Status = STATUS_UNSAFE;
1044  00a6 35010000      	mov	_System_Status,#1
1045                     ; 226 			Serious_Problem_Handler();
1047  00aa cd0000        	call	_Serious_Problem_Handler
1049  00ad               L752:
1050                     ; 229 }
1053  00ad 5b02          	addw	sp,#2
1054  00af 85            	popw	x
1055  00b0 bf00          	ldw	c_y,x
1056  00b2 320002        	pop	c_y+2
1057  00b5 85            	popw	x
1058  00b6 bf00          	ldw	c_x,x
1059  00b8 320002        	pop	c_x+2
1060  00bb 80            	iret
1151                     	xdef	f_TIM3_Safe_Check_IRQHandler
1152                     	xdef	_ALD_Detetc_Ctr
1153                     	xdef	_FireH_Detect_Ctr
1154                     	xdef	_ALDHL_Detect_Ctr
1155                     	xdef	_Get_Temperture_Failed_Ctr
1156                     	xdef	_High_Temperture_Ctr
1157                     	xdef	_Get_Alcohol_Concentration_Failed
1158                     	xdef	_High_Alcohol_Concentration_Ctr
1159                     	xref.b	_System_Status
1160                     	switch	.ubsct
1161  0000               _Safe_Check_Result:
1162  0000 0000          	ds.b	2
1163                     	xdef	_Safe_Check_Result
1164                     	xdef	_Safe_Check
1165                     	xdef	_Safe_Check_Init
1166                     	xdef	_Temperture_Check
1167                     	xdef	_Alcohol_Concentration_Check
1168                     	xdef	_Alcohol_ADC_Init
1169                     	xref	_UART_Send_Char
1170                     	xref	_Serious_Problem_Handler
1171                     	xref	_DS18B20_Get_Temperture
1172                     	xref	_WWDG_GetCounter
1173                     	xref	_WWDG_SetCounter
1174                     	xref	_TIM3_ClearITPendingBit
1175                     	xref	_TIM3_ITConfig
1176                     	xref	_TIM3_Cmd
1177                     	xref	_TIM3_TimeBaseInit
1178                     	xref	_GPIO_ReadInputPin
1179                     	xref	_GPIO_WriteReverse
1180                     	xref	_GPIO_WriteLow
1181                     	xref	_GPIO_WriteHigh
1182                     	xref	_GPIO_Init
1183                     	xref	_CLK_PeripheralClockConfig
1184                     	xref	_ADC1_ClearFlag
1185                     	xref	_ADC1_GetFlagStatus
1186                     	xref	_ADC1_GetConversionValue
1187                     	xref	_ADC1_StartConversion
1188                     	xref	_ADC1_AWDChannelConfig
1189                     	xref	_ADC1_Cmd
1190                     	xref	_ADC1_Init
1191                     	xref.b	c_x
1192                     	xref.b	c_y
1212                     	xref	c_uitolx
1213                     	xref	c_lcmp
1214                     	xref	c_uitoly
1215                     	end
