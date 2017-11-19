   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  17                     .const:	section	.text
  18  0000               _HSIDivFactor:
  19  0000 01            	dc.b	1
  20  0001 02            	dc.b	2
  21  0002 04            	dc.b	4
  22  0003 08            	dc.b	8
  23  0004               _CLKPrescTable:
  24  0004 01            	dc.b	1
  25  0005 02            	dc.b	2
  26  0006 04            	dc.b	4
  27  0007 08            	dc.b	8
  28  0008 0a            	dc.b	10
  29  0009 10            	dc.b	16
  30  000a 14            	dc.b	20
  31  000b 28            	dc.b	40
  60                     ; 72 void CLK_DeInit(void)
  60                     ; 73 {
  62                     .text:	section	.text,new
  63  0000               _CLK_DeInit:
  67                     ; 74   CLK->ICKR = CLK_ICKR_RESET_VALUE;
  69  0000 350150c0      	mov	20672,#1
  70                     ; 75   CLK->ECKR = CLK_ECKR_RESET_VALUE;
  72  0004 725f50c1      	clr	20673
  73                     ; 76   CLK->SWR  = CLK_SWR_RESET_VALUE;
  75  0008 35e150c4      	mov	20676,#225
  76                     ; 77   CLK->SWCR = CLK_SWCR_RESET_VALUE;
  78  000c 725f50c5      	clr	20677
  79                     ; 78   CLK->CKDIVR = CLK_CKDIVR_RESET_VALUE;
  81  0010 351850c6      	mov	20678,#24
  82                     ; 79   CLK->PCKENR1 = CLK_PCKENR1_RESET_VALUE;
  84  0014 35ff50c7      	mov	20679,#255
  85                     ; 80   CLK->PCKENR2 = CLK_PCKENR2_RESET_VALUE;
  87  0018 35ff50ca      	mov	20682,#255
  88                     ; 81   CLK->CSSR = CLK_CSSR_RESET_VALUE;
  90  001c 725f50c8      	clr	20680
  91                     ; 82   CLK->CCOR = CLK_CCOR_RESET_VALUE;
  93  0020 725f50c9      	clr	20681
  95  0024               L52:
  96                     ; 83   while ((CLK->CCOR & CLK_CCOR_CCOEN)!= 0)
  98  0024 c650c9        	ld	a,20681
  99  0027 a501          	bcp	a,#1
 100  0029 26f9          	jrne	L52
 101                     ; 85   CLK->CCOR = CLK_CCOR_RESET_VALUE;
 103  002b 725f50c9      	clr	20681
 104                     ; 86   CLK->HSITRIMR = CLK_HSITRIMR_RESET_VALUE;
 106  002f 725f50cc      	clr	20684
 107                     ; 87   CLK->SWIMCCR = CLK_SWIMCCR_RESET_VALUE;
 109  0033 725f50cd      	clr	20685
 110                     ; 88 }
 113  0037 81            	ret
 170                     ; 99 void CLK_FastHaltWakeUpCmd(FunctionalState NewState)
 170                     ; 100 {
 171                     .text:	section	.text,new
 172  0000               _CLK_FastHaltWakeUpCmd:
 174  0000 88            	push	a
 175       00000000      OFST:	set	0
 178                     ; 102   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 180  0001 4d            	tnz	a
 181  0002 2704          	jreq	L21
 182  0004 a101          	cp	a,#1
 183  0006 2603          	jrne	L01
 184  0008               L21:
 185  0008 4f            	clr	a
 186  0009 2010          	jra	L41
 187  000b               L01:
 188  000b ae0066        	ldw	x,#102
 189  000e 89            	pushw	x
 190  000f ae0000        	ldw	x,#0
 191  0012 89            	pushw	x
 192  0013 ae000c        	ldw	x,#L75
 193  0016 cd0000        	call	_assert_failed
 195  0019 5b04          	addw	sp,#4
 196  001b               L41:
 197                     ; 104   if (NewState != DISABLE)
 199  001b 0d01          	tnz	(OFST+1,sp)
 200  001d 2706          	jreq	L16
 201                     ; 107     CLK->ICKR |= CLK_ICKR_FHWU;
 203  001f 721450c0      	bset	20672,#2
 205  0023 2004          	jra	L36
 206  0025               L16:
 207                     ; 112     CLK->ICKR &= (uint8_t)(~CLK_ICKR_FHWU);
 209  0025 721550c0      	bres	20672,#2
 210  0029               L36:
 211                     ; 114 }
 214  0029 84            	pop	a
 215  002a 81            	ret
 251                     ; 121 void CLK_HSECmd(FunctionalState NewState)
 251                     ; 122 {
 252                     .text:	section	.text,new
 253  0000               _CLK_HSECmd:
 255  0000 88            	push	a
 256       00000000      OFST:	set	0
 259                     ; 124   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 261  0001 4d            	tnz	a
 262  0002 2704          	jreq	L22
 263  0004 a101          	cp	a,#1
 264  0006 2603          	jrne	L02
 265  0008               L22:
 266  0008 4f            	clr	a
 267  0009 2010          	jra	L42
 268  000b               L02:
 269  000b ae007c        	ldw	x,#124
 270  000e 89            	pushw	x
 271  000f ae0000        	ldw	x,#0
 272  0012 89            	pushw	x
 273  0013 ae000c        	ldw	x,#L75
 274  0016 cd0000        	call	_assert_failed
 276  0019 5b04          	addw	sp,#4
 277  001b               L42:
 278                     ; 126   if (NewState != DISABLE)
 280  001b 0d01          	tnz	(OFST+1,sp)
 281  001d 2706          	jreq	L301
 282                     ; 129     CLK->ECKR |= CLK_ECKR_HSEEN;
 284  001f 721050c1      	bset	20673,#0
 286  0023 2004          	jra	L501
 287  0025               L301:
 288                     ; 134     CLK->ECKR &= (uint8_t)(~CLK_ECKR_HSEEN);
 290  0025 721150c1      	bres	20673,#0
 291  0029               L501:
 292                     ; 136 }
 295  0029 84            	pop	a
 296  002a 81            	ret
 332                     ; 143 void CLK_HSICmd(FunctionalState NewState)
 332                     ; 144 {
 333                     .text:	section	.text,new
 334  0000               _CLK_HSICmd:
 336  0000 88            	push	a
 337       00000000      OFST:	set	0
 340                     ; 146   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 342  0001 4d            	tnz	a
 343  0002 2704          	jreq	L23
 344  0004 a101          	cp	a,#1
 345  0006 2603          	jrne	L03
 346  0008               L23:
 347  0008 4f            	clr	a
 348  0009 2010          	jra	L43
 349  000b               L03:
 350  000b ae0092        	ldw	x,#146
 351  000e 89            	pushw	x
 352  000f ae0000        	ldw	x,#0
 353  0012 89            	pushw	x
 354  0013 ae000c        	ldw	x,#L75
 355  0016 cd0000        	call	_assert_failed
 357  0019 5b04          	addw	sp,#4
 358  001b               L43:
 359                     ; 148   if (NewState != DISABLE)
 361  001b 0d01          	tnz	(OFST+1,sp)
 362  001d 2706          	jreq	L521
 363                     ; 151     CLK->ICKR |= CLK_ICKR_HSIEN;
 365  001f 721050c0      	bset	20672,#0
 367  0023 2004          	jra	L721
 368  0025               L521:
 369                     ; 156     CLK->ICKR &= (uint8_t)(~CLK_ICKR_HSIEN);
 371  0025 721150c0      	bres	20672,#0
 372  0029               L721:
 373                     ; 158 }
 376  0029 84            	pop	a
 377  002a 81            	ret
 413                     ; 166 void CLK_LSICmd(FunctionalState NewState)
 413                     ; 167 {
 414                     .text:	section	.text,new
 415  0000               _CLK_LSICmd:
 417  0000 88            	push	a
 418       00000000      OFST:	set	0
 421                     ; 169   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 423  0001 4d            	tnz	a
 424  0002 2704          	jreq	L24
 425  0004 a101          	cp	a,#1
 426  0006 2603          	jrne	L04
 427  0008               L24:
 428  0008 4f            	clr	a
 429  0009 2010          	jra	L44
 430  000b               L04:
 431  000b ae00a9        	ldw	x,#169
 432  000e 89            	pushw	x
 433  000f ae0000        	ldw	x,#0
 434  0012 89            	pushw	x
 435  0013 ae000c        	ldw	x,#L75
 436  0016 cd0000        	call	_assert_failed
 438  0019 5b04          	addw	sp,#4
 439  001b               L44:
 440                     ; 171   if (NewState != DISABLE)
 442  001b 0d01          	tnz	(OFST+1,sp)
 443  001d 2706          	jreq	L741
 444                     ; 174     CLK->ICKR |= CLK_ICKR_LSIEN;
 446  001f 721650c0      	bset	20672,#3
 448  0023 2004          	jra	L151
 449  0025               L741:
 450                     ; 179     CLK->ICKR &= (uint8_t)(~CLK_ICKR_LSIEN);
 452  0025 721750c0      	bres	20672,#3
 453  0029               L151:
 454                     ; 181 }
 457  0029 84            	pop	a
 458  002a 81            	ret
 494                     ; 189 void CLK_CCOCmd(FunctionalState NewState)
 494                     ; 190 {
 495                     .text:	section	.text,new
 496  0000               _CLK_CCOCmd:
 498  0000 88            	push	a
 499       00000000      OFST:	set	0
 502                     ; 192   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 504  0001 4d            	tnz	a
 505  0002 2704          	jreq	L25
 506  0004 a101          	cp	a,#1
 507  0006 2603          	jrne	L05
 508  0008               L25:
 509  0008 4f            	clr	a
 510  0009 2010          	jra	L45
 511  000b               L05:
 512  000b ae00c0        	ldw	x,#192
 513  000e 89            	pushw	x
 514  000f ae0000        	ldw	x,#0
 515  0012 89            	pushw	x
 516  0013 ae000c        	ldw	x,#L75
 517  0016 cd0000        	call	_assert_failed
 519  0019 5b04          	addw	sp,#4
 520  001b               L45:
 521                     ; 194   if (NewState != DISABLE)
 523  001b 0d01          	tnz	(OFST+1,sp)
 524  001d 2706          	jreq	L171
 525                     ; 197     CLK->CCOR |= CLK_CCOR_CCOEN;
 527  001f 721050c9      	bset	20681,#0
 529  0023 2004          	jra	L371
 530  0025               L171:
 531                     ; 202     CLK->CCOR &= (uint8_t)(~CLK_CCOR_CCOEN);
 533  0025 721150c9      	bres	20681,#0
 534  0029               L371:
 535                     ; 204 }
 538  0029 84            	pop	a
 539  002a 81            	ret
 575                     ; 213 void CLK_ClockSwitchCmd(FunctionalState NewState)
 575                     ; 214 {
 576                     .text:	section	.text,new
 577  0000               _CLK_ClockSwitchCmd:
 579  0000 88            	push	a
 580       00000000      OFST:	set	0
 583                     ; 216   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 585  0001 4d            	tnz	a
 586  0002 2704          	jreq	L26
 587  0004 a101          	cp	a,#1
 588  0006 2603          	jrne	L06
 589  0008               L26:
 590  0008 4f            	clr	a
 591  0009 2010          	jra	L46
 592  000b               L06:
 593  000b ae00d8        	ldw	x,#216
 594  000e 89            	pushw	x
 595  000f ae0000        	ldw	x,#0
 596  0012 89            	pushw	x
 597  0013 ae000c        	ldw	x,#L75
 598  0016 cd0000        	call	_assert_failed
 600  0019 5b04          	addw	sp,#4
 601  001b               L46:
 602                     ; 218   if (NewState != DISABLE )
 604  001b 0d01          	tnz	(OFST+1,sp)
 605  001d 2706          	jreq	L312
 606                     ; 221     CLK->SWCR |= CLK_SWCR_SWEN;
 608  001f 721250c5      	bset	20677,#1
 610  0023 2004          	jra	L512
 611  0025               L312:
 612                     ; 226     CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWEN);
 614  0025 721350c5      	bres	20677,#1
 615  0029               L512:
 616                     ; 228 }
 619  0029 84            	pop	a
 620  002a 81            	ret
 657                     ; 238 void CLK_SlowActiveHaltWakeUpCmd(FunctionalState NewState)
 657                     ; 239 {
 658                     .text:	section	.text,new
 659  0000               _CLK_SlowActiveHaltWakeUpCmd:
 661  0000 88            	push	a
 662       00000000      OFST:	set	0
 665                     ; 241   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 667  0001 4d            	tnz	a
 668  0002 2704          	jreq	L27
 669  0004 a101          	cp	a,#1
 670  0006 2603          	jrne	L07
 671  0008               L27:
 672  0008 4f            	clr	a
 673  0009 2010          	jra	L47
 674  000b               L07:
 675  000b ae00f1        	ldw	x,#241
 676  000e 89            	pushw	x
 677  000f ae0000        	ldw	x,#0
 678  0012 89            	pushw	x
 679  0013 ae000c        	ldw	x,#L75
 680  0016 cd0000        	call	_assert_failed
 682  0019 5b04          	addw	sp,#4
 683  001b               L47:
 684                     ; 243   if (NewState != DISABLE)
 686  001b 0d01          	tnz	(OFST+1,sp)
 687  001d 2706          	jreq	L532
 688                     ; 246     CLK->ICKR |= CLK_ICKR_SWUAH;
 690  001f 721a50c0      	bset	20672,#5
 692  0023 2004          	jra	L732
 693  0025               L532:
 694                     ; 251     CLK->ICKR &= (uint8_t)(~CLK_ICKR_SWUAH);
 696  0025 721b50c0      	bres	20672,#5
 697  0029               L732:
 698                     ; 253 }
 701  0029 84            	pop	a
 702  002a 81            	ret
 862                     ; 263 void CLK_PeripheralClockConfig(CLK_Peripheral_TypeDef CLK_Peripheral, FunctionalState NewState)
 862                     ; 264 {
 863                     .text:	section	.text,new
 864  0000               _CLK_PeripheralClockConfig:
 866  0000 89            	pushw	x
 867       00000000      OFST:	set	0
 870                     ; 266   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 872  0001 9f            	ld	a,xl
 873  0002 4d            	tnz	a
 874  0003 2705          	jreq	L201
 875  0005 9f            	ld	a,xl
 876  0006 a101          	cp	a,#1
 877  0008 2603          	jrne	L001
 878  000a               L201:
 879  000a 4f            	clr	a
 880  000b 2010          	jra	L401
 881  000d               L001:
 882  000d ae010a        	ldw	x,#266
 883  0010 89            	pushw	x
 884  0011 ae0000        	ldw	x,#0
 885  0014 89            	pushw	x
 886  0015 ae000c        	ldw	x,#L75
 887  0018 cd0000        	call	_assert_failed
 889  001b 5b04          	addw	sp,#4
 890  001d               L401:
 891                     ; 267   assert_param(IS_CLK_PERIPHERAL_OK(CLK_Peripheral));
 893  001d 0d01          	tnz	(OFST+1,sp)
 894  001f 274e          	jreq	L011
 895  0021 7b01          	ld	a,(OFST+1,sp)
 896  0023 a101          	cp	a,#1
 897  0025 2748          	jreq	L011
 898  0027 7b01          	ld	a,(OFST+1,sp)
 899  0029 a103          	cp	a,#3
 900  002b 2742          	jreq	L011
 901  002d 7b01          	ld	a,(OFST+1,sp)
 902  002f a103          	cp	a,#3
 903  0031 273c          	jreq	L011
 904  0033 7b01          	ld	a,(OFST+1,sp)
 905  0035 a103          	cp	a,#3
 906  0037 2736          	jreq	L011
 907  0039 7b01          	ld	a,(OFST+1,sp)
 908  003b a104          	cp	a,#4
 909  003d 2730          	jreq	L011
 910  003f 7b01          	ld	a,(OFST+1,sp)
 911  0041 a105          	cp	a,#5
 912  0043 272a          	jreq	L011
 913  0045 7b01          	ld	a,(OFST+1,sp)
 914  0047 a105          	cp	a,#5
 915  0049 2724          	jreq	L011
 916  004b 7b01          	ld	a,(OFST+1,sp)
 917  004d a104          	cp	a,#4
 918  004f 271e          	jreq	L011
 919  0051 7b01          	ld	a,(OFST+1,sp)
 920  0053 a106          	cp	a,#6
 921  0055 2718          	jreq	L011
 922  0057 7b01          	ld	a,(OFST+1,sp)
 923  0059 a107          	cp	a,#7
 924  005b 2712          	jreq	L011
 925  005d 7b01          	ld	a,(OFST+1,sp)
 926  005f a117          	cp	a,#23
 927  0061 270c          	jreq	L011
 928  0063 7b01          	ld	a,(OFST+1,sp)
 929  0065 a113          	cp	a,#19
 930  0067 2706          	jreq	L011
 931  0069 7b01          	ld	a,(OFST+1,sp)
 932  006b a112          	cp	a,#18
 933  006d 2603          	jrne	L601
 934  006f               L011:
 935  006f 4f            	clr	a
 936  0070 2010          	jra	L211
 937  0072               L601:
 938  0072 ae010b        	ldw	x,#267
 939  0075 89            	pushw	x
 940  0076 ae0000        	ldw	x,#0
 941  0079 89            	pushw	x
 942  007a ae000c        	ldw	x,#L75
 943  007d cd0000        	call	_assert_failed
 945  0080 5b04          	addw	sp,#4
 946  0082               L211:
 947                     ; 269   if (((uint8_t)CLK_Peripheral & (uint8_t)0x10) == 0x00)
 949  0082 7b01          	ld	a,(OFST+1,sp)
 950  0084 a510          	bcp	a,#16
 951  0086 2633          	jrne	L323
 952                     ; 271     if (NewState != DISABLE)
 954  0088 0d02          	tnz	(OFST+2,sp)
 955  008a 2717          	jreq	L523
 956                     ; 274       CLK->PCKENR1 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
 958  008c 7b01          	ld	a,(OFST+1,sp)
 959  008e a40f          	and	a,#15
 960  0090 5f            	clrw	x
 961  0091 97            	ld	xl,a
 962  0092 a601          	ld	a,#1
 963  0094 5d            	tnzw	x
 964  0095 2704          	jreq	L411
 965  0097               L611:
 966  0097 48            	sll	a
 967  0098 5a            	decw	x
 968  0099 26fc          	jrne	L611
 969  009b               L411:
 970  009b ca50c7        	or	a,20679
 971  009e c750c7        	ld	20679,a
 973  00a1 2049          	jra	L133
 974  00a3               L523:
 975                     ; 279       CLK->PCKENR1 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
 977  00a3 7b01          	ld	a,(OFST+1,sp)
 978  00a5 a40f          	and	a,#15
 979  00a7 5f            	clrw	x
 980  00a8 97            	ld	xl,a
 981  00a9 a601          	ld	a,#1
 982  00ab 5d            	tnzw	x
 983  00ac 2704          	jreq	L021
 984  00ae               L221:
 985  00ae 48            	sll	a
 986  00af 5a            	decw	x
 987  00b0 26fc          	jrne	L221
 988  00b2               L021:
 989  00b2 43            	cpl	a
 990  00b3 c450c7        	and	a,20679
 991  00b6 c750c7        	ld	20679,a
 992  00b9 2031          	jra	L133
 993  00bb               L323:
 994                     ; 284     if (NewState != DISABLE)
 996  00bb 0d02          	tnz	(OFST+2,sp)
 997  00bd 2717          	jreq	L333
 998                     ; 287       CLK->PCKENR2 |= (uint8_t)((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F));
1000  00bf 7b01          	ld	a,(OFST+1,sp)
1001  00c1 a40f          	and	a,#15
1002  00c3 5f            	clrw	x
1003  00c4 97            	ld	xl,a
1004  00c5 a601          	ld	a,#1
1005  00c7 5d            	tnzw	x
1006  00c8 2704          	jreq	L421
1007  00ca               L621:
1008  00ca 48            	sll	a
1009  00cb 5a            	decw	x
1010  00cc 26fc          	jrne	L621
1011  00ce               L421:
1012  00ce ca50ca        	or	a,20682
1013  00d1 c750ca        	ld	20682,a
1015  00d4 2016          	jra	L133
1016  00d6               L333:
1017                     ; 292       CLK->PCKENR2 &= (uint8_t)(~(uint8_t)(((uint8_t)1 << ((uint8_t)CLK_Peripheral & (uint8_t)0x0F))));
1019  00d6 7b01          	ld	a,(OFST+1,sp)
1020  00d8 a40f          	and	a,#15
1021  00da 5f            	clrw	x
1022  00db 97            	ld	xl,a
1023  00dc a601          	ld	a,#1
1024  00de 5d            	tnzw	x
1025  00df 2704          	jreq	L031
1026  00e1               L231:
1027  00e1 48            	sll	a
1028  00e2 5a            	decw	x
1029  00e3 26fc          	jrne	L231
1030  00e5               L031:
1031  00e5 43            	cpl	a
1032  00e6 c450ca        	and	a,20682
1033  00e9 c750ca        	ld	20682,a
1034  00ec               L133:
1035                     ; 295 }
1038  00ec 85            	popw	x
1039  00ed 81            	ret
1228                     ; 309 ErrorStatus CLK_ClockSwitchConfig(CLK_SwitchMode_TypeDef CLK_SwitchMode, CLK_Source_TypeDef CLK_NewClock, FunctionalState ITState, CLK_CurrentClockState_TypeDef CLK_CurrentClockState)
1228                     ; 310 {
1229                     .text:	section	.text,new
1230  0000               _CLK_ClockSwitchConfig:
1232  0000 89            	pushw	x
1233  0001 5204          	subw	sp,#4
1234       00000004      OFST:	set	4
1237                     ; 312   uint16_t DownCounter = CLK_TIMEOUT;
1239  0003 aeffff        	ldw	x,#65535
1240  0006 1f03          	ldw	(OFST-1,sp),x
1241                     ; 313   ErrorStatus Swif = ERROR;
1243                     ; 316   assert_param(IS_CLK_SOURCE_OK(CLK_NewClock));
1245  0008 7b06          	ld	a,(OFST+2,sp)
1246  000a a1e1          	cp	a,#225
1247  000c 270c          	jreq	L041
1248  000e 7b06          	ld	a,(OFST+2,sp)
1249  0010 a1d2          	cp	a,#210
1250  0012 2706          	jreq	L041
1251  0014 7b06          	ld	a,(OFST+2,sp)
1252  0016 a1b4          	cp	a,#180
1253  0018 2603          	jrne	L631
1254  001a               L041:
1255  001a 4f            	clr	a
1256  001b 2010          	jra	L241
1257  001d               L631:
1258  001d ae013c        	ldw	x,#316
1259  0020 89            	pushw	x
1260  0021 ae0000        	ldw	x,#0
1261  0024 89            	pushw	x
1262  0025 ae000c        	ldw	x,#L75
1263  0028 cd0000        	call	_assert_failed
1265  002b 5b04          	addw	sp,#4
1266  002d               L241:
1267                     ; 317   assert_param(IS_CLK_SWITCHMODE_OK(CLK_SwitchMode));
1269  002d 0d05          	tnz	(OFST+1,sp)
1270  002f 2706          	jreq	L641
1271  0031 7b05          	ld	a,(OFST+1,sp)
1272  0033 a101          	cp	a,#1
1273  0035 2603          	jrne	L441
1274  0037               L641:
1275  0037 4f            	clr	a
1276  0038 2010          	jra	L051
1277  003a               L441:
1278  003a ae013d        	ldw	x,#317
1279  003d 89            	pushw	x
1280  003e ae0000        	ldw	x,#0
1281  0041 89            	pushw	x
1282  0042 ae000c        	ldw	x,#L75
1283  0045 cd0000        	call	_assert_failed
1285  0048 5b04          	addw	sp,#4
1286  004a               L051:
1287                     ; 318   assert_param(IS_FUNCTIONALSTATE_OK(ITState));
1289  004a 0d09          	tnz	(OFST+5,sp)
1290  004c 2706          	jreq	L451
1291  004e 7b09          	ld	a,(OFST+5,sp)
1292  0050 a101          	cp	a,#1
1293  0052 2603          	jrne	L251
1294  0054               L451:
1295  0054 4f            	clr	a
1296  0055 2010          	jra	L651
1297  0057               L251:
1298  0057 ae013e        	ldw	x,#318
1299  005a 89            	pushw	x
1300  005b ae0000        	ldw	x,#0
1301  005e 89            	pushw	x
1302  005f ae000c        	ldw	x,#L75
1303  0062 cd0000        	call	_assert_failed
1305  0065 5b04          	addw	sp,#4
1306  0067               L651:
1307                     ; 319   assert_param(IS_CLK_CURRENTCLOCKSTATE_OK(CLK_CurrentClockState));
1309  0067 0d0a          	tnz	(OFST+6,sp)
1310  0069 2706          	jreq	L261
1311  006b 7b0a          	ld	a,(OFST+6,sp)
1312  006d a101          	cp	a,#1
1313  006f 2603          	jrne	L061
1314  0071               L261:
1315  0071 4f            	clr	a
1316  0072 2010          	jra	L461
1317  0074               L061:
1318  0074 ae013f        	ldw	x,#319
1319  0077 89            	pushw	x
1320  0078 ae0000        	ldw	x,#0
1321  007b 89            	pushw	x
1322  007c ae000c        	ldw	x,#L75
1323  007f cd0000        	call	_assert_failed
1325  0082 5b04          	addw	sp,#4
1326  0084               L461:
1327                     ; 322   clock_master = (CLK_Source_TypeDef)CLK->CMSR;
1329  0084 c650c3        	ld	a,20675
1330  0087 6b01          	ld	(OFST-3,sp),a
1331                     ; 325   if (CLK_SwitchMode == CLK_SWITCHMODE_AUTO)
1333  0089 7b05          	ld	a,(OFST+1,sp)
1334  008b a101          	cp	a,#1
1335  008d 264b          	jrne	L744
1336                     ; 328     CLK->SWCR |= CLK_SWCR_SWEN;
1338  008f 721250c5      	bset	20677,#1
1339                     ; 331     if (ITState != DISABLE)
1341  0093 0d09          	tnz	(OFST+5,sp)
1342  0095 2706          	jreq	L154
1343                     ; 333       CLK->SWCR |= CLK_SWCR_SWIEN;
1345  0097 721450c5      	bset	20677,#2
1347  009b 2004          	jra	L354
1348  009d               L154:
1349                     ; 337       CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWIEN);
1351  009d 721550c5      	bres	20677,#2
1352  00a1               L354:
1353                     ; 341     CLK->SWR = (uint8_t)CLK_NewClock;
1355  00a1 7b06          	ld	a,(OFST+2,sp)
1356  00a3 c750c4        	ld	20676,a
1358  00a6 2007          	jra	L164
1359  00a8               L554:
1360                     ; 346       DownCounter--;
1362  00a8 1e03          	ldw	x,(OFST-1,sp)
1363  00aa 1d0001        	subw	x,#1
1364  00ad 1f03          	ldw	(OFST-1,sp),x
1365  00af               L164:
1366                     ; 344     while((((CLK->SWCR & CLK_SWCR_SWBSY) != 0 )&& (DownCounter != 0)))
1368  00af c650c5        	ld	a,20677
1369  00b2 a501          	bcp	a,#1
1370  00b4 2704          	jreq	L564
1372  00b6 1e03          	ldw	x,(OFST-1,sp)
1373  00b8 26ee          	jrne	L554
1374  00ba               L564:
1375                     ; 349     if(DownCounter != 0)
1377  00ba 1e03          	ldw	x,(OFST-1,sp)
1378  00bc 2706          	jreq	L764
1379                     ; 351       Swif = SUCCESS;
1381  00be a601          	ld	a,#1
1382  00c0 6b02          	ld	(OFST-2,sp),a
1384  00c2 2002          	jra	L374
1385  00c4               L764:
1386                     ; 355       Swif = ERROR;
1388  00c4 0f02          	clr	(OFST-2,sp)
1389  00c6               L374:
1390                     ; 390   if(Swif != ERROR)
1392  00c6 0d02          	tnz	(OFST-2,sp)
1393  00c8 2767          	jreq	L715
1394                     ; 393     if((CLK_CurrentClockState == CLK_CURRENTCLOCKSTATE_DISABLE) && ( clock_master == CLK_SOURCE_HSI))
1396  00ca 0d0a          	tnz	(OFST+6,sp)
1397  00cc 2645          	jrne	L125
1399  00ce 7b01          	ld	a,(OFST-3,sp)
1400  00d0 a1e1          	cp	a,#225
1401  00d2 263f          	jrne	L125
1402                     ; 395       CLK->ICKR &= (uint8_t)(~CLK_ICKR_HSIEN);
1404  00d4 721150c0      	bres	20672,#0
1406  00d8 2057          	jra	L715
1407  00da               L744:
1408                     ; 361     if (ITState != DISABLE)
1410  00da 0d09          	tnz	(OFST+5,sp)
1411  00dc 2706          	jreq	L574
1412                     ; 363       CLK->SWCR |= CLK_SWCR_SWIEN;
1414  00de 721450c5      	bset	20677,#2
1416  00e2 2004          	jra	L774
1417  00e4               L574:
1418                     ; 367       CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWIEN);
1420  00e4 721550c5      	bres	20677,#2
1421  00e8               L774:
1422                     ; 371     CLK->SWR = (uint8_t)CLK_NewClock;
1424  00e8 7b06          	ld	a,(OFST+2,sp)
1425  00ea c750c4        	ld	20676,a
1427  00ed 2007          	jra	L505
1428  00ef               L105:
1429                     ; 376       DownCounter--;
1431  00ef 1e03          	ldw	x,(OFST-1,sp)
1432  00f1 1d0001        	subw	x,#1
1433  00f4 1f03          	ldw	(OFST-1,sp),x
1434  00f6               L505:
1435                     ; 374     while((((CLK->SWCR & CLK_SWCR_SWIF) != 0 ) && (DownCounter != 0)))
1437  00f6 c650c5        	ld	a,20677
1438  00f9 a508          	bcp	a,#8
1439  00fb 2704          	jreq	L115
1441  00fd 1e03          	ldw	x,(OFST-1,sp)
1442  00ff 26ee          	jrne	L105
1443  0101               L115:
1444                     ; 379     if(DownCounter != 0)
1446  0101 1e03          	ldw	x,(OFST-1,sp)
1447  0103 270a          	jreq	L315
1448                     ; 382       CLK->SWCR |= CLK_SWCR_SWEN;
1450  0105 721250c5      	bset	20677,#1
1451                     ; 383       Swif = SUCCESS;
1453  0109 a601          	ld	a,#1
1454  010b 6b02          	ld	(OFST-2,sp),a
1456  010d 20b7          	jra	L374
1457  010f               L315:
1458                     ; 387       Swif = ERROR;
1460  010f 0f02          	clr	(OFST-2,sp)
1461  0111 20b3          	jra	L374
1462  0113               L125:
1463                     ; 397     else if((CLK_CurrentClockState == CLK_CURRENTCLOCKSTATE_DISABLE) && ( clock_master == CLK_SOURCE_LSI))
1465  0113 0d0a          	tnz	(OFST+6,sp)
1466  0115 260c          	jrne	L525
1468  0117 7b01          	ld	a,(OFST-3,sp)
1469  0119 a1d2          	cp	a,#210
1470  011b 2606          	jrne	L525
1471                     ; 399       CLK->ICKR &= (uint8_t)(~CLK_ICKR_LSIEN);
1473  011d 721750c0      	bres	20672,#3
1475  0121 200e          	jra	L715
1476  0123               L525:
1477                     ; 401     else if ((CLK_CurrentClockState == CLK_CURRENTCLOCKSTATE_DISABLE) && ( clock_master == CLK_SOURCE_HSE))
1479  0123 0d0a          	tnz	(OFST+6,sp)
1480  0125 260a          	jrne	L715
1482  0127 7b01          	ld	a,(OFST-3,sp)
1483  0129 a1b4          	cp	a,#180
1484  012b 2604          	jrne	L715
1485                     ; 403       CLK->ECKR &= (uint8_t)(~CLK_ECKR_HSEEN);
1487  012d 721150c1      	bres	20673,#0
1488  0131               L715:
1489                     ; 406   return(Swif);
1491  0131 7b02          	ld	a,(OFST-2,sp)
1494  0133 5b06          	addw	sp,#6
1495  0135 81            	ret
1634                     ; 415 void CLK_HSIPrescalerConfig(CLK_Prescaler_TypeDef HSIPrescaler)
1634                     ; 416 {
1635                     .text:	section	.text,new
1636  0000               _CLK_HSIPrescalerConfig:
1638  0000 88            	push	a
1639       00000000      OFST:	set	0
1642                     ; 418   assert_param(IS_CLK_HSIPRESCALER_OK(HSIPrescaler));
1644  0001 4d            	tnz	a
1645  0002 270c          	jreq	L271
1646  0004 a108          	cp	a,#8
1647  0006 2708          	jreq	L271
1648  0008 a110          	cp	a,#16
1649  000a 2704          	jreq	L271
1650  000c a118          	cp	a,#24
1651  000e 2603          	jrne	L071
1652  0010               L271:
1653  0010 4f            	clr	a
1654  0011 2010          	jra	L471
1655  0013               L071:
1656  0013 ae01a2        	ldw	x,#418
1657  0016 89            	pushw	x
1658  0017 ae0000        	ldw	x,#0
1659  001a 89            	pushw	x
1660  001b ae000c        	ldw	x,#L75
1661  001e cd0000        	call	_assert_failed
1663  0021 5b04          	addw	sp,#4
1664  0023               L471:
1665                     ; 421   CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_HSIDIV);
1667  0023 c650c6        	ld	a,20678
1668  0026 a4e7          	and	a,#231
1669  0028 c750c6        	ld	20678,a
1670                     ; 424   CLK->CKDIVR |= (uint8_t)HSIPrescaler;
1672  002b c650c6        	ld	a,20678
1673  002e 1a01          	or	a,(OFST+1,sp)
1674  0030 c750c6        	ld	20678,a
1675                     ; 425 }
1678  0033 84            	pop	a
1679  0034 81            	ret
1815                     ; 436 void CLK_CCOConfig(CLK_Output_TypeDef CLK_CCO)
1815                     ; 437 {
1816                     .text:	section	.text,new
1817  0000               _CLK_CCOConfig:
1819  0000 88            	push	a
1820       00000000      OFST:	set	0
1823                     ; 439   assert_param(IS_CLK_OUTPUT_OK(CLK_CCO));
1825  0001 4d            	tnz	a
1826  0002 2730          	jreq	L202
1827  0004 a104          	cp	a,#4
1828  0006 272c          	jreq	L202
1829  0008 a102          	cp	a,#2
1830  000a 2728          	jreq	L202
1831  000c a108          	cp	a,#8
1832  000e 2724          	jreq	L202
1833  0010 a10a          	cp	a,#10
1834  0012 2720          	jreq	L202
1835  0014 a10c          	cp	a,#12
1836  0016 271c          	jreq	L202
1837  0018 a10e          	cp	a,#14
1838  001a 2718          	jreq	L202
1839  001c a110          	cp	a,#16
1840  001e 2714          	jreq	L202
1841  0020 a112          	cp	a,#18
1842  0022 2710          	jreq	L202
1843  0024 a114          	cp	a,#20
1844  0026 270c          	jreq	L202
1845  0028 a116          	cp	a,#22
1846  002a 2708          	jreq	L202
1847  002c a118          	cp	a,#24
1848  002e 2704          	jreq	L202
1849  0030 a11a          	cp	a,#26
1850  0032 2603          	jrne	L002
1851  0034               L202:
1852  0034 4f            	clr	a
1853  0035 2010          	jra	L402
1854  0037               L002:
1855  0037 ae01b7        	ldw	x,#439
1856  003a 89            	pushw	x
1857  003b ae0000        	ldw	x,#0
1858  003e 89            	pushw	x
1859  003f ae000c        	ldw	x,#L75
1860  0042 cd0000        	call	_assert_failed
1862  0045 5b04          	addw	sp,#4
1863  0047               L402:
1864                     ; 442   CLK->CCOR &= (uint8_t)(~CLK_CCOR_CCOSEL);
1866  0047 c650c9        	ld	a,20681
1867  004a a4e1          	and	a,#225
1868  004c c750c9        	ld	20681,a
1869                     ; 445   CLK->CCOR |= (uint8_t)CLK_CCO;
1871  004f c650c9        	ld	a,20681
1872  0052 1a01          	or	a,(OFST+1,sp)
1873  0054 c750c9        	ld	20681,a
1874                     ; 448   CLK->CCOR |= CLK_CCOR_CCOEN;
1876  0057 721050c9      	bset	20681,#0
1877                     ; 449 }
1880  005b 84            	pop	a
1881  005c 81            	ret
1947                     ; 459 void CLK_ITConfig(CLK_IT_TypeDef CLK_IT, FunctionalState NewState)
1947                     ; 460 {
1948                     .text:	section	.text,new
1949  0000               _CLK_ITConfig:
1951  0000 89            	pushw	x
1952       00000000      OFST:	set	0
1955                     ; 462   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1957  0001 9f            	ld	a,xl
1958  0002 4d            	tnz	a
1959  0003 2705          	jreq	L212
1960  0005 9f            	ld	a,xl
1961  0006 a101          	cp	a,#1
1962  0008 2603          	jrne	L012
1963  000a               L212:
1964  000a 4f            	clr	a
1965  000b 2010          	jra	L412
1966  000d               L012:
1967  000d ae01ce        	ldw	x,#462
1968  0010 89            	pushw	x
1969  0011 ae0000        	ldw	x,#0
1970  0014 89            	pushw	x
1971  0015 ae000c        	ldw	x,#L75
1972  0018 cd0000        	call	_assert_failed
1974  001b 5b04          	addw	sp,#4
1975  001d               L412:
1976                     ; 463   assert_param(IS_CLK_IT_OK(CLK_IT));
1978  001d 7b01          	ld	a,(OFST+1,sp)
1979  001f a10c          	cp	a,#12
1980  0021 2706          	jreq	L022
1981  0023 7b01          	ld	a,(OFST+1,sp)
1982  0025 a11c          	cp	a,#28
1983  0027 2603          	jrne	L612
1984  0029               L022:
1985  0029 4f            	clr	a
1986  002a 2010          	jra	L222
1987  002c               L612:
1988  002c ae01cf        	ldw	x,#463
1989  002f 89            	pushw	x
1990  0030 ae0000        	ldw	x,#0
1991  0033 89            	pushw	x
1992  0034 ae000c        	ldw	x,#L75
1993  0037 cd0000        	call	_assert_failed
1995  003a 5b04          	addw	sp,#4
1996  003c               L222:
1997                     ; 465   if (NewState != DISABLE)
1999  003c 0d02          	tnz	(OFST+2,sp)
2000  003e 271a          	jreq	L727
2001                     ; 467     switch (CLK_IT)
2003  0040 7b01          	ld	a,(OFST+1,sp)
2005                     ; 475     default:
2005                     ; 476       break;
2006  0042 a00c          	sub	a,#12
2007  0044 270a          	jreq	L366
2008  0046 a010          	sub	a,#16
2009  0048 2624          	jrne	L537
2010                     ; 469     case CLK_IT_SWIF: /* Enable the clock switch interrupt */
2010                     ; 470       CLK->SWCR |= CLK_SWCR_SWIEN;
2012  004a 721450c5      	bset	20677,#2
2013                     ; 471       break;
2015  004e 201e          	jra	L537
2016  0050               L366:
2017                     ; 472     case CLK_IT_CSSD: /* Enable the clock security system detection interrupt */
2017                     ; 473       CLK->CSSR |= CLK_CSSR_CSSDIE;
2019  0050 721450c8      	bset	20680,#2
2020                     ; 474       break;
2022  0054 2018          	jra	L537
2023  0056               L566:
2024                     ; 475     default:
2024                     ; 476       break;
2026  0056 2016          	jra	L537
2027  0058               L337:
2029  0058 2014          	jra	L537
2030  005a               L727:
2031                     ; 481     switch (CLK_IT)
2033  005a 7b01          	ld	a,(OFST+1,sp)
2035                     ; 489     default:
2035                     ; 490       break;
2036  005c a00c          	sub	a,#12
2037  005e 270a          	jreq	L176
2038  0060 a010          	sub	a,#16
2039  0062 260a          	jrne	L537
2040                     ; 483     case CLK_IT_SWIF: /* Disable the clock switch interrupt */
2040                     ; 484       CLK->SWCR  &= (uint8_t)(~CLK_SWCR_SWIEN);
2042  0064 721550c5      	bres	20677,#2
2043                     ; 485       break;
2045  0068 2004          	jra	L537
2046  006a               L176:
2047                     ; 486     case CLK_IT_CSSD: /* Disable the clock security system detection interrupt */
2047                     ; 487       CLK->CSSR &= (uint8_t)(~CLK_CSSR_CSSDIE);
2049  006a 721550c8      	bres	20680,#2
2050                     ; 488       break;
2051  006e               L537:
2052                     ; 493 }
2055  006e 85            	popw	x
2056  006f 81            	ret
2057  0070               L376:
2058                     ; 489     default:
2058                     ; 490       break;
2060  0070 20fc          	jra	L537
2061  0072               L147:
2062  0072 20fa          	jra	L537
2098                     ; 500 void CLK_SYSCLKConfig(CLK_Prescaler_TypeDef CLK_Prescaler)
2098                     ; 501 {
2099                     .text:	section	.text,new
2100  0000               _CLK_SYSCLKConfig:
2102  0000 88            	push	a
2103       00000000      OFST:	set	0
2106                     ; 503   assert_param(IS_CLK_PRESCALER_OK(CLK_Prescaler));
2108  0001 4d            	tnz	a
2109  0002 272c          	jreq	L032
2110  0004 a108          	cp	a,#8
2111  0006 2728          	jreq	L032
2112  0008 a110          	cp	a,#16
2113  000a 2724          	jreq	L032
2114  000c a118          	cp	a,#24
2115  000e 2720          	jreq	L032
2116  0010 a180          	cp	a,#128
2117  0012 271c          	jreq	L032
2118  0014 a181          	cp	a,#129
2119  0016 2718          	jreq	L032
2120  0018 a182          	cp	a,#130
2121  001a 2714          	jreq	L032
2122  001c a183          	cp	a,#131
2123  001e 2710          	jreq	L032
2124  0020 a184          	cp	a,#132
2125  0022 270c          	jreq	L032
2126  0024 a185          	cp	a,#133
2127  0026 2708          	jreq	L032
2128  0028 a186          	cp	a,#134
2129  002a 2704          	jreq	L032
2130  002c a187          	cp	a,#135
2131  002e 2603          	jrne	L622
2132  0030               L032:
2133  0030 4f            	clr	a
2134  0031 2010          	jra	L232
2135  0033               L622:
2136  0033 ae01f7        	ldw	x,#503
2137  0036 89            	pushw	x
2138  0037 ae0000        	ldw	x,#0
2139  003a 89            	pushw	x
2140  003b ae000c        	ldw	x,#L75
2141  003e cd0000        	call	_assert_failed
2143  0041 5b04          	addw	sp,#4
2144  0043               L232:
2145                     ; 505   if (((uint8_t)CLK_Prescaler & (uint8_t)0x80) == 0x00) /* Bit7 = 0 means HSI divider */
2147  0043 7b01          	ld	a,(OFST+1,sp)
2148  0045 a580          	bcp	a,#128
2149  0047 2614          	jrne	L167
2150                     ; 507     CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_HSIDIV);
2152  0049 c650c6        	ld	a,20678
2153  004c a4e7          	and	a,#231
2154  004e c750c6        	ld	20678,a
2155                     ; 508     CLK->CKDIVR |= (uint8_t)((uint8_t)CLK_Prescaler & (uint8_t)CLK_CKDIVR_HSIDIV);
2157  0051 7b01          	ld	a,(OFST+1,sp)
2158  0053 a418          	and	a,#24
2159  0055 ca50c6        	or	a,20678
2160  0058 c750c6        	ld	20678,a
2162  005b 2012          	jra	L367
2163  005d               L167:
2164                     ; 512     CLK->CKDIVR &= (uint8_t)(~CLK_CKDIVR_CPUDIV);
2166  005d c650c6        	ld	a,20678
2167  0060 a4f8          	and	a,#248
2168  0062 c750c6        	ld	20678,a
2169                     ; 513     CLK->CKDIVR |= (uint8_t)((uint8_t)CLK_Prescaler & (uint8_t)CLK_CKDIVR_CPUDIV);
2171  0065 7b01          	ld	a,(OFST+1,sp)
2172  0067 a407          	and	a,#7
2173  0069 ca50c6        	or	a,20678
2174  006c c750c6        	ld	20678,a
2175  006f               L367:
2176                     ; 515 }
2179  006f 84            	pop	a
2180  0070 81            	ret
2237                     ; 523 void CLK_SWIMConfig(CLK_SWIMDivider_TypeDef CLK_SWIMDivider)
2237                     ; 524 {
2238                     .text:	section	.text,new
2239  0000               _CLK_SWIMConfig:
2241  0000 88            	push	a
2242       00000000      OFST:	set	0
2245                     ; 526   assert_param(IS_CLK_SWIMDIVIDER_OK(CLK_SWIMDivider));
2247  0001 4d            	tnz	a
2248  0002 2704          	jreq	L042
2249  0004 a101          	cp	a,#1
2250  0006 2603          	jrne	L632
2251  0008               L042:
2252  0008 4f            	clr	a
2253  0009 2010          	jra	L242
2254  000b               L632:
2255  000b ae020e        	ldw	x,#526
2256  000e 89            	pushw	x
2257  000f ae0000        	ldw	x,#0
2258  0012 89            	pushw	x
2259  0013 ae000c        	ldw	x,#L75
2260  0016 cd0000        	call	_assert_failed
2262  0019 5b04          	addw	sp,#4
2263  001b               L242:
2264                     ; 528   if (CLK_SWIMDivider != CLK_SWIMDIVIDER_2)
2266  001b 0d01          	tnz	(OFST+1,sp)
2267  001d 2706          	jreq	L3101
2268                     ; 531     CLK->SWIMCCR |= CLK_SWIMCCR_SWIMDIV;
2270  001f 721050cd      	bset	20685,#0
2272  0023 2004          	jra	L5101
2273  0025               L3101:
2274                     ; 536     CLK->SWIMCCR &= (uint8_t)(~CLK_SWIMCCR_SWIMDIV);
2276  0025 721150cd      	bres	20685,#0
2277  0029               L5101:
2278                     ; 538 }
2281  0029 84            	pop	a
2282  002a 81            	ret
2306                     ; 547 void CLK_ClockSecuritySystemEnable(void)
2306                     ; 548 {
2307                     .text:	section	.text,new
2308  0000               _CLK_ClockSecuritySystemEnable:
2312                     ; 550   CLK->CSSR |= CLK_CSSR_CSSEN;
2314  0000 721050c8      	bset	20680,#0
2315                     ; 551 }
2318  0004 81            	ret
2343                     ; 559 CLK_Source_TypeDef CLK_GetSYSCLKSource(void)
2343                     ; 560 {
2344                     .text:	section	.text,new
2345  0000               _CLK_GetSYSCLKSource:
2349                     ; 561   return((CLK_Source_TypeDef)CLK->CMSR);
2351  0000 c650c3        	ld	a,20675
2354  0003 81            	ret
2417                     ; 569 uint32_t CLK_GetClockFreq(void)
2417                     ; 570 {
2418                     .text:	section	.text,new
2419  0000               _CLK_GetClockFreq:
2421  0000 5209          	subw	sp,#9
2422       00000009      OFST:	set	9
2425                     ; 571   uint32_t clockfrequency = 0;
2427                     ; 572   CLK_Source_TypeDef clocksource = CLK_SOURCE_HSI;
2429                     ; 573   uint8_t tmp = 0, presc = 0;
2433                     ; 576   clocksource = (CLK_Source_TypeDef)CLK->CMSR;
2435  0002 c650c3        	ld	a,20675
2436  0005 6b09          	ld	(OFST+0,sp),a
2437                     ; 578   if (clocksource == CLK_SOURCE_HSI)
2439  0007 7b09          	ld	a,(OFST+0,sp)
2440  0009 a1e1          	cp	a,#225
2441  000b 2641          	jrne	L1701
2442                     ; 580     tmp = (uint8_t)(CLK->CKDIVR & CLK_CKDIVR_HSIDIV);
2444  000d c650c6        	ld	a,20678
2445  0010 a418          	and	a,#24
2446  0012 6b09          	ld	(OFST+0,sp),a
2447                     ; 581     tmp = (uint8_t)(tmp >> 3);
2449  0014 0409          	srl	(OFST+0,sp)
2450  0016 0409          	srl	(OFST+0,sp)
2451  0018 0409          	srl	(OFST+0,sp)
2452                     ; 582     presc = HSIDivFactor[tmp];
2454  001a 7b09          	ld	a,(OFST+0,sp)
2455  001c 5f            	clrw	x
2456  001d 97            	ld	xl,a
2457  001e d60000        	ld	a,(_HSIDivFactor,x)
2458  0021 6b09          	ld	(OFST+0,sp),a
2459                     ; 583     clockfrequency = HSI_VALUE / presc;
2461  0023 7b09          	ld	a,(OFST+0,sp)
2462  0025 b703          	ld	c_lreg+3,a
2463  0027 3f02          	clr	c_lreg+2
2464  0029 3f01          	clr	c_lreg+1
2465  002b 3f00          	clr	c_lreg
2466  002d 96            	ldw	x,sp
2467  002e 1c0001        	addw	x,#OFST-8
2468  0031 cd0000        	call	c_rtol
2470  0034 ae2400        	ldw	x,#9216
2471  0037 bf02          	ldw	c_lreg+2,x
2472  0039 ae00f4        	ldw	x,#244
2473  003c bf00          	ldw	c_lreg,x
2474  003e 96            	ldw	x,sp
2475  003f 1c0001        	addw	x,#OFST-8
2476  0042 cd0000        	call	c_ludv
2478  0045 96            	ldw	x,sp
2479  0046 1c0005        	addw	x,#OFST-4
2480  0049 cd0000        	call	c_rtol
2483  004c 201c          	jra	L3701
2484  004e               L1701:
2485                     ; 585   else if ( clocksource == CLK_SOURCE_LSI)
2487  004e 7b09          	ld	a,(OFST+0,sp)
2488  0050 a1d2          	cp	a,#210
2489  0052 260c          	jrne	L5701
2490                     ; 587     clockfrequency = LSI_VALUE;
2492  0054 aef400        	ldw	x,#62464
2493  0057 1f07          	ldw	(OFST-2,sp),x
2494  0059 ae0001        	ldw	x,#1
2495  005c 1f05          	ldw	(OFST-4,sp),x
2497  005e 200a          	jra	L3701
2498  0060               L5701:
2499                     ; 591     clockfrequency = HSE_VALUE;
2501  0060 ae2400        	ldw	x,#9216
2502  0063 1f07          	ldw	(OFST-2,sp),x
2503  0065 ae00f4        	ldw	x,#244
2504  0068 1f05          	ldw	(OFST-4,sp),x
2505  006a               L3701:
2506                     ; 594   return((uint32_t)clockfrequency);
2508  006a 96            	ldw	x,sp
2509  006b 1c0005        	addw	x,#OFST-4
2510  006e cd0000        	call	c_ltor
2514  0071 5b09          	addw	sp,#9
2515  0073 81            	ret
2615                     ; 604 void CLK_AdjustHSICalibrationValue(CLK_HSITrimValue_TypeDef CLK_HSICalibrationValue)
2615                     ; 605 {
2616                     .text:	section	.text,new
2617  0000               _CLK_AdjustHSICalibrationValue:
2619  0000 88            	push	a
2620       00000000      OFST:	set	0
2623                     ; 607   assert_param(IS_CLK_HSITRIMVALUE_OK(CLK_HSICalibrationValue));
2625  0001 4d            	tnz	a
2626  0002 271c          	jreq	L652
2627  0004 a101          	cp	a,#1
2628  0006 2718          	jreq	L652
2629  0008 a102          	cp	a,#2
2630  000a 2714          	jreq	L652
2631  000c a103          	cp	a,#3
2632  000e 2710          	jreq	L652
2633  0010 a104          	cp	a,#4
2634  0012 270c          	jreq	L652
2635  0014 a105          	cp	a,#5
2636  0016 2708          	jreq	L652
2637  0018 a106          	cp	a,#6
2638  001a 2704          	jreq	L652
2639  001c a107          	cp	a,#7
2640  001e 2603          	jrne	L452
2641  0020               L652:
2642  0020 4f            	clr	a
2643  0021 2010          	jra	L062
2644  0023               L452:
2645  0023 ae025f        	ldw	x,#607
2646  0026 89            	pushw	x
2647  0027 ae0000        	ldw	x,#0
2648  002a 89            	pushw	x
2649  002b ae000c        	ldw	x,#L75
2650  002e cd0000        	call	_assert_failed
2652  0031 5b04          	addw	sp,#4
2653  0033               L062:
2654                     ; 610   CLK->HSITRIMR = (uint8_t)( (uint8_t)(CLK->HSITRIMR & (uint8_t)(~CLK_HSITRIMR_HSITRIM))|((uint8_t)CLK_HSICalibrationValue));
2656  0033 c650cc        	ld	a,20684
2657  0036 a4f8          	and	a,#248
2658  0038 1a01          	or	a,(OFST+1,sp)
2659  003a c750cc        	ld	20684,a
2660                     ; 611 }
2663  003d 84            	pop	a
2664  003e 81            	ret
2688                     ; 622 void CLK_SYSCLKEmergencyClear(void)
2688                     ; 623 {
2689                     .text:	section	.text,new
2690  0000               _CLK_SYSCLKEmergencyClear:
2694                     ; 624   CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWBSY);
2696  0000 721150c5      	bres	20677,#0
2697                     ; 625 }
2700  0004 81            	ret
2854                     ; 634 FlagStatus CLK_GetFlagStatus(CLK_Flag_TypeDef CLK_FLAG)
2854                     ; 635 {
2855                     .text:	section	.text,new
2856  0000               _CLK_GetFlagStatus:
2858  0000 89            	pushw	x
2859  0001 5203          	subw	sp,#3
2860       00000003      OFST:	set	3
2863                     ; 636   uint16_t statusreg = 0;
2865                     ; 637   uint8_t tmpreg = 0;
2867                     ; 638   FlagStatus bitstatus = RESET;
2869                     ; 641   assert_param(IS_CLK_FLAG_OK(CLK_FLAG));
2871  0003 a30110        	cpw	x,#272
2872  0006 2728          	jreq	L072
2873  0008 a30102        	cpw	x,#258
2874  000b 2723          	jreq	L072
2875  000d a30202        	cpw	x,#514
2876  0010 271e          	jreq	L072
2877  0012 a30308        	cpw	x,#776
2878  0015 2719          	jreq	L072
2879  0017 a30301        	cpw	x,#769
2880  001a 2714          	jreq	L072
2881  001c a30408        	cpw	x,#1032
2882  001f 270f          	jreq	L072
2883  0021 a30402        	cpw	x,#1026
2884  0024 270a          	jreq	L072
2885  0026 a30504        	cpw	x,#1284
2886  0029 2705          	jreq	L072
2887  002b a30502        	cpw	x,#1282
2888  002e 2603          	jrne	L662
2889  0030               L072:
2890  0030 4f            	clr	a
2891  0031 2010          	jra	L272
2892  0033               L662:
2893  0033 ae0281        	ldw	x,#641
2894  0036 89            	pushw	x
2895  0037 ae0000        	ldw	x,#0
2896  003a 89            	pushw	x
2897  003b ae000c        	ldw	x,#L75
2898  003e cd0000        	call	_assert_failed
2900  0041 5b04          	addw	sp,#4
2901  0043               L272:
2902                     ; 644   statusreg = (uint16_t)((uint16_t)CLK_FLAG & (uint16_t)0xFF00);
2904  0043 7b04          	ld	a,(OFST+1,sp)
2905  0045 97            	ld	xl,a
2906  0046 7b05          	ld	a,(OFST+2,sp)
2907  0048 9f            	ld	a,xl
2908  0049 a4ff          	and	a,#255
2909  004b 97            	ld	xl,a
2910  004c 4f            	clr	a
2911  004d 02            	rlwa	x,a
2912  004e 1f01          	ldw	(OFST-2,sp),x
2913  0050 01            	rrwa	x,a
2914                     ; 647   if (statusreg == 0x0100) /* The flag to check is in ICKRregister */
2916  0051 1e01          	ldw	x,(OFST-2,sp)
2917  0053 a30100        	cpw	x,#256
2918  0056 2607          	jrne	L3421
2919                     ; 649     tmpreg = CLK->ICKR;
2921  0058 c650c0        	ld	a,20672
2922  005b 6b03          	ld	(OFST+0,sp),a
2924  005d 202f          	jra	L5421
2925  005f               L3421:
2926                     ; 651   else if (statusreg == 0x0200) /* The flag to check is in ECKRregister */
2928  005f 1e01          	ldw	x,(OFST-2,sp)
2929  0061 a30200        	cpw	x,#512
2930  0064 2607          	jrne	L7421
2931                     ; 653     tmpreg = CLK->ECKR;
2933  0066 c650c1        	ld	a,20673
2934  0069 6b03          	ld	(OFST+0,sp),a
2936  006b 2021          	jra	L5421
2937  006d               L7421:
2938                     ; 655   else if (statusreg == 0x0300) /* The flag to check is in SWIC register */
2940  006d 1e01          	ldw	x,(OFST-2,sp)
2941  006f a30300        	cpw	x,#768
2942  0072 2607          	jrne	L3521
2943                     ; 657     tmpreg = CLK->SWCR;
2945  0074 c650c5        	ld	a,20677
2946  0077 6b03          	ld	(OFST+0,sp),a
2948  0079 2013          	jra	L5421
2949  007b               L3521:
2950                     ; 659   else if (statusreg == 0x0400) /* The flag to check is in CSS register */
2952  007b 1e01          	ldw	x,(OFST-2,sp)
2953  007d a30400        	cpw	x,#1024
2954  0080 2607          	jrne	L7521
2955                     ; 661     tmpreg = CLK->CSSR;
2957  0082 c650c8        	ld	a,20680
2958  0085 6b03          	ld	(OFST+0,sp),a
2960  0087 2005          	jra	L5421
2961  0089               L7521:
2962                     ; 665     tmpreg = CLK->CCOR;
2964  0089 c650c9        	ld	a,20681
2965  008c 6b03          	ld	(OFST+0,sp),a
2966  008e               L5421:
2967                     ; 668   if ((tmpreg & (uint8_t)CLK_FLAG) != (uint8_t)RESET)
2969  008e 7b05          	ld	a,(OFST+2,sp)
2970  0090 1503          	bcp	a,(OFST+0,sp)
2971  0092 2706          	jreq	L3621
2972                     ; 670     bitstatus = SET;
2974  0094 a601          	ld	a,#1
2975  0096 6b03          	ld	(OFST+0,sp),a
2977  0098 2002          	jra	L5621
2978  009a               L3621:
2979                     ; 674     bitstatus = RESET;
2981  009a 0f03          	clr	(OFST+0,sp)
2982  009c               L5621:
2983                     ; 678   return((FlagStatus)bitstatus);
2985  009c 7b03          	ld	a,(OFST+0,sp)
2988  009e 5b05          	addw	sp,#5
2989  00a0 81            	ret
3036                     ; 687 ITStatus CLK_GetITStatus(CLK_IT_TypeDef CLK_IT)
3036                     ; 688 {
3037                     .text:	section	.text,new
3038  0000               _CLK_GetITStatus:
3040  0000 88            	push	a
3041  0001 88            	push	a
3042       00000001      OFST:	set	1
3045                     ; 689   ITStatus bitstatus = RESET;
3047                     ; 692   assert_param(IS_CLK_IT_OK(CLK_IT));
3049  0002 a10c          	cp	a,#12
3050  0004 2704          	jreq	L003
3051  0006 a11c          	cp	a,#28
3052  0008 2603          	jrne	L672
3053  000a               L003:
3054  000a 4f            	clr	a
3055  000b 2010          	jra	L203
3056  000d               L672:
3057  000d ae02b4        	ldw	x,#692
3058  0010 89            	pushw	x
3059  0011 ae0000        	ldw	x,#0
3060  0014 89            	pushw	x
3061  0015 ae000c        	ldw	x,#L75
3062  0018 cd0000        	call	_assert_failed
3064  001b 5b04          	addw	sp,#4
3065  001d               L203:
3066                     ; 694   if (CLK_IT == CLK_IT_SWIF)
3068  001d 7b02          	ld	a,(OFST+1,sp)
3069  001f a11c          	cp	a,#28
3070  0021 2613          	jrne	L1131
3071                     ; 697     if ((CLK->SWCR & (uint8_t)CLK_IT) == (uint8_t)0x0C)
3073  0023 c650c5        	ld	a,20677
3074  0026 1402          	and	a,(OFST+1,sp)
3075  0028 a10c          	cp	a,#12
3076  002a 2606          	jrne	L3131
3077                     ; 699       bitstatus = SET;
3079  002c a601          	ld	a,#1
3080  002e 6b01          	ld	(OFST+0,sp),a
3082  0030 2015          	jra	L7131
3083  0032               L3131:
3084                     ; 703       bitstatus = RESET;
3086  0032 0f01          	clr	(OFST+0,sp)
3087  0034 2011          	jra	L7131
3088  0036               L1131:
3089                     ; 709     if ((CLK->CSSR & (uint8_t)CLK_IT) == (uint8_t)0x0C)
3091  0036 c650c8        	ld	a,20680
3092  0039 1402          	and	a,(OFST+1,sp)
3093  003b a10c          	cp	a,#12
3094  003d 2606          	jrne	L1231
3095                     ; 711       bitstatus = SET;
3097  003f a601          	ld	a,#1
3098  0041 6b01          	ld	(OFST+0,sp),a
3100  0043 2002          	jra	L7131
3101  0045               L1231:
3102                     ; 715       bitstatus = RESET;
3104  0045 0f01          	clr	(OFST+0,sp)
3105  0047               L7131:
3106                     ; 720   return bitstatus;
3108  0047 7b01          	ld	a,(OFST+0,sp)
3111  0049 85            	popw	x
3112  004a 81            	ret
3149                     ; 729 void CLK_ClearITPendingBit(CLK_IT_TypeDef CLK_IT)
3149                     ; 730 {
3150                     .text:	section	.text,new
3151  0000               _CLK_ClearITPendingBit:
3153  0000 88            	push	a
3154       00000000      OFST:	set	0
3157                     ; 732   assert_param(IS_CLK_IT_OK(CLK_IT));
3159  0001 a10c          	cp	a,#12
3160  0003 2704          	jreq	L013
3161  0005 a11c          	cp	a,#28
3162  0007 2603          	jrne	L603
3163  0009               L013:
3164  0009 4f            	clr	a
3165  000a 2010          	jra	L213
3166  000c               L603:
3167  000c ae02dc        	ldw	x,#732
3168  000f 89            	pushw	x
3169  0010 ae0000        	ldw	x,#0
3170  0013 89            	pushw	x
3171  0014 ae000c        	ldw	x,#L75
3172  0017 cd0000        	call	_assert_failed
3174  001a 5b04          	addw	sp,#4
3175  001c               L213:
3176                     ; 734   if (CLK_IT == (uint8_t)CLK_IT_CSSD)
3178  001c 7b01          	ld	a,(OFST+1,sp)
3179  001e a10c          	cp	a,#12
3180  0020 2606          	jrne	L3431
3181                     ; 737     CLK->CSSR &= (uint8_t)(~CLK_CSSR_CSSD);
3183  0022 721750c8      	bres	20680,#3
3185  0026 2004          	jra	L5431
3186  0028               L3431:
3187                     ; 742     CLK->SWCR &= (uint8_t)(~CLK_SWCR_SWIF);
3189  0028 721750c5      	bres	20677,#3
3190  002c               L5431:
3191                     ; 745 }
3194  002c 84            	pop	a
3195  002d 81            	ret
3230                     	xdef	_CLKPrescTable
3231                     	xdef	_HSIDivFactor
3232                     	xdef	_CLK_ClearITPendingBit
3233                     	xdef	_CLK_GetITStatus
3234                     	xdef	_CLK_GetFlagStatus
3235                     	xdef	_CLK_GetSYSCLKSource
3236                     	xdef	_CLK_GetClockFreq
3237                     	xdef	_CLK_AdjustHSICalibrationValue
3238                     	xdef	_CLK_SYSCLKEmergencyClear
3239                     	xdef	_CLK_ClockSecuritySystemEnable
3240                     	xdef	_CLK_SWIMConfig
3241                     	xdef	_CLK_SYSCLKConfig
3242                     	xdef	_CLK_ITConfig
3243                     	xdef	_CLK_CCOConfig
3244                     	xdef	_CLK_HSIPrescalerConfig
3245                     	xdef	_CLK_ClockSwitchConfig
3246                     	xdef	_CLK_PeripheralClockConfig
3247                     	xdef	_CLK_SlowActiveHaltWakeUpCmd
3248                     	xdef	_CLK_FastHaltWakeUpCmd
3249                     	xdef	_CLK_ClockSwitchCmd
3250                     	xdef	_CLK_CCOCmd
3251                     	xdef	_CLK_LSICmd
3252                     	xdef	_CLK_HSICmd
3253                     	xdef	_CLK_HSECmd
3254                     	xdef	_CLK_DeInit
3255                     	xref	_assert_failed
3256                     	switch	.const
3257  000c               L75:
3258  000c 73746d38735f  	dc.b	"stm8s_stdperiph_li"
3259  001e 625c6c696272  	dc.b	"b\libraries\stm8s_"
3260  0030 737464706572  	dc.b	"stdperiph_driver\s"
3261  0042 72635c73746d  	dc.b	"rc\stm8s_clk.c",0
3262                     	xref.b	c_lreg
3263                     	xref.b	c_x
3283                     	xref	c_ltor
3284                     	xref	c_ludv
3285                     	xref	c_rtol
3286                     	end
