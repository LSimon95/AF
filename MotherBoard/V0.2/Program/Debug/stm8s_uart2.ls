   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  45                     ; 53 void UART2_DeInit(void)
  45                     ; 54 {
  47                     .text:	section	.text,new
  48  0000               _UART2_DeInit:
  52                     ; 57   (void) UART2->SR;
  54  0000 c65240        	ld	a,21056
  55                     ; 58   (void)UART2->DR;
  57  0003 c65241        	ld	a,21057
  58                     ; 60   UART2->BRR2 = UART2_BRR2_RESET_VALUE;  /*  Set UART2_BRR2 to reset value 0x00 */
  60  0006 725f5243      	clr	21059
  61                     ; 61   UART2->BRR1 = UART2_BRR1_RESET_VALUE;  /*  Set UART2_BRR1 to reset value 0x00 */
  63  000a 725f5242      	clr	21058
  64                     ; 63   UART2->CR1 = UART2_CR1_RESET_VALUE; /*  Set UART2_CR1 to reset value 0x00  */
  66  000e 725f5244      	clr	21060
  67                     ; 64   UART2->CR2 = UART2_CR2_RESET_VALUE; /*  Set UART2_CR2 to reset value 0x00  */
  69  0012 725f5245      	clr	21061
  70                     ; 65   UART2->CR3 = UART2_CR3_RESET_VALUE; /*  Set UART2_CR3 to reset value 0x00  */
  72  0016 725f5246      	clr	21062
  73                     ; 66   UART2->CR4 = UART2_CR4_RESET_VALUE; /*  Set UART2_CR4 to reset value 0x00  */
  75  001a 725f5247      	clr	21063
  76                     ; 67   UART2->CR5 = UART2_CR5_RESET_VALUE; /*  Set UART2_CR5 to reset value 0x00  */
  78  001e 725f5248      	clr	21064
  79                     ; 68   UART2->CR6 = UART2_CR6_RESET_VALUE; /*  Set UART2_CR6 to reset value 0x00  */
  81  0022 725f5249      	clr	21065
  82                     ; 69 }
  85  0026 81            	ret
 407                     .const:	section	.text
 408  0000               L21:
 409  0000 00098969      	dc.l	625001
 410  0004               L25:
 411  0004 00000064      	dc.l	100
 412                     ; 85 void UART2_Init(uint32_t BaudRate, UART2_WordLength_TypeDef WordLength, UART2_StopBits_TypeDef StopBits, UART2_Parity_TypeDef Parity, UART2_SyncMode_TypeDef SyncMode, UART2_Mode_TypeDef Mode)
 412                     ; 86 {
 413                     .text:	section	.text,new
 414  0000               _UART2_Init:
 416  0000 520e          	subw	sp,#14
 417       0000000e      OFST:	set	14
 420                     ; 87   uint8_t BRR2_1 = 0, BRR2_2 = 0;
 424                     ; 88   uint32_t BaudRate_Mantissa = 0, BaudRate_Mantissa100 = 0;
 428                     ; 91   assert_param(IS_UART2_BAUDRATE_OK(BaudRate));
 430  0002 96            	ldw	x,sp
 431  0003 1c0011        	addw	x,#OFST+3
 432  0006 cd0000        	call	c_ltor
 434  0009 ae0000        	ldw	x,#L21
 435  000c cd0000        	call	c_lcmp
 437  000f 2403          	jruge	L01
 438  0011 4f            	clr	a
 439  0012 2010          	jra	L41
 440  0014               L01:
 441  0014 ae005b        	ldw	x,#91
 442  0017 89            	pushw	x
 443  0018 ae0000        	ldw	x,#0
 444  001b 89            	pushw	x
 445  001c ae0008        	ldw	x,#L302
 446  001f cd0000        	call	_assert_failed
 448  0022 5b04          	addw	sp,#4
 449  0024               L41:
 450                     ; 92   assert_param(IS_UART2_WORDLENGTH_OK(WordLength));
 452  0024 0d15          	tnz	(OFST+7,sp)
 453  0026 2706          	jreq	L02
 454  0028 7b15          	ld	a,(OFST+7,sp)
 455  002a a110          	cp	a,#16
 456  002c 2603          	jrne	L61
 457  002e               L02:
 458  002e 4f            	clr	a
 459  002f 2010          	jra	L22
 460  0031               L61:
 461  0031 ae005c        	ldw	x,#92
 462  0034 89            	pushw	x
 463  0035 ae0000        	ldw	x,#0
 464  0038 89            	pushw	x
 465  0039 ae0008        	ldw	x,#L302
 466  003c cd0000        	call	_assert_failed
 468  003f 5b04          	addw	sp,#4
 469  0041               L22:
 470                     ; 93   assert_param(IS_UART2_STOPBITS_OK(StopBits));
 472  0041 0d16          	tnz	(OFST+8,sp)
 473  0043 2712          	jreq	L62
 474  0045 7b16          	ld	a,(OFST+8,sp)
 475  0047 a110          	cp	a,#16
 476  0049 270c          	jreq	L62
 477  004b 7b16          	ld	a,(OFST+8,sp)
 478  004d a120          	cp	a,#32
 479  004f 2706          	jreq	L62
 480  0051 7b16          	ld	a,(OFST+8,sp)
 481  0053 a130          	cp	a,#48
 482  0055 2603          	jrne	L42
 483  0057               L62:
 484  0057 4f            	clr	a
 485  0058 2010          	jra	L03
 486  005a               L42:
 487  005a ae005d        	ldw	x,#93
 488  005d 89            	pushw	x
 489  005e ae0000        	ldw	x,#0
 490  0061 89            	pushw	x
 491  0062 ae0008        	ldw	x,#L302
 492  0065 cd0000        	call	_assert_failed
 494  0068 5b04          	addw	sp,#4
 495  006a               L03:
 496                     ; 94   assert_param(IS_UART2_PARITY_OK(Parity));
 498  006a 0d17          	tnz	(OFST+9,sp)
 499  006c 270c          	jreq	L43
 500  006e 7b17          	ld	a,(OFST+9,sp)
 501  0070 a104          	cp	a,#4
 502  0072 2706          	jreq	L43
 503  0074 7b17          	ld	a,(OFST+9,sp)
 504  0076 a106          	cp	a,#6
 505  0078 2603          	jrne	L23
 506  007a               L43:
 507  007a 4f            	clr	a
 508  007b 2010          	jra	L63
 509  007d               L23:
 510  007d ae005e        	ldw	x,#94
 511  0080 89            	pushw	x
 512  0081 ae0000        	ldw	x,#0
 513  0084 89            	pushw	x
 514  0085 ae0008        	ldw	x,#L302
 515  0088 cd0000        	call	_assert_failed
 517  008b 5b04          	addw	sp,#4
 518  008d               L63:
 519                     ; 95   assert_param(IS_UART2_MODE_OK((uint8_t)Mode));
 521  008d 7b19          	ld	a,(OFST+11,sp)
 522  008f a108          	cp	a,#8
 523  0091 2730          	jreq	L24
 524  0093 7b19          	ld	a,(OFST+11,sp)
 525  0095 a140          	cp	a,#64
 526  0097 272a          	jreq	L24
 527  0099 7b19          	ld	a,(OFST+11,sp)
 528  009b a104          	cp	a,#4
 529  009d 2724          	jreq	L24
 530  009f 7b19          	ld	a,(OFST+11,sp)
 531  00a1 a180          	cp	a,#128
 532  00a3 271e          	jreq	L24
 533  00a5 7b19          	ld	a,(OFST+11,sp)
 534  00a7 a10c          	cp	a,#12
 535  00a9 2718          	jreq	L24
 536  00ab 7b19          	ld	a,(OFST+11,sp)
 537  00ad a10c          	cp	a,#12
 538  00af 2712          	jreq	L24
 539  00b1 7b19          	ld	a,(OFST+11,sp)
 540  00b3 a144          	cp	a,#68
 541  00b5 270c          	jreq	L24
 542  00b7 7b19          	ld	a,(OFST+11,sp)
 543  00b9 a1c0          	cp	a,#192
 544  00bb 2706          	jreq	L24
 545  00bd 7b19          	ld	a,(OFST+11,sp)
 546  00bf a188          	cp	a,#136
 547  00c1 2603          	jrne	L04
 548  00c3               L24:
 549  00c3 4f            	clr	a
 550  00c4 2010          	jra	L44
 551  00c6               L04:
 552  00c6 ae005f        	ldw	x,#95
 553  00c9 89            	pushw	x
 554  00ca ae0000        	ldw	x,#0
 555  00cd 89            	pushw	x
 556  00ce ae0008        	ldw	x,#L302
 557  00d1 cd0000        	call	_assert_failed
 559  00d4 5b04          	addw	sp,#4
 560  00d6               L44:
 561                     ; 96   assert_param(IS_UART2_SYNCMODE_OK((uint8_t)SyncMode));
 563  00d6 7b18          	ld	a,(OFST+10,sp)
 564  00d8 a488          	and	a,#136
 565  00da a188          	cp	a,#136
 566  00dc 271b          	jreq	L64
 567  00de 7b18          	ld	a,(OFST+10,sp)
 568  00e0 a444          	and	a,#68
 569  00e2 a144          	cp	a,#68
 570  00e4 2713          	jreq	L64
 571  00e6 7b18          	ld	a,(OFST+10,sp)
 572  00e8 a422          	and	a,#34
 573  00ea a122          	cp	a,#34
 574  00ec 270b          	jreq	L64
 575  00ee 7b18          	ld	a,(OFST+10,sp)
 576  00f0 a411          	and	a,#17
 577  00f2 a111          	cp	a,#17
 578  00f4 2703          	jreq	L64
 579  00f6 4f            	clr	a
 580  00f7 2010          	jra	L05
 581  00f9               L64:
 582  00f9 ae0060        	ldw	x,#96
 583  00fc 89            	pushw	x
 584  00fd ae0000        	ldw	x,#0
 585  0100 89            	pushw	x
 586  0101 ae0008        	ldw	x,#L302
 587  0104 cd0000        	call	_assert_failed
 589  0107 5b04          	addw	sp,#4
 590  0109               L05:
 591                     ; 99   UART2->CR1 &= (uint8_t)(~UART2_CR1_M);
 593  0109 72195244      	bres	21060,#4
 594                     ; 101   UART2->CR1 |= (uint8_t)WordLength; 
 596  010d c65244        	ld	a,21060
 597  0110 1a15          	or	a,(OFST+7,sp)
 598  0112 c75244        	ld	21060,a
 599                     ; 104   UART2->CR3 &= (uint8_t)(~UART2_CR3_STOP);
 601  0115 c65246        	ld	a,21062
 602  0118 a4cf          	and	a,#207
 603  011a c75246        	ld	21062,a
 604                     ; 106   UART2->CR3 |= (uint8_t)StopBits; 
 606  011d c65246        	ld	a,21062
 607  0120 1a16          	or	a,(OFST+8,sp)
 608  0122 c75246        	ld	21062,a
 609                     ; 109   UART2->CR1 &= (uint8_t)(~(UART2_CR1_PCEN | UART2_CR1_PS  ));
 611  0125 c65244        	ld	a,21060
 612  0128 a4f9          	and	a,#249
 613  012a c75244        	ld	21060,a
 614                     ; 111   UART2->CR1 |= (uint8_t)Parity;
 616  012d c65244        	ld	a,21060
 617  0130 1a17          	or	a,(OFST+9,sp)
 618  0132 c75244        	ld	21060,a
 619                     ; 114   UART2->BRR1 &= (uint8_t)(~UART2_BRR1_DIVM);
 621  0135 725f5242      	clr	21058
 622                     ; 116   UART2->BRR2 &= (uint8_t)(~UART2_BRR2_DIVM);
 624  0139 c65243        	ld	a,21059
 625  013c a40f          	and	a,#15
 626  013e c75243        	ld	21059,a
 627                     ; 118   UART2->BRR2 &= (uint8_t)(~UART2_BRR2_DIVF);
 629  0141 c65243        	ld	a,21059
 630  0144 a4f0          	and	a,#240
 631  0146 c75243        	ld	21059,a
 632                     ; 121   BaudRate_Mantissa    = ((uint32_t)CLK_GetClockFreq() / (BaudRate << 4));
 634  0149 96            	ldw	x,sp
 635  014a 1c0011        	addw	x,#OFST+3
 636  014d cd0000        	call	c_ltor
 638  0150 a604          	ld	a,#4
 639  0152 cd0000        	call	c_llsh
 641  0155 96            	ldw	x,sp
 642  0156 1c0001        	addw	x,#OFST-13
 643  0159 cd0000        	call	c_rtol
 645  015c cd0000        	call	_CLK_GetClockFreq
 647  015f 96            	ldw	x,sp
 648  0160 1c0001        	addw	x,#OFST-13
 649  0163 cd0000        	call	c_ludv
 651  0166 96            	ldw	x,sp
 652  0167 1c000b        	addw	x,#OFST-3
 653  016a cd0000        	call	c_rtol
 655                     ; 122   BaudRate_Mantissa100 = (((uint32_t)CLK_GetClockFreq() * 100) / (BaudRate << 4));
 657  016d 96            	ldw	x,sp
 658  016e 1c0011        	addw	x,#OFST+3
 659  0171 cd0000        	call	c_ltor
 661  0174 a604          	ld	a,#4
 662  0176 cd0000        	call	c_llsh
 664  0179 96            	ldw	x,sp
 665  017a 1c0001        	addw	x,#OFST-13
 666  017d cd0000        	call	c_rtol
 668  0180 cd0000        	call	_CLK_GetClockFreq
 670  0183 a664          	ld	a,#100
 671  0185 cd0000        	call	c_smul
 673  0188 96            	ldw	x,sp
 674  0189 1c0001        	addw	x,#OFST-13
 675  018c cd0000        	call	c_ludv
 677  018f 96            	ldw	x,sp
 678  0190 1c0007        	addw	x,#OFST-7
 679  0193 cd0000        	call	c_rtol
 681                     ; 126   BRR2_1 = (uint8_t)((uint8_t)(((BaudRate_Mantissa100 - (BaudRate_Mantissa * 100))
 681                     ; 127                                 << 4) / 100) & (uint8_t)0x0F); 
 683  0196 96            	ldw	x,sp
 684  0197 1c000b        	addw	x,#OFST-3
 685  019a cd0000        	call	c_ltor
 687  019d a664          	ld	a,#100
 688  019f cd0000        	call	c_smul
 690  01a2 96            	ldw	x,sp
 691  01a3 1c0001        	addw	x,#OFST-13
 692  01a6 cd0000        	call	c_rtol
 694  01a9 96            	ldw	x,sp
 695  01aa 1c0007        	addw	x,#OFST-7
 696  01ad cd0000        	call	c_ltor
 698  01b0 96            	ldw	x,sp
 699  01b1 1c0001        	addw	x,#OFST-13
 700  01b4 cd0000        	call	c_lsub
 702  01b7 a604          	ld	a,#4
 703  01b9 cd0000        	call	c_llsh
 705  01bc ae0004        	ldw	x,#L25
 706  01bf cd0000        	call	c_ludv
 708  01c2 b603          	ld	a,c_lreg+3
 709  01c4 a40f          	and	a,#15
 710  01c6 6b05          	ld	(OFST-9,sp),a
 711                     ; 128   BRR2_2 = (uint8_t)((BaudRate_Mantissa >> 4) & (uint8_t)0xF0);
 713  01c8 96            	ldw	x,sp
 714  01c9 1c000b        	addw	x,#OFST-3
 715  01cc cd0000        	call	c_ltor
 717  01cf a604          	ld	a,#4
 718  01d1 cd0000        	call	c_lursh
 720  01d4 b603          	ld	a,c_lreg+3
 721  01d6 a4f0          	and	a,#240
 722  01d8 b703          	ld	c_lreg+3,a
 723  01da 3f02          	clr	c_lreg+2
 724  01dc 3f01          	clr	c_lreg+1
 725  01de 3f00          	clr	c_lreg
 726  01e0 b603          	ld	a,c_lreg+3
 727  01e2 6b06          	ld	(OFST-8,sp),a
 728                     ; 130   UART2->BRR2 = (uint8_t)(BRR2_1 | BRR2_2);
 730  01e4 7b05          	ld	a,(OFST-9,sp)
 731  01e6 1a06          	or	a,(OFST-8,sp)
 732  01e8 c75243        	ld	21059,a
 733                     ; 132   UART2->BRR1 = (uint8_t)BaudRate_Mantissa;           
 735  01eb 7b0e          	ld	a,(OFST+0,sp)
 736  01ed c75242        	ld	21058,a
 737                     ; 135   UART2->CR2 &= (uint8_t)~(UART2_CR2_TEN | UART2_CR2_REN);
 739  01f0 c65245        	ld	a,21061
 740  01f3 a4f3          	and	a,#243
 741  01f5 c75245        	ld	21061,a
 742                     ; 137   UART2->CR3 &= (uint8_t)~(UART2_CR3_CPOL | UART2_CR3_CPHA | UART2_CR3_LBCL);
 744  01f8 c65246        	ld	a,21062
 745  01fb a4f8          	and	a,#248
 746  01fd c75246        	ld	21062,a
 747                     ; 139   UART2->CR3 |= (uint8_t)((uint8_t)SyncMode & (uint8_t)(UART2_CR3_CPOL | \
 747                     ; 140     UART2_CR3_CPHA | UART2_CR3_LBCL));
 749  0200 7b18          	ld	a,(OFST+10,sp)
 750  0202 a407          	and	a,#7
 751  0204 ca5246        	or	a,21062
 752  0207 c75246        	ld	21062,a
 753                     ; 142   if ((uint8_t)(Mode & UART2_MODE_TX_ENABLE))
 755  020a 7b19          	ld	a,(OFST+11,sp)
 756  020c a504          	bcp	a,#4
 757  020e 2706          	jreq	L502
 758                     ; 145     UART2->CR2 |= (uint8_t)UART2_CR2_TEN;
 760  0210 72165245      	bset	21061,#3
 762  0214 2004          	jra	L702
 763  0216               L502:
 764                     ; 150     UART2->CR2 &= (uint8_t)(~UART2_CR2_TEN);
 766  0216 72175245      	bres	21061,#3
 767  021a               L702:
 768                     ; 152   if ((uint8_t)(Mode & UART2_MODE_RX_ENABLE))
 770  021a 7b19          	ld	a,(OFST+11,sp)
 771  021c a508          	bcp	a,#8
 772  021e 2706          	jreq	L112
 773                     ; 155     UART2->CR2 |= (uint8_t)UART2_CR2_REN;
 775  0220 72145245      	bset	21061,#2
 777  0224 2004          	jra	L312
 778  0226               L112:
 779                     ; 160     UART2->CR2 &= (uint8_t)(~UART2_CR2_REN);
 781  0226 72155245      	bres	21061,#2
 782  022a               L312:
 783                     ; 164   if ((uint8_t)(SyncMode & UART2_SYNCMODE_CLOCK_DISABLE))
 785  022a 7b18          	ld	a,(OFST+10,sp)
 786  022c a580          	bcp	a,#128
 787  022e 2706          	jreq	L512
 788                     ; 167     UART2->CR3 &= (uint8_t)(~UART2_CR3_CKEN); 
 790  0230 72175246      	bres	21062,#3
 792  0234 200a          	jra	L712
 793  0236               L512:
 794                     ; 171     UART2->CR3 |= (uint8_t)((uint8_t)SyncMode & UART2_CR3_CKEN);
 796  0236 7b18          	ld	a,(OFST+10,sp)
 797  0238 a408          	and	a,#8
 798  023a ca5246        	or	a,21062
 799  023d c75246        	ld	21062,a
 800  0240               L712:
 801                     ; 173 }
 804  0240 5b0e          	addw	sp,#14
 805  0242 81            	ret
 860                     ; 181 void UART2_Cmd(FunctionalState NewState)
 860                     ; 182 {
 861                     .text:	section	.text,new
 862  0000               _UART2_Cmd:
 866                     ; 183   if (NewState != DISABLE)
 868  0000 4d            	tnz	a
 869  0001 2706          	jreq	L742
 870                     ; 186     UART2->CR1 &= (uint8_t)(~UART2_CR1_UARTD);
 872  0003 721b5244      	bres	21060,#5
 874  0007 2004          	jra	L152
 875  0009               L742:
 876                     ; 191     UART2->CR1 |= UART2_CR1_UARTD; 
 878  0009 721a5244      	bset	21060,#5
 879  000d               L152:
 880                     ; 193 }
 883  000d 81            	ret
