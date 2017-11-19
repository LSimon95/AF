   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  45                     ; 52 void ADC1_DeInit(void)
  45                     ; 53 {
  47                     .text:	section	.text,new
  48  0000               _ADC1_DeInit:
  52                     ; 54   ADC1->CSR  = ADC1_CSR_RESET_VALUE;
  54  0000 725f5400      	clr	21504
  55                     ; 55   ADC1->CR1  = ADC1_CR1_RESET_VALUE;
  57  0004 725f5401      	clr	21505
  58                     ; 56   ADC1->CR2  = ADC1_CR2_RESET_VALUE;
  60  0008 725f5402      	clr	21506
  61                     ; 57   ADC1->CR3  = ADC1_CR3_RESET_VALUE;
  63  000c 725f5403      	clr	21507
  64                     ; 58   ADC1->TDRH = ADC1_TDRH_RESET_VALUE;
  66  0010 725f5406      	clr	21510
  67                     ; 59   ADC1->TDRL = ADC1_TDRL_RESET_VALUE;
  69  0014 725f5407      	clr	21511
  70                     ; 60   ADC1->HTRH = ADC1_HTRH_RESET_VALUE;
  72  0018 35ff5408      	mov	21512,#255
  73                     ; 61   ADC1->HTRL = ADC1_HTRL_RESET_VALUE;
  75  001c 35035409      	mov	21513,#3
  76                     ; 62   ADC1->LTRH = ADC1_LTRH_RESET_VALUE;
  78  0020 725f540a      	clr	21514
  79                     ; 63   ADC1->LTRL = ADC1_LTRL_RESET_VALUE;
  81  0024 725f540b      	clr	21515
  82                     ; 64   ADC1->AWCRH = ADC1_AWCRH_RESET_VALUE;
  84  0028 725f540e      	clr	21518
  85                     ; 65   ADC1->AWCRL = ADC1_AWCRL_RESET_VALUE;
  87  002c 725f540f      	clr	21519
  88                     ; 66 }
  91  0030 81            	ret
 543                     ; 88 void ADC1_Init(ADC1_ConvMode_TypeDef ADC1_ConversionMode, ADC1_Channel_TypeDef ADC1_Channel, ADC1_PresSel_TypeDef ADC1_PrescalerSelection, ADC1_ExtTrig_TypeDef ADC1_ExtTrigger, FunctionalState ADC1_ExtTriggerState, ADC1_Align_TypeDef ADC1_Align, ADC1_SchmittTrigg_TypeDef ADC1_SchmittTriggerChannel, FunctionalState ADC1_SchmittTriggerState)
 543                     ; 89 {
 544                     .text:	section	.text,new
 545  0000               _ADC1_Init:
 547  0000 89            	pushw	x
 548       00000000      OFST:	set	0
 551                     ; 91   assert_param(IS_ADC1_CONVERSIONMODE_OK(ADC1_ConversionMode));
 553  0001 9e            	ld	a,xh
 554  0002 4d            	tnz	a
 555  0003 2705          	jreq	L21
 556  0005 9e            	ld	a,xh
 557  0006 a101          	cp	a,#1
 558  0008 2603          	jrne	L01
 559  000a               L21:
 560  000a 4f            	clr	a
 561  000b 2010          	jra	L41
 562  000d               L01:
 563  000d ae005b        	ldw	x,#91
 564  0010 89            	pushw	x
 565  0011 ae0000        	ldw	x,#0
 566  0014 89            	pushw	x
 567  0015 ae0000        	ldw	x,#L542
 568  0018 cd0000        	call	_assert_failed
 570  001b 5b04          	addw	sp,#4
 571  001d               L41:
 572                     ; 92   assert_param(IS_ADC1_CHANNEL_OK(ADC1_Channel));
 574  001d 0d02          	tnz	(OFST+2,sp)
 575  001f 273c          	jreq	L02
 576  0021 7b02          	ld	a,(OFST+2,sp)
 577  0023 a101          	cp	a,#1
 578  0025 2736          	jreq	L02
 579  0027 7b02          	ld	a,(OFST+2,sp)
 580  0029 a102          	cp	a,#2
 581  002b 2730          	jreq	L02
 582  002d 7b02          	ld	a,(OFST+2,sp)
 583  002f a103          	cp	a,#3
 584  0031 272a          	jreq	L02
 585  0033 7b02          	ld	a,(OFST+2,sp)
 586  0035 a104          	cp	a,#4
 587  0037 2724          	jreq	L02
 588  0039 7b02          	ld	a,(OFST+2,sp)
 589  003b a105          	cp	a,#5
 590  003d 271e          	jreq	L02
 591  003f 7b02          	ld	a,(OFST+2,sp)
 592  0041 a106          	cp	a,#6
 593  0043 2718          	jreq	L02
 594  0045 7b02          	ld	a,(OFST+2,sp)
 595  0047 a107          	cp	a,#7
 596  0049 2712          	jreq	L02
 597  004b 7b02          	ld	a,(OFST+2,sp)
 598  004d a108          	cp	a,#8
 599  004f 270c          	jreq	L02
 600  0051 7b02          	ld	a,(OFST+2,sp)
 601  0053 a10c          	cp	a,#12
 602  0055 2706          	jreq	L02
 603  0057 7b02          	ld	a,(OFST+2,sp)
 604  0059 a109          	cp	a,#9
 605  005b 2603          	jrne	L61
 606  005d               L02:
 607  005d 4f            	clr	a
 608  005e 2010          	jra	L22
 609  0060               L61:
 610  0060 ae005c        	ldw	x,#92
 611  0063 89            	pushw	x
 612  0064 ae0000        	ldw	x,#0
 613  0067 89            	pushw	x
 614  0068 ae0000        	ldw	x,#L542
 615  006b cd0000        	call	_assert_failed
 617  006e 5b04          	addw	sp,#4
 618  0070               L22:
 619                     ; 93   assert_param(IS_ADC1_PRESSEL_OK(ADC1_PrescalerSelection));
 621  0070 0d05          	tnz	(OFST+5,sp)
 622  0072 272a          	jreq	L62
 623  0074 7b05          	ld	a,(OFST+5,sp)
 624  0076 a110          	cp	a,#16
 625  0078 2724          	jreq	L62
 626  007a 7b05          	ld	a,(OFST+5,sp)
 627  007c a120          	cp	a,#32
 628  007e 271e          	jreq	L62
 629  0080 7b05          	ld	a,(OFST+5,sp)
 630  0082 a130          	cp	a,#48
 631  0084 2718          	jreq	L62
 632  0086 7b05          	ld	a,(OFST+5,sp)
 633  0088 a140          	cp	a,#64
 634  008a 2712          	jreq	L62
 635  008c 7b05          	ld	a,(OFST+5,sp)
 636  008e a150          	cp	a,#80
 637  0090 270c          	jreq	L62
 638  0092 7b05          	ld	a,(OFST+5,sp)
 639  0094 a160          	cp	a,#96
 640  0096 2706          	jreq	L62
 641  0098 7b05          	ld	a,(OFST+5,sp)
 642  009a a170          	cp	a,#112
 643  009c 2603          	jrne	L42
 644  009e               L62:
 645  009e 4f            	clr	a
 646  009f 2010          	jra	L03
 647  00a1               L42:
 648  00a1 ae005d        	ldw	x,#93
 649  00a4 89            	pushw	x
 650  00a5 ae0000        	ldw	x,#0
 651  00a8 89            	pushw	x
 652  00a9 ae0000        	ldw	x,#L542
 653  00ac cd0000        	call	_assert_failed
 655  00af 5b04          	addw	sp,#4
 656  00b1               L03:
 657                     ; 94   assert_param(IS_ADC1_EXTTRIG_OK(ADC1_ExtTrigger));
 659  00b1 0d06          	tnz	(OFST+6,sp)
 660  00b3 2706          	jreq	L43
 661  00b5 7b06          	ld	a,(OFST+6,sp)
 662  00b7 a110          	cp	a,#16
 663  00b9 2603          	jrne	L23
 664  00bb               L43:
 665  00bb 4f            	clr	a
 666  00bc 2010          	jra	L63
 667  00be               L23:
 668  00be ae005e        	ldw	x,#94
 669  00c1 89            	pushw	x
 670  00c2 ae0000        	ldw	x,#0
 671  00c5 89            	pushw	x
 672  00c6 ae0000        	ldw	x,#L542
 673  00c9 cd0000        	call	_assert_failed
 675  00cc 5b04          	addw	sp,#4
 676  00ce               L63:
 677                     ; 95   assert_param(IS_FUNCTIONALSTATE_OK(((ADC1_ExtTriggerState))));
 679  00ce 0d07          	tnz	(OFST+7,sp)
 680  00d0 2706          	jreq	L24
 681  00d2 7b07          	ld	a,(OFST+7,sp)
 682  00d4 a101          	cp	a,#1
 683  00d6 2603          	jrne	L04
 684  00d8               L24:
 685  00d8 4f            	clr	a
 686  00d9 2010          	jra	L44
 687  00db               L04:
 688  00db ae005f        	ldw	x,#95
 689  00de 89            	pushw	x
 690  00df ae0000        	ldw	x,#0
 691  00e2 89            	pushw	x
 692  00e3 ae0000        	ldw	x,#L542
 693  00e6 cd0000        	call	_assert_failed
 695  00e9 5b04          	addw	sp,#4
 696  00eb               L44:
 697                     ; 96   assert_param(IS_ADC1_ALIGN_OK(ADC1_Align));
 699  00eb 0d08          	tnz	(OFST+8,sp)
 700  00ed 2706          	jreq	L05
 701  00ef 7b08          	ld	a,(OFST+8,sp)
 702  00f1 a108          	cp	a,#8
 703  00f3 2603          	jrne	L64
 704  00f5               L05:
 705  00f5 4f            	clr	a
 706  00f6 2010          	jra	L25
 707  00f8               L64:
 708  00f8 ae0060        	ldw	x,#96
 709  00fb 89            	pushw	x
 710  00fc ae0000        	ldw	x,#0
 711  00ff 89            	pushw	x
 712  0100 ae0000        	ldw	x,#L542
 713  0103 cd0000        	call	_assert_failed
 715  0106 5b04          	addw	sp,#4
 716  0108               L25:
 717                     ; 97   assert_param(IS_ADC1_SCHMITTTRIG_OK(ADC1_SchmittTriggerChannel));
 719  0108 0d09          	tnz	(OFST+9,sp)
 720  010a 2742          	jreq	L65
 721  010c 7b09          	ld	a,(OFST+9,sp)
 722  010e a101          	cp	a,#1
 723  0110 273c          	jreq	L65
 724  0112 7b09          	ld	a,(OFST+9,sp)
 725  0114 a102          	cp	a,#2
 726  0116 2736          	jreq	L65
 727  0118 7b09          	ld	a,(OFST+9,sp)
 728  011a a103          	cp	a,#3
 729  011c 2730          	jreq	L65
 730  011e 7b09          	ld	a,(OFST+9,sp)
 731  0120 a104          	cp	a,#4
 732  0122 272a          	jreq	L65
 733  0124 7b09          	ld	a,(OFST+9,sp)
 734  0126 a105          	cp	a,#5
 735  0128 2724          	jreq	L65
 736  012a 7b09          	ld	a,(OFST+9,sp)
 737  012c a106          	cp	a,#6
 738  012e 271e          	jreq	L65
 739  0130 7b09          	ld	a,(OFST+9,sp)
 740  0132 a107          	cp	a,#7
 741  0134 2718          	jreq	L65
 742  0136 7b09          	ld	a,(OFST+9,sp)
 743  0138 a108          	cp	a,#8
 744  013a 2712          	jreq	L65
 745  013c 7b09          	ld	a,(OFST+9,sp)
 746  013e a10c          	cp	a,#12
 747  0140 270c          	jreq	L65
 748  0142 7b09          	ld	a,(OFST+9,sp)
 749  0144 a1ff          	cp	a,#255
 750  0146 2706          	jreq	L65
 751  0148 7b09          	ld	a,(OFST+9,sp)
 752  014a a109          	cp	a,#9
 753  014c 2603          	jrne	L45
 754  014e               L65:
 755  014e 4f            	clr	a
 756  014f 2010          	jra	L06
 757  0151               L45:
 758  0151 ae0061        	ldw	x,#97
 759  0154 89            	pushw	x
 760  0155 ae0000        	ldw	x,#0
 761  0158 89            	pushw	x
 762  0159 ae0000        	ldw	x,#L542
 763  015c cd0000        	call	_assert_failed
 765  015f 5b04          	addw	sp,#4
 766  0161               L06:
 767                     ; 98   assert_param(IS_FUNCTIONALSTATE_OK(ADC1_SchmittTriggerState));
 769  0161 0d0a          	tnz	(OFST+10,sp)
 770  0163 2706          	jreq	L46
 771  0165 7b0a          	ld	a,(OFST+10,sp)
 772  0167 a101          	cp	a,#1
 773  0169 2603          	jrne	L26
 774  016b               L46:
 775  016b 4f            	clr	a
 776  016c 2010          	jra	L66
 777  016e               L26:
 778  016e ae0062        	ldw	x,#98
 779  0171 89            	pushw	x
 780  0172 ae0000        	ldw	x,#0
 781  0175 89            	pushw	x
 782  0176 ae0000        	ldw	x,#L542
 783  0179 cd0000        	call	_assert_failed
 785  017c 5b04          	addw	sp,#4
 786  017e               L66:
 787                     ; 103   ADC1_ConversionConfig(ADC1_ConversionMode, ADC1_Channel, ADC1_Align);
 789  017e 7b08          	ld	a,(OFST+8,sp)
 790  0180 88            	push	a
 791  0181 7b03          	ld	a,(OFST+3,sp)
 792  0183 97            	ld	xl,a
 793  0184 7b02          	ld	a,(OFST+2,sp)
 794  0186 95            	ld	xh,a
 795  0187 cd0000        	call	_ADC1_ConversionConfig
 797  018a 84            	pop	a
 798                     ; 105   ADC1_PrescalerConfig(ADC1_PrescalerSelection);
 800  018b 7b05          	ld	a,(OFST+5,sp)
 801  018d cd0000        	call	_ADC1_PrescalerConfig
 803                     ; 110   ADC1_ExternalTriggerConfig(ADC1_ExtTrigger, ADC1_ExtTriggerState);
 805  0190 7b07          	ld	a,(OFST+7,sp)
 806  0192 97            	ld	xl,a
 807  0193 7b06          	ld	a,(OFST+6,sp)
 808  0195 95            	ld	xh,a
 809  0196 cd0000        	call	_ADC1_ExternalTriggerConfig
 811                     ; 115   ADC1_SchmittTriggerConfig(ADC1_SchmittTriggerChannel, ADC1_SchmittTriggerState);
 813  0199 7b0a          	ld	a,(OFST+10,sp)
 814  019b 97            	ld	xl,a
 815  019c 7b09          	ld	a,(OFST+9,sp)
 816  019e 95            	ld	xh,a
 817  019f cd0000        	call	_ADC1_SchmittTriggerConfig
 819                     ; 118   ADC1->CR1 |= ADC1_CR1_ADON;
 821  01a2 72105401      	bset	21505,#0
 822                     ; 119 }
 825  01a6 85            	popw	x
 826  01a7 81            	ret
 862                     ; 126 void ADC1_Cmd(FunctionalState NewState)
 862                     ; 127 {
 863                     .text:	section	.text,new
 864  0000               _ADC1_Cmd:
 866  0000 88            	push	a
 867       00000000      OFST:	set	0
 870                     ; 129   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 872  0001 4d            	tnz	a
 873  0002 2704          	jreq	L47
 874  0004 a101          	cp	a,#1
 875  0006 2603          	jrne	L27
 876  0008               L47:
 877  0008 4f            	clr	a
 878  0009 2010          	jra	L67
 879  000b               L27:
 880  000b ae0081        	ldw	x,#129
 881  000e 89            	pushw	x
 882  000f ae0000        	ldw	x,#0
 883  0012 89            	pushw	x
 884  0013 ae0000        	ldw	x,#L542
 885  0016 cd0000        	call	_assert_failed
 887  0019 5b04          	addw	sp,#4
 888  001b               L67:
 889                     ; 131   if (NewState != DISABLE)
 891  001b 0d01          	tnz	(OFST+1,sp)
 892  001d 2706          	jreq	L562
 893                     ; 133     ADC1->CR1 |= ADC1_CR1_ADON;
 895  001f 72105401      	bset	21505,#0
 897  0023 2004          	jra	L762
 898  0025               L562:
 899                     ; 137     ADC1->CR1 &= (uint8_t)(~ADC1_CR1_ADON);
 901  0025 72115401      	bres	21505,#0
 902  0029               L762:
 903                     ; 139 }
 906  0029 84            	pop	a
 907  002a 81            	ret
 943                     ; 146 void ADC1_ScanModeCmd(FunctionalState NewState)
 943                     ; 147 {
 944                     .text:	section	.text,new
 945  0000               _ADC1_ScanModeCmd:
 947  0000 88            	push	a
 948       00000000      OFST:	set	0
 951                     ; 149   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 953  0001 4d            	tnz	a
 954  0002 2704          	jreq	L401
 955  0004 a101          	cp	a,#1
 956  0006 2603          	jrne	L201
 957  0008               L401:
 958  0008 4f            	clr	a
 959  0009 2010          	jra	L601
 960  000b               L201:
 961  000b ae0095        	ldw	x,#149
 962  000e 89            	pushw	x
 963  000f ae0000        	ldw	x,#0
 964  0012 89            	pushw	x
 965  0013 ae0000        	ldw	x,#L542
 966  0016 cd0000        	call	_assert_failed
 968  0019 5b04          	addw	sp,#4
 969  001b               L601:
 970                     ; 151   if (NewState != DISABLE)
 972  001b 0d01          	tnz	(OFST+1,sp)
 973  001d 2706          	jreq	L703
 974                     ; 153     ADC1->CR2 |= ADC1_CR2_SCAN;
 976  001f 72125402      	bset	21506,#1
 978  0023 2004          	jra	L113
 979  0025               L703:
 980                     ; 157     ADC1->CR2 &= (uint8_t)(~ADC1_CR2_SCAN);
 982  0025 72135402      	bres	21506,#1
 983  0029               L113:
 984                     ; 159 }
 987  0029 84            	pop	a
 988  002a 81            	ret
