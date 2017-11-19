   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  45                     ; 51 void TIM3_DeInit(void)
  45                     ; 52 {
  47                     .text:	section	.text,new
  48  0000               _TIM3_DeInit:
  52                     ; 53   TIM3->CR1 = (uint8_t)TIM3_CR1_RESET_VALUE;
  54  0000 725f5320      	clr	21280
  55                     ; 54   TIM3->IER = (uint8_t)TIM3_IER_RESET_VALUE;
  57  0004 725f5321      	clr	21281
  58                     ; 55   TIM3->SR2 = (uint8_t)TIM3_SR2_RESET_VALUE;
  60  0008 725f5323      	clr	21283
  61                     ; 58   TIM3->CCER1 = (uint8_t)TIM3_CCER1_RESET_VALUE;
  63  000c 725f5327      	clr	21287
  64                     ; 61   TIM3->CCER1 = (uint8_t)TIM3_CCER1_RESET_VALUE;
  66  0010 725f5327      	clr	21287
  67                     ; 62   TIM3->CCMR1 = (uint8_t)TIM3_CCMR1_RESET_VALUE;
  69  0014 725f5325      	clr	21285
  70                     ; 63   TIM3->CCMR2 = (uint8_t)TIM3_CCMR2_RESET_VALUE;
  72  0018 725f5326      	clr	21286
  73                     ; 64   TIM3->CNTRH = (uint8_t)TIM3_CNTRH_RESET_VALUE;
  75  001c 725f5328      	clr	21288
  76                     ; 65   TIM3->CNTRL = (uint8_t)TIM3_CNTRL_RESET_VALUE;
  78  0020 725f5329      	clr	21289
  79                     ; 66   TIM3->PSCR = (uint8_t)TIM3_PSCR_RESET_VALUE;
  81  0024 725f532a      	clr	21290
  82                     ; 67   TIM3->ARRH  = (uint8_t)TIM3_ARRH_RESET_VALUE;
  84  0028 35ff532b      	mov	21291,#255
  85                     ; 68   TIM3->ARRL  = (uint8_t)TIM3_ARRL_RESET_VALUE;
  87  002c 35ff532c      	mov	21292,#255
  88                     ; 69   TIM3->CCR1H = (uint8_t)TIM3_CCR1H_RESET_VALUE;
  90  0030 725f532d      	clr	21293
  91                     ; 70   TIM3->CCR1L = (uint8_t)TIM3_CCR1L_RESET_VALUE;
  93  0034 725f532e      	clr	21294
  94                     ; 71   TIM3->CCR2H = (uint8_t)TIM3_CCR2H_RESET_VALUE;
  96  0038 725f532f      	clr	21295
  97                     ; 72   TIM3->CCR2L = (uint8_t)TIM3_CCR2L_RESET_VALUE;
  99  003c 725f5330      	clr	21296
 100                     ; 73   TIM3->SR1 = (uint8_t)TIM3_SR1_RESET_VALUE;
 102  0040 725f5322      	clr	21282
 103                     ; 74 }
 106  0044 81            	ret
 274                     ; 82 void TIM3_TimeBaseInit( TIM3_Prescaler_TypeDef TIM3_Prescaler,
 274                     ; 83                         uint16_t TIM3_Period)
 274                     ; 84 {
 275                     .text:	section	.text,new
 276  0000               _TIM3_TimeBaseInit:
 278  0000 88            	push	a
 279       00000000      OFST:	set	0
 282                     ; 86   TIM3->PSCR = (uint8_t)(TIM3_Prescaler);
 284  0001 c7532a        	ld	21290,a
 285                     ; 88   TIM3->ARRH = (uint8_t)(TIM3_Period >> 8);
 287  0004 7b04          	ld	a,(OFST+4,sp)
 288  0006 c7532b        	ld	21291,a
 289                     ; 89   TIM3->ARRL = (uint8_t)(TIM3_Period);
 291  0009 7b05          	ld	a,(OFST+5,sp)
 292  000b c7532c        	ld	21292,a
 293                     ; 90 }
 296  000e 84            	pop	a
 297  000f 81            	ret
 455                     ; 100 void TIM3_OC1Init(TIM3_OCMode_TypeDef TIM3_OCMode,
 455                     ; 101                   TIM3_OutputState_TypeDef TIM3_OutputState,
 455                     ; 102                   uint16_t TIM3_Pulse,
 455                     ; 103                   TIM3_OCPolarity_TypeDef TIM3_OCPolarity)
 455                     ; 104 {
 456                     .text:	section	.text,new
 457  0000               _TIM3_OC1Init:
 459  0000 89            	pushw	x
 460  0001 88            	push	a
 461       00000001      OFST:	set	1
 464                     ; 106   assert_param(IS_TIM3_OC_MODE_OK(TIM3_OCMode));
 466  0002 9e            	ld	a,xh
 467  0003 4d            	tnz	a
 468  0004 2719          	jreq	L41
 469  0006 9e            	ld	a,xh
 470  0007 a110          	cp	a,#16
 471  0009 2714          	jreq	L41
 472  000b 9e            	ld	a,xh
 473  000c a120          	cp	a,#32
 474  000e 270f          	jreq	L41
 475  0010 9e            	ld	a,xh
 476  0011 a130          	cp	a,#48
 477  0013 270a          	jreq	L41
 478  0015 9e            	ld	a,xh
 479  0016 a160          	cp	a,#96
 480  0018 2705          	jreq	L41
 481  001a 9e            	ld	a,xh
 482  001b a170          	cp	a,#112
 483  001d 2603          	jrne	L21
 484  001f               L41:
 485  001f 4f            	clr	a
 486  0020 2010          	jra	L61
 487  0022               L21:
 488  0022 ae006a        	ldw	x,#106
 489  0025 89            	pushw	x
 490  0026 ae0000        	ldw	x,#0
 491  0029 89            	pushw	x
 492  002a ae0000        	ldw	x,#L502
 493  002d cd0000        	call	_assert_failed
 495  0030 5b04          	addw	sp,#4
 496  0032               L61:
 497                     ; 107   assert_param(IS_TIM3_OUTPUT_STATE_OK(TIM3_OutputState));
 499  0032 0d03          	tnz	(OFST+2,sp)
 500  0034 2706          	jreq	L22
 501  0036 7b03          	ld	a,(OFST+2,sp)
 502  0038 a111          	cp	a,#17
 503  003a 2603          	jrne	L02
 504  003c               L22:
 505  003c 4f            	clr	a
 506  003d 2010          	jra	L42
 507  003f               L02:
 508  003f ae006b        	ldw	x,#107
 509  0042 89            	pushw	x
 510  0043 ae0000        	ldw	x,#0
 511  0046 89            	pushw	x
 512  0047 ae0000        	ldw	x,#L502
 513  004a cd0000        	call	_assert_failed
 515  004d 5b04          	addw	sp,#4
 516  004f               L42:
 517                     ; 108   assert_param(IS_TIM3_OC_POLARITY_OK(TIM3_OCPolarity));
 519  004f 0d08          	tnz	(OFST+7,sp)
 520  0051 2706          	jreq	L03
 521  0053 7b08          	ld	a,(OFST+7,sp)
 522  0055 a122          	cp	a,#34
 523  0057 2603          	jrne	L62
 524  0059               L03:
 525  0059 4f            	clr	a
 526  005a 2010          	jra	L23
 527  005c               L62:
 528  005c ae006c        	ldw	x,#108
 529  005f 89            	pushw	x
 530  0060 ae0000        	ldw	x,#0
 531  0063 89            	pushw	x
 532  0064 ae0000        	ldw	x,#L502
 533  0067 cd0000        	call	_assert_failed
 535  006a 5b04          	addw	sp,#4
 536  006c               L23:
 537                     ; 111   TIM3->CCER1 &= (uint8_t)(~( TIM3_CCER1_CC1E | TIM3_CCER1_CC1P));
 539  006c c65327        	ld	a,21287
 540  006f a4fc          	and	a,#252
 541  0071 c75327        	ld	21287,a
 542                     ; 113   TIM3->CCER1 |= (uint8_t)((uint8_t)(TIM3_OutputState  & TIM3_CCER1_CC1E   ) | (uint8_t)(TIM3_OCPolarity   & TIM3_CCER1_CC1P   ));
 544  0074 7b08          	ld	a,(OFST+7,sp)
 545  0076 a402          	and	a,#2
 546  0078 6b01          	ld	(OFST+0,sp),a
 547  007a 7b03          	ld	a,(OFST+2,sp)
 548  007c a401          	and	a,#1
 549  007e 1a01          	or	a,(OFST+0,sp)
 550  0080 ca5327        	or	a,21287
 551  0083 c75327        	ld	21287,a
 552                     ; 116   TIM3->CCMR1 = (uint8_t)((uint8_t)(TIM3->CCMR1 & (uint8_t)(~TIM3_CCMR_OCM)) | (uint8_t)TIM3_OCMode);
 554  0086 c65325        	ld	a,21285
 555  0089 a48f          	and	a,#143
 556  008b 1a02          	or	a,(OFST+1,sp)
 557  008d c75325        	ld	21285,a
 558                     ; 119   TIM3->CCR1H = (uint8_t)(TIM3_Pulse >> 8);
 560  0090 7b06          	ld	a,(OFST+5,sp)
 561  0092 c7532d        	ld	21293,a
 562                     ; 120   TIM3->CCR1L = (uint8_t)(TIM3_Pulse);
 564  0095 7b07          	ld	a,(OFST+6,sp)
 565  0097 c7532e        	ld	21294,a
 566                     ; 121 }
 569  009a 5b03          	addw	sp,#3
 570  009c 81            	ret
 635                     ; 131 void TIM3_OC2Init(TIM3_OCMode_TypeDef TIM3_OCMode,
 635                     ; 132                   TIM3_OutputState_TypeDef TIM3_OutputState,
 635                     ; 133                   uint16_t TIM3_Pulse,
 635                     ; 134                   TIM3_OCPolarity_TypeDef TIM3_OCPolarity)
 635                     ; 135 {
 636                     .text:	section	.text,new
 637  0000               _TIM3_OC2Init:
 639  0000 89            	pushw	x
 640  0001 88            	push	a
 641       00000001      OFST:	set	1
 644                     ; 137   assert_param(IS_TIM3_OC_MODE_OK(TIM3_OCMode));
 646  0002 9e            	ld	a,xh
 647  0003 4d            	tnz	a
 648  0004 2719          	jreq	L04
 649  0006 9e            	ld	a,xh
 650  0007 a110          	cp	a,#16
 651  0009 2714          	jreq	L04
 652  000b 9e            	ld	a,xh
 653  000c a120          	cp	a,#32
 654  000e 270f          	jreq	L04
 655  0010 9e            	ld	a,xh
 656  0011 a130          	cp	a,#48
 657  0013 270a          	jreq	L04
 658  0015 9e            	ld	a,xh
 659  0016 a160          	cp	a,#96
 660  0018 2705          	jreq	L04
 661  001a 9e            	ld	a,xh
 662  001b a170          	cp	a,#112
 663  001d 2603          	jrne	L63
 664  001f               L04:
 665  001f 4f            	clr	a
 666  0020 2010          	jra	L24
 667  0022               L63:
 668  0022 ae0089        	ldw	x,#137
 669  0025 89            	pushw	x
 670  0026 ae0000        	ldw	x,#0
 671  0029 89            	pushw	x
 672  002a ae0000        	ldw	x,#L502
 673  002d cd0000        	call	_assert_failed
 675  0030 5b04          	addw	sp,#4
 676  0032               L24:
 677                     ; 138   assert_param(IS_TIM3_OUTPUT_STATE_OK(TIM3_OutputState));
 679  0032 0d03          	tnz	(OFST+2,sp)
 680  0034 2706          	jreq	L64
 681  0036 7b03          	ld	a,(OFST+2,sp)
 682  0038 a111          	cp	a,#17
 683  003a 2603          	jrne	L44
 684  003c               L64:
 685  003c 4f            	clr	a
 686  003d 2010          	jra	L05
 687  003f               L44:
 688  003f ae008a        	ldw	x,#138
 689  0042 89            	pushw	x
 690  0043 ae0000        	ldw	x,#0
 691  0046 89            	pushw	x
 692  0047 ae0000        	ldw	x,#L502
 693  004a cd0000        	call	_assert_failed
 695  004d 5b04          	addw	sp,#4
 696  004f               L05:
 697                     ; 139   assert_param(IS_TIM3_OC_POLARITY_OK(TIM3_OCPolarity));
 699  004f 0d08          	tnz	(OFST+7,sp)
 700  0051 2706          	jreq	L45
 701  0053 7b08          	ld	a,(OFST+7,sp)
 702  0055 a122          	cp	a,#34
 703  0057 2603          	jrne	L25
 704  0059               L45:
 705  0059 4f            	clr	a
 706  005a 2010          	jra	L65
 707  005c               L25:
 708  005c ae008b        	ldw	x,#139
 709  005f 89            	pushw	x
 710  0060 ae0000        	ldw	x,#0
 711  0063 89            	pushw	x
 712  0064 ae0000        	ldw	x,#L502
 713  0067 cd0000        	call	_assert_failed
 715  006a 5b04          	addw	sp,#4
 716  006c               L65:
 717                     ; 143   TIM3->CCER1 &= (uint8_t)(~( TIM3_CCER1_CC2E |  TIM3_CCER1_CC2P ));
 719  006c c65327        	ld	a,21287
 720  006f a4cf          	and	a,#207
 721  0071 c75327        	ld	21287,a
 722                     ; 145   TIM3->CCER1 |= (uint8_t)((uint8_t)(TIM3_OutputState  & TIM3_CCER1_CC2E   ) | (uint8_t)(TIM3_OCPolarity   & TIM3_CCER1_CC2P ));
 724  0074 7b08          	ld	a,(OFST+7,sp)
 725  0076 a420          	and	a,#32
 726  0078 6b01          	ld	(OFST+0,sp),a
 727  007a 7b03          	ld	a,(OFST+2,sp)
 728  007c a410          	and	a,#16
 729  007e 1a01          	or	a,(OFST+0,sp)
 730  0080 ca5327        	or	a,21287
 731  0083 c75327        	ld	21287,a
 732                     ; 149   TIM3->CCMR2 = (uint8_t)((uint8_t)(TIM3->CCMR2 & (uint8_t)(~TIM3_CCMR_OCM)) | (uint8_t)TIM3_OCMode);
 734  0086 c65326        	ld	a,21286
 735  0089 a48f          	and	a,#143
 736  008b 1a02          	or	a,(OFST+1,sp)
 737  008d c75326        	ld	21286,a
 738                     ; 153   TIM3->CCR2H = (uint8_t)(TIM3_Pulse >> 8);
 740  0090 7b06          	ld	a,(OFST+5,sp)
 741  0092 c7532f        	ld	21295,a
 742                     ; 154   TIM3->CCR2L = (uint8_t)(TIM3_Pulse);
 744  0095 7b07          	ld	a,(OFST+6,sp)
 745  0097 c75330        	ld	21296,a
 746                     ; 155 }
 749  009a 5b03          	addw	sp,#3
 750  009c 81            	ret
 935                     ; 166 void TIM3_ICInit(TIM3_Channel_TypeDef TIM3_Channel,
 935                     ; 167                  TIM3_ICPolarity_TypeDef TIM3_ICPolarity,
 935                     ; 168                  TIM3_ICSelection_TypeDef TIM3_ICSelection,
 935                     ; 169                  TIM3_ICPSC_TypeDef TIM3_ICPrescaler,
 935                     ; 170                  uint8_t TIM3_ICFilter)
 935                     ; 171 {
 936                     .text:	section	.text,new
 937  0000               _TIM3_ICInit:
 939  0000 89            	pushw	x
 940       00000000      OFST:	set	0
 943                     ; 173   assert_param(IS_TIM3_CHANNEL_OK(TIM3_Channel));
 945  0001 9e            	ld	a,xh
 946  0002 4d            	tnz	a
 947  0003 2705          	jreq	L46
 948  0005 9e            	ld	a,xh
 949  0006 a101          	cp	a,#1
 950  0008 2603          	jrne	L26
 951  000a               L46:
 952  000a 4f            	clr	a
 953  000b 2010          	jra	L66
 954  000d               L26:
 955  000d ae00ad        	ldw	x,#173
 956  0010 89            	pushw	x
 957  0011 ae0000        	ldw	x,#0
 958  0014 89            	pushw	x
 959  0015 ae0000        	ldw	x,#L502
 960  0018 cd0000        	call	_assert_failed
 962  001b 5b04          	addw	sp,#4
 963  001d               L66:
 964                     ; 174   assert_param(IS_TIM3_IC_POLARITY_OK(TIM3_ICPolarity));
 966  001d 0d02          	tnz	(OFST+2,sp)
 967  001f 2706          	jreq	L27
 968  0021 7b02          	ld	a,(OFST+2,sp)
 969  0023 a144          	cp	a,#68
 970  0025 2603          	jrne	L07
 971  0027               L27:
 972  0027 4f            	clr	a
 973  0028 2010          	jra	L47
 974  002a               L07:
 975  002a ae00ae        	ldw	x,#174
 976  002d 89            	pushw	x
 977  002e ae0000        	ldw	x,#0
 978  0031 89            	pushw	x
 979  0032 ae0000        	ldw	x,#L502
 980  0035 cd0000        	call	_assert_failed
 982  0038 5b04          	addw	sp,#4
 983  003a               L47:
 984                     ; 175   assert_param(IS_TIM3_IC_SELECTION_OK(TIM3_ICSelection));
 986  003a 7b05          	ld	a,(OFST+5,sp)
 987  003c a101          	cp	a,#1
 988  003e 270c          	jreq	L001
 989  0040 7b05          	ld	a,(OFST+5,sp)
 990  0042 a102          	cp	a,#2
 991  0044 2706          	jreq	L001
 992  0046 7b05          	ld	a,(OFST+5,sp)
 993  0048 a103          	cp	a,#3
 994  004a 2603          	jrne	L67
 995  004c               L001:
 996  004c 4f            	clr	a
 997  004d 2010          	jra	L201
 998  004f               L67:
 999  004f ae00af        	ldw	x,#175
1000  0052 89            	pushw	x
1001  0053 ae0000        	ldw	x,#0
1002  0056 89            	pushw	x
1003  0057 ae0000        	ldw	x,#L502
1004  005a cd0000        	call	_assert_failed
1006  005d 5b04          	addw	sp,#4
1007  005f               L201:
1008                     ; 176   assert_param(IS_TIM3_IC_PRESCALER_OK(TIM3_ICPrescaler));
1010  005f 0d06          	tnz	(OFST+6,sp)
1011  0061 2712          	jreq	L601
1012  0063 7b06          	ld	a,(OFST+6,sp)
1013  0065 a104          	cp	a,#4
1014  0067 270c          	jreq	L601
1015  0069 7b06          	ld	a,(OFST+6,sp)
1016  006b a108          	cp	a,#8
1017  006d 2706          	jreq	L601
1018  006f 7b06          	ld	a,(OFST+6,sp)
1019  0071 a10c          	cp	a,#12
1020  0073 2603          	jrne	L401
1021  0075               L601:
1022  0075 4f            	clr	a
1023  0076 2010          	jra	L011
1024  0078               L401:
1025  0078 ae00b0        	ldw	x,#176
1026  007b 89            	pushw	x
1027  007c ae0000        	ldw	x,#0
1028  007f 89            	pushw	x
1029  0080 ae0000        	ldw	x,#L502
1030  0083 cd0000        	call	_assert_failed
1032  0086 5b04          	addw	sp,#4
1033  0088               L011:
1034                     ; 177   assert_param(IS_TIM3_IC_FILTER_OK(TIM3_ICFilter));
1036  0088 7b07          	ld	a,(OFST+7,sp)
1037  008a a110          	cp	a,#16
1038  008c 2403          	jruge	L211
1039  008e 4f            	clr	a
1040  008f 2010          	jra	L411
1041  0091               L211:
1042  0091 ae00b1        	ldw	x,#177
1043  0094 89            	pushw	x
1044  0095 ae0000        	ldw	x,#0
1045  0098 89            	pushw	x
1046  0099 ae0000        	ldw	x,#L502
1047  009c cd0000        	call	_assert_failed
1049  009f 5b04          	addw	sp,#4
1050  00a1               L411:
1051                     ; 179   if (TIM3_Channel != TIM3_CHANNEL_2)
1053  00a1 7b01          	ld	a,(OFST+1,sp)
1054  00a3 a101          	cp	a,#1
1055  00a5 2714          	jreq	L543
1056                     ; 182     TI1_Config((uint8_t)TIM3_ICPolarity,
1056                     ; 183                (uint8_t)TIM3_ICSelection,
1056                     ; 184                (uint8_t)TIM3_ICFilter);
1058  00a7 7b07          	ld	a,(OFST+7,sp)
1059  00a9 88            	push	a
1060  00aa 7b06          	ld	a,(OFST+6,sp)
1061  00ac 97            	ld	xl,a
1062  00ad 7b03          	ld	a,(OFST+3,sp)
1063  00af 95            	ld	xh,a
1064  00b0 cd0000        	call	L3_TI1_Config
1066  00b3 84            	pop	a
1067                     ; 187     TIM3_SetIC1Prescaler(TIM3_ICPrescaler);
1069  00b4 7b06          	ld	a,(OFST+6,sp)
1070  00b6 cd0000        	call	_TIM3_SetIC1Prescaler
1073  00b9 2012          	jra	L743
1074  00bb               L543:
1075                     ; 192     TI2_Config((uint8_t)TIM3_ICPolarity,
1075                     ; 193                (uint8_t)TIM3_ICSelection,
1075                     ; 194                (uint8_t)TIM3_ICFilter);
1077  00bb 7b07          	ld	a,(OFST+7,sp)
1078  00bd 88            	push	a
1079  00be 7b06          	ld	a,(OFST+6,sp)
1080  00c0 97            	ld	xl,a
1081  00c1 7b03          	ld	a,(OFST+3,sp)
1082  00c3 95            	ld	xh,a
1083  00c4 cd0000        	call	L5_TI2_Config
1085  00c7 84            	pop	a
1086                     ; 197     TIM3_SetIC2Prescaler(TIM3_ICPrescaler);
1088  00c8 7b06          	ld	a,(OFST+6,sp)
1089  00ca cd0000        	call	_TIM3_SetIC2Prescaler
1091  00cd               L743:
1092                     ; 199 }
1095  00cd 85            	popw	x
1096  00ce 81            	ret
1193                     ; 210 void TIM3_PWMIConfig(TIM3_Channel_TypeDef TIM3_Channel,
1193                     ; 211                      TIM3_ICPolarity_TypeDef TIM3_ICPolarity,
1193                     ; 212                      TIM3_ICSelection_TypeDef TIM3_ICSelection,
1193                     ; 213                      TIM3_ICPSC_TypeDef TIM3_ICPrescaler,
1193                     ; 214                      uint8_t TIM3_ICFilter)
1193                     ; 215 {
1194                     .text:	section	.text,new
1195  0000               _TIM3_PWMIConfig:
1197  0000 89            	pushw	x
1198  0001 89            	pushw	x
1199       00000002      OFST:	set	2
1202                     ; 216   uint8_t icpolarity = (uint8_t)TIM3_ICPOLARITY_RISING;
1204                     ; 217   uint8_t icselection = (uint8_t)TIM3_ICSELECTION_DIRECTTI;
1206                     ; 220   assert_param(IS_TIM3_PWMI_CHANNEL_OK(TIM3_Channel));
1208  0002 9e            	ld	a,xh
1209  0003 4d            	tnz	a
1210  0004 2705          	jreq	L221
1211  0006 9e            	ld	a,xh
1212  0007 a101          	cp	a,#1
1213  0009 2603          	jrne	L021
1214  000b               L221:
1215  000b 4f            	clr	a
1216  000c 2010          	jra	L421
1217  000e               L021:
1218  000e ae00dc        	ldw	x,#220
1219  0011 89            	pushw	x
1220  0012 ae0000        	ldw	x,#0
1221  0015 89            	pushw	x
1222  0016 ae0000        	ldw	x,#L502
1223  0019 cd0000        	call	_assert_failed
1225  001c 5b04          	addw	sp,#4
1226  001e               L421:
1227                     ; 221   assert_param(IS_TIM3_IC_POLARITY_OK(TIM3_ICPolarity));
1229  001e 0d04          	tnz	(OFST+2,sp)
1230  0020 2706          	jreq	L031
1231  0022 7b04          	ld	a,(OFST+2,sp)
1232  0024 a144          	cp	a,#68
1233  0026 2603          	jrne	L621
1234  0028               L031:
1235  0028 4f            	clr	a
1236  0029 2010          	jra	L231
1237  002b               L621:
1238  002b ae00dd        	ldw	x,#221
1239  002e 89            	pushw	x
1240  002f ae0000        	ldw	x,#0
1241  0032 89            	pushw	x
1242  0033 ae0000        	ldw	x,#L502
1243  0036 cd0000        	call	_assert_failed
1245  0039 5b04          	addw	sp,#4
1246  003b               L231:
1247                     ; 222   assert_param(IS_TIM3_IC_SELECTION_OK(TIM3_ICSelection));
1249  003b 7b07          	ld	a,(OFST+5,sp)
1250  003d a101          	cp	a,#1
1251  003f 270c          	jreq	L631
1252  0041 7b07          	ld	a,(OFST+5,sp)
1253  0043 a102          	cp	a,#2
1254  0045 2706          	jreq	L631
1255  0047 7b07          	ld	a,(OFST+5,sp)
1256  0049 a103          	cp	a,#3
1257  004b 2603          	jrne	L431
1258  004d               L631:
1259  004d 4f            	clr	a
1260  004e 2010          	jra	L041
1261  0050               L431:
1262  0050 ae00de        	ldw	x,#222
1263  0053 89            	pushw	x
1264  0054 ae0000        	ldw	x,#0
1265  0057 89            	pushw	x
1266  0058 ae0000        	ldw	x,#L502
1267  005b cd0000        	call	_assert_failed
1269  005e 5b04          	addw	sp,#4
1270  0060               L041:
1271                     ; 223   assert_param(IS_TIM3_IC_PRESCALER_OK(TIM3_ICPrescaler));
1273  0060 0d08          	tnz	(OFST+6,sp)
1274  0062 2712          	jreq	L441
1275  0064 7b08          	ld	a,(OFST+6,sp)
1276  0066 a104          	cp	a,#4
1277  0068 270c          	jreq	L441
1278  006a 7b08          	ld	a,(OFST+6,sp)
1279  006c a108          	cp	a,#8
1280  006e 2706          	jreq	L441
1281  0070 7b08          	ld	a,(OFST+6,sp)
1282  0072 a10c          	cp	a,#12
1283  0074 2603          	jrne	L241
1284  0076               L441:
1285  0076 4f            	clr	a
1286  0077 2010          	jra	L641
1287  0079               L241:
1288  0079 ae00df        	ldw	x,#223
1289  007c 89            	pushw	x
1290  007d ae0000        	ldw	x,#0
1291  0080 89            	pushw	x
1292  0081 ae0000        	ldw	x,#L502
1293  0084 cd0000        	call	_assert_failed
1295  0087 5b04          	addw	sp,#4
1296  0089               L641:
1297                     ; 226   if (TIM3_ICPolarity != TIM3_ICPOLARITY_FALLING)
1299  0089 7b04          	ld	a,(OFST+2,sp)
1300  008b a144          	cp	a,#68
1301  008d 2706          	jreq	L714
1302                     ; 228     icpolarity = (uint8_t)TIM3_ICPOLARITY_FALLING;
1304  008f a644          	ld	a,#68
1305  0091 6b01          	ld	(OFST-1,sp),a
1307  0093 2002          	jra	L124
1308  0095               L714:
1309                     ; 232     icpolarity = (uint8_t)TIM3_ICPOLARITY_RISING;
1311  0095 0f01          	clr	(OFST-1,sp)
1312  0097               L124:
1313                     ; 236   if (TIM3_ICSelection == TIM3_ICSELECTION_DIRECTTI)
1315  0097 7b07          	ld	a,(OFST+5,sp)
1316  0099 a101          	cp	a,#1
1317  009b 2606          	jrne	L324
1318                     ; 238     icselection = (uint8_t)TIM3_ICSELECTION_INDIRECTTI;
1320  009d a602          	ld	a,#2
1321  009f 6b02          	ld	(OFST+0,sp),a
1323  00a1 2004          	jra	L524
1324  00a3               L324:
1325                     ; 242     icselection = (uint8_t)TIM3_ICSELECTION_DIRECTTI;
1327  00a3 a601          	ld	a,#1
1328  00a5 6b02          	ld	(OFST+0,sp),a
1329  00a7               L524:
1330                     ; 245   if (TIM3_Channel != TIM3_CHANNEL_2)
1332  00a7 7b03          	ld	a,(OFST+1,sp)
1333  00a9 a101          	cp	a,#1
1334  00ab 2726          	jreq	L724
1335                     ; 248     TI1_Config((uint8_t)TIM3_ICPolarity, (uint8_t)TIM3_ICSelection,
1335                     ; 249                (uint8_t)TIM3_ICFilter);
1337  00ad 7b09          	ld	a,(OFST+7,sp)
1338  00af 88            	push	a
1339  00b0 7b08          	ld	a,(OFST+6,sp)
1340  00b2 97            	ld	xl,a
1341  00b3 7b05          	ld	a,(OFST+3,sp)
1342  00b5 95            	ld	xh,a
1343  00b6 cd0000        	call	L3_TI1_Config
1345  00b9 84            	pop	a
1346                     ; 252     TIM3_SetIC1Prescaler(TIM3_ICPrescaler);
1348  00ba 7b08          	ld	a,(OFST+6,sp)
1349  00bc cd0000        	call	_TIM3_SetIC1Prescaler
1351                     ; 255     TI2_Config(icpolarity, icselection, TIM3_ICFilter);
1353  00bf 7b09          	ld	a,(OFST+7,sp)
1354  00c1 88            	push	a
1355  00c2 7b03          	ld	a,(OFST+1,sp)
1356  00c4 97            	ld	xl,a
1357  00c5 7b02          	ld	a,(OFST+0,sp)
1358  00c7 95            	ld	xh,a
1359  00c8 cd0000        	call	L5_TI2_Config
1361  00cb 84            	pop	a
1362                     ; 258     TIM3_SetIC2Prescaler(TIM3_ICPrescaler);
1364  00cc 7b08          	ld	a,(OFST+6,sp)
1365  00ce cd0000        	call	_TIM3_SetIC2Prescaler
1368  00d1 2024          	jra	L134
1369  00d3               L724:
1370                     ; 263     TI2_Config((uint8_t)TIM3_ICPolarity, (uint8_t)TIM3_ICSelection,
1370                     ; 264                (uint8_t)TIM3_ICFilter);
1372  00d3 7b09          	ld	a,(OFST+7,sp)
1373  00d5 88            	push	a
1374  00d6 7b08          	ld	a,(OFST+6,sp)
1375  00d8 97            	ld	xl,a
1376  00d9 7b05          	ld	a,(OFST+3,sp)
1377  00db 95            	ld	xh,a
1378  00dc cd0000        	call	L5_TI2_Config
1380  00df 84            	pop	a
1381                     ; 267     TIM3_SetIC2Prescaler(TIM3_ICPrescaler);
1383  00e0 7b08          	ld	a,(OFST+6,sp)
1384  00e2 cd0000        	call	_TIM3_SetIC2Prescaler
1386                     ; 270     TI1_Config(icpolarity, icselection, TIM3_ICFilter);
1388  00e5 7b09          	ld	a,(OFST+7,sp)
1389  00e7 88            	push	a
1390  00e8 7b03          	ld	a,(OFST+1,sp)
1391  00ea 97            	ld	xl,a
1392  00eb 7b02          	ld	a,(OFST+0,sp)
1393  00ed 95            	ld	xh,a
1394  00ee cd0000        	call	L3_TI1_Config
1396  00f1 84            	pop	a
1397                     ; 273     TIM3_SetIC1Prescaler(TIM3_ICPrescaler);
1399  00f2 7b08          	ld	a,(OFST+6,sp)
1400  00f4 cd0000        	call	_TIM3_SetIC1Prescaler
1402  00f7               L134:
1403                     ; 275 }
1406  00f7 5b04          	addw	sp,#4
1407  00f9 81            	ret
1463                     ; 283 void TIM3_Cmd(FunctionalState NewState)
1463                     ; 284 {
1464                     .text:	section	.text,new
1465  0000               _TIM3_Cmd:
1467  0000 88            	push	a
1468       00000000      OFST:	set	0
1471                     ; 286   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1473  0001 4d            	tnz	a
1474  0002 2704          	jreq	L451
1475  0004 a101          	cp	a,#1
1476  0006 2603          	jrne	L251
1477  0008               L451:
1478  0008 4f            	clr	a
1479  0009 2010          	jra	L651
1480  000b               L251:
1481  000b ae011e        	ldw	x,#286
1482  000e 89            	pushw	x
1483  000f ae0000        	ldw	x,#0
1484  0012 89            	pushw	x
1485  0013 ae0000        	ldw	x,#L502
1486  0016 cd0000        	call	_assert_failed
1488  0019 5b04          	addw	sp,#4
1489  001b               L651:
1490                     ; 289   if (NewState != DISABLE)
1492  001b 0d01          	tnz	(OFST+1,sp)
1493  001d 2706          	jreq	L164
1494                     ; 291     TIM3->CR1 |= (uint8_t)TIM3_CR1_CEN;
1496  001f 72105320      	bset	21280,#0
1498  0023 2004          	jra	L364
1499  0025               L164:
1500                     ; 295     TIM3->CR1 &= (uint8_t)(~TIM3_CR1_CEN);
1502  0025 72115320      	bres	21280,#0
1503  0029               L364:
1504                     ; 297 }
1507  0029 84            	pop	a
1508  002a 81            	ret
1581                     ; 311 void TIM3_ITConfig(TIM3_IT_TypeDef TIM3_IT, FunctionalState NewState)
1581                     ; 312 {
1582                     .text:	section	.text,new
1583  0000               _TIM3_ITConfig:
1585  0000 89            	pushw	x
1586       00000000      OFST:	set	0
1589                     ; 314   assert_param(IS_TIM3_IT_OK(TIM3_IT));
1591  0001 9e            	ld	a,xh
1592  0002 4d            	tnz	a
1593  0003 2708          	jreq	L261
1594  0005 9e            	ld	a,xh
1595  0006 a108          	cp	a,#8
1596  0008 2403          	jruge	L261
1597  000a 4f            	clr	a
1598  000b 2010          	jra	L461
1599  000d               L261:
1600  000d ae013a        	ldw	x,#314
1601  0010 89            	pushw	x
1602  0011 ae0000        	ldw	x,#0
1603  0014 89            	pushw	x
1604  0015 ae0000        	ldw	x,#L502
1605  0018 cd0000        	call	_assert_failed
1607  001b 5b04          	addw	sp,#4
1608  001d               L461:
1609                     ; 315   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1611  001d 0d02          	tnz	(OFST+2,sp)
1612  001f 2706          	jreq	L071
1613  0021 7b02          	ld	a,(OFST+2,sp)
1614  0023 a101          	cp	a,#1
1615  0025 2603          	jrne	L661
1616  0027               L071:
1617  0027 4f            	clr	a
1618  0028 2010          	jra	L271
1619  002a               L661:
1620  002a ae013b        	ldw	x,#315
1621  002d 89            	pushw	x
1622  002e ae0000        	ldw	x,#0
1623  0031 89            	pushw	x
1624  0032 ae0000        	ldw	x,#L502
1625  0035 cd0000        	call	_assert_failed
1627  0038 5b04          	addw	sp,#4
1628  003a               L271:
1629                     ; 317   if (NewState != DISABLE)
1631  003a 0d02          	tnz	(OFST+2,sp)
1632  003c 270a          	jreq	L125
1633                     ; 320     TIM3->IER |= (uint8_t)TIM3_IT;
1635  003e c65321        	ld	a,21281
1636  0041 1a01          	or	a,(OFST+1,sp)
1637  0043 c75321        	ld	21281,a
1639  0046 2009          	jra	L325
1640  0048               L125:
1641                     ; 325     TIM3->IER &= (uint8_t)(~TIM3_IT);
1643  0048 7b01          	ld	a,(OFST+1,sp)
1644  004a 43            	cpl	a
1645  004b c45321        	and	a,21281
1646  004e c75321        	ld	21281,a
1647  0051               L325:
1648                     ; 327 }
1651  0051 85            	popw	x
1652  0052 81            	ret
1689                     ; 335 void TIM3_UpdateDisableConfig(FunctionalState NewState)
1689                     ; 336 {
1690                     .text:	section	.text,new
1691  0000               _TIM3_UpdateDisableConfig:
1693  0000 88            	push	a
1694       00000000      OFST:	set	0
1697                     ; 338   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1699  0001 4d            	tnz	a
1700  0002 2704          	jreq	L002
1701  0004 a101          	cp	a,#1
1702  0006 2603          	jrne	L671
1703  0008               L002:
1704  0008 4f            	clr	a
1705  0009 2010          	jra	L202
1706  000b               L671:
1707  000b ae0152        	ldw	x,#338
1708  000e 89            	pushw	x
1709  000f ae0000        	ldw	x,#0
1710  0012 89            	pushw	x
1711  0013 ae0000        	ldw	x,#L502
1712  0016 cd0000        	call	_assert_failed
1714  0019 5b04          	addw	sp,#4
1715  001b               L202:
1716                     ; 341   if (NewState != DISABLE)
1718  001b 0d01          	tnz	(OFST+1,sp)
1719  001d 2706          	jreq	L345
1720                     ; 343     TIM3->CR1 |= TIM3_CR1_UDIS;
1722  001f 72125320      	bset	21280,#1
1724  0023 2004          	jra	L545
1725  0025               L345:
1726                     ; 347     TIM3->CR1 &= (uint8_t)(~TIM3_CR1_UDIS);
1728  0025 72135320      	bres	21280,#1
1729  0029               L545:
1730                     ; 349 }
1733  0029 84            	pop	a
1734  002a 81            	ret
1793                     ; 359 void TIM3_UpdateRequestConfig(TIM3_UpdateSource_TypeDef TIM3_UpdateSource)
1793                     ; 360 {
1794                     .text:	section	.text,new
1795  0000               _TIM3_UpdateRequestConfig:
1797  0000 88            	push	a
1798       00000000      OFST:	set	0
1801                     ; 362   assert_param(IS_TIM3_UPDATE_SOURCE_OK(TIM3_UpdateSource));
1803  0001 4d            	tnz	a
1804  0002 2704          	jreq	L012
1805  0004 a101          	cp	a,#1
1806  0006 2603          	jrne	L602
1807  0008               L012:
1808  0008 4f            	clr	a
1809  0009 2010          	jra	L212
1810  000b               L602:
1811  000b ae016a        	ldw	x,#362
1812  000e 89            	pushw	x
1813  000f ae0000        	ldw	x,#0
1814  0012 89            	pushw	x
1815  0013 ae0000        	ldw	x,#L502
1816  0016 cd0000        	call	_assert_failed
1818  0019 5b04          	addw	sp,#4
1819  001b               L212:
1820                     ; 365   if (TIM3_UpdateSource != TIM3_UPDATESOURCE_GLOBAL)
1822  001b 0d01          	tnz	(OFST+1,sp)
1823  001d 2706          	jreq	L575
1824                     ; 367     TIM3->CR1 |= TIM3_CR1_URS;
1826  001f 72145320      	bset	21280,#2
1828  0023 2004          	jra	L775
1829  0025               L575:
1830                     ; 371     TIM3->CR1 &= (uint8_t)(~TIM3_CR1_URS);
1832  0025 72155320      	bres	21280,#2
1833  0029               L775:
1834                     ; 373 }
1837  0029 84            	pop	a
1838  002a 81            	ret
1896                     ; 383 void TIM3_SelectOnePulseMode(TIM3_OPMode_TypeDef TIM3_OPMode)
1896                     ; 384 {
1897                     .text:	section	.text,new
1898  0000               _TIM3_SelectOnePulseMode:
1900  0000 88            	push	a
1901       00000000      OFST:	set	0
1904                     ; 386   assert_param(IS_TIM3_OPM_MODE_OK(TIM3_OPMode));
1906  0001 a101          	cp	a,#1
1907  0003 2703          	jreq	L022
1908  0005 4d            	tnz	a
1909  0006 2603          	jrne	L612
1910  0008               L022:
1911  0008 4f            	clr	a
1912  0009 2010          	jra	L222
1913  000b               L612:
1914  000b ae0182        	ldw	x,#386
1915  000e 89            	pushw	x
1916  000f ae0000        	ldw	x,#0
1917  0012 89            	pushw	x
1918  0013 ae0000        	ldw	x,#L502
1919  0016 cd0000        	call	_assert_failed
1921  0019 5b04          	addw	sp,#4
1922  001b               L222:
1923                     ; 389   if (TIM3_OPMode != TIM3_OPMODE_REPETITIVE)
1925  001b 0d01          	tnz	(OFST+1,sp)
1926  001d 2706          	jreq	L726
1927                     ; 391     TIM3->CR1 |= TIM3_CR1_OPM;
1929  001f 72165320      	bset	21280,#3
1931  0023 2004          	jra	L136
1932  0025               L726:
1933                     ; 395     TIM3->CR1 &= (uint8_t)(~TIM3_CR1_OPM);
1935  0025 72175320      	bres	21280,#3
1936  0029               L136:
1937                     ; 397 }
1940  0029 84            	pop	a
1941  002a 81            	ret
2010                     ; 427 void TIM3_PrescalerConfig(TIM3_Prescaler_TypeDef Prescaler,
2010                     ; 428                           TIM3_PSCReloadMode_TypeDef TIM3_PSCReloadMode)
2010                     ; 429 {
2011                     .text:	section	.text,new
2012  0000               _TIM3_PrescalerConfig:
2014  0000 89            	pushw	x
2015       00000000      OFST:	set	0
2018                     ; 431   assert_param(IS_TIM3_PRESCALER_RELOAD_OK(TIM3_PSCReloadMode));
2020  0001 9f            	ld	a,xl
2021  0002 4d            	tnz	a
2022  0003 2705          	jreq	L032
2023  0005 9f            	ld	a,xl
2024  0006 a101          	cp	a,#1
2025  0008 2603          	jrne	L622
2026  000a               L032:
2027  000a 4f            	clr	a
2028  000b 2010          	jra	L232
2029  000d               L622:
2030  000d ae01af        	ldw	x,#431
2031  0010 89            	pushw	x
2032  0011 ae0000        	ldw	x,#0
2033  0014 89            	pushw	x
2034  0015 ae0000        	ldw	x,#L502
2035  0018 cd0000        	call	_assert_failed
2037  001b 5b04          	addw	sp,#4
2038  001d               L232:
2039                     ; 432   assert_param(IS_TIM3_PRESCALER_OK(Prescaler));
2041  001d 0d01          	tnz	(OFST+1,sp)
2042  001f 275a          	jreq	L632
2043  0021 7b01          	ld	a,(OFST+1,sp)
2044  0023 a101          	cp	a,#1
2045  0025 2754          	jreq	L632
2046  0027 7b01          	ld	a,(OFST+1,sp)
2047  0029 a102          	cp	a,#2
2048  002b 274e          	jreq	L632
2049  002d 7b01          	ld	a,(OFST+1,sp)
2050  002f a103          	cp	a,#3
2051  0031 2748          	jreq	L632
2052  0033 7b01          	ld	a,(OFST+1,sp)
2053  0035 a104          	cp	a,#4
2054  0037 2742          	jreq	L632
2055  0039 7b01          	ld	a,(OFST+1,sp)
2056  003b a105          	cp	a,#5
2057  003d 273c          	jreq	L632
2058  003f 7b01          	ld	a,(OFST+1,sp)
2059  0041 a106          	cp	a,#6
2060  0043 2736          	jreq	L632
2061  0045 7b01          	ld	a,(OFST+1,sp)
2062  0047 a107          	cp	a,#7
2063  0049 2730          	jreq	L632
2064  004b 7b01          	ld	a,(OFST+1,sp)
2065  004d a108          	cp	a,#8
2066  004f 272a          	jreq	L632
2067  0051 7b01          	ld	a,(OFST+1,sp)
2068  0053 a109          	cp	a,#9
2069  0055 2724          	jreq	L632
2070  0057 7b01          	ld	a,(OFST+1,sp)
2071  0059 a10a          	cp	a,#10
2072  005b 271e          	jreq	L632
2073  005d 7b01          	ld	a,(OFST+1,sp)
2074  005f a10b          	cp	a,#11
2075  0061 2718          	jreq	L632
2076  0063 7b01          	ld	a,(OFST+1,sp)
2077  0065 a10c          	cp	a,#12
2078  0067 2712          	jreq	L632
2079  0069 7b01          	ld	a,(OFST+1,sp)
2080  006b a10d          	cp	a,#13
2081  006d 270c          	jreq	L632
2082  006f 7b01          	ld	a,(OFST+1,sp)
2083  0071 a10e          	cp	a,#14
2084  0073 2706          	jreq	L632
2085  0075 7b01          	ld	a,(OFST+1,sp)
2086  0077 a10f          	cp	a,#15
2087  0079 2603          	jrne	L432
2088  007b               L632:
2089  007b 4f            	clr	a
2090  007c 2010          	jra	L042
2091  007e               L432:
2092  007e ae01b0        	ldw	x,#432
2093  0081 89            	pushw	x
2094  0082 ae0000        	ldw	x,#0
2095  0085 89            	pushw	x
2096  0086 ae0000        	ldw	x,#L502
2097  0089 cd0000        	call	_assert_failed
2099  008c 5b04          	addw	sp,#4
2100  008e               L042:
2101                     ; 435   TIM3->PSCR = (uint8_t)Prescaler;
2103  008e 7b01          	ld	a,(OFST+1,sp)
2104  0090 c7532a        	ld	21290,a
2105                     ; 438   TIM3->EGR = (uint8_t)TIM3_PSCReloadMode;
2107  0093 7b02          	ld	a,(OFST+2,sp)
2108  0095 c75324        	ld	21284,a
2109                     ; 439 }
2112  0098 85            	popw	x
2113  0099 81            	ret
2172                     ; 450 void TIM3_ForcedOC1Config(TIM3_ForcedAction_TypeDef TIM3_ForcedAction)
2172                     ; 451 {
2173                     .text:	section	.text,new
2174  0000               _TIM3_ForcedOC1Config:
2176  0000 88            	push	a
2177       00000000      OFST:	set	0
2180                     ; 453   assert_param(IS_TIM3_FORCED_ACTION_OK(TIM3_ForcedAction));
2182  0001 a150          	cp	a,#80
2183  0003 2704          	jreq	L642
2184  0005 a140          	cp	a,#64
2185  0007 2603          	jrne	L442
2186  0009               L642:
2187  0009 4f            	clr	a
2188  000a 2010          	jra	L052
2189  000c               L442:
2190  000c ae01c5        	ldw	x,#453
2191  000f 89            	pushw	x
2192  0010 ae0000        	ldw	x,#0
2193  0013 89            	pushw	x
2194  0014 ae0000        	ldw	x,#L502
2195  0017 cd0000        	call	_assert_failed
2197  001a 5b04          	addw	sp,#4
2198  001c               L052:
2199                     ; 456   TIM3->CCMR1 =  (uint8_t)((uint8_t)(TIM3->CCMR1 & (uint8_t)(~TIM3_CCMR_OCM))  | (uint8_t)TIM3_ForcedAction);
2201  001c c65325        	ld	a,21285
2202  001f a48f          	and	a,#143
2203  0021 1a01          	or	a,(OFST+1,sp)
2204  0023 c75325        	ld	21285,a
2205                     ; 457 }
2208  0026 84            	pop	a
2209  0027 81            	ret
2246                     ; 468 void TIM3_ForcedOC2Config(TIM3_ForcedAction_TypeDef TIM3_ForcedAction)
2246                     ; 469 {
2247                     .text:	section	.text,new
2248  0000               _TIM3_ForcedOC2Config:
2250  0000 88            	push	a
2251       00000000      OFST:	set	0
2254                     ; 471   assert_param(IS_TIM3_FORCED_ACTION_OK(TIM3_ForcedAction));
2256  0001 a150          	cp	a,#80
2257  0003 2704          	jreq	L652
2258  0005 a140          	cp	a,#64
2259  0007 2603          	jrne	L452
2260  0009               L652:
2261  0009 4f            	clr	a
2262  000a 2010          	jra	L062
2263  000c               L452:
2264  000c ae01d7        	ldw	x,#471
2265  000f 89            	pushw	x
2266  0010 ae0000        	ldw	x,#0
2267  0013 89            	pushw	x
2268  0014 ae0000        	ldw	x,#L502
2269  0017 cd0000        	call	_assert_failed
2271  001a 5b04          	addw	sp,#4
2272  001c               L062:
2273                     ; 474   TIM3->CCMR2 =  (uint8_t)((uint8_t)(TIM3->CCMR2 & (uint8_t)(~TIM3_CCMR_OCM)) | (uint8_t)TIM3_ForcedAction);
2275  001c c65326        	ld	a,21286
2276  001f a48f          	and	a,#143
2277  0021 1a01          	or	a,(OFST+1,sp)
2278  0023 c75326        	ld	21286,a
2279                     ; 475 }
2282  0026 84            	pop	a
2283  0027 81            	ret
2320                     ; 483 void TIM3_ARRPreloadConfig(FunctionalState NewState)
2320                     ; 484 {
2321                     .text:	section	.text,new
2322  0000               _TIM3_ARRPreloadConfig:
2324  0000 88            	push	a
2325       00000000      OFST:	set	0
2328                     ; 486   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2330  0001 4d            	tnz	a
2331  0002 2704          	jreq	L662
2332  0004 a101          	cp	a,#1
2333  0006 2603          	jrne	L462
2334  0008               L662:
2335  0008 4f            	clr	a
2336  0009 2010          	jra	L072
2337  000b               L462:
2338  000b ae01e6        	ldw	x,#486
2339  000e 89            	pushw	x
2340  000f ae0000        	ldw	x,#0
2341  0012 89            	pushw	x
2342  0013 ae0000        	ldw	x,#L502
2343  0016 cd0000        	call	_assert_failed
2345  0019 5b04          	addw	sp,#4
2346  001b               L072:
2347                     ; 489   if (NewState != DISABLE)
2349  001b 0d01          	tnz	(OFST+1,sp)
2350  001d 2706          	jreq	L747
2351                     ; 491     TIM3->CR1 |= TIM3_CR1_ARPE;
2353  001f 721e5320      	bset	21280,#7
2355  0023 2004          	jra	L157
2356  0025               L747:
2357                     ; 495     TIM3->CR1 &= (uint8_t)(~TIM3_CR1_ARPE);
2359  0025 721f5320      	bres	21280,#7
2360  0029               L157:
2361                     ; 497 }
2364  0029 84            	pop	a
2365  002a 81            	ret
2402                     ; 505 void TIM3_OC1PreloadConfig(FunctionalState NewState)
2402                     ; 506 {
2403                     .text:	section	.text,new
2404  0000               _TIM3_OC1PreloadConfig:
2406  0000 88            	push	a
2407       00000000      OFST:	set	0
2410                     ; 508   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2412  0001 4d            	tnz	a
2413  0002 2704          	jreq	L672
2414  0004 a101          	cp	a,#1
2415  0006 2603          	jrne	L472
2416  0008               L672:
2417  0008 4f            	clr	a
2418  0009 2010          	jra	L003
2419  000b               L472:
2420  000b ae01fc        	ldw	x,#508
2421  000e 89            	pushw	x
2422  000f ae0000        	ldw	x,#0
2423  0012 89            	pushw	x
2424  0013 ae0000        	ldw	x,#L502
2425  0016 cd0000        	call	_assert_failed
2427  0019 5b04          	addw	sp,#4
2428  001b               L003:
2429                     ; 511   if (NewState != DISABLE)
2431  001b 0d01          	tnz	(OFST+1,sp)
2432  001d 2706          	jreq	L177
2433                     ; 513     TIM3->CCMR1 |= TIM3_CCMR_OCxPE;
2435  001f 72165325      	bset	21285,#3
2437  0023 2004          	jra	L377
2438  0025               L177:
2439                     ; 517     TIM3->CCMR1 &= (uint8_t)(~TIM3_CCMR_OCxPE);
2441  0025 72175325      	bres	21285,#3
2442  0029               L377:
2443                     ; 519 }
2446  0029 84            	pop	a
2447  002a 81            	ret
2484                     ; 527 void TIM3_OC2PreloadConfig(FunctionalState NewState)
2484                     ; 528 {
2485                     .text:	section	.text,new
2486  0000               _TIM3_OC2PreloadConfig:
2488  0000 88            	push	a
2489       00000000      OFST:	set	0
2492                     ; 530   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2494  0001 4d            	tnz	a
2495  0002 2704          	jreq	L603
2496  0004 a101          	cp	a,#1
2497  0006 2603          	jrne	L403
2498  0008               L603:
2499  0008 4f            	clr	a
2500  0009 2010          	jra	L013
2501  000b               L403:
2502  000b ae0212        	ldw	x,#530
2503  000e 89            	pushw	x
2504  000f ae0000        	ldw	x,#0
2505  0012 89            	pushw	x
2506  0013 ae0000        	ldw	x,#L502
2507  0016 cd0000        	call	_assert_failed
2509  0019 5b04          	addw	sp,#4
2510  001b               L013:
2511                     ; 533   if (NewState != DISABLE)
2513  001b 0d01          	tnz	(OFST+1,sp)
2514  001d 2706          	jreq	L3101
2515                     ; 535     TIM3->CCMR2 |= TIM3_CCMR_OCxPE;
2517  001f 72165326      	bset	21286,#3
2519  0023 2004          	jra	L5101
2520  0025               L3101:
2521                     ; 539     TIM3->CCMR2 &= (uint8_t)(~TIM3_CCMR_OCxPE);
2523  0025 72175326      	bres	21286,#3
2524  0029               L5101:
2525                     ; 541 }
2528  0029 84            	pop	a
2529  002a 81            	ret
2595                     ; 552 void TIM3_GenerateEvent(TIM3_EventSource_TypeDef TIM3_EventSource)
2595                     ; 553 {
2596                     .text:	section	.text,new
2597  0000               _TIM3_GenerateEvent:
2599  0000 88            	push	a
2600       00000000      OFST:	set	0
2603                     ; 555   assert_param(IS_TIM3_EVENT_SOURCE_OK(TIM3_EventSource));
2605  0001 4d            	tnz	a
2606  0002 2703          	jreq	L413
2607  0004 4f            	clr	a
2608  0005 2010          	jra	L613
2609  0007               L413:
2610  0007 ae022b        	ldw	x,#555
2611  000a 89            	pushw	x
2612  000b ae0000        	ldw	x,#0
2613  000e 89            	pushw	x
2614  000f ae0000        	ldw	x,#L502
2615  0012 cd0000        	call	_assert_failed
2617  0015 5b04          	addw	sp,#4
2618  0017               L613:
2619                     ; 558   TIM3->EGR = (uint8_t)TIM3_EventSource;
2621  0017 7b01          	ld	a,(OFST+1,sp)
2622  0019 c75324        	ld	21284,a
2623                     ; 559 }
2626  001c 84            	pop	a
2627  001d 81            	ret
2664                     ; 569 void TIM3_OC1PolarityConfig(TIM3_OCPolarity_TypeDef TIM3_OCPolarity)
2664                     ; 570 {
2665                     .text:	section	.text,new
2666  0000               _TIM3_OC1PolarityConfig:
2668  0000 88            	push	a
2669       00000000      OFST:	set	0
2672                     ; 572   assert_param(IS_TIM3_OC_POLARITY_OK(TIM3_OCPolarity));
2674  0001 4d            	tnz	a
2675  0002 2704          	jreq	L423
2676  0004 a122          	cp	a,#34
2677  0006 2603          	jrne	L223
2678  0008               L423:
2679  0008 4f            	clr	a
2680  0009 2010          	jra	L623
2681  000b               L223:
2682  000b ae023c        	ldw	x,#572
2683  000e 89            	pushw	x
2684  000f ae0000        	ldw	x,#0
2685  0012 89            	pushw	x
2686  0013 ae0000        	ldw	x,#L502
2687  0016 cd0000        	call	_assert_failed
2689  0019 5b04          	addw	sp,#4
2690  001b               L623:
2691                     ; 575   if (TIM3_OCPolarity != TIM3_OCPOLARITY_HIGH)
2693  001b 0d01          	tnz	(OFST+1,sp)
2694  001d 2706          	jreq	L5601
2695                     ; 577     TIM3->CCER1 |= TIM3_CCER1_CC1P;
2697  001f 72125327      	bset	21287,#1
2699  0023 2004          	jra	L7601
2700  0025               L5601:
2701                     ; 581     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1P);
2703  0025 72135327      	bres	21287,#1
2704  0029               L7601:
2705                     ; 583 }
2708  0029 84            	pop	a
2709  002a 81            	ret
2746                     ; 593 void TIM3_OC2PolarityConfig(TIM3_OCPolarity_TypeDef TIM3_OCPolarity)
2746                     ; 594 {
2747                     .text:	section	.text,new
2748  0000               _TIM3_OC2PolarityConfig:
2750  0000 88            	push	a
2751       00000000      OFST:	set	0
2754                     ; 596   assert_param(IS_TIM3_OC_POLARITY_OK(TIM3_OCPolarity));
2756  0001 4d            	tnz	a
2757  0002 2704          	jreq	L433
2758  0004 a122          	cp	a,#34
2759  0006 2603          	jrne	L233
2760  0008               L433:
2761  0008 4f            	clr	a
2762  0009 2010          	jra	L633
2763  000b               L233:
2764  000b ae0254        	ldw	x,#596
2765  000e 89            	pushw	x
2766  000f ae0000        	ldw	x,#0
2767  0012 89            	pushw	x
2768  0013 ae0000        	ldw	x,#L502
2769  0016 cd0000        	call	_assert_failed
2771  0019 5b04          	addw	sp,#4
2772  001b               L633:
2773                     ; 599   if (TIM3_OCPolarity != TIM3_OCPOLARITY_HIGH)
2775  001b 0d01          	tnz	(OFST+1,sp)
2776  001d 2706          	jreq	L7011
2777                     ; 601     TIM3->CCER1 |= TIM3_CCER1_CC2P;
2779  001f 721a5327      	bset	21287,#5
2781  0023 2004          	jra	L1111
2782  0025               L7011:
2783                     ; 605     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC2P);
2785  0025 721b5327      	bres	21287,#5
2786  0029               L1111:
2787                     ; 607 }
2790  0029 84            	pop	a
2791  002a 81            	ret
2837                     ; 619 void TIM3_CCxCmd(TIM3_Channel_TypeDef TIM3_Channel, FunctionalState NewState)
2837                     ; 620 {
2838                     .text:	section	.text,new
2839  0000               _TIM3_CCxCmd:
2841  0000 89            	pushw	x
2842       00000000      OFST:	set	0
2845                     ; 622   assert_param(IS_TIM3_CHANNEL_OK(TIM3_Channel));
2847  0001 9e            	ld	a,xh
2848  0002 4d            	tnz	a
2849  0003 2705          	jreq	L443
2850  0005 9e            	ld	a,xh
2851  0006 a101          	cp	a,#1
2852  0008 2603          	jrne	L243
2853  000a               L443:
2854  000a 4f            	clr	a
2855  000b 2010          	jra	L643
2856  000d               L243:
2857  000d ae026e        	ldw	x,#622
2858  0010 89            	pushw	x
2859  0011 ae0000        	ldw	x,#0
2860  0014 89            	pushw	x
2861  0015 ae0000        	ldw	x,#L502
2862  0018 cd0000        	call	_assert_failed
2864  001b 5b04          	addw	sp,#4
2865  001d               L643:
2866                     ; 623   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2868  001d 0d02          	tnz	(OFST+2,sp)
2869  001f 2706          	jreq	L253
2870  0021 7b02          	ld	a,(OFST+2,sp)
2871  0023 a101          	cp	a,#1
2872  0025 2603          	jrne	L053
2873  0027               L253:
2874  0027 4f            	clr	a
2875  0028 2010          	jra	L453
2876  002a               L053:
2877  002a ae026f        	ldw	x,#623
2878  002d 89            	pushw	x
2879  002e ae0000        	ldw	x,#0
2880  0031 89            	pushw	x
2881  0032 ae0000        	ldw	x,#L502
2882  0035 cd0000        	call	_assert_failed
2884  0038 5b04          	addw	sp,#4
2885  003a               L453:
2886                     ; 625   if (TIM3_Channel == TIM3_CHANNEL_1)
2888  003a 0d01          	tnz	(OFST+1,sp)
2889  003c 2610          	jrne	L5311
2890                     ; 628     if (NewState != DISABLE)
2892  003e 0d02          	tnz	(OFST+2,sp)
2893  0040 2706          	jreq	L7311
2894                     ; 630       TIM3->CCER1 |= TIM3_CCER1_CC1E;
2896  0042 72105327      	bset	21287,#0
2898  0046 2014          	jra	L3411
2899  0048               L7311:
2900                     ; 634       TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1E);
2902  0048 72115327      	bres	21287,#0
2903  004c 200e          	jra	L3411
2904  004e               L5311:
2905                     ; 641     if (NewState != DISABLE)
2907  004e 0d02          	tnz	(OFST+2,sp)
2908  0050 2706          	jreq	L5411
2909                     ; 643       TIM3->CCER1 |= TIM3_CCER1_CC2E;
2911  0052 72185327      	bset	21287,#4
2913  0056 2004          	jra	L3411
2914  0058               L5411:
2915                     ; 647       TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC2E);
2917  0058 72195327      	bres	21287,#4
2918  005c               L3411:
2919                     ; 650 }
2922  005c 85            	popw	x
2923  005d 81            	ret
2969                     ; 671 void TIM3_SelectOCxM(TIM3_Channel_TypeDef TIM3_Channel, TIM3_OCMode_TypeDef TIM3_OCMode)
2969                     ; 672 {
2970                     .text:	section	.text,new
2971  0000               _TIM3_SelectOCxM:
2973  0000 89            	pushw	x
2974       00000000      OFST:	set	0
2977                     ; 674   assert_param(IS_TIM3_CHANNEL_OK(TIM3_Channel));
2979  0001 9e            	ld	a,xh
2980  0002 4d            	tnz	a
2981  0003 2705          	jreq	L263
2982  0005 9e            	ld	a,xh
2983  0006 a101          	cp	a,#1
2984  0008 2603          	jrne	L063
2985  000a               L263:
2986  000a 4f            	clr	a
2987  000b 2010          	jra	L463
2988  000d               L063:
2989  000d ae02a2        	ldw	x,#674
2990  0010 89            	pushw	x
2991  0011 ae0000        	ldw	x,#0
2992  0014 89            	pushw	x
2993  0015 ae0000        	ldw	x,#L502
2994  0018 cd0000        	call	_assert_failed
2996  001b 5b04          	addw	sp,#4
2997  001d               L463:
2998                     ; 675   assert_param(IS_TIM3_OCM_OK(TIM3_OCMode));
3000  001d 0d02          	tnz	(OFST+2,sp)
3001  001f 272a          	jreq	L073
3002  0021 7b02          	ld	a,(OFST+2,sp)
3003  0023 a110          	cp	a,#16
3004  0025 2724          	jreq	L073
3005  0027 7b02          	ld	a,(OFST+2,sp)
3006  0029 a120          	cp	a,#32
3007  002b 271e          	jreq	L073
3008  002d 7b02          	ld	a,(OFST+2,sp)
3009  002f a130          	cp	a,#48
3010  0031 2718          	jreq	L073
3011  0033 7b02          	ld	a,(OFST+2,sp)
3012  0035 a160          	cp	a,#96
3013  0037 2712          	jreq	L073
3014  0039 7b02          	ld	a,(OFST+2,sp)
3015  003b a170          	cp	a,#112
3016  003d 270c          	jreq	L073
3017  003f 7b02          	ld	a,(OFST+2,sp)
3018  0041 a150          	cp	a,#80
3019  0043 2706          	jreq	L073
3020  0045 7b02          	ld	a,(OFST+2,sp)
3021  0047 a140          	cp	a,#64
3022  0049 2603          	jrne	L663
3023  004b               L073:
3024  004b 4f            	clr	a
3025  004c 2010          	jra	L273
3026  004e               L663:
3027  004e ae02a3        	ldw	x,#675
3028  0051 89            	pushw	x
3029  0052 ae0000        	ldw	x,#0
3030  0055 89            	pushw	x
3031  0056 ae0000        	ldw	x,#L502
3032  0059 cd0000        	call	_assert_failed
3034  005c 5b04          	addw	sp,#4
3035  005e               L273:
3036                     ; 677   if (TIM3_Channel == TIM3_CHANNEL_1)
3038  005e 0d01          	tnz	(OFST+1,sp)
3039  0060 2610          	jrne	L3711
3040                     ; 680     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1E);
3042  0062 72115327      	bres	21287,#0
3043                     ; 683     TIM3->CCMR1 = (uint8_t)((uint8_t)(TIM3->CCMR1 & (uint8_t)(~TIM3_CCMR_OCM)) | (uint8_t)TIM3_OCMode);
3045  0066 c65325        	ld	a,21285
3046  0069 a48f          	and	a,#143
3047  006b 1a02          	or	a,(OFST+2,sp)
3048  006d c75325        	ld	21285,a
3050  0070 200e          	jra	L5711
3051  0072               L3711:
3052                     ; 688     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC2E);
3054  0072 72195327      	bres	21287,#4
3055                     ; 691     TIM3->CCMR2 = (uint8_t)((uint8_t)(TIM3->CCMR2 & (uint8_t)(~TIM3_CCMR_OCM)) | (uint8_t)TIM3_OCMode);
3057  0076 c65326        	ld	a,21286
3058  0079 a48f          	and	a,#143
3059  007b 1a02          	or	a,(OFST+2,sp)
3060  007d c75326        	ld	21286,a
3061  0080               L5711:
3062                     ; 693 }
3065  0080 85            	popw	x
3066  0081 81            	ret
3100                     ; 701 void TIM3_SetCounter(uint16_t Counter)
3100                     ; 702 {
3101                     .text:	section	.text,new
3102  0000               _TIM3_SetCounter:
3106                     ; 704   TIM3->CNTRH = (uint8_t)(Counter >> 8);
3108  0000 9e            	ld	a,xh
3109  0001 c75328        	ld	21288,a
3110                     ; 705   TIM3->CNTRL = (uint8_t)(Counter);
3112  0004 9f            	ld	a,xl
3113  0005 c75329        	ld	21289,a
3114                     ; 706 }
3117  0008 81            	ret
3151                     ; 714 void TIM3_SetAutoreload(uint16_t Autoreload)
3151                     ; 715 {
3152                     .text:	section	.text,new
3153  0000               _TIM3_SetAutoreload:
3157                     ; 717   TIM3->ARRH = (uint8_t)(Autoreload >> 8);
3159  0000 9e            	ld	a,xh
3160  0001 c7532b        	ld	21291,a
3161                     ; 718   TIM3->ARRL = (uint8_t)(Autoreload);
3163  0004 9f            	ld	a,xl
3164  0005 c7532c        	ld	21292,a
3165                     ; 719 }
3168  0008 81            	ret
3202                     ; 727 void TIM3_SetCompare1(uint16_t Compare1)
3202                     ; 728 {
3203                     .text:	section	.text,new
3204  0000               _TIM3_SetCompare1:
3208                     ; 730   TIM3->CCR1H = (uint8_t)(Compare1 >> 8);
3210  0000 9e            	ld	a,xh
3211  0001 c7532d        	ld	21293,a
3212                     ; 731   TIM3->CCR1L = (uint8_t)(Compare1);
3214  0004 9f            	ld	a,xl
3215  0005 c7532e        	ld	21294,a
3216                     ; 732 }
3219  0008 81            	ret
3253                     ; 740 void TIM3_SetCompare2(uint16_t Compare2)
3253                     ; 741 {
3254                     .text:	section	.text,new
3255  0000               _TIM3_SetCompare2:
3259                     ; 743   TIM3->CCR2H = (uint8_t)(Compare2 >> 8);
3261  0000 9e            	ld	a,xh
3262  0001 c7532f        	ld	21295,a
3263                     ; 744   TIM3->CCR2L = (uint8_t)(Compare2);
3265  0004 9f            	ld	a,xl
3266  0005 c75330        	ld	21296,a
3267                     ; 745 }
3270  0008 81            	ret
3307                     ; 757 void TIM3_SetIC1Prescaler(TIM3_ICPSC_TypeDef TIM3_IC1Prescaler)
3307                     ; 758 {
3308                     .text:	section	.text,new
3309  0000               _TIM3_SetIC1Prescaler:
3311  0000 88            	push	a
3312       00000000      OFST:	set	0
3315                     ; 760   assert_param(IS_TIM3_IC_PRESCALER_OK(TIM3_IC1Prescaler));
3317  0001 4d            	tnz	a
3318  0002 270c          	jreq	L014
3319  0004 a104          	cp	a,#4
3320  0006 2708          	jreq	L014
3321  0008 a108          	cp	a,#8
3322  000a 2704          	jreq	L014
3323  000c a10c          	cp	a,#12
3324  000e 2603          	jrne	L604
3325  0010               L014:
3326  0010 4f            	clr	a
3327  0011 2010          	jra	L214
3328  0013               L604:
3329  0013 ae02f8        	ldw	x,#760
3330  0016 89            	pushw	x
3331  0017 ae0000        	ldw	x,#0
3332  001a 89            	pushw	x
3333  001b ae0000        	ldw	x,#L502
3334  001e cd0000        	call	_assert_failed
3336  0021 5b04          	addw	sp,#4
3337  0023               L214:
3338                     ; 763   TIM3->CCMR1 = (uint8_t)((uint8_t)(TIM3->CCMR1 & (uint8_t)(~TIM3_CCMR_ICxPSC)) | (uint8_t)TIM3_IC1Prescaler);
3340  0023 c65325        	ld	a,21285
3341  0026 a4f3          	and	a,#243
3342  0028 1a01          	or	a,(OFST+1,sp)
3343  002a c75325        	ld	21285,a
3344                     ; 764 }
3347  002d 84            	pop	a
3348  002e 81            	ret
3385                     ; 776 void TIM3_SetIC2Prescaler(TIM3_ICPSC_TypeDef TIM3_IC2Prescaler)
3385                     ; 777 {
3386                     .text:	section	.text,new
3387  0000               _TIM3_SetIC2Prescaler:
3389  0000 88            	push	a
3390       00000000      OFST:	set	0
3393                     ; 779   assert_param(IS_TIM3_IC_PRESCALER_OK(TIM3_IC2Prescaler));
3395  0001 4d            	tnz	a
3396  0002 270c          	jreq	L024
3397  0004 a104          	cp	a,#4
3398  0006 2708          	jreq	L024
3399  0008 a108          	cp	a,#8
3400  000a 2704          	jreq	L024
3401  000c a10c          	cp	a,#12
3402  000e 2603          	jrne	L614
3403  0010               L024:
3404  0010 4f            	clr	a
3405  0011 2010          	jra	L224
3406  0013               L614:
3407  0013 ae030b        	ldw	x,#779
3408  0016 89            	pushw	x
3409  0017 ae0000        	ldw	x,#0
3410  001a 89            	pushw	x
3411  001b ae0000        	ldw	x,#L502
3412  001e cd0000        	call	_assert_failed
3414  0021 5b04          	addw	sp,#4
3415  0023               L224:
3416                     ; 782   TIM3->CCMR2 = (uint8_t)((uint8_t)(TIM3->CCMR2 & (uint8_t)(~TIM3_CCMR_ICxPSC)) | (uint8_t)TIM3_IC2Prescaler);
3418  0023 c65326        	ld	a,21286
3419  0026 a4f3          	and	a,#243
3420  0028 1a01          	or	a,(OFST+1,sp)
3421  002a c75326        	ld	21286,a
3422                     ; 783 }
3425  002d 84            	pop	a
3426  002e 81            	ret
3478                     ; 790 uint16_t TIM3_GetCapture1(void)
3478                     ; 791 {
3479                     .text:	section	.text,new
3480  0000               _TIM3_GetCapture1:
3482  0000 5204          	subw	sp,#4
3483       00000004      OFST:	set	4
3486                     ; 793   uint16_t tmpccr1 = 0;
3488                     ; 794   uint8_t tmpccr1l=0, tmpccr1h=0;
3492                     ; 796   tmpccr1h = TIM3->CCR1H;
3494  0002 c6532d        	ld	a,21293
3495  0005 6b02          	ld	(OFST-2,sp),a
3496                     ; 797   tmpccr1l = TIM3->CCR1L;
3498  0007 c6532e        	ld	a,21294
3499  000a 6b01          	ld	(OFST-3,sp),a
3500                     ; 799   tmpccr1 = (uint16_t)(tmpccr1l);
3502  000c 7b01          	ld	a,(OFST-3,sp)
3503  000e 5f            	clrw	x
3504  000f 97            	ld	xl,a
3505  0010 1f03          	ldw	(OFST-1,sp),x
3506                     ; 800   tmpccr1 |= (uint16_t)((uint16_t)tmpccr1h << 8);
3508  0012 7b02          	ld	a,(OFST-2,sp)
3509  0014 5f            	clrw	x
3510  0015 97            	ld	xl,a
3511  0016 4f            	clr	a
3512  0017 02            	rlwa	x,a
3513  0018 01            	rrwa	x,a
3514  0019 1a04          	or	a,(OFST+0,sp)
3515  001b 01            	rrwa	x,a
3516  001c 1a03          	or	a,(OFST-1,sp)
3517  001e 01            	rrwa	x,a
3518  001f 1f03          	ldw	(OFST-1,sp),x
3519                     ; 802   return (uint16_t)tmpccr1;
3521  0021 1e03          	ldw	x,(OFST-1,sp)
3524  0023 5b04          	addw	sp,#4
3525  0025 81            	ret
3577                     ; 810 uint16_t TIM3_GetCapture2(void)
3577                     ; 811 {
3578                     .text:	section	.text,new
3579  0000               _TIM3_GetCapture2:
3581  0000 5204          	subw	sp,#4
3582       00000004      OFST:	set	4
3585                     ; 813   uint16_t tmpccr2 = 0;
3587                     ; 814   uint8_t tmpccr2l=0, tmpccr2h=0;
3591                     ; 816   tmpccr2h = TIM3->CCR2H;
3593  0002 c6532f        	ld	a,21295
3594  0005 6b02          	ld	(OFST-2,sp),a
3595                     ; 817   tmpccr2l = TIM3->CCR2L;
3597  0007 c65330        	ld	a,21296
3598  000a 6b01          	ld	(OFST-3,sp),a
3599                     ; 819   tmpccr2 = (uint16_t)(tmpccr2l);
3601  000c 7b01          	ld	a,(OFST-3,sp)
3602  000e 5f            	clrw	x
3603  000f 97            	ld	xl,a
3604  0010 1f03          	ldw	(OFST-1,sp),x
3605                     ; 820   tmpccr2 |= (uint16_t)((uint16_t)tmpccr2h << 8);
3607  0012 7b02          	ld	a,(OFST-2,sp)
3608  0014 5f            	clrw	x
3609  0015 97            	ld	xl,a
3610  0016 4f            	clr	a
3611  0017 02            	rlwa	x,a
3612  0018 01            	rrwa	x,a
3613  0019 1a04          	or	a,(OFST+0,sp)
3614  001b 01            	rrwa	x,a
3615  001c 1a03          	or	a,(OFST-1,sp)
3616  001e 01            	rrwa	x,a
3617  001f 1f03          	ldw	(OFST-1,sp),x
3618                     ; 822   return (uint16_t)tmpccr2;
3620  0021 1e03          	ldw	x,(OFST-1,sp)
3623  0023 5b04          	addw	sp,#4
3624  0025 81            	ret
3658                     ; 830 uint16_t TIM3_GetCounter(void)
3658                     ; 831 {
3659                     .text:	section	.text,new
3660  0000               _TIM3_GetCounter:
3662  0000 89            	pushw	x
3663       00000002      OFST:	set	2
3666                     ; 832   uint16_t tmpcntr = 0;
3668                     ; 834   tmpcntr = ((uint16_t)TIM3->CNTRH << 8);
3670  0001 c65328        	ld	a,21288
3671  0004 5f            	clrw	x
3672  0005 97            	ld	xl,a
3673  0006 4f            	clr	a
3674  0007 02            	rlwa	x,a
3675  0008 1f01          	ldw	(OFST-1,sp),x
3676                     ; 836   return (uint16_t)( tmpcntr| (uint16_t)(TIM3->CNTRL));
3678  000a c65329        	ld	a,21289
3679  000d 5f            	clrw	x
3680  000e 97            	ld	xl,a
3681  000f 01            	rrwa	x,a
3682  0010 1a02          	or	a,(OFST+0,sp)
3683  0012 01            	rrwa	x,a
3684  0013 1a01          	or	a,(OFST-1,sp)
3685  0015 01            	rrwa	x,a
3688  0016 5b02          	addw	sp,#2
3689  0018 81            	ret
3713                     ; 844 TIM3_Prescaler_TypeDef TIM3_GetPrescaler(void)
3713                     ; 845 {
3714                     .text:	section	.text,new
3715  0000               _TIM3_GetPrescaler:
3719                     ; 847   return (TIM3_Prescaler_TypeDef)(TIM3->PSCR);
3721  0000 c6532a        	ld	a,21290
3724  0003 81            	ret
3850                     ; 861 FlagStatus TIM3_GetFlagStatus(TIM3_FLAG_TypeDef TIM3_FLAG)
3850                     ; 862 {
3851                     .text:	section	.text,new
3852  0000               _TIM3_GetFlagStatus:
3854  0000 89            	pushw	x
3855  0001 89            	pushw	x
3856       00000002      OFST:	set	2
3859                     ; 863   FlagStatus bitstatus = RESET;
3861                     ; 864   uint8_t tim3_flag_l = 0, tim3_flag_h = 0;
3865                     ; 867   assert_param(IS_TIM3_GET_FLAG_OK(TIM3_FLAG));
3867  0002 a30001        	cpw	x,#1
3868  0005 2714          	jreq	L044
3869  0007 a30002        	cpw	x,#2
3870  000a 270f          	jreq	L044
3871  000c a30004        	cpw	x,#4
3872  000f 270a          	jreq	L044
3873  0011 a30200        	cpw	x,#512
3874  0014 2705          	jreq	L044
3875  0016 a30400        	cpw	x,#1024
3876  0019 2603          	jrne	L634
3877  001b               L044:
3878  001b 4f            	clr	a
3879  001c 2010          	jra	L244
3880  001e               L634:
3881  001e ae0363        	ldw	x,#867
3882  0021 89            	pushw	x
3883  0022 ae0000        	ldw	x,#0
3884  0025 89            	pushw	x
3885  0026 ae0000        	ldw	x,#L502
3886  0029 cd0000        	call	_assert_failed
3888  002c 5b04          	addw	sp,#4
3889  002e               L244:
3890                     ; 869   tim3_flag_l = (uint8_t)(TIM3->SR1 & (uint8_t)TIM3_FLAG);
3892  002e c65322        	ld	a,21282
3893  0031 1404          	and	a,(OFST+2,sp)
3894  0033 6b01          	ld	(OFST-1,sp),a
3895                     ; 870   tim3_flag_h = (uint8_t)((uint16_t)TIM3_FLAG >> 8);
3897  0035 7b03          	ld	a,(OFST+1,sp)
3898  0037 6b02          	ld	(OFST+0,sp),a
3899                     ; 872   if (((tim3_flag_l) | (uint8_t)(TIM3->SR2 & tim3_flag_h)) != (uint8_t)RESET )
3901  0039 c65323        	ld	a,21283
3902  003c 1402          	and	a,(OFST+0,sp)
3903  003e 1a01          	or	a,(OFST-1,sp)
3904  0040 2706          	jreq	L5051
3905                     ; 874     bitstatus = SET;
3907  0042 a601          	ld	a,#1
3908  0044 6b02          	ld	(OFST+0,sp),a
3910  0046 2002          	jra	L7051
3911  0048               L5051:
3912                     ; 878     bitstatus = RESET;
3914  0048 0f02          	clr	(OFST+0,sp)
3915  004a               L7051:
3916                     ; 880   return (FlagStatus)bitstatus;
3918  004a 7b02          	ld	a,(OFST+0,sp)
3921  004c 5b04          	addw	sp,#4
3922  004e 81            	ret
3958                     ; 894 void TIM3_ClearFlag(TIM3_FLAG_TypeDef TIM3_FLAG)
3958                     ; 895 {
3959                     .text:	section	.text,new
3960  0000               _TIM3_ClearFlag:
3962  0000 89            	pushw	x
3963       00000000      OFST:	set	0
3966                     ; 897   assert_param(IS_TIM3_CLEAR_FLAG_OK(TIM3_FLAG));
3968  0001 01            	rrwa	x,a
3969  0002 a4f8          	and	a,#248
3970  0004 01            	rrwa	x,a
3971  0005 a4f9          	and	a,#249
3972  0007 01            	rrwa	x,a
3973  0008 a30000        	cpw	x,#0
3974  000b 2607          	jrne	L644
3975  000d 1e01          	ldw	x,(OFST+1,sp)
3976  000f 2703          	jreq	L644
3977  0011 4f            	clr	a
3978  0012 2010          	jra	L054
3979  0014               L644:
3980  0014 ae0381        	ldw	x,#897
3981  0017 89            	pushw	x
3982  0018 ae0000        	ldw	x,#0
3983  001b 89            	pushw	x
3984  001c ae0000        	ldw	x,#L502
3985  001f cd0000        	call	_assert_failed
3987  0022 5b04          	addw	sp,#4
3988  0024               L054:
3989                     ; 900   TIM3->SR1 = (uint8_t)(~((uint8_t)(TIM3_FLAG)));
3991  0024 7b02          	ld	a,(OFST+2,sp)
3992  0026 43            	cpl	a
3993  0027 c75322        	ld	21282,a
3994                     ; 901   TIM3->SR2 = (uint8_t)(~((uint8_t)((uint16_t)TIM3_FLAG >> 8)));
3996  002a 7b01          	ld	a,(OFST+1,sp)
3997  002c 43            	cpl	a
3998  002d c75323        	ld	21283,a
3999                     ; 902 }
4002  0030 85            	popw	x
4003  0031 81            	ret
4068                     ; 913 ITStatus TIM3_GetITStatus(TIM3_IT_TypeDef TIM3_IT)
4068                     ; 914 {
4069                     .text:	section	.text,new
4070  0000               _TIM3_GetITStatus:
4072  0000 88            	push	a
4073  0001 89            	pushw	x
4074       00000002      OFST:	set	2
4077                     ; 915   ITStatus bitstatus = RESET;
4079                     ; 916   uint8_t TIM3_itStatus = 0, TIM3_itEnable = 0;
4083                     ; 919   assert_param(IS_TIM3_GET_IT_OK(TIM3_IT));
4085  0002 a101          	cp	a,#1
4086  0004 2708          	jreq	L654
4087  0006 a102          	cp	a,#2
4088  0008 2704          	jreq	L654
4089  000a a104          	cp	a,#4
4090  000c 2603          	jrne	L454
4091  000e               L654:
4092  000e 4f            	clr	a
4093  000f 2010          	jra	L064
4094  0011               L454:
4095  0011 ae0397        	ldw	x,#919
4096  0014 89            	pushw	x
4097  0015 ae0000        	ldw	x,#0
4098  0018 89            	pushw	x
4099  0019 ae0000        	ldw	x,#L502
4100  001c cd0000        	call	_assert_failed
4102  001f 5b04          	addw	sp,#4
4103  0021               L064:
4104                     ; 921   TIM3_itStatus = (uint8_t)(TIM3->SR1 & TIM3_IT);
4106  0021 c65322        	ld	a,21282
4107  0024 1403          	and	a,(OFST+1,sp)
4108  0026 6b01          	ld	(OFST-1,sp),a
4109                     ; 923   TIM3_itEnable = (uint8_t)(TIM3->IER & TIM3_IT);
4111  0028 c65321        	ld	a,21281
4112  002b 1403          	and	a,(OFST+1,sp)
4113  002d 6b02          	ld	(OFST+0,sp),a
4114                     ; 925   if ((TIM3_itStatus != (uint8_t)RESET ) && (TIM3_itEnable != (uint8_t)RESET ))
4116  002f 0d01          	tnz	(OFST-1,sp)
4117  0031 270a          	jreq	L1651
4119  0033 0d02          	tnz	(OFST+0,sp)
4120  0035 2706          	jreq	L1651
4121                     ; 927     bitstatus = SET;
4123  0037 a601          	ld	a,#1
4124  0039 6b02          	ld	(OFST+0,sp),a
4126  003b 2002          	jra	L3651
4127  003d               L1651:
4128                     ; 931     bitstatus = RESET;
4130  003d 0f02          	clr	(OFST+0,sp)
4131  003f               L3651:
4132                     ; 933   return (ITStatus)(bitstatus);
4134  003f 7b02          	ld	a,(OFST+0,sp)
4137  0041 5b03          	addw	sp,#3
4138  0043 81            	ret
4175                     ; 945 void TIM3_ClearITPendingBit(TIM3_IT_TypeDef TIM3_IT)
4175                     ; 946 {
4176                     .text:	section	.text,new
4177  0000               _TIM3_ClearITPendingBit:
4179  0000 88            	push	a
4180       00000000      OFST:	set	0
4183                     ; 948   assert_param(IS_TIM3_IT_OK(TIM3_IT));
4185  0001 4d            	tnz	a
4186  0002 2707          	jreq	L464
4187  0004 a108          	cp	a,#8
4188  0006 2403          	jruge	L464
4189  0008 4f            	clr	a
4190  0009 2010          	jra	L664
4191  000b               L464:
4192  000b ae03b4        	ldw	x,#948
4193  000e 89            	pushw	x
4194  000f ae0000        	ldw	x,#0
4195  0012 89            	pushw	x
4196  0013 ae0000        	ldw	x,#L502
4197  0016 cd0000        	call	_assert_failed
4199  0019 5b04          	addw	sp,#4
4200  001b               L664:
4201                     ; 951   TIM3->SR1 = (uint8_t)(~TIM3_IT);
4203  001b 7b01          	ld	a,(OFST+1,sp)
4204  001d 43            	cpl	a
4205  001e c75322        	ld	21282,a
4206                     ; 952 }
4209  0021 84            	pop	a
4210  0022 81            	ret
4262                     ; 970 static void TI1_Config(uint8_t TIM3_ICPolarity,
4262                     ; 971                        uint8_t TIM3_ICSelection,
4262                     ; 972                        uint8_t TIM3_ICFilter)
4262                     ; 973 {
4263                     .text:	section	.text,new
4264  0000               L3_TI1_Config:
4266  0000 89            	pushw	x
4267  0001 88            	push	a
4268       00000001      OFST:	set	1
4271                     ; 975   TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1E);
4273  0002 72115327      	bres	21287,#0
4274                     ; 978   TIM3->CCMR1 = (uint8_t)((uint8_t)(TIM3->CCMR1 & (uint8_t)(~( TIM3_CCMR_CCxS | TIM3_CCMR_ICxF))) | (uint8_t)(( (TIM3_ICSelection)) | ((uint8_t)( TIM3_ICFilter << 4))));
4276  0006 7b06          	ld	a,(OFST+5,sp)
4277  0008 97            	ld	xl,a
4278  0009 a610          	ld	a,#16
4279  000b 42            	mul	x,a
4280  000c 9f            	ld	a,xl
4281  000d 1a03          	or	a,(OFST+2,sp)
4282  000f 6b01          	ld	(OFST+0,sp),a
4283  0011 c65325        	ld	a,21285
4284  0014 a40c          	and	a,#12
4285  0016 1a01          	or	a,(OFST+0,sp)
4286  0018 c75325        	ld	21285,a
4287                     ; 981   if (TIM3_ICPolarity != TIM3_ICPOLARITY_RISING)
4289  001b 0d02          	tnz	(OFST+1,sp)
4290  001d 2706          	jreq	L1361
4291                     ; 983     TIM3->CCER1 |= TIM3_CCER1_CC1P;
4293  001f 72125327      	bset	21287,#1
4295  0023 2004          	jra	L3361
4296  0025               L1361:
4297                     ; 987     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC1P);
4299  0025 72135327      	bres	21287,#1
4300  0029               L3361:
4301                     ; 990   TIM3->CCER1 |= TIM3_CCER1_CC1E;
4303  0029 72105327      	bset	21287,#0
4304                     ; 991 }
4307  002d 5b03          	addw	sp,#3
4308  002f 81            	ret
4360                     ; 1009 static void TI2_Config(uint8_t TIM3_ICPolarity,
4360                     ; 1010                        uint8_t TIM3_ICSelection,
4360                     ; 1011                        uint8_t TIM3_ICFilter)
4360                     ; 1012 {
4361                     .text:	section	.text,new
4362  0000               L5_TI2_Config:
4364  0000 89            	pushw	x
4365  0001 88            	push	a
4366       00000001      OFST:	set	1
4369                     ; 1014   TIM3->CCER1 &=  (uint8_t)(~TIM3_CCER1_CC2E);
4371  0002 72195327      	bres	21287,#4
4372                     ; 1017   TIM3->CCMR2 = (uint8_t)((uint8_t)(TIM3->CCMR2 & (uint8_t)(~( TIM3_CCMR_CCxS |
4372                     ; 1018                                                               TIM3_CCMR_ICxF    ))) | (uint8_t)(( (TIM3_ICSelection)) | 
4372                     ; 1019                                                                                                 ((uint8_t)( TIM3_ICFilter << 4))));
4374  0006 7b06          	ld	a,(OFST+5,sp)
4375  0008 97            	ld	xl,a
4376  0009 a610          	ld	a,#16
4377  000b 42            	mul	x,a
4378  000c 9f            	ld	a,xl
4379  000d 1a03          	or	a,(OFST+2,sp)
4380  000f 6b01          	ld	(OFST+0,sp),a
4381  0011 c65326        	ld	a,21286
4382  0014 a40c          	and	a,#12
4383  0016 1a01          	or	a,(OFST+0,sp)
4384  0018 c75326        	ld	21286,a
4385                     ; 1022   if (TIM3_ICPolarity != TIM3_ICPOLARITY_RISING)
4387  001b 0d02          	tnz	(OFST+1,sp)
4388  001d 2706          	jreq	L3661
4389                     ; 1024     TIM3->CCER1 |= TIM3_CCER1_CC2P;
4391  001f 721a5327      	bset	21287,#5
4393  0023 2004          	jra	L5661
4394  0025               L3661:
4395                     ; 1028     TIM3->CCER1 &= (uint8_t)(~TIM3_CCER1_CC2P);
4397  0025 721b5327      	bres	21287,#5
4398  0029               L5661:
4399                     ; 1032   TIM3->CCER1 |= TIM3_CCER1_CC2E;
4401  0029 72185327      	bset	21287,#4
4402                     ; 1033 }
4405  002d 5b03          	addw	sp,#3
4406  002f 81            	ret
4419                     	xdef	_TIM3_ClearITPendingBit
4420                     	xdef	_TIM3_GetITStatus
4421                     	xdef	_TIM3_ClearFlag
4422                     	xdef	_TIM3_GetFlagStatus
4423                     	xdef	_TIM3_GetPrescaler
4424                     	xdef	_TIM3_GetCounter
4425                     	xdef	_TIM3_GetCapture2
4426                     	xdef	_TIM3_GetCapture1
4427                     	xdef	_TIM3_SetIC2Prescaler
4428                     	xdef	_TIM3_SetIC1Prescaler
4429                     	xdef	_TIM3_SetCompare2
4430                     	xdef	_TIM3_SetCompare1
4431                     	xdef	_TIM3_SetAutoreload
4432                     	xdef	_TIM3_SetCounter
4433                     	xdef	_TIM3_SelectOCxM
4434                     	xdef	_TIM3_CCxCmd
4435                     	xdef	_TIM3_OC2PolarityConfig
4436                     	xdef	_TIM3_OC1PolarityConfig
4437                     	xdef	_TIM3_GenerateEvent
4438                     	xdef	_TIM3_OC2PreloadConfig
4439                     	xdef	_TIM3_OC1PreloadConfig
4440                     	xdef	_TIM3_ARRPreloadConfig
4441                     	xdef	_TIM3_ForcedOC2Config
4442                     	xdef	_TIM3_ForcedOC1Config
4443                     	xdef	_TIM3_PrescalerConfig
4444                     	xdef	_TIM3_SelectOnePulseMode
4445                     	xdef	_TIM3_UpdateRequestConfig
4446                     	xdef	_TIM3_UpdateDisableConfig
4447                     	xdef	_TIM3_ITConfig
4448                     	xdef	_TIM3_Cmd
4449                     	xdef	_TIM3_PWMIConfig
4450                     	xdef	_TIM3_ICInit
4451                     	xdef	_TIM3_OC2Init
4452                     	xdef	_TIM3_OC1Init
4453                     	xdef	_TIM3_TimeBaseInit
4454                     	xdef	_TIM3_DeInit
4455                     	xref	_assert_failed
4456                     .const:	section	.text
4457  0000               L502:
4458  0000 73746d38735f  	dc.b	"stm8s_stdperiph_li"
4459  0012 625c6c696272  	dc.b	"b\libraries\stm8s_"
4460  0024 737464706572  	dc.b	"stdperiph_driver\s"
4461  0036 72635c73746d  	dc.b	"rc\stm8s_tim3.c",0
4481                     	end