1016                     ; 210 void UART2_ITConfig(UART2_IT_TypeDef UART2_IT, FunctionalState NewState)
1016                     ; 211 {
1017                     .text:	section	.text,new
1018  0000               _UART2_ITConfig:
1020  0000 89            	pushw	x
1021  0001 89            	pushw	x
1022       00000002      OFST:	set	2
1025                     ; 212   uint8_t uartreg = 0, itpos = 0x00;
1029                     ; 215   assert_param(IS_UART2_CONFIG_IT_OK(UART2_IT));
1031  0002 a30100        	cpw	x,#256
1032  0005 271e          	jreq	L26
1033  0007 a30277        	cpw	x,#631
1034  000a 2719          	jreq	L26
1035  000c a30266        	cpw	x,#614
1036  000f 2714          	jreq	L26
1037  0011 a30205        	cpw	x,#517
1038  0014 270f          	jreq	L26
1039  0016 a30244        	cpw	x,#580
1040  0019 270a          	jreq	L26
1041  001b a30412        	cpw	x,#1042
1042  001e 2705          	jreq	L26
1043  0020 a30346        	cpw	x,#838
1044  0023 2603          	jrne	L06
1045  0025               L26:
1046  0025 4f            	clr	a
1047  0026 2010          	jra	L46
1048  0028               L06:
1049  0028 ae00d7        	ldw	x,#215
1050  002b 89            	pushw	x
1051  002c ae0000        	ldw	x,#0
1052  002f 89            	pushw	x
1053  0030 ae0008        	ldw	x,#L302
1054  0033 cd0000        	call	_assert_failed
1056  0036 5b04          	addw	sp,#4
1057  0038               L46:
1058                     ; 216   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1060  0038 0d07          	tnz	(OFST+5,sp)
1061  003a 2706          	jreq	L07
1062  003c 7b07          	ld	a,(OFST+5,sp)
1063  003e a101          	cp	a,#1
1064  0040 2603          	jrne	L66
1065  0042               L07:
1066  0042 4f            	clr	a
1067  0043 2010          	jra	L27
1068  0045               L66:
1069  0045 ae00d8        	ldw	x,#216
1070  0048 89            	pushw	x
1071  0049 ae0000        	ldw	x,#0
1072  004c 89            	pushw	x
1073  004d ae0008        	ldw	x,#L302
1074  0050 cd0000        	call	_assert_failed
1076  0053 5b04          	addw	sp,#4
1077  0055               L27:
1078                     ; 219   uartreg = (uint8_t)((uint16_t)UART2_IT >> 0x08);
1080  0055 7b03          	ld	a,(OFST+1,sp)
1081  0057 6b01          	ld	(OFST-1,sp),a
1082                     ; 222   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART2_IT & (uint8_t)0x0F));
1084  0059 7b04          	ld	a,(OFST+2,sp)
1085  005b a40f          	and	a,#15
1086  005d 5f            	clrw	x
1087  005e 97            	ld	xl,a
1088  005f a601          	ld	a,#1
1089  0061 5d            	tnzw	x
1090  0062 2704          	jreq	L47
1091  0064               L67:
1092  0064 48            	sll	a
1093  0065 5a            	decw	x
1094  0066 26fc          	jrne	L67
1095  0068               L47:
1096  0068 6b02          	ld	(OFST+0,sp),a
1097                     ; 224   if (NewState != DISABLE)
1099  006a 0d07          	tnz	(OFST+5,sp)
1100  006c 273a          	jreq	L333
1101                     ; 227     if (uartreg == 0x01)
1103  006e 7b01          	ld	a,(OFST-1,sp)
1104  0070 a101          	cp	a,#1
1105  0072 260a          	jrne	L533
1106                     ; 229       UART2->CR1 |= itpos;
1108  0074 c65244        	ld	a,21060
1109  0077 1a02          	or	a,(OFST+0,sp)
1110  0079 c75244        	ld	21060,a
1112  007c 2066          	jra	L153
1113  007e               L533:
1114                     ; 231     else if (uartreg == 0x02)
1116  007e 7b01          	ld	a,(OFST-1,sp)
1117  0080 a102          	cp	a,#2
1118  0082 260a          	jrne	L143
1119                     ; 233       UART2->CR2 |= itpos;
1121  0084 c65245        	ld	a,21061
1122  0087 1a02          	or	a,(OFST+0,sp)
1123  0089 c75245        	ld	21061,a
1125  008c 2056          	jra	L153
1126  008e               L143:
1127                     ; 235     else if (uartreg == 0x03)
1129  008e 7b01          	ld	a,(OFST-1,sp)
1130  0090 a103          	cp	a,#3
1131  0092 260a          	jrne	L543
1132                     ; 237       UART2->CR4 |= itpos;
1134  0094 c65247        	ld	a,21063
1135  0097 1a02          	or	a,(OFST+0,sp)
1136  0099 c75247        	ld	21063,a
1138  009c 2046          	jra	L153
1139  009e               L543:
1140                     ; 241       UART2->CR6 |= itpos;
1142  009e c65249        	ld	a,21065
1143  00a1 1a02          	or	a,(OFST+0,sp)
1144  00a3 c75249        	ld	21065,a
1145  00a6 203c          	jra	L153
1146  00a8               L333:
1147                     ; 247     if (uartreg == 0x01)
1149  00a8 7b01          	ld	a,(OFST-1,sp)
1150  00aa a101          	cp	a,#1
1151  00ac 260b          	jrne	L353
1152                     ; 249       UART2->CR1 &= (uint8_t)(~itpos);
1154  00ae 7b02          	ld	a,(OFST+0,sp)
1155  00b0 43            	cpl	a
1156  00b1 c45244        	and	a,21060
1157  00b4 c75244        	ld	21060,a
1159  00b7 202b          	jra	L153
1160  00b9               L353:
1161                     ; 251     else if (uartreg == 0x02)
1163  00b9 7b01          	ld	a,(OFST-1,sp)
1164  00bb a102          	cp	a,#2
1165  00bd 260b          	jrne	L753
1166                     ; 253       UART2->CR2 &= (uint8_t)(~itpos);
1168  00bf 7b02          	ld	a,(OFST+0,sp)
1169  00c1 43            	cpl	a
1170  00c2 c45245        	and	a,21061
1171  00c5 c75245        	ld	21061,a
1173  00c8 201a          	jra	L153
1174  00ca               L753:
1175                     ; 255     else if (uartreg == 0x03)
1177  00ca 7b01          	ld	a,(OFST-1,sp)
1178  00cc a103          	cp	a,#3
1179  00ce 260b          	jrne	L363
1180                     ; 257       UART2->CR4 &= (uint8_t)(~itpos);
1182  00d0 7b02          	ld	a,(OFST+0,sp)
1183  00d2 43            	cpl	a
1184  00d3 c45247        	and	a,21063
1185  00d6 c75247        	ld	21063,a
1187  00d9 2009          	jra	L153
1188  00db               L363:
1189                     ; 261       UART2->CR6 &= (uint8_t)(~itpos);
1191  00db 7b02          	ld	a,(OFST+0,sp)
1192  00dd 43            	cpl	a
1193  00de c45249        	and	a,21065
1194  00e1 c75249        	ld	21065,a
1195  00e4               L153:
1196                     ; 264 }
1199  00e4 5b04          	addw	sp,#4
1200  00e6 81            	ret
1258                     ; 272 void UART2_IrDAConfig(UART2_IrDAMode_TypeDef UART2_IrDAMode)
1258                     ; 273 {
1259                     .text:	section	.text,new
1260  0000               _UART2_IrDAConfig:
1262  0000 88            	push	a
1263       00000000      OFST:	set	0
1266                     ; 274   assert_param(IS_UART2_IRDAMODE_OK(UART2_IrDAMode));
1268  0001 a101          	cp	a,#1
1269  0003 2703          	jreq	L401
1270  0005 4d            	tnz	a
1271  0006 2603          	jrne	L201
1272  0008               L401:
1273  0008 4f            	clr	a
1274  0009 2010          	jra	L601
1275  000b               L201:
1276  000b ae0112        	ldw	x,#274
1277  000e 89            	pushw	x
1278  000f ae0000        	ldw	x,#0
1279  0012 89            	pushw	x
1280  0013 ae0008        	ldw	x,#L302
1281  0016 cd0000        	call	_assert_failed
1283  0019 5b04          	addw	sp,#4
1284  001b               L601:
1285                     ; 276   if (UART2_IrDAMode != UART2_IRDAMODE_NORMAL)
1287  001b 0d01          	tnz	(OFST+1,sp)
1288  001d 2706          	jreq	L514
1289                     ; 278     UART2->CR5 |= UART2_CR5_IRLP;
1291  001f 72145248      	bset	21064,#2
1293  0023 2004          	jra	L714
1294  0025               L514:
1295                     ; 282     UART2->CR5 &= ((uint8_t)~UART2_CR5_IRLP);
1297  0025 72155248      	bres	21064,#2
1298  0029               L714:
1299                     ; 284 }
1302  0029 84            	pop	a
1303  002a 81            	ret
1339                     ; 292 void UART2_IrDACmd(FunctionalState NewState)
1339                     ; 293 {
1340                     .text:	section	.text,new
1341  0000               _UART2_IrDACmd:
1343  0000 88            	push	a
1344       00000000      OFST:	set	0
1347                     ; 295   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1349  0001 4d            	tnz	a
1350  0002 2704          	jreq	L411
1351  0004 a101          	cp	a,#1
1352  0006 2603          	jrne	L211
1353  0008               L411:
1354  0008 4f            	clr	a
1355  0009 2010          	jra	L611
1356  000b               L211:
1357  000b ae0127        	ldw	x,#295
1358  000e 89            	pushw	x
1359  000f ae0000        	ldw	x,#0
1360  0012 89            	pushw	x
1361  0013 ae0008        	ldw	x,#L302
1362  0016 cd0000        	call	_assert_failed
1364  0019 5b04          	addw	sp,#4
1365  001b               L611:
1366                     ; 297   if (NewState != DISABLE)
1368  001b 0d01          	tnz	(OFST+1,sp)
1369  001d 2706          	jreq	L734
1370                     ; 300     UART2->CR5 |= UART2_CR5_IREN;
1372  001f 72125248      	bset	21064,#1
1374  0023 2004          	jra	L144
1375  0025               L734:
1376                     ; 305     UART2->CR5 &= ((uint8_t)~UART2_CR5_IREN);
1378  0025 72135248      	bres	21064,#1
1379  0029               L144:
1380                     ; 307 }
1383  0029 84            	pop	a
1384  002a 81            	ret
1444                     ; 316 void UART2_LINBreakDetectionConfig(UART2_LINBreakDetectionLength_TypeDef UART2_LINBreakDetectionLength)
1444                     ; 317 {
1445                     .text:	section	.text,new
1446  0000               _UART2_LINBreakDetectionConfig:
1448  0000 88            	push	a
1449       00000000      OFST:	set	0
1452                     ; 319   assert_param(IS_UART2_LINBREAKDETECTIONLENGTH_OK(UART2_LINBreakDetectionLength));
1454  0001 4d            	tnz	a
1455  0002 2704          	jreq	L421
1456  0004 a101          	cp	a,#1
1457  0006 2603          	jrne	L221
1458  0008               L421:
1459  0008 4f            	clr	a
1460  0009 2010          	jra	L621
1461  000b               L221:
1462  000b ae013f        	ldw	x,#319
1463  000e 89            	pushw	x
1464  000f ae0000        	ldw	x,#0
1465  0012 89            	pushw	x
1466  0013 ae0008        	ldw	x,#L302
1467  0016 cd0000        	call	_assert_failed
1469  0019 5b04          	addw	sp,#4
1470  001b               L621:
1471                     ; 321   if (UART2_LINBreakDetectionLength != UART2_LINBREAKDETECTIONLENGTH_10BITS)
1473  001b 0d01          	tnz	(OFST+1,sp)
1474  001d 2706          	jreq	L174
1475                     ; 323     UART2->CR4 |= UART2_CR4_LBDL;
1477  001f 721a5247      	bset	21063,#5
1479  0023 2004          	jra	L374
1480  0025               L174:
1481                     ; 327     UART2->CR4 &= ((uint8_t)~UART2_CR4_LBDL);
1483  0025 721b5247      	bres	21063,#5
1484  0029               L374:
1485                     ; 329 }
1488  0029 84            	pop	a
1489  002a 81            	ret
1611                     ; 341 void UART2_LINConfig(UART2_LinMode_TypeDef UART2_Mode, 
1611                     ; 342                      UART2_LinAutosync_TypeDef UART2_Autosync, 
1611                     ; 343                      UART2_LinDivUp_TypeDef UART2_DivUp)
1611                     ; 344 {
1612                     .text:	section	.text,new
1613  0000               _UART2_LINConfig:
1615  0000 89            	pushw	x
1616       00000000      OFST:	set	0
1619                     ; 346   assert_param(IS_UART2_SLAVE_OK(UART2_Mode));
1621  0001 9e            	ld	a,xh
1622  0002 4d            	tnz	a
1623  0003 2705          	jreq	L431
1624  0005 9e            	ld	a,xh
1625  0006 a101          	cp	a,#1
1626  0008 2603          	jrne	L231
1627  000a               L431:
1628  000a 4f            	clr	a
1629  000b 2010          	jra	L631
1630  000d               L231:
1631  000d ae015a        	ldw	x,#346
1632  0010 89            	pushw	x
1633  0011 ae0000        	ldw	x,#0
1634  0014 89            	pushw	x
1635  0015 ae0008        	ldw	x,#L302
1636  0018 cd0000        	call	_assert_failed
1638  001b 5b04          	addw	sp,#4
1639  001d               L631:
1640                     ; 347   assert_param(IS_UART2_AUTOSYNC_OK(UART2_Autosync));
1642  001d 7b02          	ld	a,(OFST+2,sp)
1643  001f a101          	cp	a,#1
1644  0021 2704          	jreq	L241
1645  0023 0d02          	tnz	(OFST+2,sp)
1646  0025 2603          	jrne	L041
1647  0027               L241:
1648  0027 4f            	clr	a
1649  0028 2010          	jra	L441
1650  002a               L041:
1651  002a ae015b        	ldw	x,#347
1652  002d 89            	pushw	x
1653  002e ae0000        	ldw	x,#0
1654  0031 89            	pushw	x
1655  0032 ae0008        	ldw	x,#L302
1656  0035 cd0000        	call	_assert_failed
1658  0038 5b04          	addw	sp,#4
1659  003a               L441:
1660                     ; 348   assert_param(IS_UART2_DIVUP_OK(UART2_DivUp));
1662  003a 0d05          	tnz	(OFST+5,sp)
1663  003c 2706          	jreq	L051
1664  003e 7b05          	ld	a,(OFST+5,sp)
1665  0040 a101          	cp	a,#1
1666  0042 2603          	jrne	L641
1667  0044               L051:
1668  0044 4f            	clr	a
1669  0045 2010          	jra	L251
1670  0047               L641:
1671  0047 ae015c        	ldw	x,#348
1672  004a 89            	pushw	x
1673  004b ae0000        	ldw	x,#0
1674  004e 89            	pushw	x
1675  004f ae0008        	ldw	x,#L302
1676  0052 cd0000        	call	_assert_failed
1678  0055 5b04          	addw	sp,#4
1679  0057               L251:
1680                     ; 350   if (UART2_Mode != UART2_LIN_MODE_MASTER)
1682  0057 0d01          	tnz	(OFST+1,sp)
1683  0059 2706          	jreq	L355
1684                     ; 352     UART2->CR6 |=  UART2_CR6_LSLV;
1686  005b 721a5249      	bset	21065,#5
1688  005f 2004          	jra	L555
1689  0061               L355:
1690                     ; 356     UART2->CR6 &= ((uint8_t)~UART2_CR6_LSLV);
1692  0061 721b5249      	bres	21065,#5
1693  0065               L555:
1694                     ; 359   if (UART2_Autosync != UART2_LIN_AUTOSYNC_DISABLE)
1696  0065 0d02          	tnz	(OFST+2,sp)
1697  0067 2706          	jreq	L755
1698                     ; 361     UART2->CR6 |=  UART2_CR6_LASE ;
1700  0069 72185249      	bset	21065,#4
1702  006d 2004          	jra	L165
1703  006f               L755:
1704                     ; 365     UART2->CR6 &= ((uint8_t)~ UART2_CR6_LASE );
1706  006f 72195249      	bres	21065,#4
1707  0073               L165:
1708                     ; 368   if (UART2_DivUp != UART2_LIN_DIVUP_LBRR1)
1710  0073 0d05          	tnz	(OFST+5,sp)
1711  0075 2706          	jreq	L365
1712                     ; 370     UART2->CR6 |=  UART2_CR6_LDUM;
1714  0077 721e5249      	bset	21065,#7
1716  007b 2004          	jra	L565
1717  007d               L365:
1718                     ; 374     UART2->CR6 &= ((uint8_t)~ UART2_CR6_LDUM);
1720  007d 721f5249      	bres	21065,#7
1721  0081               L565:
1722                     ; 376 }
1725  0081 85            	popw	x
1726  0082 81            	ret
1762                     ; 384 void UART2_LINCmd(FunctionalState NewState)
1762                     ; 385 {
1763                     .text:	section	.text,new
1764  0000               _UART2_LINCmd:
1766  0000 88            	push	a
1767       00000000      OFST:	set	0
1770                     ; 386   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1772  0001 4d            	tnz	a
1773  0002 2704          	jreq	L061
1774  0004 a101          	cp	a,#1
1775  0006 2603          	jrne	L651
1776  0008               L061:
1777  0008 4f            	clr	a
1778  0009 2010          	jra	L261
1779  000b               L651:
1780  000b ae0182        	ldw	x,#386
1781  000e 89            	pushw	x
1782  000f ae0000        	ldw	x,#0
1783  0012 89            	pushw	x
1784  0013 ae0008        	ldw	x,#L302
1785  0016 cd0000        	call	_assert_failed
1787  0019 5b04          	addw	sp,#4
1788  001b               L261:
1789                     ; 388   if (NewState != DISABLE)
1791  001b 0d01          	tnz	(OFST+1,sp)
1792  001d 2706          	jreq	L506
1793                     ; 391     UART2->CR3 |= UART2_CR3_LINEN;
1795  001f 721c5246      	bset	21062,#6
1797  0023 2004          	jra	L706
1798  0025               L506:
1799                     ; 396     UART2->CR3 &= ((uint8_t)~UART2_CR3_LINEN);
1801  0025 721d5246      	bres	21062,#6
1802  0029               L706:
1803                     ; 398 }
1806  0029 84            	pop	a
1807  002a 81            	ret
1843                     ; 406 void UART2_SmartCardCmd(FunctionalState NewState)
1843                     ; 407 {
1844                     .text:	section	.text,new
1845  0000               _UART2_SmartCardCmd:
1847  0000 88            	push	a
1848       00000000      OFST:	set	0
1851                     ; 409   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1853  0001 4d            	tnz	a
1854  0002 2704          	jreq	L071
1855  0004 a101          	cp	a,#1
1856  0006 2603          	jrne	L661
1857  0008               L071:
1858  0008 4f            	clr	a
1859  0009 2010          	jra	L271
1860  000b               L661:
1861  000b ae0199        	ldw	x,#409
1862  000e 89            	pushw	x
1863  000f ae0000        	ldw	x,#0
1864  0012 89            	pushw	x
1865  0013 ae0008        	ldw	x,#L302
1866  0016 cd0000        	call	_assert_failed
1868  0019 5b04          	addw	sp,#4
1869  001b               L271:
1870                     ; 411   if (NewState != DISABLE)
1872  001b 0d01          	tnz	(OFST+1,sp)
1873  001d 2706          	jreq	L726
1874                     ; 414     UART2->CR5 |= UART2_CR5_SCEN;
1876  001f 721a5248      	bset	21064,#5
1878  0023 2004          	jra	L136
1879  0025               L726:
1880                     ; 419     UART2->CR5 &= ((uint8_t)(~UART2_CR5_SCEN));
1882  0025 721b5248      	bres	21064,#5
1883  0029               L136:
1884                     ; 421 }
1887  0029 84            	pop	a
1888  002a 81            	ret
1925                     ; 429 void UART2_SmartCardNACKCmd(FunctionalState NewState)
1925                     ; 430 {
1926                     .text:	section	.text,new
1927  0000               _UART2_SmartCardNACKCmd:
1929  0000 88            	push	a
1930       00000000      OFST:	set	0
1933                     ; 432   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
1935  0001 4d            	tnz	a
1936  0002 2704          	jreq	L002
1937  0004 a101          	cp	a,#1
1938  0006 2603          	jrne	L671
1939  0008               L002:
1940  0008 4f            	clr	a
1941  0009 2010          	jra	L202
1942  000b               L671:
1943  000b ae01b0        	ldw	x,#432
1944  000e 89            	pushw	x
1945  000f ae0000        	ldw	x,#0
1946  0012 89            	pushw	x
1947  0013 ae0008        	ldw	x,#L302
1948  0016 cd0000        	call	_assert_failed
1950  0019 5b04          	addw	sp,#4
1951  001b               L202:
1952                     ; 434   if (NewState != DISABLE)
1954  001b 0d01          	tnz	(OFST+1,sp)
1955  001d 2706          	jreq	L156
1956                     ; 437     UART2->CR5 |= UART2_CR5_NACK;
1958  001f 72185248      	bset	21064,#4
1960  0023 2004          	jra	L356
1961  0025               L156:
1962                     ; 442     UART2->CR5 &= ((uint8_t)~(UART2_CR5_NACK));
1964  0025 72195248      	bres	21064,#4
1965  0029               L356:
1966                     ; 444 }
1969  0029 84            	pop	a
1970  002a 81            	ret
2028                     ; 452 void UART2_WakeUpConfig(UART2_WakeUp_TypeDef UART2_WakeUp)
2028                     ; 453 {
2029                     .text:	section	.text,new
2030  0000               _UART2_WakeUpConfig:
2032  0000 88            	push	a
2033       00000000      OFST:	set	0
2036                     ; 454   assert_param(IS_UART2_WAKEUP_OK(UART2_WakeUp));
2038  0001 4d            	tnz	a
2039  0002 2704          	jreq	L012
2040  0004 a108          	cp	a,#8
2041  0006 2603          	jrne	L602
2042  0008               L012:
2043  0008 4f            	clr	a
2044  0009 2010          	jra	L212
2045  000b               L602:
2046  000b ae01c6        	ldw	x,#454
2047  000e 89            	pushw	x
2048  000f ae0000        	ldw	x,#0
2049  0012 89            	pushw	x
2050  0013 ae0008        	ldw	x,#L302
2051  0016 cd0000        	call	_assert_failed
2053  0019 5b04          	addw	sp,#4
2054  001b               L212:
2055                     ; 456   UART2->CR1 &= ((uint8_t)~UART2_CR1_WAKE);
2057  001b 72175244      	bres	21060,#3
2058                     ; 457   UART2->CR1 |= (uint8_t)UART2_WakeUp;
2060  001f c65244        	ld	a,21060
2061  0022 1a01          	or	a,(OFST+1,sp)
2062  0024 c75244        	ld	21060,a
2063                     ; 458 }
2066  0027 84            	pop	a
2067  0028 81            	ret
2104                     ; 466 void UART2_ReceiverWakeUpCmd(FunctionalState NewState)
2104                     ; 467 {
2105                     .text:	section	.text,new
2106  0000               _UART2_ReceiverWakeUpCmd:
2108  0000 88            	push	a
2109       00000000      OFST:	set	0
2112                     ; 468   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
2114  0001 4d            	tnz	a
2115  0002 2704          	jreq	L022
2116  0004 a101          	cp	a,#1
2117  0006 2603          	jrne	L612
2118  0008               L022:
2119  0008 4f            	clr	a
2120  0009 2010          	jra	L222
2121  000b               L612:
2122  000b ae01d4        	ldw	x,#468
2123  000e 89            	pushw	x
2124  000f ae0000        	ldw	x,#0
2125  0012 89            	pushw	x
2126  0013 ae0008        	ldw	x,#L302
2127  0016 cd0000        	call	_assert_failed
2129  0019 5b04          	addw	sp,#4
2130  001b               L222:
2131                     ; 470   if (NewState != DISABLE)
2133  001b 0d01          	tnz	(OFST+1,sp)
2134  001d 2706          	jreq	L127
2135                     ; 473     UART2->CR2 |= UART2_CR2_RWU;
2137  001f 72125245      	bset	21061,#1
2139  0023 2004          	jra	L327
2140  0025               L127:
2141                     ; 478     UART2->CR2 &= ((uint8_t)~UART2_CR2_RWU);
2143  0025 72135245      	bres	21061,#1
2144  0029               L327:
2145                     ; 480 }
2148  0029 84            	pop	a
2149  002a 81            	ret
2172                     ; 487 uint8_t UART2_ReceiveData8(void)
2172                     ; 488 {
2173                     .text:	section	.text,new
2174  0000               _UART2_ReceiveData8:
2178                     ; 489   return ((uint8_t)UART2->DR);
2180  0000 c65241        	ld	a,21057
2183  0003 81            	ret
2217                     ; 497 uint16_t UART2_ReceiveData9(void)
2217                     ; 498 {
2218                     .text:	section	.text,new
2219  0000               _UART2_ReceiveData9:
2221  0000 89            	pushw	x
2222       00000002      OFST:	set	2
2225                     ; 499   uint16_t temp = 0;
2227                     ; 501   temp = ((uint16_t)(((uint16_t)((uint16_t)UART2->CR1 & (uint16_t)UART2_CR1_R8)) << 1));
2229  0001 c65244        	ld	a,21060
2230  0004 5f            	clrw	x
2231  0005 a480          	and	a,#128
2232  0007 5f            	clrw	x
2233  0008 02            	rlwa	x,a
2234  0009 58            	sllw	x
2235  000a 1f01          	ldw	(OFST-1,sp),x
2236                     ; 503   return (uint16_t)((((uint16_t)UART2->DR) | temp) & ((uint16_t)0x01FF));
2238  000c c65241        	ld	a,21057
2239  000f 5f            	clrw	x
2240  0010 97            	ld	xl,a
2241  0011 01            	rrwa	x,a
2242  0012 1a02          	or	a,(OFST+0,sp)
2243  0014 01            	rrwa	x,a
2244  0015 1a01          	or	a,(OFST-1,sp)
2245  0017 01            	rrwa	x,a
2246  0018 01            	rrwa	x,a
2247  0019 a4ff          	and	a,#255
2248  001b 01            	rrwa	x,a
2249  001c a401          	and	a,#1
2250  001e 01            	rrwa	x,a
2253  001f 5b02          	addw	sp,#2
2254  0021 81            	ret
2288                     ; 511 void UART2_SendData8(uint8_t Data)
2288                     ; 512 {
2289                     .text:	section	.text,new
2290  0000               _UART2_SendData8:
2294                     ; 514   UART2->DR = Data;
2296  0000 c75241        	ld	21057,a
2297                     ; 515 }
2300  0003 81            	ret
2334                     ; 522 void UART2_SendData9(uint16_t Data)
2334                     ; 523 {
2335                     .text:	section	.text,new
2336  0000               _UART2_SendData9:
2338  0000 89            	pushw	x
2339       00000000      OFST:	set	0
2342                     ; 525   UART2->CR1 &= ((uint8_t)~UART2_CR1_T8);                  
2344  0001 721d5244      	bres	21060,#6
2345                     ; 528   UART2->CR1 |= (uint8_t)(((uint8_t)(Data >> 2)) & UART2_CR1_T8); 
2347  0005 54            	srlw	x
2348  0006 54            	srlw	x
2349  0007 9f            	ld	a,xl
2350  0008 a440          	and	a,#64
2351  000a ca5244        	or	a,21060
2352  000d c75244        	ld	21060,a
2353                     ; 531   UART2->DR   = (uint8_t)(Data);                    
2355  0010 7b02          	ld	a,(OFST+2,sp)
2356  0012 c75241        	ld	21057,a
2357                     ; 532 }
2360  0015 85            	popw	x
2361  0016 81            	ret
2384                     ; 539 void UART2_SendBreak(void)
2384                     ; 540 {
2385                     .text:	section	.text,new
2386  0000               _UART2_SendBreak:
2390                     ; 541   UART2->CR2 |= UART2_CR2_SBK;
2392  0000 72105245      	bset	21061,#0
2393                     ; 542 }
2396  0004 81            	ret
2431                     ; 549 void UART2_SetAddress(uint8_t UART2_Address)
2431                     ; 550 {
2432                     .text:	section	.text,new
2433  0000               _UART2_SetAddress:
2435  0000 88            	push	a
2436       00000000      OFST:	set	0
2439                     ; 552   assert_param(IS_UART2_ADDRESS_OK(UART2_Address));
2441  0001 a110          	cp	a,#16
2442  0003 2403          	jruge	L042
2443  0005 4f            	clr	a
2444  0006 2010          	jra	L242
2445  0008               L042:
2446  0008 ae0228        	ldw	x,#552
2447  000b 89            	pushw	x
2448  000c ae0000        	ldw	x,#0
2449  000f 89            	pushw	x
2450  0010 ae0008        	ldw	x,#L302
2451  0013 cd0000        	call	_assert_failed
2453  0016 5b04          	addw	sp,#4
2454  0018               L242:
2455                     ; 555   UART2->CR4 &= ((uint8_t)~UART2_CR4_ADD);
2457  0018 c65247        	ld	a,21063
2458  001b a4f0          	and	a,#240
2459  001d c75247        	ld	21063,a
2460                     ; 557   UART2->CR4 |= UART2_Address;
2462  0020 c65247        	ld	a,21063
2463  0023 1a01          	or	a,(OFST+1,sp)
2464  0025 c75247        	ld	21063,a
2465                     ; 558 }
2468  0028 84            	pop	a
2469  0029 81            	ret
2503                     ; 566 void UART2_SetGuardTime(uint8_t UART2_GuardTime)
2503                     ; 567 {
2504                     .text:	section	.text,new
2505  0000               _UART2_SetGuardTime:
2509                     ; 569   UART2->GTR = UART2_GuardTime;
2511  0000 c7524a        	ld	21066,a
2512                     ; 570 }
2515  0003 81            	ret
2549                     ; 594 void UART2_SetPrescaler(uint8_t UART2_Prescaler)
2549                     ; 595 {
2550                     .text:	section	.text,new
2551  0000               _UART2_SetPrescaler:
2555                     ; 597   UART2->PSCR = UART2_Prescaler;
2557  0000 c7524b        	ld	21067,a
2558                     ; 598 }
2561  0003 81            	ret
2719                     ; 606 FlagStatus UART2_GetFlagStatus(UART2_Flag_TypeDef UART2_FLAG)
2719                     ; 607 {
2720                     .text:	section	.text,new
2721  0000               _UART2_GetFlagStatus:
2723  0000 89            	pushw	x
2724  0001 88            	push	a
2725       00000001      OFST:	set	1
2728                     ; 608   FlagStatus status = RESET;
2730                     ; 611   assert_param(IS_UART2_FLAG_OK(UART2_FLAG));
2732  0002 a30080        	cpw	x,#128
2733  0005 2737          	jreq	L452
2734  0007 a30040        	cpw	x,#64
2735  000a 2732          	jreq	L452
2736  000c a30020        	cpw	x,#32
2737  000f 272d          	jreq	L452
2738  0011 a30010        	cpw	x,#16
2739  0014 2728          	jreq	L452
2740  0016 a30008        	cpw	x,#8
2741  0019 2723          	jreq	L452
2742  001b a30004        	cpw	x,#4
2743  001e 271e          	jreq	L452
2744  0020 a30002        	cpw	x,#2
2745  0023 2719          	jreq	L452
2746  0025 a30001        	cpw	x,#1
2747  0028 2714          	jreq	L452
2748  002a a30101        	cpw	x,#257
2749  002d 270f          	jreq	L452
2750  002f a30301        	cpw	x,#769
2751  0032 270a          	jreq	L452
2752  0034 a30302        	cpw	x,#770
2753  0037 2705          	jreq	L452
2754  0039 a30210        	cpw	x,#528
2755  003c 2603          	jrne	L252
2756  003e               L452:
2757  003e 4f            	clr	a
2758  003f 2010          	jra	L652
2759  0041               L252:
2760  0041 ae0263        	ldw	x,#611
2761  0044 89            	pushw	x
2762  0045 ae0000        	ldw	x,#0
2763  0048 89            	pushw	x
2764  0049 ae0008        	ldw	x,#L302
2765  004c cd0000        	call	_assert_failed
2767  004f 5b04          	addw	sp,#4
2768  0051               L652:
2769                     ; 614   if (UART2_FLAG == UART2_FLAG_LBDF)
2771  0051 1e02          	ldw	x,(OFST+1,sp)
2772  0053 a30210        	cpw	x,#528
2773  0056 2611          	jrne	L7511
2774                     ; 616     if ((UART2->CR4 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2776  0058 c65247        	ld	a,21063
2777  005b 1503          	bcp	a,(OFST+2,sp)
2778  005d 2706          	jreq	L1611
2779                     ; 619       status = SET;
2781  005f a601          	ld	a,#1
2782  0061 6b01          	ld	(OFST+0,sp),a
2784  0063 2039          	jra	L5611
2785  0065               L1611:
2786                     ; 624       status = RESET;
2788  0065 0f01          	clr	(OFST+0,sp)
2789  0067 2035          	jra	L5611
2790  0069               L7511:
2791                     ; 627   else if (UART2_FLAG == UART2_FLAG_SBK)
2793  0069 1e02          	ldw	x,(OFST+1,sp)
2794  006b a30101        	cpw	x,#257
2795  006e 2611          	jrne	L7611
2796                     ; 629     if ((UART2->CR2 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2798  0070 c65245        	ld	a,21061
2799  0073 1503          	bcp	a,(OFST+2,sp)
2800  0075 2706          	jreq	L1711
2801                     ; 632       status = SET;
2803  0077 a601          	ld	a,#1
2804  0079 6b01          	ld	(OFST+0,sp),a
2806  007b 2021          	jra	L5611
2807  007d               L1711:
2808                     ; 637       status = RESET;
2810  007d 0f01          	clr	(OFST+0,sp)
2811  007f 201d          	jra	L5611
2812  0081               L7611:
2813                     ; 640   else if ((UART2_FLAG == UART2_FLAG_LHDF) || (UART2_FLAG == UART2_FLAG_LSF))
2815  0081 1e02          	ldw	x,(OFST+1,sp)
2816  0083 a30302        	cpw	x,#770
2817  0086 2707          	jreq	L1021
2819  0088 1e02          	ldw	x,(OFST+1,sp)
2820  008a a30301        	cpw	x,#769
2821  008d 2614          	jrne	L7711
2822  008f               L1021:
2823                     ; 642     if ((UART2->CR6 & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2825  008f c65249        	ld	a,21065
2826  0092 1503          	bcp	a,(OFST+2,sp)
2827  0094 2706          	jreq	L3021
2828                     ; 645       status = SET;
2830  0096 a601          	ld	a,#1
2831  0098 6b01          	ld	(OFST+0,sp),a
2833  009a 2002          	jra	L5611
2834  009c               L3021:
2835                     ; 650       status = RESET;
2837  009c 0f01          	clr	(OFST+0,sp)
2838  009e               L5611:
2839                     ; 668   return  status;
2841  009e 7b01          	ld	a,(OFST+0,sp)
2844  00a0 5b03          	addw	sp,#3
2845  00a2 81            	ret
2846  00a3               L7711:
2847                     ; 655     if ((UART2->SR & (uint8_t)UART2_FLAG) != (uint8_t)0x00)
2849  00a3 c65240        	ld	a,21056
2850  00a6 1503          	bcp	a,(OFST+2,sp)
2851  00a8 2706          	jreq	L1121
2852                     ; 658       status = SET;
2854  00aa a601          	ld	a,#1
2855  00ac 6b01          	ld	(OFST+0,sp),a
2857  00ae 20ee          	jra	L5611
2858  00b0               L1121:
2859                     ; 663       status = RESET;
2861  00b0 0f01          	clr	(OFST+0,sp)
2862  00b2 20ea          	jra	L5611
2898                     ; 699 void UART2_ClearFlag(UART2_Flag_TypeDef UART2_FLAG)
2898                     ; 700 {
2899                     .text:	section	.text,new
2900  0000               _UART2_ClearFlag:
2902  0000 89            	pushw	x
2903       00000000      OFST:	set	0
2906                     ; 701   assert_param(IS_UART2_CLEAR_FLAG_OK(UART2_FLAG));
2908  0001 a30020        	cpw	x,#32
2909  0004 270f          	jreq	L462
2910  0006 a30302        	cpw	x,#770
2911  0009 270a          	jreq	L462
2912  000b a30301        	cpw	x,#769
2913  000e 2705          	jreq	L462
2914  0010 a30210        	cpw	x,#528
2915  0013 2603          	jrne	L262
2916  0015               L462:
2917  0015 4f            	clr	a
2918  0016 2010          	jra	L662
2919  0018               L262:
2920  0018 ae02bd        	ldw	x,#701
2921  001b 89            	pushw	x
2922  001c ae0000        	ldw	x,#0
2923  001f 89            	pushw	x
2924  0020 ae0008        	ldw	x,#L302
2925  0023 cd0000        	call	_assert_failed
2927  0026 5b04          	addw	sp,#4
2928  0028               L662:
2929                     ; 704   if (UART2_FLAG == UART2_FLAG_RXNE)
2931  0028 1e01          	ldw	x,(OFST+1,sp)
2932  002a a30020        	cpw	x,#32
2933  002d 2606          	jrne	L3321
2934                     ; 706     UART2->SR = (uint8_t)~(UART2_SR_RXNE);
2936  002f 35df5240      	mov	21056,#223
2938  0033 201e          	jra	L5321
2939  0035               L3321:
2940                     ; 709   else if (UART2_FLAG == UART2_FLAG_LBDF)
2942  0035 1e01          	ldw	x,(OFST+1,sp)
2943  0037 a30210        	cpw	x,#528
2944  003a 2606          	jrne	L7321
2945                     ; 711     UART2->CR4 &= (uint8_t)(~UART2_CR4_LBDF);
2947  003c 72195247      	bres	21063,#4
2949  0040 2011          	jra	L5321
2950  0042               L7321:
2951                     ; 714   else if (UART2_FLAG == UART2_FLAG_LHDF)
2953  0042 1e01          	ldw	x,(OFST+1,sp)
2954  0044 a30302        	cpw	x,#770
2955  0047 2606          	jrne	L3421
2956                     ; 716     UART2->CR6 &= (uint8_t)(~UART2_CR6_LHDF);
2958  0049 72135249      	bres	21065,#1
2960  004d 2004          	jra	L5321
2961  004f               L3421:
2962                     ; 721     UART2->CR6 &= (uint8_t)(~UART2_CR6_LSF);
2964  004f 72115249      	bres	21065,#0
2965  0053               L5321:
2966                     ; 723 }
2969  0053 85            	popw	x
2970  0054 81            	ret
3053                     ; 738 ITStatus UART2_GetITStatus(UART2_IT_TypeDef UART2_IT)
3053                     ; 739 {
3054                     .text:	section	.text,new
3055  0000               _UART2_GetITStatus:
3057  0000 89            	pushw	x
3058  0001 89            	pushw	x
3059       00000002      OFST:	set	2
3062                     ; 740   ITStatus pendingbitstatus = RESET;
3064                     ; 741   uint8_t itpos = 0;
3066                     ; 742   uint8_t itmask1 = 0;
3068                     ; 743   uint8_t itmask2 = 0;
3070                     ; 744   uint8_t enablestatus = 0;
3072                     ; 747   assert_param(IS_UART2_GET_IT_OK(UART2_IT));
3074  0002 a30277        	cpw	x,#631
3075  0005 2723          	jreq	L472
3076  0007 a30266        	cpw	x,#614
3077  000a 271e          	jreq	L472
3078  000c a30255        	cpw	x,#597
3079  000f 2719          	jreq	L472
3080  0011 a30244        	cpw	x,#580
3081  0014 2714          	jreq	L472
3082  0016 a30235        	cpw	x,#565
3083  0019 270f          	jreq	L472
3084  001b a30346        	cpw	x,#838
3085  001e 270a          	jreq	L472
3086  0020 a30412        	cpw	x,#1042
3087  0023 2705          	jreq	L472
3088  0025 a30100        	cpw	x,#256
3089  0028 2603          	jrne	L272
3090  002a               L472:
3091  002a 4f            	clr	a
3092  002b 2010          	jra	L672
3093  002d               L272:
3094  002d ae02eb        	ldw	x,#747
3095  0030 89            	pushw	x
3096  0031 ae0000        	ldw	x,#0
3097  0034 89            	pushw	x
3098  0035 ae0008        	ldw	x,#L302
3099  0038 cd0000        	call	_assert_failed
3101  003b 5b04          	addw	sp,#4
3102  003d               L672:
3103                     ; 750   itpos = (uint8_t)((uint8_t)1 << (uint8_t)((uint8_t)UART2_IT & (uint8_t)0x0F));
3105  003d 7b04          	ld	a,(OFST+2,sp)
3106  003f a40f          	and	a,#15
3107  0041 5f            	clrw	x
3108  0042 97            	ld	xl,a
3109  0043 a601          	ld	a,#1
3110  0045 5d            	tnzw	x
3111  0046 2704          	jreq	L003
3112  0048               L203:
3113  0048 48            	sll	a
3114  0049 5a            	decw	x
3115  004a 26fc          	jrne	L203
3116  004c               L003:
3117  004c 6b01          	ld	(OFST-1,sp),a
3118                     ; 752   itmask1 = (uint8_t)((uint8_t)UART2_IT >> (uint8_t)4);
3120  004e 7b04          	ld	a,(OFST+2,sp)
3121  0050 4e            	swap	a
3122  0051 a40f          	and	a,#15
3123  0053 6b02          	ld	(OFST+0,sp),a
3124                     ; 754   itmask2 = (uint8_t)((uint8_t)1 << itmask1);
3126  0055 7b02          	ld	a,(OFST+0,sp)
3127  0057 5f            	clrw	x
3128  0058 97            	ld	xl,a
3129  0059 a601          	ld	a,#1
3130  005b 5d            	tnzw	x
3131  005c 2704          	jreq	L403
3132  005e               L603:
3133  005e 48            	sll	a
3134  005f 5a            	decw	x
3135  0060 26fc          	jrne	L603
3136  0062               L403:
3137  0062 6b02          	ld	(OFST+0,sp),a
3138                     ; 757   if (UART2_IT == UART2_IT_PE)
3140  0064 1e03          	ldw	x,(OFST+1,sp)
3141  0066 a30100        	cpw	x,#256
3142  0069 261c          	jrne	L1131
3143                     ; 760     enablestatus = (uint8_t)((uint8_t)UART2->CR1 & itmask2);
3145  006b c65244        	ld	a,21060
3146  006e 1402          	and	a,(OFST+0,sp)
3147  0070 6b02          	ld	(OFST+0,sp),a
3148                     ; 763     if (((UART2->SR & itpos) != (uint8_t)0x00) && enablestatus)
3150  0072 c65240        	ld	a,21056
3151  0075 1501          	bcp	a,(OFST-1,sp)
3152  0077 270a          	jreq	L3131
3154  0079 0d02          	tnz	(OFST+0,sp)
3155  007b 2706          	jreq	L3131
3156                     ; 766       pendingbitstatus = SET;
3158  007d a601          	ld	a,#1
3159  007f 6b02          	ld	(OFST+0,sp),a
3161  0081 2064          	jra	L7131
3162  0083               L3131:
3163                     ; 771       pendingbitstatus = RESET;
3165  0083 0f02          	clr	(OFST+0,sp)
3166  0085 2060          	jra	L7131
3167  0087               L1131:
3168                     ; 774   else if (UART2_IT == UART2_IT_LBDF)
3170  0087 1e03          	ldw	x,(OFST+1,sp)
3171  0089 a30346        	cpw	x,#838
3172  008c 261c          	jrne	L1231
3173                     ; 777     enablestatus = (uint8_t)((uint8_t)UART2->CR4 & itmask2);
3175  008e c65247        	ld	a,21063
3176  0091 1402          	and	a,(OFST+0,sp)
3177  0093 6b02          	ld	(OFST+0,sp),a
3178                     ; 779     if (((UART2->CR4 & itpos) != (uint8_t)0x00) && enablestatus)
3180  0095 c65247        	ld	a,21063
3181  0098 1501          	bcp	a,(OFST-1,sp)
3182  009a 270a          	jreq	L3231
3184  009c 0d02          	tnz	(OFST+0,sp)
3185  009e 2706          	jreq	L3231
3186                     ; 782       pendingbitstatus = SET;
3188  00a0 a601          	ld	a,#1
3189  00a2 6b02          	ld	(OFST+0,sp),a
3191  00a4 2041          	jra	L7131
3192  00a6               L3231:
3193                     ; 787       pendingbitstatus = RESET;
3195  00a6 0f02          	clr	(OFST+0,sp)
3196  00a8 203d          	jra	L7131
3197  00aa               L1231:
3198                     ; 790   else if (UART2_IT == UART2_IT_LHDF)
3200  00aa 1e03          	ldw	x,(OFST+1,sp)
3201  00ac a30412        	cpw	x,#1042
3202  00af 261c          	jrne	L1331
3203                     ; 793     enablestatus = (uint8_t)((uint8_t)UART2->CR6 & itmask2);
3205  00b1 c65249        	ld	a,21065
3206  00b4 1402          	and	a,(OFST+0,sp)
3207  00b6 6b02          	ld	(OFST+0,sp),a
3208                     ; 795     if (((UART2->CR6 & itpos) != (uint8_t)0x00) && enablestatus)
3210  00b8 c65249        	ld	a,21065
3211  00bb 1501          	bcp	a,(OFST-1,sp)
3212  00bd 270a          	jreq	L3331
3214  00bf 0d02          	tnz	(OFST+0,sp)
3215  00c1 2706          	jreq	L3331
3216                     ; 798       pendingbitstatus = SET;
3218  00c3 a601          	ld	a,#1
3219  00c5 6b02          	ld	(OFST+0,sp),a
3221  00c7 201e          	jra	L7131
3222  00c9               L3331:
3223                     ; 803       pendingbitstatus = RESET;
3225  00c9 0f02          	clr	(OFST+0,sp)
3226  00cb 201a          	jra	L7131
3227  00cd               L1331:
3228                     ; 809     enablestatus = (uint8_t)((uint8_t)UART2->CR2 & itmask2);
3230  00cd c65245        	ld	a,21061
3231  00d0 1402          	and	a,(OFST+0,sp)
3232  00d2 6b02          	ld	(OFST+0,sp),a
3233                     ; 811     if (((UART2->SR & itpos) != (uint8_t)0x00) && enablestatus)
3235  00d4 c65240        	ld	a,21056
3236  00d7 1501          	bcp	a,(OFST-1,sp)
3237  00d9 270a          	jreq	L1431
3239  00db 0d02          	tnz	(OFST+0,sp)
3240  00dd 2706          	jreq	L1431
3241                     ; 814       pendingbitstatus = SET;
3243  00df a601          	ld	a,#1
3244  00e1 6b02          	ld	(OFST+0,sp),a
3246  00e3 2002          	jra	L7131
3247  00e5               L1431:
3248                     ; 819       pendingbitstatus = RESET;
3250  00e5 0f02          	clr	(OFST+0,sp)
3251  00e7               L7131:
3252                     ; 823   return  pendingbitstatus;
3254  00e7 7b02          	ld	a,(OFST+0,sp)
3257  00e9 5b04          	addw	sp,#4
3258  00eb 81            	ret
3295                     ; 852 void UART2_ClearITPendingBit(UART2_IT_TypeDef UART2_IT)
3295                     ; 853 {
3296                     .text:	section	.text,new
3297  0000               _UART2_ClearITPendingBit:
3299  0000 89            	pushw	x
3300       00000000      OFST:	set	0
3303                     ; 854   assert_param(IS_UART2_CLEAR_IT_OK(UART2_IT));
3305  0001 a30255        	cpw	x,#597
3306  0004 270a          	jreq	L413
3307  0006 a30412        	cpw	x,#1042
3308  0009 2705          	jreq	L413
3309  000b a30346        	cpw	x,#838
3310  000e 2603          	jrne	L213
3311  0010               L413:
3312  0010 4f            	clr	a
3313  0011 2010          	jra	L613
3314  0013               L213:
3315  0013 ae0356        	ldw	x,#854
3316  0016 89            	pushw	x
3317  0017 ae0000        	ldw	x,#0
3318  001a 89            	pushw	x
3319  001b ae0008        	ldw	x,#L302
3320  001e cd0000        	call	_assert_failed
3322  0021 5b04          	addw	sp,#4
3323  0023               L613:
3324                     ; 857   if (UART2_IT == UART2_IT_RXNE)
3326  0023 1e01          	ldw	x,(OFST+1,sp)
3327  0025 a30255        	cpw	x,#597
3328  0028 2606          	jrne	L3631
3329                     ; 859     UART2->SR = (uint8_t)~(UART2_SR_RXNE);
3331  002a 35df5240      	mov	21056,#223
3333  002e 2011          	jra	L5631
3334  0030               L3631:
3335                     ; 862   else if (UART2_IT == UART2_IT_LBDF)
3337  0030 1e01          	ldw	x,(OFST+1,sp)
3338  0032 a30346        	cpw	x,#838
3339  0035 2606          	jrne	L7631
3340                     ; 864     UART2->CR4 &= (uint8_t)~(UART2_CR4_LBDF);
3342  0037 72195247      	bres	21063,#4
3344  003b 2004          	jra	L5631
3345  003d               L7631:
3346                     ; 869     UART2->CR6 &= (uint8_t)(~UART2_CR6_LHDF);
3348  003d 72135249      	bres	21065,#1
3349  0041               L5631:
3350                     ; 871 }
3353  0041 85            	popw	x
3354  0042 81            	ret
3367                     	xdef	_UART2_ClearITPendingBit
3368                     	xdef	_UART2_GetITStatus
3369                     	xdef	_UART2_ClearFlag
3370                     	xdef	_UART2_GetFlagStatus
3371                     	xdef	_UART2_SetPrescaler
3372                     	xdef	_UART2_SetGuardTime
3373                     	xdef	_UART2_SetAddress
3374                     	xdef	_UART2_SendBreak
3375                     	xdef	_UART2_SendData9
3376                     	xdef	_UART2_SendData8
3377                     	xdef	_UART2_ReceiveData9
3378                     	xdef	_UART2_ReceiveData8
3379                     	xdef	_UART2_ReceiverWakeUpCmd
3380                     	xdef	_UART2_WakeUpConfig
3381                     	xdef	_UART2_SmartCardNACKCmd
3382                     	xdef	_UART2_SmartCardCmd
3383                     	xdef	_UART2_LINCmd
3384                     	xdef	_UART2_LINConfig
3385                     	xdef	_UART2_LINBreakDetectionConfig
3386                     	xdef	_UART2_IrDACmd
3387                     	xdef	_UART2_IrDAConfig
3388                     	xdef	_UART2_ITConfig
3389                     	xdef	_UART2_Cmd
3390                     	xdef	_UART2_Init
3391                     	xdef	_UART2_DeInit
3392                     	xref	_assert_failed
3393                     	xref	_CLK_GetClockFreq
3394                     	switch	.const
3395  0008               L302:
3396  0008 73746d38735f  	dc.b	"stm8s_stdperiph_li"
3397  001a 625c6c696272  	dc.b	"b\libraries\stm8s_"
3398  002c 737464706572  	dc.b	"stdperiph_driver\s"
3399  003e 72635c73746d  	dc.b	"rc\stm8s_uart2.c",0
3400                     	xref.b	c_lreg
3401                     	xref.b	c_x
3421                     	xref	c_lursh
3422                     	xref	c_lsub
3423                     	xref	c_smul
3424                     	xref	c_ludv
3425                     	xref	c_rtol
3426                     	xref	c_llsh
3427                     	xref	c_lcmp
3428                     	xref	c_ltor
3429                     	end