1024                     ; 166 void ADC1_DataBufferCmd(FunctionalState NewState)
1024                     ; 167 {
1025                     .text:	section	.text,new
1026  0000               _ADC1_DataBufferCmd:
1028  0000 88            	push	a
1029       00000000      OFST:	set	0
1032                     ; 169   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1034  0001 4d            	tnz	a
1035  0002 2704          	jreq	L411
1036  0004 a101          	cp	a,#1
1037  0006 2603          	jrne	L211
1038  0008               L411:
1039  0008 4f            	clr	a
1040  0009 2010          	jra	L611
1041  000b               L211:
1042  000b ae00a9        	ldw	x,#169
1043  000e 89            	pushw	x
1044  000f ae0000        	ldw	x,#0
1045  0012 89            	pushw	x
1046  0013 ae0000        	ldw	x,#L542
1047  0016 cd0000        	call	_assert_failed
1049  0019 5b04          	addw	sp,#4
1050  001b               L611:
1051                     ; 171   if (NewState != DISABLE)
1053  001b 0d01          	tnz	(OFST+1,sp)
1054  001d 2706          	jreq	L133
1055                     ; 173     ADC1->CR3 |= ADC1_CR3_DBUF;
1057  001f 721e5403      	bset	21507,#7
1059  0023 2004          	jra	L333
1060  0025               L133:
1061                     ; 177     ADC1->CR3 &= (uint8_t)(~ADC1_CR3_DBUF);
1063  0025 721f5403      	bres	21507,#7
1064  0029               L333:
1065                     ; 179 }
1068  0029 84            	pop	a
1069  002a 81            	ret
1226                     ; 190 void ADC1_ITConfig(ADC1_IT_TypeDef ADC1_IT, FunctionalState NewState)
1226                     ; 191 {
1227                     .text:	section	.text,new
1228  0000               _ADC1_ITConfig:
1230  0000 89            	pushw	x
1231       00000000      OFST:	set	0
1234                     ; 193   assert_param(IS_ADC1_IT_OK(ADC1_IT));
1236  0001 a30020        	cpw	x,#32
1237  0004 2705          	jreq	L421
1238  0006 a30010        	cpw	x,#16
1239  0009 2603          	jrne	L221
1240  000b               L421:
1241  000b 4f            	clr	a
1242  000c 2010          	jra	L621
1243  000e               L221:
1244  000e ae00c1        	ldw	x,#193
1245  0011 89            	pushw	x
1246  0012 ae0000        	ldw	x,#0
1247  0015 89            	pushw	x
1248  0016 ae0000        	ldw	x,#L542
1249  0019 cd0000        	call	_assert_failed
1251  001c 5b04          	addw	sp,#4
1252  001e               L621:
1253                     ; 194   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1255  001e 0d05          	tnz	(OFST+5,sp)
1256  0020 2706          	jreq	L231
1257  0022 7b05          	ld	a,(OFST+5,sp)
1258  0024 a101          	cp	a,#1
1259  0026 2603          	jrne	L031
1260  0028               L231:
1261  0028 4f            	clr	a
1262  0029 2010          	jra	L431
1263  002b               L031:
1264  002b ae00c2        	ldw	x,#194
1265  002e 89            	pushw	x
1266  002f ae0000        	ldw	x,#0
1267  0032 89            	pushw	x
1268  0033 ae0000        	ldw	x,#L542
1269  0036 cd0000        	call	_assert_failed
1271  0039 5b04          	addw	sp,#4
1272  003b               L431:
1273                     ; 196   if (NewState != DISABLE)
1275  003b 0d05          	tnz	(OFST+5,sp)
1276  003d 270a          	jreq	L124
1277                     ; 199     ADC1->CSR |= (uint8_t)ADC1_IT;
1279  003f c65400        	ld	a,21504
1280  0042 1a02          	or	a,(OFST+2,sp)
1281  0044 c75400        	ld	21504,a
1283  0047 2009          	jra	L324
1284  0049               L124:
1285                     ; 204     ADC1->CSR &= (uint8_t)((uint16_t)~(uint16_t)ADC1_IT);
1287  0049 7b02          	ld	a,(OFST+2,sp)
1288  004b 43            	cpl	a
1289  004c c45400        	and	a,21504
1290  004f c75400        	ld	21504,a
1291  0052               L324:
1292                     ; 206 }
1295  0052 85            	popw	x
1296  0053 81            	ret
1333                     ; 214 void ADC1_PrescalerConfig(ADC1_PresSel_TypeDef ADC1_Prescaler)
1333                     ; 215 {
1334                     .text:	section	.text,new
1335  0000               _ADC1_PrescalerConfig:
1337  0000 88            	push	a
1338       00000000      OFST:	set	0
1341                     ; 217   assert_param(IS_ADC1_PRESSEL_OK(ADC1_Prescaler));
1343  0001 4d            	tnz	a
1344  0002 271c          	jreq	L241
1345  0004 a110          	cp	a,#16
1346  0006 2718          	jreq	L241
1347  0008 a120          	cp	a,#32
1348  000a 2714          	jreq	L241
1349  000c a130          	cp	a,#48
1350  000e 2710          	jreq	L241
1351  0010 a140          	cp	a,#64
1352  0012 270c          	jreq	L241
1353  0014 a150          	cp	a,#80
1354  0016 2708          	jreq	L241
1355  0018 a160          	cp	a,#96
1356  001a 2704          	jreq	L241
1357  001c a170          	cp	a,#112
1358  001e 2603          	jrne	L041
1359  0020               L241:
1360  0020 4f            	clr	a
1361  0021 2010          	jra	L441
1362  0023               L041:
1363  0023 ae00d9        	ldw	x,#217
1364  0026 89            	pushw	x
1365  0027 ae0000        	ldw	x,#0
1366  002a 89            	pushw	x
1367  002b ae0000        	ldw	x,#L542
1368  002e cd0000        	call	_assert_failed
1370  0031 5b04          	addw	sp,#4
1371  0033               L441:
1372                     ; 220   ADC1->CR1 &= (uint8_t)(~ADC1_CR1_SPSEL);
1374  0033 c65401        	ld	a,21505
1375  0036 a48f          	and	a,#143
1376  0038 c75401        	ld	21505,a
1377                     ; 222   ADC1->CR1 |= (uint8_t)(ADC1_Prescaler);
1379  003b c65401        	ld	a,21505
1380  003e 1a01          	or	a,(OFST+1,sp)
1381  0040 c75401        	ld	21505,a
1382                     ; 223 }
1385  0043 84            	pop	a
1386  0044 81            	ret
1434                     ; 233 void ADC1_SchmittTriggerConfig(ADC1_SchmittTrigg_TypeDef ADC1_SchmittTriggerChannel, FunctionalState NewState)
1434                     ; 234 {
1435                     .text:	section	.text,new
1436  0000               _ADC1_SchmittTriggerConfig:
1438  0000 89            	pushw	x
1439       00000000      OFST:	set	0
1442                     ; 236   assert_param(IS_ADC1_SCHMITTTRIG_OK(ADC1_SchmittTriggerChannel));
1444  0001 9e            	ld	a,xh
1445  0002 4d            	tnz	a
1446  0003 2737          	jreq	L251
1447  0005 9e            	ld	a,xh
1448  0006 a101          	cp	a,#1
1449  0008 2732          	jreq	L251
1450  000a 9e            	ld	a,xh
1451  000b a102          	cp	a,#2
1452  000d 272d          	jreq	L251
1453  000f 9e            	ld	a,xh
1454  0010 a103          	cp	a,#3
1455  0012 2728          	jreq	L251
1456  0014 9e            	ld	a,xh
1457  0015 a104          	cp	a,#4
1458  0017 2723          	jreq	L251
1459  0019 9e            	ld	a,xh
1460  001a a105          	cp	a,#5
1461  001c 271e          	jreq	L251
1462  001e 9e            	ld	a,xh
1463  001f a106          	cp	a,#6
1464  0021 2719          	jreq	L251
1465  0023 9e            	ld	a,xh
1466  0024 a107          	cp	a,#7
1467  0026 2714          	jreq	L251
1468  0028 9e            	ld	a,xh
1469  0029 a108          	cp	a,#8
1470  002b 270f          	jreq	L251
1471  002d 9e            	ld	a,xh
1472  002e a10c          	cp	a,#12
1473  0030 270a          	jreq	L251
1474  0032 9e            	ld	a,xh
1475  0033 a1ff          	cp	a,#255
1476  0035 2705          	jreq	L251
1477  0037 9e            	ld	a,xh
1478  0038 a109          	cp	a,#9
1479  003a 2603          	jrne	L051
1480  003c               L251:
1481  003c 4f            	clr	a
1482  003d 2010          	jra	L451
1483  003f               L051:
1484  003f ae00ec        	ldw	x,#236
1485  0042 89            	pushw	x
1486  0043 ae0000        	ldw	x,#0
1487  0046 89            	pushw	x
1488  0047 ae0000        	ldw	x,#L542
1489  004a cd0000        	call	_assert_failed
1491  004d 5b04          	addw	sp,#4
1492  004f               L451:
1493                     ; 237   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1495  004f 0d02          	tnz	(OFST+2,sp)
1496  0051 2706          	jreq	L061
1497  0053 7b02          	ld	a,(OFST+2,sp)
1498  0055 a101          	cp	a,#1
1499  0057 2603          	jrne	L651
1500  0059               L061:
1501  0059 4f            	clr	a
1502  005a 2010          	jra	L261
1503  005c               L651:
1504  005c ae00ed        	ldw	x,#237
1505  005f 89            	pushw	x
1506  0060 ae0000        	ldw	x,#0
1507  0063 89            	pushw	x
1508  0064 ae0000        	ldw	x,#L542
1509  0067 cd0000        	call	_assert_failed
1511  006a 5b04          	addw	sp,#4
1512  006c               L261:
1513                     ; 239   if (ADC1_SchmittTriggerChannel == ADC1_SCHMITTTRIG_ALL)
1515  006c 7b01          	ld	a,(OFST+1,sp)
1516  006e a1ff          	cp	a,#255
1517  0070 2620          	jrne	L564
1518                     ; 241     if (NewState != DISABLE)
1520  0072 0d02          	tnz	(OFST+2,sp)
1521  0074 270a          	jreq	L764
1522                     ; 243       ADC1->TDRL &= (uint8_t)0x0;
1524  0076 725f5407      	clr	21511
1525                     ; 244       ADC1->TDRH &= (uint8_t)0x0;
1527  007a 725f5406      	clr	21510
1529  007e 2078          	jra	L374
1530  0080               L764:
1531                     ; 248       ADC1->TDRL |= (uint8_t)0xFF;
1533  0080 c65407        	ld	a,21511
1534  0083 aaff          	or	a,#255
1535  0085 c75407        	ld	21511,a
1536                     ; 249       ADC1->TDRH |= (uint8_t)0xFF;
1538  0088 c65406        	ld	a,21510
1539  008b aaff          	or	a,#255
1540  008d c75406        	ld	21510,a
1541  0090 2066          	jra	L374
1542  0092               L564:
1543                     ; 252   else if (ADC1_SchmittTriggerChannel < ADC1_SCHMITTTRIG_CHANNEL8)
1545  0092 7b01          	ld	a,(OFST+1,sp)
1546  0094 a108          	cp	a,#8
1547  0096 242f          	jruge	L574
1548                     ; 254     if (NewState != DISABLE)
1550  0098 0d02          	tnz	(OFST+2,sp)
1551  009a 2716          	jreq	L774
1552                     ; 256       ADC1->TDRL &= (uint8_t)(~(uint8_t)((uint8_t)0x01 << (uint8_t)ADC1_SchmittTriggerChannel));
1554  009c 7b01          	ld	a,(OFST+1,sp)
1555  009e 5f            	clrw	x
1556  009f 97            	ld	xl,a
1557  00a0 a601          	ld	a,#1
1558  00a2 5d            	tnzw	x
1559  00a3 2704          	jreq	L461
1560  00a5               L661:
1561  00a5 48            	sll	a
1562  00a6 5a            	decw	x
1563  00a7 26fc          	jrne	L661
1564  00a9               L461:
1565  00a9 43            	cpl	a
1566  00aa c45407        	and	a,21511
1567  00ad c75407        	ld	21511,a
1569  00b0 2046          	jra	L374
1570  00b2               L774:
1571                     ; 260       ADC1->TDRL |= (uint8_t)((uint8_t)0x01 << (uint8_t)ADC1_SchmittTriggerChannel);
1573  00b2 7b01          	ld	a,(OFST+1,sp)
1574  00b4 5f            	clrw	x
1575  00b5 97            	ld	xl,a
1576  00b6 a601          	ld	a,#1
1577  00b8 5d            	tnzw	x
1578  00b9 2704          	jreq	L071
1579  00bb               L271:
1580  00bb 48            	sll	a
1581  00bc 5a            	decw	x
1582  00bd 26fc          	jrne	L271
1583  00bf               L071:
1584  00bf ca5407        	or	a,21511
1585  00c2 c75407        	ld	21511,a
1586  00c5 2031          	jra	L374
1587  00c7               L574:
1588                     ; 265     if (NewState != DISABLE)
1590  00c7 0d02          	tnz	(OFST+2,sp)
1591  00c9 2718          	jreq	L505
1592                     ; 267       ADC1->TDRH &= (uint8_t)(~(uint8_t)((uint8_t)0x01 << ((uint8_t)ADC1_SchmittTriggerChannel - (uint8_t)8)));
1594  00cb 7b01          	ld	a,(OFST+1,sp)
1595  00cd a008          	sub	a,#8
1596  00cf 5f            	clrw	x
1597  00d0 97            	ld	xl,a
1598  00d1 a601          	ld	a,#1
1599  00d3 5d            	tnzw	x
1600  00d4 2704          	jreq	L471
1601  00d6               L671:
1602  00d6 48            	sll	a
1603  00d7 5a            	decw	x
1604  00d8 26fc          	jrne	L671
1605  00da               L471:
1606  00da 43            	cpl	a
1607  00db c45406        	and	a,21510
1608  00de c75406        	ld	21510,a
1610  00e1 2015          	jra	L374
1611  00e3               L505:
1612                     ; 271       ADC1->TDRH |= (uint8_t)((uint8_t)0x01 << ((uint8_t)ADC1_SchmittTriggerChannel - (uint8_t)8));
1614  00e3 7b01          	ld	a,(OFST+1,sp)
1615  00e5 a008          	sub	a,#8
1616  00e7 5f            	clrw	x
1617  00e8 97            	ld	xl,a
1618  00e9 a601          	ld	a,#1
1619  00eb 5d            	tnzw	x
1620  00ec 2704          	jreq	L002
1621  00ee               L202:
1622  00ee 48            	sll	a
1623  00ef 5a            	decw	x
1624  00f0 26fc          	jrne	L202
1625  00f2               L002:
1626  00f2 ca5406        	or	a,21510
1627  00f5 c75406        	ld	21510,a
1628  00f8               L374:
1629                     ; 274 }
1632  00f8 85            	popw	x
1633  00f9 81            	ret
1691                     ; 286 void ADC1_ConversionConfig(ADC1_ConvMode_TypeDef ADC1_ConversionMode, ADC1_Channel_TypeDef ADC1_Channel, ADC1_Align_TypeDef ADC1_Align)
1691                     ; 287 {
1692                     .text:	section	.text,new
1693  0000               _ADC1_ConversionConfig:
1695  0000 89            	pushw	x
1696       00000000      OFST:	set	0
1699                     ; 289   assert_param(IS_ADC1_CONVERSIONMODE_OK(ADC1_ConversionMode));
1701  0001 9e            	ld	a,xh
1702  0002 4d            	tnz	a
1703  0003 2705          	jreq	L012
1704  0005 9e            	ld	a,xh
1705  0006 a101          	cp	a,#1
1706  0008 2603          	jrne	L602
1707  000a               L012:
1708  000a 4f            	clr	a
1709  000b 2010          	jra	L212
1710  000d               L602:
1711  000d ae0121        	ldw	x,#289
1712  0010 89            	pushw	x
1713  0011 ae0000        	ldw	x,#0
1714  0014 89            	pushw	x
1715  0015 ae0000        	ldw	x,#L542
1716  0018 cd0000        	call	_assert_failed
1718  001b 5b04          	addw	sp,#4
1719  001d               L212:
1720                     ; 290   assert_param(IS_ADC1_CHANNEL_OK(ADC1_Channel));
1722  001d 0d02          	tnz	(OFST+2,sp)
1723  001f 273c          	jreq	L612
1724  0021 7b02          	ld	a,(OFST+2,sp)
1725  0023 a101          	cp	a,#1
1726  0025 2736          	jreq	L612
1727  0027 7b02          	ld	a,(OFST+2,sp)
1728  0029 a102          	cp	a,#2
1729  002b 2730          	jreq	L612
1730  002d 7b02          	ld	a,(OFST+2,sp)
1731  002f a103          	cp	a,#3
1732  0031 272a          	jreq	L612
1733  0033 7b02          	ld	a,(OFST+2,sp)
1734  0035 a104          	cp	a,#4
1735  0037 2724          	jreq	L612
1736  0039 7b02          	ld	a,(OFST+2,sp)
1737  003b a105          	cp	a,#5
1738  003d 271e          	jreq	L612
1739  003f 7b02          	ld	a,(OFST+2,sp)
1740  0041 a106          	cp	a,#6
1741  0043 2718          	jreq	L612
1742  0045 7b02          	ld	a,(OFST+2,sp)
1743  0047 a107          	cp	a,#7
1744  0049 2712          	jreq	L612
1745  004b 7b02          	ld	a,(OFST+2,sp)
1746  004d a108          	cp	a,#8
1747  004f 270c          	jreq	L612
1748  0051 7b02          	ld	a,(OFST+2,sp)
1749  0053 a10c          	cp	a,#12
1750  0055 2706          	jreq	L612
1751  0057 7b02          	ld	a,(OFST+2,sp)
1752  0059 a109          	cp	a,#9
1753  005b 2603          	jrne	L412
1754  005d               L612:
1755  005d 4f            	clr	a
1756  005e 2010          	jra	L022
1757  0060               L412:
1758  0060 ae0122        	ldw	x,#290
1759  0063 89            	pushw	x
1760  0064 ae0000        	ldw	x,#0
1761  0067 89            	pushw	x
1762  0068 ae0000        	ldw	x,#L542
1763  006b cd0000        	call	_assert_failed
1765  006e 5b04          	addw	sp,#4
1766  0070               L022:
1767                     ; 291   assert_param(IS_ADC1_ALIGN_OK(ADC1_Align));
1769  0070 0d05          	tnz	(OFST+5,sp)
1770  0072 2706          	jreq	L422
1771  0074 7b05          	ld	a,(OFST+5,sp)
1772  0076 a108          	cp	a,#8
1773  0078 2603          	jrne	L222
1774  007a               L422:
1775  007a 4f            	clr	a
1776  007b 2010          	jra	L622
1777  007d               L222:
1778  007d ae0123        	ldw	x,#291
1779  0080 89            	pushw	x
1780  0081 ae0000        	ldw	x,#0
1781  0084 89            	pushw	x
1782  0085 ae0000        	ldw	x,#L542
1783  0088 cd0000        	call	_assert_failed
1785  008b 5b04          	addw	sp,#4
1786  008d               L622:
1787                     ; 294   ADC1->CR2 &= (uint8_t)(~ADC1_CR2_ALIGN);
1789  008d 72175402      	bres	21506,#3
1790                     ; 296   ADC1->CR2 |= (uint8_t)(ADC1_Align);
1792  0091 c65402        	ld	a,21506
1793  0094 1a05          	or	a,(OFST+5,sp)
1794  0096 c75402        	ld	21506,a
1795                     ; 298   if (ADC1_ConversionMode == ADC1_CONVERSIONMODE_CONTINUOUS)
1797  0099 7b01          	ld	a,(OFST+1,sp)
1798  009b a101          	cp	a,#1
1799  009d 2606          	jrne	L735
1800                     ; 301     ADC1->CR1 |= ADC1_CR1_CONT;
1802  009f 72125401      	bset	21505,#1
1804  00a3 2004          	jra	L145
1805  00a5               L735:
1806                     ; 306     ADC1->CR1 &= (uint8_t)(~ADC1_CR1_CONT);
1808  00a5 72135401      	bres	21505,#1
1809  00a9               L145:
1810                     ; 310   ADC1->CSR &= (uint8_t)(~ADC1_CSR_CH);
1812  00a9 c65400        	ld	a,21504
1813  00ac a4f0          	and	a,#240
1814  00ae c75400        	ld	21504,a
1815                     ; 312   ADC1->CSR |= (uint8_t)(ADC1_Channel);
1817  00b1 c65400        	ld	a,21504
1818  00b4 1a02          	or	a,(OFST+2,sp)
1819  00b6 c75400        	ld	21504,a
1820                     ; 313 }
1823  00b9 85            	popw	x
1824  00ba 81            	ret
1871                     ; 325 void ADC1_ExternalTriggerConfig(ADC1_ExtTrig_TypeDef ADC1_ExtTrigger, FunctionalState NewState)
1871                     ; 326 {
1872                     .text:	section	.text,new
1873  0000               _ADC1_ExternalTriggerConfig:
1875  0000 89            	pushw	x
1876       00000000      OFST:	set	0
1879                     ; 328   assert_param(IS_ADC1_EXTTRIG_OK(ADC1_ExtTrigger));
1881  0001 9e            	ld	a,xh
1882  0002 4d            	tnz	a
1883  0003 2705          	jreq	L432
1884  0005 9e            	ld	a,xh
1885  0006 a110          	cp	a,#16
1886  0008 2603          	jrne	L232
1887  000a               L432:
1888  000a 4f            	clr	a
1889  000b 2010          	jra	L632
1890  000d               L232:
1891  000d ae0148        	ldw	x,#328
1892  0010 89            	pushw	x
1893  0011 ae0000        	ldw	x,#0
1894  0014 89            	pushw	x
1895  0015 ae0000        	ldw	x,#L542
1896  0018 cd0000        	call	_assert_failed
1898  001b 5b04          	addw	sp,#4
1899  001d               L632:
1900                     ; 329   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1902  001d 0d02          	tnz	(OFST+2,sp)
1903  001f 2706          	jreq	L242
1904  0021 7b02          	ld	a,(OFST+2,sp)
1905  0023 a101          	cp	a,#1
1906  0025 2603          	jrne	L042
1907  0027               L242:
1908  0027 4f            	clr	a
1909  0028 2010          	jra	L442
1910  002a               L042:
1911  002a ae0149        	ldw	x,#329
1912  002d 89            	pushw	x
1913  002e ae0000        	ldw	x,#0
1914  0031 89            	pushw	x
1915  0032 ae0000        	ldw	x,#L542
1916  0035 cd0000        	call	_assert_failed
1918  0038 5b04          	addw	sp,#4
1919  003a               L442:
1920                     ; 332   ADC1->CR2 &= (uint8_t)(~ADC1_CR2_EXTSEL);
1922  003a c65402        	ld	a,21506
1923  003d a4cf          	and	a,#207
1924  003f c75402        	ld	21506,a
1925                     ; 334   if (NewState != DISABLE)
1927  0042 0d02          	tnz	(OFST+2,sp)
1928  0044 2706          	jreq	L565
1929                     ; 337     ADC1->CR2 |= (uint8_t)(ADC1_CR2_EXTTRIG);
1931  0046 721c5402      	bset	21506,#6
1933  004a 2004          	jra	L765
1934  004c               L565:
1935                     ; 342     ADC1->CR2 &= (uint8_t)(~ADC1_CR2_EXTTRIG);
1937  004c 721d5402      	bres	21506,#6
1938  0050               L765:
1939                     ; 346   ADC1->CR2 |= (uint8_t)(ADC1_ExtTrigger);
1941  0050 c65402        	ld	a,21506
1942  0053 1a01          	or	a,(OFST+1,sp)
1943  0055 c75402        	ld	21506,a
1944                     ; 347 }
1947  0058 85            	popw	x
1948  0059 81            	ret
1972                     ; 358 void ADC1_StartConversion(void)
1972                     ; 359 {
1973                     .text:	section	.text,new
1974  0000               _ADC1_StartConversion:
1978                     ; 360   ADC1->CR1 |= ADC1_CR1_ADON;
1980  0000 72105401      	bset	21505,#0
1981                     ; 361 }
1984  0004 81            	ret
2028                     ; 370 uint16_t ADC1_GetConversionValue(void)
2028                     ; 371 {
2029                     .text:	section	.text,new
2030  0000               _ADC1_GetConversionValue:
2032  0000 5205          	subw	sp,#5
2033       00000005      OFST:	set	5
2036                     ; 372   uint16_t temph = 0;
2038                     ; 373   uint8_t templ = 0;
2040                     ; 375   if ((ADC1->CR2 & ADC1_CR2_ALIGN) != 0) /* Right alignment */
2042  0002 c65402        	ld	a,21506
2043  0005 a508          	bcp	a,#8
2044  0007 2715          	jreq	L326
2045                     ; 378     templ = ADC1->DRL;
2047  0009 c65405        	ld	a,21509
2048  000c 6b03          	ld	(OFST-2,sp),a
2049                     ; 380     temph = ADC1->DRH;
2051  000e c65404        	ld	a,21508
2052  0011 5f            	clrw	x
2053  0012 97            	ld	xl,a
2054  0013 1f04          	ldw	(OFST-1,sp),x
2055                     ; 382     temph = (uint16_t)(templ | (uint16_t)(temph << (uint8_t)8));
2057  0015 1e04          	ldw	x,(OFST-1,sp)
2058  0017 7b03          	ld	a,(OFST-2,sp)
2059  0019 02            	rlwa	x,a
2060  001a 1f04          	ldw	(OFST-1,sp),x
2062  001c 2021          	jra	L526
2063  001e               L326:
2064                     ; 387     temph = ADC1->DRH;
2066  001e c65404        	ld	a,21508
2067  0021 5f            	clrw	x
2068  0022 97            	ld	xl,a
2069  0023 1f04          	ldw	(OFST-1,sp),x
2070                     ; 389     templ = ADC1->DRL;
2072  0025 c65405        	ld	a,21509
2073  0028 6b03          	ld	(OFST-2,sp),a
2074                     ; 391     temph = (uint16_t)((uint16_t)((uint16_t)templ << 6) | (uint16_t)((uint16_t)temph << 8));
2076  002a 1e04          	ldw	x,(OFST-1,sp)
2077  002c 4f            	clr	a
2078  002d 02            	rlwa	x,a
2079  002e 1f01          	ldw	(OFST-4,sp),x
2080  0030 7b03          	ld	a,(OFST-2,sp)
2081  0032 97            	ld	xl,a
2082  0033 a640          	ld	a,#64
2083  0035 42            	mul	x,a
2084  0036 01            	rrwa	x,a
2085  0037 1a02          	or	a,(OFST-3,sp)
2086  0039 01            	rrwa	x,a
2087  003a 1a01          	or	a,(OFST-4,sp)
2088  003c 01            	rrwa	x,a
2089  003d 1f04          	ldw	(OFST-1,sp),x
2090  003f               L526:
2091                     ; 394   return ((uint16_t)temph);
2093  003f 1e04          	ldw	x,(OFST-1,sp)
2096  0041 5b05          	addw	sp,#5
2097  0043 81            	ret
2144                     ; 405 void ADC1_AWDChannelConfig(ADC1_Channel_TypeDef Channel, FunctionalState NewState)
2144                     ; 406 {
2145                     .text:	section	.text,new
2146  0000               _ADC1_AWDChannelConfig:
2148  0000 89            	pushw	x
2149       00000000      OFST:	set	0
2152                     ; 408   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2154  0001 9f            	ld	a,xl
2155  0002 4d            	tnz	a
2156  0003 2705          	jreq	L652
2157  0005 9f            	ld	a,xl
2158  0006 a101          	cp	a,#1
2159  0008 2603          	jrne	L452
2160  000a               L652:
2161  000a 4f            	clr	a
2162  000b 2010          	jra	L062
2163  000d               L452:
2164  000d ae0198        	ldw	x,#408
2165  0010 89            	pushw	x
2166  0011 ae0000        	ldw	x,#0
2167  0014 89            	pushw	x
2168  0015 ae0000        	ldw	x,#L542
2169  0018 cd0000        	call	_assert_failed
2171  001b 5b04          	addw	sp,#4
2172  001d               L062:
2173                     ; 409   assert_param(IS_ADC1_CHANNEL_OK(Channel));
2175  001d 0d01          	tnz	(OFST+1,sp)
2176  001f 273c          	jreq	L462
2177  0021 7b01          	ld	a,(OFST+1,sp)
2178  0023 a101          	cp	a,#1
2179  0025 2736          	jreq	L462
2180  0027 7b01          	ld	a,(OFST+1,sp)
2181  0029 a102          	cp	a,#2
2182  002b 2730          	jreq	L462
2183  002d 7b01          	ld	a,(OFST+1,sp)
2184  002f a103          	cp	a,#3
2185  0031 272a          	jreq	L462
2186  0033 7b01          	ld	a,(OFST+1,sp)
2187  0035 a104          	cp	a,#4
2188  0037 2724          	jreq	L462
2189  0039 7b01          	ld	a,(OFST+1,sp)
2190  003b a105          	cp	a,#5
2191  003d 271e          	jreq	L462
2192  003f 7b01          	ld	a,(OFST+1,sp)
2193  0041 a106          	cp	a,#6
2194  0043 2718          	jreq	L462
2195  0045 7b01          	ld	a,(OFST+1,sp)
2196  0047 a107          	cp	a,#7
2197  0049 2712          	jreq	L462
2198  004b 7b01          	ld	a,(OFST+1,sp)
2199  004d a108          	cp	a,#8
2200  004f 270c          	jreq	L462
2201  0051 7b01          	ld	a,(OFST+1,sp)
2202  0053 a10c          	cp	a,#12
2203  0055 2706          	jreq	L462
2204  0057 7b01          	ld	a,(OFST+1,sp)
2205  0059 a109          	cp	a,#9
2206  005b 2603          	jrne	L262
2207  005d               L462:
2208  005d 4f            	clr	a
2209  005e 2010          	jra	L662
2210  0060               L262:
2211  0060 ae0199        	ldw	x,#409
2212  0063 89            	pushw	x
2213  0064 ae0000        	ldw	x,#0
2214  0067 89            	pushw	x
2215  0068 ae0000        	ldw	x,#L542
2216  006b cd0000        	call	_assert_failed
2218  006e 5b04          	addw	sp,#4
2219  0070               L662:
2220                     ; 411   if (Channel < (uint8_t)8)
2222  0070 7b01          	ld	a,(OFST+1,sp)
2223  0072 a108          	cp	a,#8
2224  0074 242f          	jruge	L156
2225                     ; 413     if (NewState != DISABLE)
2227  0076 0d02          	tnz	(OFST+2,sp)
2228  0078 2715          	jreq	L356
2229                     ; 415       ADC1->AWCRL |= (uint8_t)((uint8_t)1 << Channel);
2231  007a 7b01          	ld	a,(OFST+1,sp)
2232  007c 5f            	clrw	x
2233  007d 97            	ld	xl,a
2234  007e a601          	ld	a,#1
2235  0080 5d            	tnzw	x
2236  0081 2704          	jreq	L072
2237  0083               L272:
2238  0083 48            	sll	a
2239  0084 5a            	decw	x
2240  0085 26fc          	jrne	L272
2241  0087               L072:
2242  0087 ca540f        	or	a,21519
2243  008a c7540f        	ld	21519,a
2245  008d 2047          	jra	L756
2246  008f               L356:
2247                     ; 419       ADC1->AWCRL &= (uint8_t)~(uint8_t)((uint8_t)1 << Channel);
2249  008f 7b01          	ld	a,(OFST+1,sp)
2250  0091 5f            	clrw	x
2251  0092 97            	ld	xl,a
2252  0093 a601          	ld	a,#1
2253  0095 5d            	tnzw	x
2254  0096 2704          	jreq	L472
2255  0098               L672:
2256  0098 48            	sll	a
2257  0099 5a            	decw	x
2258  009a 26fc          	jrne	L672
2259  009c               L472:
2260  009c 43            	cpl	a
2261  009d c4540f        	and	a,21519
2262  00a0 c7540f        	ld	21519,a
2263  00a3 2031          	jra	L756
2264  00a5               L156:
2265                     ; 424     if (NewState != DISABLE)
2267  00a5 0d02          	tnz	(OFST+2,sp)
2268  00a7 2717          	jreq	L166
2269                     ; 426       ADC1->AWCRH |= (uint8_t)((uint8_t)1 << (Channel - (uint8_t)8));
2271  00a9 7b01          	ld	a,(OFST+1,sp)
2272  00ab a008          	sub	a,#8
2273  00ad 5f            	clrw	x
2274  00ae 97            	ld	xl,a
2275  00af a601          	ld	a,#1
2276  00b1 5d            	tnzw	x
2277  00b2 2704          	jreq	L003
2278  00b4               L203:
2279  00b4 48            	sll	a
2280  00b5 5a            	decw	x
2281  00b6 26fc          	jrne	L203
2282  00b8               L003:
2283  00b8 ca540e        	or	a,21518
2284  00bb c7540e        	ld	21518,a
2286  00be 2016          	jra	L756
2287  00c0               L166:
2288                     ; 430       ADC1->AWCRH &= (uint8_t)~(uint8_t)((uint8_t)1 << (uint8_t)(Channel - (uint8_t)8));
2290  00c0 7b01          	ld	a,(OFST+1,sp)
2291  00c2 a008          	sub	a,#8
2292  00c4 5f            	clrw	x
2293  00c5 97            	ld	xl,a
2294  00c6 a601          	ld	a,#1
2295  00c8 5d            	tnzw	x
2296  00c9 2704          	jreq	L403
2297  00cb               L603:
2298  00cb 48            	sll	a
2299  00cc 5a            	decw	x
2300  00cd 26fc          	jrne	L603
2301  00cf               L403:
2302  00cf 43            	cpl	a
2303  00d0 c4540e        	and	a,21518
2304  00d3 c7540e        	ld	21518,a
2305  00d6               L756:
2306                     ; 433 }
2309  00d6 85            	popw	x
2310  00d7 81            	ret
2345                     ; 441 void ADC1_SetHighThreshold(uint16_t Threshold)
2345                     ; 442 {
2346                     .text:	section	.text,new
2347  0000               _ADC1_SetHighThreshold:
2349  0000 89            	pushw	x
2350       00000000      OFST:	set	0
2353                     ; 443   ADC1->HTRH = (uint8_t)(Threshold >> (uint8_t)2);
2355  0001 54            	srlw	x
2356  0002 54            	srlw	x
2357  0003 9f            	ld	a,xl
2358  0004 c75408        	ld	21512,a
2359                     ; 444   ADC1->HTRL = (uint8_t)Threshold;
2361  0007 7b02          	ld	a,(OFST+2,sp)
2362  0009 c75409        	ld	21513,a
2363                     ; 445 }
2366  000c 85            	popw	x
2367  000d 81            	ret
2402                     ; 453 void ADC1_SetLowThreshold(uint16_t Threshold)
2402                     ; 454 {
2403                     .text:	section	.text,new
2404  0000               _ADC1_SetLowThreshold:
2408                     ; 455   ADC1->LTRL = (uint8_t)Threshold;
2410  0000 9f            	ld	a,xl
2411  0001 c7540b        	ld	21515,a
2412                     ; 456   ADC1->LTRH = (uint8_t)(Threshold >> (uint8_t)2);
2414  0004 54            	srlw	x
2415  0005 54            	srlw	x
2416  0006 9f            	ld	a,xl
2417  0007 c7540a        	ld	21514,a
2418                     ; 457 }
2421  000a 81            	ret
2475                     ; 466 uint16_t ADC1_GetBufferValue(uint8_t Buffer)
2475                     ; 467 {
2476                     .text:	section	.text,new
2477  0000               _ADC1_GetBufferValue:
2479  0000 88            	push	a
2480  0001 5205          	subw	sp,#5
2481       00000005      OFST:	set	5
2484                     ; 468   uint16_t temph = 0;
2486                     ; 469   uint8_t templ = 0;
2488                     ; 472   assert_param(IS_ADC1_BUFFER_OK(Buffer));
2490  0003 a10a          	cp	a,#10
2491  0005 2403          	jruge	L613
2492  0007 4f            	clr	a
2493  0008 2010          	jra	L023
2494  000a               L613:
2495  000a ae01d8        	ldw	x,#472
2496  000d 89            	pushw	x
2497  000e ae0000        	ldw	x,#0
2498  0011 89            	pushw	x
2499  0012 ae0000        	ldw	x,#L542
2500  0015 cd0000        	call	_assert_failed
2502  0018 5b04          	addw	sp,#4
2503  001a               L023:
2504                     ; 474   if ((ADC1->CR2 & ADC1_CR2_ALIGN) != 0) /* Right alignment */
2506  001a c65402        	ld	a,21506
2507  001d a508          	bcp	a,#8
2508  001f 271f          	jreq	L747
2509                     ; 477     templ = *(uint8_t*)(uint16_t)((uint16_t)ADC1_BaseAddress + (uint8_t)(Buffer << 1) + 1);
2511  0021 7b06          	ld	a,(OFST+1,sp)
2512  0023 48            	sll	a
2513  0024 5f            	clrw	x
2514  0025 97            	ld	xl,a
2515  0026 d653e1        	ld	a,(21473,x)
2516  0029 6b03          	ld	(OFST-2,sp),a
2517                     ; 479     temph = *(uint8_t*)(uint16_t)((uint16_t)ADC1_BaseAddress + (uint8_t)(Buffer << 1));
2519  002b 7b06          	ld	a,(OFST+1,sp)
2520  002d 48            	sll	a
2521  002e 5f            	clrw	x
2522  002f 97            	ld	xl,a
2523  0030 d653e0        	ld	a,(21472,x)
2524  0033 5f            	clrw	x
2525  0034 97            	ld	xl,a
2526  0035 1f04          	ldw	(OFST-1,sp),x
2527                     ; 481     temph = (uint16_t)(templ | (uint16_t)(temph << (uint8_t)8));
2529  0037 1e04          	ldw	x,(OFST-1,sp)
2530  0039 7b03          	ld	a,(OFST-2,sp)
2531  003b 02            	rlwa	x,a
2532  003c 1f04          	ldw	(OFST-1,sp),x
2534  003e 202b          	jra	L157
2535  0040               L747:
2536                     ; 486     temph = *(uint8_t*)(uint16_t)((uint16_t)ADC1_BaseAddress + (uint8_t)(Buffer << 1));
2538  0040 7b06          	ld	a,(OFST+1,sp)
2539  0042 48            	sll	a
2540  0043 5f            	clrw	x
2541  0044 97            	ld	xl,a
2542  0045 d653e0        	ld	a,(21472,x)
2543  0048 5f            	clrw	x
2544  0049 97            	ld	xl,a
2545  004a 1f04          	ldw	(OFST-1,sp),x
2546                     ; 488     templ = *(uint8_t*)(uint16_t)((uint16_t)ADC1_BaseAddress + (uint8_t)(Buffer << 1) + 1);
2548  004c 7b06          	ld	a,(OFST+1,sp)
2549  004e 48            	sll	a
2550  004f 5f            	clrw	x
2551  0050 97            	ld	xl,a
2552  0051 d653e1        	ld	a,(21473,x)
2553  0054 6b03          	ld	(OFST-2,sp),a
2554                     ; 490     temph = (uint16_t)((uint16_t)((uint16_t)templ << 6) | (uint16_t)(temph << 8));
2556  0056 1e04          	ldw	x,(OFST-1,sp)
2557  0058 4f            	clr	a
2558  0059 02            	rlwa	x,a
2559  005a 1f01          	ldw	(OFST-4,sp),x
2560  005c 7b03          	ld	a,(OFST-2,sp)
2561  005e 97            	ld	xl,a
2562  005f a640          	ld	a,#64
2563  0061 42            	mul	x,a
2564  0062 01            	rrwa	x,a
2565  0063 1a02          	or	a,(OFST-3,sp)
2566  0065 01            	rrwa	x,a
2567  0066 1a01          	or	a,(OFST-4,sp)
2568  0068 01            	rrwa	x,a
2569  0069 1f04          	ldw	(OFST-1,sp),x
2570  006b               L157:
2571                     ; 493   return ((uint16_t)temph);
2573  006b 1e04          	ldw	x,(OFST-1,sp)
2576  006d 5b06          	addw	sp,#6
2577  006f 81            	ret
2644                     ; 502 FlagStatus ADC1_GetAWDChannelStatus(ADC1_Channel_TypeDef Channel)
2644                     ; 503 {
2645                     .text:	section	.text,new
2646  0000               _ADC1_GetAWDChannelStatus:
2648  0000 88            	push	a
2649  0001 88            	push	a
2650       00000001      OFST:	set	1
2653                     ; 504   uint8_t status = 0;
2655                     ; 507   assert_param(IS_ADC1_CHANNEL_OK(Channel));
2657  0002 4d            	tnz	a
2658  0003 2728          	jreq	L623
2659  0005 a101          	cp	a,#1
2660  0007 2724          	jreq	L623
2661  0009 a102          	cp	a,#2
2662  000b 2720          	jreq	L623
2663  000d a103          	cp	a,#3
2664  000f 271c          	jreq	L623
2665  0011 a104          	cp	a,#4
2666  0013 2718          	jreq	L623
2667  0015 a105          	cp	a,#5
2668  0017 2714          	jreq	L623
2669  0019 a106          	cp	a,#6
2670  001b 2710          	jreq	L623
2671  001d a107          	cp	a,#7
2672  001f 270c          	jreq	L623
2673  0021 a108          	cp	a,#8
2674  0023 2708          	jreq	L623
2675  0025 a10c          	cp	a,#12
2676  0027 2704          	jreq	L623
2677  0029 a109          	cp	a,#9
2678  002b 2603          	jrne	L423
2679  002d               L623:
2680  002d 4f            	clr	a
2681  002e 2010          	jra	L033
2682  0030               L423:
2683  0030 ae01fb        	ldw	x,#507
2684  0033 89            	pushw	x
2685  0034 ae0000        	ldw	x,#0
2686  0037 89            	pushw	x
2687  0038 ae0000        	ldw	x,#L542
2688  003b cd0000        	call	_assert_failed
2690  003e 5b04          	addw	sp,#4
2691  0040               L033:
2692                     ; 509   if (Channel < (uint8_t)8)
2694  0040 7b02          	ld	a,(OFST+1,sp)
2695  0042 a108          	cp	a,#8
2696  0044 2414          	jruge	L5001
2697                     ; 511     status = (uint8_t)(ADC1->AWSRL & (uint8_t)((uint8_t)1 << Channel));
2699  0046 7b02          	ld	a,(OFST+1,sp)
2700  0048 5f            	clrw	x
2701  0049 97            	ld	xl,a
2702  004a a601          	ld	a,#1
2703  004c 5d            	tnzw	x
2704  004d 2704          	jreq	L233
2705  004f               L433:
2706  004f 48            	sll	a
2707  0050 5a            	decw	x
2708  0051 26fc          	jrne	L433
2709  0053               L233:
2710  0053 c4540d        	and	a,21517
2711  0056 6b01          	ld	(OFST+0,sp),a
2713  0058 2014          	jra	L7001
2714  005a               L5001:
2715                     ; 515     status = (uint8_t)(ADC1->AWSRH & (uint8_t)((uint8_t)1 << (Channel - (uint8_t)8)));
2717  005a 7b02          	ld	a,(OFST+1,sp)
2718  005c a008          	sub	a,#8
2719  005e 5f            	clrw	x
2720  005f 97            	ld	xl,a
2721  0060 a601          	ld	a,#1
2722  0062 5d            	tnzw	x
2723  0063 2704          	jreq	L633
2724  0065               L043:
2725  0065 48            	sll	a
2726  0066 5a            	decw	x
2727  0067 26fc          	jrne	L043
2728  0069               L633:
2729  0069 c4540c        	and	a,21516
2730  006c 6b01          	ld	(OFST+0,sp),a
2731  006e               L7001:
2732                     ; 518   return ((FlagStatus)status);
2734  006e 7b01          	ld	a,(OFST+0,sp)
2737  0070 85            	popw	x
2738  0071 81            	ret
2897                     ; 527 FlagStatus ADC1_GetFlagStatus(ADC1_Flag_TypeDef Flag)
2897                     ; 528 {
2898                     .text:	section	.text,new
2899  0000               _ADC1_GetFlagStatus:
2901  0000 88            	push	a
2902  0001 88            	push	a
2903       00000001      OFST:	set	1
2906                     ; 529   uint8_t flagstatus = 0;
2908                     ; 530   uint8_t temp = 0;
2910                     ; 533   assert_param(IS_ADC1_FLAG_OK(Flag));
2912  0002 a180          	cp	a,#128
2913  0004 2730          	jreq	L643
2914  0006 a141          	cp	a,#65
2915  0008 272c          	jreq	L643
2916  000a a140          	cp	a,#64
2917  000c 2728          	jreq	L643
2918  000e a110          	cp	a,#16
2919  0010 2724          	jreq	L643
2920  0012 a111          	cp	a,#17
2921  0014 2720          	jreq	L643
2922  0016 a112          	cp	a,#18
2923  0018 271c          	jreq	L643
2924  001a a113          	cp	a,#19
2925  001c 2718          	jreq	L643
2926  001e a114          	cp	a,#20
2927  0020 2714          	jreq	L643
2928  0022 a115          	cp	a,#21
2929  0024 2710          	jreq	L643
2930  0026 a116          	cp	a,#22
2931  0028 270c          	jreq	L643
2932  002a a117          	cp	a,#23
2933  002c 2708          	jreq	L643
2934  002e a118          	cp	a,#24
2935  0030 2704          	jreq	L643
2936  0032 a119          	cp	a,#25
2937  0034 2603          	jrne	L443
2938  0036               L643:
2939  0036 4f            	clr	a
2940  0037 2010          	jra	L053
2941  0039               L443:
2942  0039 ae0215        	ldw	x,#533
2943  003c 89            	pushw	x
2944  003d ae0000        	ldw	x,#0
2945  0040 89            	pushw	x
2946  0041 ae0000        	ldw	x,#L542
2947  0044 cd0000        	call	_assert_failed
2949  0047 5b04          	addw	sp,#4
2950  0049               L053:
2951                     ; 535   if ((Flag & 0x0F) == 0x01)
2953  0049 7b02          	ld	a,(OFST+1,sp)
2954  004b a40f          	and	a,#15
2955  004d a101          	cp	a,#1
2956  004f 2609          	jrne	L7701
2957                     ; 538     flagstatus = (uint8_t)(ADC1->CR3 & ADC1_CR3_OVR);
2959  0051 c65403        	ld	a,21507
2960  0054 a440          	and	a,#64
2961  0056 6b01          	ld	(OFST+0,sp),a
2963  0058 2045          	jra	L1011
2964  005a               L7701:
2965                     ; 540   else if ((Flag & 0xF0) == 0x10)
2967  005a 7b02          	ld	a,(OFST+1,sp)
2968  005c a4f0          	and	a,#240
2969  005e a110          	cp	a,#16
2970  0060 2636          	jrne	L3011
2971                     ; 543     temp = (uint8_t)(Flag & (uint8_t)0x0F);
2973  0062 7b02          	ld	a,(OFST+1,sp)
2974  0064 a40f          	and	a,#15
2975  0066 6b01          	ld	(OFST+0,sp),a
2976                     ; 544     if (temp < 8)
2978  0068 7b01          	ld	a,(OFST+0,sp)
2979  006a a108          	cp	a,#8
2980  006c 2414          	jruge	L5011
2981                     ; 546       flagstatus = (uint8_t)(ADC1->AWSRL & (uint8_t)((uint8_t)1 << temp));
2983  006e 7b01          	ld	a,(OFST+0,sp)
2984  0070 5f            	clrw	x
2985  0071 97            	ld	xl,a
2986  0072 a601          	ld	a,#1
2987  0074 5d            	tnzw	x
2988  0075 2704          	jreq	L253
2989  0077               L453:
2990  0077 48            	sll	a
2991  0078 5a            	decw	x
2992  0079 26fc          	jrne	L453
2993  007b               L253:
2994  007b c4540d        	and	a,21517
2995  007e 6b01          	ld	(OFST+0,sp),a
2997  0080 201d          	jra	L1011
2998  0082               L5011:
2999                     ; 550       flagstatus = (uint8_t)(ADC1->AWSRH & (uint8_t)((uint8_t)1 << (temp - 8)));
3001  0082 7b01          	ld	a,(OFST+0,sp)
3002  0084 a008          	sub	a,#8
3003  0086 5f            	clrw	x
3004  0087 97            	ld	xl,a
3005  0088 a601          	ld	a,#1
3006  008a 5d            	tnzw	x
3007  008b 2704          	jreq	L653
3008  008d               L063:
3009  008d 48            	sll	a
3010  008e 5a            	decw	x
3011  008f 26fc          	jrne	L063
3012  0091               L653:
3013  0091 c4540c        	and	a,21516
3014  0094 6b01          	ld	(OFST+0,sp),a
3015  0096 2007          	jra	L1011
3016  0098               L3011:
3017                     ; 555     flagstatus = (uint8_t)(ADC1->CSR & Flag);
3019  0098 c65400        	ld	a,21504
3020  009b 1402          	and	a,(OFST+1,sp)
3021  009d 6b01          	ld	(OFST+0,sp),a
3022  009f               L1011:
3023                     ; 557   return ((FlagStatus)flagstatus);
3025  009f 7b01          	ld	a,(OFST+0,sp)
3028  00a1 85            	popw	x
3029  00a2 81            	ret
3074                     ; 567 void ADC1_ClearFlag(ADC1_Flag_TypeDef Flag)
3074                     ; 568 {
3075                     .text:	section	.text,new
3076  0000               _ADC1_ClearFlag:
3078  0000 88            	push	a
3079  0001 88            	push	a
3080       00000001      OFST:	set	1
3083                     ; 569   uint8_t temp = 0;
3085                     ; 572   assert_param(IS_ADC1_FLAG_OK(Flag));
3087  0002 a180          	cp	a,#128
3088  0004 2730          	jreq	L663
3089  0006 a141          	cp	a,#65
3090  0008 272c          	jreq	L663
3091  000a a140          	cp	a,#64
3092  000c 2728          	jreq	L663
3093  000e a110          	cp	a,#16
3094  0010 2724          	jreq	L663
3095  0012 a111          	cp	a,#17
3096  0014 2720          	jreq	L663
3097  0016 a112          	cp	a,#18
3098  0018 271c          	jreq	L663
3099  001a a113          	cp	a,#19
3100  001c 2718          	jreq	L663
3101  001e a114          	cp	a,#20
3102  0020 2714          	jreq	L663
3103  0022 a115          	cp	a,#21
3104  0024 2710          	jreq	L663
3105  0026 a116          	cp	a,#22
3106  0028 270c          	jreq	L663
3107  002a a117          	cp	a,#23
3108  002c 2708          	jreq	L663
3109  002e a118          	cp	a,#24
3110  0030 2704          	jreq	L663
3111  0032 a119          	cp	a,#25
3112  0034 2603          	jrne	L463
3113  0036               L663:
3114  0036 4f            	clr	a
3115  0037 2010          	jra	L073
3116  0039               L463:
3117  0039 ae023c        	ldw	x,#572
3118  003c 89            	pushw	x
3119  003d ae0000        	ldw	x,#0
3120  0040 89            	pushw	x
3121  0041 ae0000        	ldw	x,#L542
3122  0044 cd0000        	call	_assert_failed
3124  0047 5b04          	addw	sp,#4
3125  0049               L073:
3126                     ; 574   if ((Flag & 0x0F) == 0x01)
3128  0049 7b02          	ld	a,(OFST+1,sp)
3129  004b a40f          	and	a,#15
3130  004d a101          	cp	a,#1
3131  004f 2606          	jrne	L5311
3132                     ; 577     ADC1->CR3 &= (uint8_t)(~ADC1_CR3_OVR);
3134  0051 721d5403      	bres	21507,#6
3136  0055 204b          	jra	L7311
3137  0057               L5311:
3138                     ; 579   else if ((Flag & 0xF0) == 0x10)
3140  0057 7b02          	ld	a,(OFST+1,sp)
3141  0059 a4f0          	and	a,#240
3142  005b a110          	cp	a,#16
3143  005d 263a          	jrne	L1411
3144                     ; 582     temp = (uint8_t)(Flag & (uint8_t)0x0F);
3146  005f 7b02          	ld	a,(OFST+1,sp)
3147  0061 a40f          	and	a,#15
3148  0063 6b01          	ld	(OFST+0,sp),a
3149                     ; 583     if (temp < 8)
3151  0065 7b01          	ld	a,(OFST+0,sp)
3152  0067 a108          	cp	a,#8
3153  0069 2416          	jruge	L3411
3154                     ; 585       ADC1->AWSRL &= (uint8_t)~(uint8_t)((uint8_t)1 << temp);
3156  006b 7b01          	ld	a,(OFST+0,sp)
3157  006d 5f            	clrw	x
3158  006e 97            	ld	xl,a
3159  006f a601          	ld	a,#1
3160  0071 5d            	tnzw	x
3161  0072 2704          	jreq	L273
3162  0074               L473:
3163  0074 48            	sll	a
3164  0075 5a            	decw	x
3165  0076 26fc          	jrne	L473
3166  0078               L273:
3167  0078 43            	cpl	a
3168  0079 c4540d        	and	a,21517
3169  007c c7540d        	ld	21517,a
3171  007f 2021          	jra	L7311
3172  0081               L3411:
3173                     ; 589       ADC1->AWSRH &= (uint8_t)~(uint8_t)((uint8_t)1 << (temp - 8));
3175  0081 7b01          	ld	a,(OFST+0,sp)
3176  0083 a008          	sub	a,#8
3177  0085 5f            	clrw	x
3178  0086 97            	ld	xl,a
3179  0087 a601          	ld	a,#1
3180  0089 5d            	tnzw	x
3181  008a 2704          	jreq	L673
3182  008c               L004:
3183  008c 48            	sll	a
3184  008d 5a            	decw	x
3185  008e 26fc          	jrne	L004
3186  0090               L673:
3187  0090 43            	cpl	a
3188  0091 c4540c        	and	a,21516
3189  0094 c7540c        	ld	21516,a
3190  0097 2009          	jra	L7311
3191  0099               L1411:
3192                     ; 594     ADC1->CSR &= (uint8_t) (~Flag);
3194  0099 7b02          	ld	a,(OFST+1,sp)
3195  009b 43            	cpl	a
3196  009c c45400        	and	a,21504
3197  009f c75400        	ld	21504,a
3198  00a2               L7311:
3199                     ; 596 }
3202  00a2 85            	popw	x
3203  00a3 81            	ret
3259                     ; 616 ITStatus ADC1_GetITStatus(ADC1_IT_TypeDef ITPendingBit)
3259                     ; 617 {
3260                     .text:	section	.text,new
3261  0000               _ADC1_GetITStatus:
3263  0000 89            	pushw	x
3264  0001 88            	push	a
3265       00000001      OFST:	set	1
3268                     ; 618   ITStatus itstatus = RESET;
3270                     ; 619   uint8_t temp = 0;
3272                     ; 622   assert_param(IS_ADC1_ITPENDINGBIT_OK(ITPendingBit));
3274  0002 a30080        	cpw	x,#128
3275  0005 273c          	jreq	L604
3276  0007 a30140        	cpw	x,#320
3277  000a 2737          	jreq	L604
3278  000c a30110        	cpw	x,#272
3279  000f 2732          	jreq	L604
3280  0011 a30111        	cpw	x,#273
3281  0014 272d          	jreq	L604
3282  0016 a30112        	cpw	x,#274
3283  0019 2728          	jreq	L604
3284  001b a30113        	cpw	x,#275
3285  001e 2723          	jreq	L604
3286  0020 a30114        	cpw	x,#276
3287  0023 271e          	jreq	L604
3288  0025 a30115        	cpw	x,#277
3289  0028 2719          	jreq	L604
3290  002a a30116        	cpw	x,#278
3291  002d 2714          	jreq	L604
3292  002f a30117        	cpw	x,#279
3293  0032 270f          	jreq	L604
3294  0034 a30118        	cpw	x,#280
3295  0037 270a          	jreq	L604
3296  0039 a3011c        	cpw	x,#284
3297  003c 2705          	jreq	L604
3298  003e a30119        	cpw	x,#281
3299  0041 2603          	jrne	L404
3300  0043               L604:
3301  0043 4f            	clr	a
3302  0044 2010          	jra	L014
3303  0046               L404:
3304  0046 ae026e        	ldw	x,#622
3305  0049 89            	pushw	x
3306  004a ae0000        	ldw	x,#0
3307  004d 89            	pushw	x
3308  004e ae0000        	ldw	x,#L542
3309  0051 cd0000        	call	_assert_failed
3311  0054 5b04          	addw	sp,#4
3312  0056               L014:
3313                     ; 624   if (((uint16_t)ITPendingBit & 0xF0) == 0x10)
3315  0056 7b02          	ld	a,(OFST+1,sp)
3316  0058 97            	ld	xl,a
3317  0059 7b03          	ld	a,(OFST+2,sp)
3318  005b a4f0          	and	a,#240
3319  005d 5f            	clrw	x
3320  005e 02            	rlwa	x,a
3321  005f a30010        	cpw	x,#16
3322  0062 2636          	jrne	L7711
3323                     ; 627     temp = (uint8_t)((uint16_t)ITPendingBit & 0x0F);
3325  0064 7b03          	ld	a,(OFST+2,sp)
3326  0066 a40f          	and	a,#15
3327  0068 6b01          	ld	(OFST+0,sp),a
3328                     ; 628     if (temp < 8)
3330  006a 7b01          	ld	a,(OFST+0,sp)
3331  006c a108          	cp	a,#8
3332  006e 2414          	jruge	L1021
3333                     ; 630       itstatus = (ITStatus)(ADC1->AWSRL & (uint8_t)((uint8_t)1 << temp));
3335  0070 7b01          	ld	a,(OFST+0,sp)
3336  0072 5f            	clrw	x
3337  0073 97            	ld	xl,a
3338  0074 a601          	ld	a,#1
3339  0076 5d            	tnzw	x
3340  0077 2704          	jreq	L214
3341  0079               L414:
3342  0079 48            	sll	a
3343  007a 5a            	decw	x
3344  007b 26fc          	jrne	L414
3345  007d               L214:
3346  007d c4540d        	and	a,21517
3347  0080 6b01          	ld	(OFST+0,sp),a
3349  0082 201d          	jra	L5021
3350  0084               L1021:
3351                     ; 634       itstatus = (ITStatus)(ADC1->AWSRH & (uint8_t)((uint8_t)1 << (temp - 8)));
3353  0084 7b01          	ld	a,(OFST+0,sp)
3354  0086 a008          	sub	a,#8
3355  0088 5f            	clrw	x
3356  0089 97            	ld	xl,a
3357  008a a601          	ld	a,#1
3358  008c 5d            	tnzw	x
3359  008d 2704          	jreq	L614
3360  008f               L024:
3361  008f 48            	sll	a
3362  0090 5a            	decw	x
3363  0091 26fc          	jrne	L024
3364  0093               L614:
3365  0093 c4540c        	and	a,21516
3366  0096 6b01          	ld	(OFST+0,sp),a
3367  0098 2007          	jra	L5021
3368  009a               L7711:
3369                     ; 639     itstatus = (ITStatus)(ADC1->CSR & (uint8_t)ITPendingBit);
3371  009a c65400        	ld	a,21504
3372  009d 1403          	and	a,(OFST+2,sp)
3373  009f 6b01          	ld	(OFST+0,sp),a
3374  00a1               L5021:
3375                     ; 641   return ((ITStatus)itstatus);
3377  00a1 7b01          	ld	a,(OFST+0,sp)
3380  00a3 5b03          	addw	sp,#3
3381  00a5 81            	ret
3427                     ; 662 void ADC1_ClearITPendingBit(ADC1_IT_TypeDef ITPendingBit)
3427                     ; 663 {
3428                     .text:	section	.text,new
3429  0000               _ADC1_ClearITPendingBit:
3431  0000 89            	pushw	x
3432  0001 88            	push	a
3433       00000001      OFST:	set	1
3436                     ; 664   uint8_t temp = 0;
3438                     ; 667   assert_param(IS_ADC1_ITPENDINGBIT_OK(ITPendingBit));
3440  0002 a30080        	cpw	x,#128
3441  0005 273c          	jreq	L624
3442  0007 a30140        	cpw	x,#320
3443  000a 2737          	jreq	L624
3444  000c a30110        	cpw	x,#272
3445  000f 2732          	jreq	L624
3446  0011 a30111        	cpw	x,#273
3447  0014 272d          	jreq	L624
3448  0016 a30112        	cpw	x,#274
3449  0019 2728          	jreq	L624
3450  001b a30113        	cpw	x,#275
3451  001e 2723          	jreq	L624
3452  0020 a30114        	cpw	x,#276
3453  0023 271e          	jreq	L624
3454  0025 a30115        	cpw	x,#277
3455  0028 2719          	jreq	L624
3456  002a a30116        	cpw	x,#278
3457  002d 2714          	jreq	L624
3458  002f a30117        	cpw	x,#279
3459  0032 270f          	jreq	L624
3460  0034 a30118        	cpw	x,#280
3461  0037 270a          	jreq	L624
3462  0039 a3011c        	cpw	x,#284
3463  003c 2705          	jreq	L624
3464  003e a30119        	cpw	x,#281
3465  0041 2603          	jrne	L424
3466  0043               L624:
3467  0043 4f            	clr	a
3468  0044 2010          	jra	L034
3469  0046               L424:
3470  0046 ae029b        	ldw	x,#667
3471  0049 89            	pushw	x
3472  004a ae0000        	ldw	x,#0
3473  004d 89            	pushw	x
3474  004e ae0000        	ldw	x,#L542
3475  0051 cd0000        	call	_assert_failed
3477  0054 5b04          	addw	sp,#4
3478  0056               L034:
3479                     ; 669   if (((uint16_t)ITPendingBit & 0xF0) == 0x10)
3481  0056 7b02          	ld	a,(OFST+1,sp)
3482  0058 97            	ld	xl,a
3483  0059 7b03          	ld	a,(OFST+2,sp)
3484  005b a4f0          	and	a,#240
3485  005d 5f            	clrw	x
3486  005e 02            	rlwa	x,a
3487  005f a30010        	cpw	x,#16
3488  0062 263a          	jrne	L1321
3489                     ; 672     temp = (uint8_t)((uint16_t)ITPendingBit & 0x0F);
3491  0064 7b03          	ld	a,(OFST+2,sp)
3492  0066 a40f          	and	a,#15
3493  0068 6b01          	ld	(OFST+0,sp),a
3494                     ; 673     if (temp < 8)
3496  006a 7b01          	ld	a,(OFST+0,sp)
3497  006c a108          	cp	a,#8
3498  006e 2416          	jruge	L3321
3499                     ; 675       ADC1->AWSRL &= (uint8_t)~(uint8_t)((uint8_t)1 << temp);
3501  0070 7b01          	ld	a,(OFST+0,sp)
3502  0072 5f            	clrw	x
3503  0073 97            	ld	xl,a
3504  0074 a601          	ld	a,#1
3505  0076 5d            	tnzw	x
3506  0077 2704          	jreq	L234
3507  0079               L434:
3508  0079 48            	sll	a
3509  007a 5a            	decw	x
3510  007b 26fc          	jrne	L434
3511  007d               L234:
3512  007d 43            	cpl	a
3513  007e c4540d        	and	a,21517
3514  0081 c7540d        	ld	21517,a
3516  0084 2021          	jra	L7321
3517  0086               L3321:
3518                     ; 679       ADC1->AWSRH &= (uint8_t)~(uint8_t)((uint8_t)1 << (temp - 8));
3520  0086 7b01          	ld	a,(OFST+0,sp)
3521  0088 a008          	sub	a,#8
3522  008a 5f            	clrw	x
3523  008b 97            	ld	xl,a
3524  008c a601          	ld	a,#1
3525  008e 5d            	tnzw	x
3526  008f 2704          	jreq	L634
3527  0091               L044:
3528  0091 48            	sll	a
3529  0092 5a            	decw	x
3530  0093 26fc          	jrne	L044
3531  0095               L634:
3532  0095 43            	cpl	a
3533  0096 c4540c        	and	a,21516
3534  0099 c7540c        	ld	21516,a
3535  009c 2009          	jra	L7321
3536  009e               L1321:
3537                     ; 684     ADC1->CSR &= (uint8_t)((uint16_t)~(uint16_t)ITPendingBit);
3539  009e 7b03          	ld	a,(OFST+2,sp)
3540  00a0 43            	cpl	a
3541  00a1 c45400        	and	a,21504
3542  00a4 c75400        	ld	21504,a
3543  00a7               L7321:
3544                     ; 686 }
3547  00a7 5b03          	addw	sp,#3
3548  00a9 81            	ret
3561                     	xdef	_ADC1_ClearITPendingBit
3562                     	xdef	_ADC1_GetITStatus
3563                     	xdef	_ADC1_ClearFlag
3564                     	xdef	_ADC1_GetFlagStatus
3565                     	xdef	_ADC1_GetAWDChannelStatus
3566                     	xdef	_ADC1_GetBufferValue
3567                     	xdef	_ADC1_SetLowThreshold
3568                     	xdef	_ADC1_SetHighThreshold
3569                     	xdef	_ADC1_GetConversionValue
3570                     	xdef	_ADC1_StartConversion
3571                     	xdef	_ADC1_AWDChannelConfig
3572                     	xdef	_ADC1_ExternalTriggerConfig
3573                     	xdef	_ADC1_ConversionConfig
3574                     	xdef	_ADC1_SchmittTriggerConfig
3575                     	xdef	_ADC1_PrescalerConfig
3576                     	xdef	_ADC1_ITConfig
3577                     	xdef	_ADC1_DataBufferCmd
3578                     	xdef	_ADC1_ScanModeCmd
3579                     	xdef	_ADC1_Cmd
3580                     	xdef	_ADC1_Init
3581                     	xdef	_ADC1_DeInit
3582                     	xref	_assert_failed
3583                     .const:	section	.text
3584  0000               L542:
3585  0000 73746d38735f  	dc.b	"stm8s_stdperiph_li"
3586  0012 625c6c696272  	dc.b	"b\libraries\stm8s_"
3587  0024 737464706572  	dc.b	"stdperiph_driver\s"
3588  0036 72635c73746d  	dc.b	"rc\stm8s_adc1.c",0
3608                     	end
