   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  65                     ; 10 void main(void)
  65                     ; 11 {
  67                     .text:	section	.text,new
  68  0000               _main:
  70  0000 88            	push	a
  71       00000001      OFST:	set	1
  74                     ; 14 	Init();
  76  0001 cd0000        	call	_Init
  78                     ; 15 	System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
  80  0004 3f00          	clr	_System_Status
  81                     ; 16 	STANDBYE();
  83  0006 4b40          	push	#64
  84  0008 ae5005        	ldw	x,#20485
  85  000b cd0000        	call	_GPIO_WriteHigh
  87  000e 84            	pop	a
  91  000f 4b80          	push	#128
  92  0011 ae5005        	ldw	x,#20485
  93  0014 cd0000        	call	_GPIO_WriteLow
  95  0017 84            	pop	a
  99  0018 4b40          	push	#64
 100  001a ae5000        	ldw	x,#20480
 101  001d cd0000        	call	_GPIO_WriteHigh
 103  0020 84            	pop	a
 104  0021               L53:
 105                     ; 19 		Command = Remote_Control_Get_Command();
 107  0021 cd0000        	call	_Remote_Control_Get_Command
 109  0024 6b01          	ld	(OFST+0,sp),a
 110                     ; 21 		switch(Command)
 112  0026 7b01          	ld	a,(OFST+0,sp)
 114                     ; 44 			default:
 114                     ; 45 			break;
 115  0028 4a            	dec	a
 116  0029 2722          	jreq	L5
 117  002b a002          	sub	a,#2
 118  002d 26f2          	jrne	L53
 119                     ; 23 			case PUMP_ALCOHOL:
 119                     ; 24 				if(System_Status.System_Status == STATUS_UNSAFE && Safe_Check_Result.Unsafe_Type != STORE_ALCOHOL_LEVE_LOW && Safe_Check_Result.Unsafe_Type != SAFE)
 121  002f b600          	ld	a,_System_Status
 122  0031 a101          	cp	a,#1
 123  0033 260a          	jrne	L54
 125  0035 b601          	ld	a,_Safe_Check_Result+1
 126  0037 a106          	cp	a,#6
 127  0039 2704          	jreq	L54
 129  003b 3d01          	tnz	_Safe_Check_Result+1
 130  003d 26e2          	jrne	L53
 131                     ; 26 						break;
 133  003f               L54:
 134                     ; 28 				System_Status.System_Status = STATUS_PUMP_IN_ALCOHOL;
 136  003f 35030000      	mov	_System_Status,#3
 137                     ; 29 				Pump_In_Alcohol();
 139  0043 cd0000        	call	_Pump_In_Alcohol
 141                     ; 30 				System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
 143  0046 3f00          	clr	_System_Status
 144                     ; 31 				Remote_Control_Get_Command(); //Clear Last Command
 146  0048 cd0000        	call	_Remote_Control_Get_Command
 148                     ; 32 			break;
 150  004b 20d4          	jra	L53
 151  004d               L5:
 152                     ; 33 			case START_FIRE:
 152                     ; 34 				if(System_Status.System_Status == STATUS_UNSAFE)
 154  004d b600          	ld	a,_System_Status
 155  004f a101          	cp	a,#1
 156  0051 27ce          	jreq	L53
 157                     ; 36 					break;
 159                     ; 38 				System_Status.System_Status = STATUS_START_FIRE;
 161  0053 35020000      	mov	_System_Status,#2
 162                     ; 39 				Start_Fire();
 164  0057 cd0000        	call	_Start_Fire
 166                     ; 40 				System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
 168  005a 3f00          	clr	_System_Status
 169                     ; 41 				Remote_Control_Get_Command(); //Clear Last Command
 171  005c cd0000        	call	_Remote_Control_Get_Command
 173                     ; 42 			break;
 175  005f 20c0          	jra	L53
 176  0061               L7:
 177                     ; 44 			default:
 177                     ; 45 			break;
 179  0061 20be          	jra	L53
 180  0063               L34:
 182  0063 20bc          	jra	L53
 224                     .const:	section	.text
 225  0000               L21:
 226  0000 0000c350      	dc.l	50000
 227                     ; 50 uint8_t Pump_In_Alcohol(void)
 227                     ; 51 {
 228                     .text:	section	.text,new
 229  0000               _Pump_In_Alcohol:
 231  0000 89            	pushw	x
 232       00000002      OFST:	set	2
 235                     ; 52 	uint16_t Ctr = 0x0000;
 237  0001 5f            	clrw	x
 238  0002 1f01          	ldw	(OFST-1,sp),x
 239                     ; 53 	WORKING();
 241  0004 4b40          	push	#64
 242  0006 ae5005        	ldw	x,#20485
 243  0009 cd0000        	call	_GPIO_WriteLow
 245  000c 84            	pop	a
 249  000d 4b80          	push	#128
 250  000f ae5005        	ldw	x,#20485
 251  0012 cd0000        	call	_GPIO_WriteHigh
 253  0015 84            	pop	a
 257  0016 4b40          	push	#64
 258  0018 ae5000        	ldw	x,#20480
 259  001b cd0000        	call	_GPIO_WriteHigh
 261  001e 84            	pop	a
 262                     ; 54 	if(!ALDHH)
 265  001f 4b02          	push	#2
 266  0021 ae5005        	ldw	x,#20485
 267  0024 cd0000        	call	_GPIO_ReadInputPin
 269  0027 5b01          	addw	sp,#1
 270  0029 4d            	tnz	a
 271  002a 2616          	jrne	L76
 272                     ; 56 		Delay_ms(5);			//disappear shakes
 274  002c ae0005        	ldw	x,#5
 275  002f cd0000        	call	_Delay_ms
 277                     ; 57 		if(!ALDHH)
 279  0032 4b02          	push	#2
 280  0034 ae5005        	ldw	x,#20485
 281  0037 cd0000        	call	_GPIO_ReadInputPin
 283  003a 5b01          	addw	sp,#1
 284  003c 4d            	tnz	a
 285  003d 2603          	jrne	L76
 286                     ; 58 			return NULL;
 288  003f 4f            	clr	a
 291  0040 85            	popw	x
 292  0041 81            	ret
 293  0042               L76:
 294                     ; 60 	Pump2(0);
 296  0042 4b04          	push	#4
 297  0044 ae500a        	ldw	x,#20490
 298  0047 cd0000        	call	_GPIO_WriteLow
 300  004a 84            	pop	a
 303  004b 2006          	jra	L57
 304  004d               L37:
 305                     ; 63 		Delay_ms(1);
 307  004d ae0001        	ldw	x,#1
 308  0050 cd0000        	call	_Delay_ms
 310  0053               L57:
 311                     ; 61 	while(ALDHH && (Ctr++ < 50000) && Remote_Control_Get_Command() != STOP_FIRE)
 313  0053 4b02          	push	#2
 314  0055 ae5005        	ldw	x,#20485
 315  0058 cd0000        	call	_GPIO_ReadInputPin
 317  005b 5b01          	addw	sp,#1
 318  005d 4d            	tnz	a
 319  005e 271b          	jreq	L101
 321  0060 9c            	rvf
 322  0061 1601          	ldw	y,(OFST-1,sp)
 323  0063 0c02          	inc	(OFST+0,sp)
 324  0065 2602          	jrne	L01
 325  0067 0c01          	inc	(OFST-1,sp)
 326  0069               L01:
 327  0069 cd0000        	call	c_uitoly
 329  006c ae0000        	ldw	x,#L21
 330  006f cd0000        	call	c_lcmp
 332  0072 2e07          	jrsge	L101
 334  0074 cd0000        	call	_Remote_Control_Get_Command
 336  0077 a102          	cp	a,#2
 337  0079 26d2          	jrne	L37
 338  007b               L101:
 339                     ; 65 	if(Ctr >= 50000)
 341  007b 9c            	rvf
 342  007c 1e01          	ldw	x,(OFST-1,sp)
 343  007e cd0000        	call	c_uitolx
 345  0081 ae0000        	ldw	x,#L21
 346  0084 cd0000        	call	c_lcmp
 348  0087 2f2b          	jrslt	L501
 349                     ; 67 		WARNNING();
 351  0089 4b40          	push	#64
 352  008b ae5005        	ldw	x,#20485
 353  008e cd0000        	call	_GPIO_WriteHigh
 355  0091 84            	pop	a
 359  0092 4b80          	push	#128
 360  0094 ae5005        	ldw	x,#20485
 361  0097 cd0000        	call	_GPIO_WriteHigh
 363  009a 84            	pop	a
 367  009b 4b40          	push	#64
 368  009d ae5000        	ldw	x,#20480
 369  00a0 cd0000        	call	_GPIO_WriteLow
 371  00a3 84            	pop	a
 372                     ; 68 		Pump2(1);
 375  00a4 4b04          	push	#4
 376  00a6 ae500a        	ldw	x,#20490
 377  00a9 cd0000        	call	_GPIO_WriteHigh
 379  00ac 84            	pop	a
 380                     ; 69 		Safe_Check_Result.Unsafe_Type = TOO_LONG_WAIT_FILL_WITH_ALCOHOL;
 383  00ad 35070001      	mov	_Safe_Check_Result+1,#7
 384                     ; 70 		Serious_Problem_Handler();
 386  00b1 cd0000        	call	_Serious_Problem_Handler
 388  00b4               L501:
 389                     ; 72 	STANDBYE();
 391  00b4 4b40          	push	#64
 392  00b6 ae5005        	ldw	x,#20485
 393  00b9 cd0000        	call	_GPIO_WriteHigh
 395  00bc 84            	pop	a
 399  00bd 4b80          	push	#128
 400  00bf ae5005        	ldw	x,#20485
 401  00c2 cd0000        	call	_GPIO_WriteLow
 403  00c5 84            	pop	a
 407  00c6 4b40          	push	#64
 408  00c8 ae5000        	ldw	x,#20480
 409  00cb cd0000        	call	_GPIO_WriteHigh
 411  00ce 84            	pop	a
 412                     ; 73 	Pump2(1);
 415  00cf 4b04          	push	#4
 416  00d1 ae500a        	ldw	x,#20490
 417  00d4 cd0000        	call	_GPIO_WriteHigh
 419  00d7 84            	pop	a
 420                     ; 74 	return NULL;
 423  00d8 4f            	clr	a
 426  00d9 85            	popw	x
 427  00da 81            	ret
 468                     ; 77 uint8_t Start_Fire(void)
 468                     ; 78 {
 469                     .text:	section	.text,new
 470  0000               _Start_Fire:
 472  0000 89            	pushw	x
 473       00000002      OFST:	set	2
 476                     ; 79 	uint16_t Ctr = 0x0000;
 478                     ; 80 	WORKING();
 480  0001 4b40          	push	#64
 481  0003 ae5005        	ldw	x,#20485
 482  0006 cd0000        	call	_GPIO_WriteLow
 484  0009 84            	pop	a
 488  000a 4b80          	push	#128
 489  000c ae5005        	ldw	x,#20485
 490  000f cd0000        	call	_GPIO_WriteHigh
 492  0012 84            	pop	a
 496  0013 4b40          	push	#64
 497  0015 ae5000        	ldw	x,#20480
 498  0018 cd0000        	call	_GPIO_WriteHigh
 500  001b 84            	pop	a
 501                     ; 81 	AHeater(0);
 504  001c 4b10          	push	#16
 505  001e ae5000        	ldw	x,#20480
 506  0021 cd0000        	call	_GPIO_WriteLow
 508  0024 84            	pop	a
 509                     ; 82 	for(Ctr = 0; Ctr <= 20000 && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
 512  0025 5f            	clrw	x
 513  0026 1f01          	ldw	(OFST-1,sp),x
 515  0028 200d          	jra	L131
 516  002a               L521:
 517                     ; 84 		Delay_ms(1);
 519  002a ae0001        	ldw	x,#1
 520  002d cd0000        	call	_Delay_ms
 522                     ; 82 	for(Ctr = 0; Ctr <= 20000 && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
 524  0030 1e01          	ldw	x,(OFST-1,sp)
 525  0032 1c0001        	addw	x,#1
 526  0035 1f01          	ldw	(OFST-1,sp),x
 527  0037               L131:
 530  0037 1e01          	ldw	x,(OFST-1,sp)
 531  0039 a34e21        	cpw	x,#20001
 532  003c 240d          	jruge	L531
 534  003e cd0000        	call	_Remote_Control_Get_Command
 536  0041 a102          	cp	a,#2
 537  0043 2706          	jreq	L531
 539  0045 b600          	ld	a,_System_Status
 540  0047 a102          	cp	a,#2
 541  0049 27df          	jreq	L521
 542  004b               L531:
 543                     ; 86 	if(Ctr < 20000)
 545  004b 1e01          	ldw	x,(OFST-1,sp)
 546  004d a34e20        	cpw	x,#20000
 547  0050 2439          	jruge	L141
 548                     ; 88 		STOP_WORKING();
 550  0052 4b02          	push	#2
 551  0054 ae500a        	ldw	x,#20490
 552  0057 cd0000        	call	_GPIO_WriteHigh
 554  005a 84            	pop	a
 558  005b 4b04          	push	#4
 559  005d ae500a        	ldw	x,#20490
 560  0060 cd0000        	call	_GPIO_WriteHigh
 562  0063 84            	pop	a
 566  0064 4b10          	push	#16
 567  0066 ae5000        	ldw	x,#20480
 568  0069 cd0000        	call	_GPIO_WriteHigh
 570  006c 84            	pop	a
 571                     ; 89 		STANDBYE();
 574  006d 4b40          	push	#64
 575  006f ae5005        	ldw	x,#20485
 576  0072 cd0000        	call	_GPIO_WriteHigh
 578  0075 84            	pop	a
 582  0076 4b80          	push	#128
 583  0078 ae5005        	ldw	x,#20485
 584  007b cd0000        	call	_GPIO_WriteLow
 586  007e 84            	pop	a
 590  007f 4b40          	push	#64
 591  0081 ae5000        	ldw	x,#20480
 592  0084 cd0000        	call	_GPIO_WriteHigh
 594  0087 84            	pop	a
 595                     ; 90 		return NULL;
 598  0088 4f            	clr	a
 600  0089 206d          	jra	L61
 601  008b               L141:
 602                     ; 92 	Pump1(0);
 604  008b 4b02          	push	#2
 605  008d ae500a        	ldw	x,#20490
 606  0090 cd0000        	call	_GPIO_WriteLow
 608  0093 84            	pop	a
 609                     ; 93 	for(Ctr = 0; Ctr <= 2000  && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
 612  0094 5f            	clrw	x
 613  0095 1f01          	ldw	(OFST-1,sp),x
 615  0097 200d          	jra	L741
 616  0099               L341:
 617                     ; 95 		Delay_ms(1);
 619  0099 ae0001        	ldw	x,#1
 620  009c cd0000        	call	_Delay_ms
 622                     ; 93 	for(Ctr = 0; Ctr <= 2000  && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
 624  009f 1e01          	ldw	x,(OFST-1,sp)
 625  00a1 1c0001        	addw	x,#1
 626  00a4 1f01          	ldw	(OFST-1,sp),x
 627  00a6               L741:
 630  00a6 1e01          	ldw	x,(OFST-1,sp)
 631  00a8 a307d1        	cpw	x,#2001
 632  00ab 240d          	jruge	L351
 634  00ad cd0000        	call	_Remote_Control_Get_Command
 636  00b0 a102          	cp	a,#2
 637  00b2 2706          	jreq	L351
 639  00b4 b600          	ld	a,_System_Status
 640  00b6 a102          	cp	a,#2
 641  00b8 27df          	jreq	L341
 642  00ba               L351:
 643                     ; 97 	if(Ctr < 2000)
 645  00ba 1e01          	ldw	x,(OFST-1,sp)
 646  00bc a307d0        	cpw	x,#2000
 647  00bf 2439          	jruge	L751
 648                     ; 99 		STOP_WORKING();
 650  00c1 4b02          	push	#2
 651  00c3 ae500a        	ldw	x,#20490
 652  00c6 cd0000        	call	_GPIO_WriteHigh
 654  00c9 84            	pop	a
 658  00ca 4b04          	push	#4
 659  00cc ae500a        	ldw	x,#20490
 660  00cf cd0000        	call	_GPIO_WriteHigh
 662  00d2 84            	pop	a
 666  00d3 4b10          	push	#16
 667  00d5 ae5000        	ldw	x,#20480
 668  00d8 cd0000        	call	_GPIO_WriteHigh
 670  00db 84            	pop	a
 671                     ; 100 		STANDBYE();
 674  00dc 4b40          	push	#64
 675  00de ae5005        	ldw	x,#20485
 676  00e1 cd0000        	call	_GPIO_WriteHigh
 678  00e4 84            	pop	a
 682  00e5 4b80          	push	#128
 683  00e7 ae5005        	ldw	x,#20485
 684  00ea cd0000        	call	_GPIO_WriteLow
 686  00ed 84            	pop	a
 690  00ee 4b40          	push	#64
 691  00f0 ae5000        	ldw	x,#20480
 692  00f3 cd0000        	call	_GPIO_WriteHigh
 694  00f6 84            	pop	a
 695                     ; 101 		return NULL;
 698  00f7 4f            	clr	a
 700  00f8               L61:
 702  00f8 85            	popw	x
 703  00f9 81            	ret
 704  00fa               L751:
 705                     ; 103 	AHeater(1);
 707  00fa 4b10          	push	#16
 708  00fc ae5000        	ldw	x,#20480
 709  00ff cd0000        	call	_GPIO_WriteHigh
 711  0102 84            	pop	a
 712  0103               L161:
 713                     ; 106 		if(Remote_Control_Get_Command() == STOP_FIRE || System_Status.System_Status != STATUS_START_FIRE)
 715  0103 cd0000        	call	_Remote_Control_Get_Command
 717  0106 a102          	cp	a,#2
 718  0108 275a          	jreq	L361
 720  010a b600          	ld	a,_System_Status
 721  010c a102          	cp	a,#2
 722  010e 2654          	jrne	L361
 723                     ; 108 		if(!FireDL)
 725  0110 4b10          	push	#16
 726  0112 ae5005        	ldw	x,#20485
 727  0115 cd0000        	call	_GPIO_ReadInputPin
 729  0118 5b01          	addw	sp,#1
 730  011a 4d            	tnz	a
 731  011b 261c          	jrne	L171
 732                     ; 110 			Delay_ms(5);
 734  011d ae0005        	ldw	x,#5
 735  0120 cd0000        	call	_Delay_ms
 737                     ; 111 			if(!FireDL)
 739  0123 4b10          	push	#16
 740  0125 ae5005        	ldw	x,#20485
 741  0128 cd0000        	call	_GPIO_ReadInputPin
 743  012b 5b01          	addw	sp,#1
 744  012d 4d            	tnz	a
 745  012e 2609          	jrne	L171
 746                     ; 113 				Pump1(1);
 748  0130 4b02          	push	#2
 749  0132 ae500a        	ldw	x,#20490
 750  0135 cd0000        	call	_GPIO_WriteHigh
 752  0138 84            	pop	a
 754  0139               L171:
 755                     ; 116 		if(FireDL)
 757  0139 4b10          	push	#16
 758  013b ae5005        	ldw	x,#20485
 759  013e cd0000        	call	_GPIO_ReadInputPin
 761  0141 5b01          	addw	sp,#1
 762  0143 4d            	tnz	a
 763  0144 27bd          	jreq	L161
 764                     ; 118 			Delay_ms(5);
 766  0146 ae0005        	ldw	x,#5
 767  0149 cd0000        	call	_Delay_ms
 769                     ; 119 			if(FireDL)
 771  014c 4b10          	push	#16
 772  014e ae5005        	ldw	x,#20485
 773  0151 cd0000        	call	_GPIO_ReadInputPin
 775  0154 5b01          	addw	sp,#1
 776  0156 4d            	tnz	a
 777  0157 27aa          	jreq	L161
 778                     ; 121 				Pump1(0);
 780  0159 4b02          	push	#2
 781  015b ae500a        	ldw	x,#20490
 782  015e cd0000        	call	_GPIO_WriteLow
 784  0161 84            	pop	a
 786  0162 209f          	jra	L161
 787  0164               L361:
 788                     ; 125 	STOP_WORKING();
 790  0164 4b02          	push	#2
 791  0166 ae500a        	ldw	x,#20490
 792  0169 cd0000        	call	_GPIO_WriteHigh
 794  016c 84            	pop	a
 798  016d 4b04          	push	#4
 799  016f ae500a        	ldw	x,#20490
 800  0172 cd0000        	call	_GPIO_WriteHigh
 802  0175 84            	pop	a
 806  0176 4b10          	push	#16
 807  0178 ae5000        	ldw	x,#20480
 808  017b cd0000        	call	_GPIO_WriteHigh
 810  017e 84            	pop	a
 811                     ; 126 	WARNNING();
 814  017f 4b40          	push	#64
 815  0181 ae5005        	ldw	x,#20485
 816  0184 cd0000        	call	_GPIO_WriteHigh
 818  0187 84            	pop	a
 822  0188 4b80          	push	#128
 823  018a ae5005        	ldw	x,#20485
 824  018d cd0000        	call	_GPIO_WriteHigh
 826  0190 84            	pop	a
 830  0191 4b40          	push	#64
 831  0193 ae5000        	ldw	x,#20480
 832  0196 cd0000        	call	_GPIO_WriteLow
 834  0199 84            	pop	a
 835  019a               L102:
 836                     ; 127 	while(1);
 838  019a 20fe          	jra	L102
 874                     ; 132 void assert_failed(uint8_t* file, uint32_t line) //assert_failed function
 874                     ; 133 { 
 875                     .text:	section	.text,new
 876  0000               _assert_failed:
 880  0000               L322:
 881                     ; 140 		UART_Send_Char(0x01);
 883  0000 a601          	ld	a,#1
 884  0002 cd0000        	call	_UART_Send_Char
 887  0005 20f9          	jra	L322
 941                     ; 144 void Init(void)
 941                     ; 145 {
 942                     .text:	section	.text,new
 943  0000               _Init:
 945  0000 88            	push	a
 946       00000001      OFST:	set	1
 949  0001               L742:
 950                     ; 148 	while(Sys_Clk_Init() != SUCCESS);
 952  0001 cd0000        	call	_Sys_Clk_Init
 954  0004 a101          	cp	a,#1
 955  0006 26f9          	jrne	L742
 956                     ; 149 	TIM4_Tick_Init();
 958  0008 cd0000        	call	_TIM4_Tick_Init
 960                     ; 151 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
 962  000b a6f7          	ld	a,#247
 963  000d cd0000        	call	_FLASH_Unlock
 965                     ; 152 	FLASH_EraseByte(0x4000);
 967  0010 ae4000        	ldw	x,#16384
 968  0013 89            	pushw	x
 969  0014 ae0000        	ldw	x,#0
 970  0017 89            	pushw	x
 971  0018 cd0000        	call	_FLASH_EraseByte
 973  001b 5b04          	addw	sp,#4
 974                     ; 153 	FLASH_Lock(FLASH_MEMTYPE_DATA);
 976  001d a6f7          	ld	a,#247
 977  001f cd0000        	call	_FLASH_Lock
 979                     ; 156 	UART_Init();
 981  0022 cd0000        	call	_UART_Init
 983                     ; 158 	GPIO_Init(GPIOB, GPIO_PIN_6, GPIO_MODE_OUT_PP_HIGH_SLOW);
 985  0025 4bd0          	push	#208
 986  0027 4b40          	push	#64
 987  0029 ae5005        	ldw	x,#20485
 988  002c cd0000        	call	_GPIO_Init
 990  002f 85            	popw	x
 991                     ; 159 	GPIO_Init(GPIOB, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_SLOW);
 993  0030 4bd0          	push	#208
 994  0032 4b80          	push	#128
 995  0034 ae5005        	ldw	x,#20485
 996  0037 cd0000        	call	_GPIO_Init
 998  003a 85            	popw	x
 999                     ; 160 	GPIO_Init(GPIOA, GPIO_PIN_6, GPIO_MODE_OUT_PP_HIGH_SLOW);
1001  003b 4bd0          	push	#208
1002  003d 4b40          	push	#64
1003  003f ae5000        	ldw	x,#20480
1004  0042 cd0000        	call	_GPIO_Init
1006  0045 85            	popw	x
1007                     ; 162 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
1009  0046 a6f7          	ld	a,#247
1010  0048 cd0000        	call	_FLASH_Unlock
1012                     ; 163 	ERROR = FLASH_ReadByte(0x4000);
1014  004b ae4000        	ldw	x,#16384
1015  004e 89            	pushw	x
1016  004f ae0000        	ldw	x,#0
1017  0052 89            	pushw	x
1018  0053 cd0000        	call	_FLASH_ReadByte
1020  0056 5b04          	addw	sp,#4
1021  0058 6b01          	ld	(OFST+0,sp),a
1022                     ; 164 	FLASH_Lock(FLASH_MEMTYPE_DATA);
1024  005a a6f7          	ld	a,#247
1025  005c cd0000        	call	_FLASH_Lock
1027                     ; 165 	if((ERROR == HIGH_TEMPERTURE) || (ERROR == GET_TEMPERTURE_FAILED) || (ERROR == GET_ALCOHOL_CONCENTRATION_FAILED) || (ERROR == TOO_LONG_WAIT_FILL_WITH_ALCOHOL) || (ERROR == ALCOHOL_LEAKAGE))
1029  005f 7b01          	ld	a,(OFST+0,sp)
1030  0061 a101          	cp	a,#1
1031  0063 2718          	jreq	L552
1033  0065 7b01          	ld	a,(OFST+0,sp)
1034  0067 a102          	cp	a,#2
1035  0069 2712          	jreq	L552
1037  006b 7b01          	ld	a,(OFST+0,sp)
1038  006d a105          	cp	a,#5
1039  006f 270c          	jreq	L552
1041  0071 7b01          	ld	a,(OFST+0,sp)
1042  0073 a107          	cp	a,#7
1043  0075 2706          	jreq	L552
1045  0077 7b01          	ld	a,(OFST+0,sp)
1046  0079 a109          	cp	a,#9
1047  007b 262c          	jrne	L352
1048  007d               L552:
1049                     ; 167 		sim();
1052  007d 9b            sim
1054                     ; 168 		WARNNING();
1057  007e 4b40          	push	#64
1058  0080 ae5005        	ldw	x,#20485
1059  0083 cd0000        	call	_GPIO_WriteHigh
1061  0086 84            	pop	a
1065  0087 4b80          	push	#128
1066  0089 ae5005        	ldw	x,#20485
1067  008c cd0000        	call	_GPIO_WriteHigh
1069  008f 84            	pop	a
1073  0090 4b40          	push	#64
1074  0092 ae5000        	ldw	x,#20480
1075  0095 cd0000        	call	_GPIO_WriteLow
1077  0098 84            	pop	a
1079  0099               L372:
1080                     ; 171 			while(!UART2_GetFlagStatus(UART2_FLAG_TXE));
1082  0099 ae0080        	ldw	x,#128
1083  009c cd0000        	call	_UART2_GetFlagStatus
1085  009f 4d            	tnz	a
1086  00a0 27f7          	jreq	L372
1087                     ; 172 			UART2_SendData8(ERROR);
1089  00a2 7b01          	ld	a,(OFST+0,sp)
1090  00a4 cd0000        	call	_UART2_SendData8
1093  00a7 20f0          	jra	L372
1094  00a9               L352:
1095                     ; 177 	WWDG_Init(0x7F, 0x57);	//Enable WWDG, about 30 - 49 ms is refresh Window Time
1097  00a9 ae0057        	ldw	x,#87
1098  00ac a67f          	ld	a,#127
1099  00ae 95            	ld	xh,a
1100  00af cd0000        	call	_WWDG_Init
1102                     ; 181 	GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_HIGH_SLOW);
1104  00b2 4bd0          	push	#208
1105  00b4 4b08          	push	#8
1106  00b6 ae500a        	ldw	x,#20490
1107  00b9 cd0000        	call	_GPIO_Init
1109  00bc 85            	popw	x
1110                     ; 183 	GPIO_Init(GPIOC, GPIO_PIN_1, GPIO_MODE_OUT_PP_HIGH_SLOW);
1112  00bd 4bd0          	push	#208
1113  00bf 4b02          	push	#2
1114  00c1 ae500a        	ldw	x,#20490
1115  00c4 cd0000        	call	_GPIO_Init
1117  00c7 85            	popw	x
1118                     ; 184 	GPIO_Init(GPIOC, GPIO_PIN_2, GPIO_MODE_OUT_PP_HIGH_SLOW);
1120  00c8 4bd0          	push	#208
1121  00ca 4b04          	push	#4
1122  00cc ae500a        	ldw	x,#20490
1123  00cf cd0000        	call	_GPIO_Init
1125  00d2 85            	popw	x
1126                     ; 186 	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_SLOW);
1128  00d3 4bd0          	push	#208
1129  00d5 4b20          	push	#32
1130  00d7 ae5000        	ldw	x,#20480
1131  00da cd0000        	call	_GPIO_Init
1133  00dd 85            	popw	x
1134                     ; 188 	GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_IN_PU_NO_IT);
1136  00de 4b40          	push	#64
1137  00e0 4b01          	push	#1
1138  00e2 ae5005        	ldw	x,#20485
1139  00e5 cd0000        	call	_GPIO_Init
1141  00e8 85            	popw	x
1142                     ; 189 	GPIO_Init(GPIOB, GPIO_PIN_1, GPIO_MODE_IN_PU_NO_IT);
1144  00e9 4b40          	push	#64
1145  00eb 4b02          	push	#2
1146  00ed ae5005        	ldw	x,#20485
1147  00f0 cd0000        	call	_GPIO_Init
1149  00f3 85            	popw	x
1150                     ; 191 	Remote_Control_Init();
1152  00f4 cd0000        	call	_Remote_Control_Init
1154                     ; 192 	Remote_Control_Cmd(ENABLE);
1156  00f7 a601          	ld	a,#1
1157  00f9 cd0000        	call	_Remote_Control_Cmd
1159                     ; 194 	GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT);
1161  00fc 4b00          	push	#0
1162  00fe 4b08          	push	#8
1163  0100 ae5005        	ldw	x,#20485
1164  0103 cd0000        	call	_GPIO_Init
1166  0106 85            	popw	x
1167                     ; 195 	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
1169  0107 4b00          	push	#0
1170  0109 4b10          	push	#16
1171  010b ae5005        	ldw	x,#20485
1172  010e cd0000        	call	_GPIO_Init
1174  0111 85            	popw	x
1175                     ; 197 	GPIO_Init(GPIOA, GPIO_PIN_4, GPIO_MODE_OUT_PP_HIGH_SLOW);
1177  0112 4bd0          	push	#208
1178  0114 4b10          	push	#16
1179  0116 ae5000        	ldw	x,#20480
1180  0119 cd0000        	call	_GPIO_Init
1182  011c 85            	popw	x
1183                     ; 199 	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT);
1185  011d 4b00          	push	#0
1186  011f 4b20          	push	#32
1187  0121 ae5005        	ldw	x,#20485
1188  0124 cd0000        	call	_GPIO_Init
1190  0127 85            	popw	x
1191                     ; 201 	if(Safe_Check_Init())
1193  0128 cd0000        	call	_Safe_Check_Init
1195  012b 4d            	tnz	a
1196  012c 270b          	jreq	L772
1197                     ; 203 		Safe_Check_Result.Unsafe_Type = SAFE_CHECK_INIT_FAILED;
1199  012e 35080001      	mov	_Safe_Check_Result+1,#8
1200                     ; 204 		Safe_Check_Result.Safe_Flag = UNSAFE;
1202  0132 35010000      	mov	_Safe_Check_Result,#1
1203                     ; 205 		Serious_Problem_Handler();
1205  0136 cd0000        	call	_Serious_Problem_Handler
1207  0139               L772:
1208                     ; 207 }
1211  0139 84            	pop	a
1212  013a 81            	ret
1238                     ; 209 void UART_Init(void)
1238                     ; 210 {
1239                     .text:	section	.text,new
1240  0000               _UART_Init:
1244                     ; 211 	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART2, ENABLE);
1246  0000 ae0001        	ldw	x,#1
1247  0003 a603          	ld	a,#3
1248  0005 95            	ld	xh,a
1249  0006 cd0000        	call	_CLK_PeripheralClockConfig
1251                     ; 213 	UART2_Init(38400, UART2_WORDLENGTH_8D, UART2_STOPBITS_1, UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE, UART2_MODE_TX_ENABLE);
1253  0009 4b04          	push	#4
1254  000b 4b80          	push	#128
1255  000d 4b00          	push	#0
1256  000f 4b00          	push	#0
1257  0011 4b00          	push	#0
1258  0013 ae9600        	ldw	x,#38400
1259  0016 89            	pushw	x
1260  0017 ae0000        	ldw	x,#0
1261  001a 89            	pushw	x
1262  001b cd0000        	call	_UART2_Init
1264  001e 5b09          	addw	sp,#9
1265                     ; 214 	UART2_Cmd(ENABLE);
1267  0020 a601          	ld	a,#1
1268  0022 cd0000        	call	_UART2_Cmd
1270                     ; 215 }
1273  0025 81            	ret
1311                     ; 217 void UART_Send_Char(uint8_t C)
1311                     ; 218 {
1312                     .text:	section	.text,new
1313  0000               _UART_Send_Char:
1315  0000 88            	push	a
1316       00000000      OFST:	set	0
1319  0001               L133:
1320                     ; 219 	while(!UART2_GetFlagStatus(UART2_FLAG_TXE));
1322  0001 ae0080        	ldw	x,#128
1323  0004 cd0000        	call	_UART2_GetFlagStatus
1325  0007 4d            	tnz	a
1326  0008 27f7          	jreq	L133
1327                     ; 220 	sim();
1330  000a 9b            sim
1332                     ; 221 	UART2_SendData8(C);
1335  000b 7b01          	ld	a,(OFST+1,sp)
1336  000d cd0000        	call	_UART2_SendData8
1338                     ; 222 	rim(); //!!
1341  0010 9a            rim
1343                     ; 223 }
1347  0011 84            	pop	a
1348  0012 81            	ret
1393                     ; 225 ErrorStatus Sys_Clk_Init(void)
1393                     ; 226 {
1394                     .text:	section	.text,new
1395  0000               _Sys_Clk_Init:
1399                     ; 227 	return CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSE, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
1401  0000 4b01          	push	#1
1402  0002 4b00          	push	#0
1403  0004 ae00b4        	ldw	x,#180
1404  0007 a601          	ld	a,#1
1405  0009 95            	ld	xh,a
1406  000a cd0000        	call	_CLK_ClockSwitchConfig
1408  000d 85            	popw	x
1411  000e 81            	ret
1446                     ; 230 void Serious_Problem_Handler(void)
1446                     ; 231 {
1447                     .text:	section	.text,new
1448  0000               _Serious_Problem_Handler:
1452                     ; 232 	WARNNING();
1454  0000 4b40          	push	#64
1455  0002 ae5005        	ldw	x,#20485
1456  0005 cd0000        	call	_GPIO_WriteHigh
1458  0008 84            	pop	a
1462  0009 4b80          	push	#128
1463  000b ae5005        	ldw	x,#20485
1464  000e cd0000        	call	_GPIO_WriteHigh
1466  0011 84            	pop	a
1470  0012 4b40          	push	#64
1471  0014 ae5000        	ldw	x,#20480
1472  0017 cd0000        	call	_GPIO_WriteLow
1474  001a 84            	pop	a
1475                     ; 233 	STOP_WORKING();
1478  001b 4b02          	push	#2
1479  001d ae500a        	ldw	x,#20490
1480  0020 cd0000        	call	_GPIO_WriteHigh
1482  0023 84            	pop	a
1486  0024 4b04          	push	#4
1487  0026 ae500a        	ldw	x,#20490
1488  0029 cd0000        	call	_GPIO_WriteHigh
1490  002c 84            	pop	a
1494  002d 4b10          	push	#16
1495  002f ae5000        	ldw	x,#20480
1496  0032 cd0000        	call	_GPIO_WriteHigh
1498  0035 84            	pop	a
1499                     ; 234 	sim();
1503  0036 9b            sim
1505                     ; 235 	FLASH_Unlock(FLASH_MEMTYPE_DATA);
1508  0037 a6f7          	ld	a,#247
1509  0039 cd0000        	call	_FLASH_Unlock
1511                     ; 236 	FLASH_EraseByte(0x4000);
1513  003c ae4000        	ldw	x,#16384
1514  003f 89            	pushw	x
1515  0040 ae0000        	ldw	x,#0
1516  0043 89            	pushw	x
1517  0044 cd0000        	call	_FLASH_EraseByte
1519  0047 5b04          	addw	sp,#4
1520                     ; 237 	FLASH_ProgramByte(0x4000, (uint8_t)Safe_Check_Result.Unsafe_Type);
1522  0049 3b0001        	push	_Safe_Check_Result+1
1523  004c ae4000        	ldw	x,#16384
1524  004f 89            	pushw	x
1525  0050 ae0000        	ldw	x,#0
1526  0053 89            	pushw	x
1527  0054 cd0000        	call	_FLASH_ProgramByte
1529  0057 5b05          	addw	sp,#5
1530                     ; 238 	FLASH_Lock(FLASH_MEMTYPE_DATA);
1532  0059 a6f7          	ld	a,#247
1533  005b cd0000        	call	_FLASH_Lock
1535  005e               L563:
1536                     ; 241 		if((WWDG_GetCounter() & 0x7f) < 0x50)
1538  005e cd0000        	call	_WWDG_GetCounter
1540  0061 a47f          	and	a,#127
1541  0063 a150          	cp	a,#80
1542  0065 24f7          	jruge	L563
1543                     ; 243 			WWDG_SetCounter(0x7F);
1545  0067 a67f          	ld	a,#127
1546  0069 cd0000        	call	_WWDG_SetCounter
1548  006c 20f0          	jra	L563
1626                     	xdef	_main
1627                     	switch	.ubsct
1628  0000               _System_Status:
1629  0000 00            	ds.b	1
1630                     	xdef	_System_Status
1631                     	xref.b	_Safe_Check_Result
1632                     	xdef	_Start_Fire
1633                     	xdef	_Pump_In_Alcohol
1634                     	xdef	_UART_Send_Char
1635                     	xdef	_UART_Init
1636                     	xdef	_Init
1637                     	xdef	_Sys_Clk_Init
1638                     	xdef	_Serious_Problem_Handler
1639                     	xref	_Safe_Check_Init
1640                     	xref	_Remote_Control_Cmd
1641                     	xref	_Remote_Control_Init
1642                     	xref	_Remote_Control_Get_Command
1643                     	xref	_Delay_ms
1644                     	xref	_TIM4_Tick_Init
1645                     	xdef	_assert_failed
1646                     	xref	_WWDG_GetCounter
1647                     	xref	_WWDG_SetCounter
1648                     	xref	_WWDG_Init
1649                     	xref	_UART2_GetFlagStatus
1650                     	xref	_UART2_SendData8
1651                     	xref	_UART2_Cmd
1652                     	xref	_UART2_Init
1653                     	xref	_GPIO_ReadInputPin
1654                     	xref	_GPIO_WriteReverse
1655                     	xref	_GPIO_WriteLow
1656                     	xref	_GPIO_WriteHigh
1657                     	xref	_GPIO_Init
1658                     	xref	_FLASH_ReadByte
1659                     	xref	_FLASH_ProgramByte
1660                     	xref	_FLASH_EraseByte
1661                     	xref	_FLASH_Lock
1662                     	xref	_FLASH_Unlock
1663                     	xref	_CLK_ClockSwitchConfig
1664                     	xref	_CLK_PeripheralClockConfig
1684                     	xref	c_uitolx
1685                     	xref	c_lcmp
1686                     	xref	c_uitoly
1687                     	end
