   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.8.32 - 23 Mar 2010
   3                     ; Generator V4.3.4 - 23 Mar 2010
  78                     ; 87 void FLASH_Unlock(FLASH_MemType_TypeDef FLASH_MemType)
  78                     ; 88 {
  80                     .text:	section	.text,new
  81  0000               _FLASH_Unlock:
  83  0000 88            	push	a
  84       00000000      OFST:	set	0
  87                     ; 90   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
  89  0001 a1fd          	cp	a,#253
  90  0003 2704          	jreq	L01
  91  0005 a1f7          	cp	a,#247
  92  0007 2603          	jrne	L6
  93  0009               L01:
  94  0009 4f            	clr	a
  95  000a 2010          	jra	L21
  96  000c               L6:
  97  000c ae005a        	ldw	x,#90
  98  000f 89            	pushw	x
  99  0010 ae0000        	ldw	x,#0
 100  0013 89            	pushw	x
 101  0014 ae0010        	ldw	x,#L73
 102  0017 cd0000        	call	_assert_failed
 104  001a 5b04          	addw	sp,#4
 105  001c               L21:
 106                     ; 93   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
 108  001c 7b01          	ld	a,(OFST+1,sp)
 109  001e a1fd          	cp	a,#253
 110  0020 260a          	jrne	L14
 111                     ; 95     FLASH->PUKR = FLASH_RASS_KEY1;
 113  0022 35565062      	mov	20578,#86
 114                     ; 96     FLASH->PUKR = FLASH_RASS_KEY2;
 116  0026 35ae5062      	mov	20578,#174
 118  002a 2008          	jra	L34
 119  002c               L14:
 120                     ; 101     FLASH->DUKR = FLASH_RASS_KEY2; /* Warning: keys are reversed on data memory !!! */
 122  002c 35ae5064      	mov	20580,#174
 123                     ; 102     FLASH->DUKR = FLASH_RASS_KEY1;
 125  0030 35565064      	mov	20580,#86
 126  0034               L34:
 127                     ; 104 }
 130  0034 84            	pop	a
 131  0035 81            	ret
 167                     ; 112 void FLASH_Lock(FLASH_MemType_TypeDef FLASH_MemType)
 167                     ; 113 {
 168                     .text:	section	.text,new
 169  0000               _FLASH_Lock:
 171  0000 88            	push	a
 172       00000000      OFST:	set	0
 175                     ; 115   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
 177  0001 a1fd          	cp	a,#253
 178  0003 2704          	jreq	L02
 179  0005 a1f7          	cp	a,#247
 180  0007 2603          	jrne	L61
 181  0009               L02:
 182  0009 4f            	clr	a
 183  000a 2010          	jra	L22
 184  000c               L61:
 185  000c ae0073        	ldw	x,#115
 186  000f 89            	pushw	x
 187  0010 ae0000        	ldw	x,#0
 188  0013 89            	pushw	x
 189  0014 ae0010        	ldw	x,#L73
 190  0017 cd0000        	call	_assert_failed
 192  001a 5b04          	addw	sp,#4
 193  001c               L22:
 194                     ; 118   FLASH->IAPSR &= (uint8_t)FLASH_MemType;
 196  001c c6505f        	ld	a,20575
 197  001f 1401          	and	a,(OFST+1,sp)
 198  0021 c7505f        	ld	20575,a
 199                     ; 119 }
 202  0024 84            	pop	a
 203  0025 81            	ret
 226                     ; 126 void FLASH_DeInit(void)
 226                     ; 127 {
 227                     .text:	section	.text,new
 228  0000               _FLASH_DeInit:
 232                     ; 128   FLASH->CR1 = FLASH_CR1_RESET_VALUE;
 234  0000 725f505a      	clr	20570
 235                     ; 129   FLASH->CR2 = FLASH_CR2_RESET_VALUE;
 237  0004 725f505b      	clr	20571
 238                     ; 130   FLASH->NCR2 = FLASH_NCR2_RESET_VALUE;
 240  0008 35ff505c      	mov	20572,#255
 241                     ; 131   FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_DUL);
 243  000c 7217505f      	bres	20575,#3
 244                     ; 132   FLASH->IAPSR &= (uint8_t)(~FLASH_IAPSR_PUL);
 246  0010 7213505f      	bres	20575,#1
 247                     ; 133   (void) FLASH->IAPSR; /* Reading of this register causes the clearing of status flags */
 249  0014 c6505f        	ld	a,20575
 250                     ; 134 }
 253  0017 81            	ret
 309                     ; 142 void FLASH_ITConfig(FunctionalState NewState)
 309                     ; 143 {
 310                     .text:	section	.text,new
 311  0000               _FLASH_ITConfig:
 313  0000 88            	push	a
 314       00000000      OFST:	set	0
 317                     ; 145   assert_param(IS_FUNCTIONALSTATE_OK(NewState));
 319  0001 4d            	tnz	a
 320  0002 2704          	jreq	L23
 321  0004 a101          	cp	a,#1
 322  0006 2603          	jrne	L03
 323  0008               L23:
 324  0008 4f            	clr	a
 325  0009 2010          	jra	L43
 326  000b               L03:
 327  000b ae0091        	ldw	x,#145
 328  000e 89            	pushw	x
 329  000f ae0000        	ldw	x,#0
 330  0012 89            	pushw	x
 331  0013 ae0010        	ldw	x,#L73
 332  0016 cd0000        	call	_assert_failed
 334  0019 5b04          	addw	sp,#4
 335  001b               L43:
 336                     ; 147   if(NewState != DISABLE)
 338  001b 0d01          	tnz	(OFST+1,sp)
 339  001d 2706          	jreq	L121
 340                     ; 149     FLASH->CR1 |= FLASH_CR1_IE; /* Enables the interrupt sources */
 342  001f 7212505a      	bset	20570,#1
 344  0023 2004          	jra	L321
 345  0025               L121:
 346                     ; 153     FLASH->CR1 &= (uint8_t)(~FLASH_CR1_IE); /* Disables the interrupt sources */
 348  0025 7213505a      	bres	20570,#1
 349  0029               L321:
 350                     ; 155 }
 353  0029 84            	pop	a
 354  002a 81            	ret
 389                     .const:	section	.text
 390  0000               L64:
 391  0000 00008000      	dc.l	32768
 392  0004               L05:
 393  0004 00010000      	dc.l	65536
 394  0008               L25:
 395  0008 00004000      	dc.l	16384
 396  000c               L45:
 397  000c 00004400      	dc.l	17408
 398                     ; 164 void FLASH_EraseByte(uint32_t Address)
 398                     ; 165 {
 399                     .text:	section	.text,new
 400  0000               _FLASH_EraseByte:
 402       00000000      OFST:	set	0
 405                     ; 167   assert_param(IS_FLASH_ADDRESS_OK(Address));
 407  0000 96            	ldw	x,sp
 408  0001 1c0003        	addw	x,#OFST+3
 409  0004 cd0000        	call	c_ltor
 411  0007 ae0000        	ldw	x,#L64
 412  000a cd0000        	call	c_lcmp
 414  000d 250f          	jrult	L44
 415  000f 96            	ldw	x,sp
 416  0010 1c0003        	addw	x,#OFST+3
 417  0013 cd0000        	call	c_ltor
 419  0016 ae0004        	ldw	x,#L05
 420  0019 cd0000        	call	c_lcmp
 422  001c 251e          	jrult	L24
 423  001e               L44:
 424  001e 96            	ldw	x,sp
 425  001f 1c0003        	addw	x,#OFST+3
 426  0022 cd0000        	call	c_ltor
 428  0025 ae0008        	ldw	x,#L25
 429  0028 cd0000        	call	c_lcmp
 431  002b 2512          	jrult	L04
 432  002d 96            	ldw	x,sp
 433  002e 1c0003        	addw	x,#OFST+3
 434  0031 cd0000        	call	c_ltor
 436  0034 ae000c        	ldw	x,#L45
 437  0037 cd0000        	call	c_lcmp
 439  003a 2403          	jruge	L04
 440  003c               L24:
 441  003c 4f            	clr	a
 442  003d 2010          	jra	L65
 443  003f               L04:
 444  003f ae00a7        	ldw	x,#167
 445  0042 89            	pushw	x
 446  0043 ae0000        	ldw	x,#0
 447  0046 89            	pushw	x
 448  0047 ae0010        	ldw	x,#L73
 449  004a cd0000        	call	_assert_failed
 451  004d 5b04          	addw	sp,#4
 452  004f               L65:
 453                     ; 170   *(PointerAttr uint8_t*) (MemoryAddressCast)Address = FLASH_CLEAR_BYTE; 
 455  004f 1e05          	ldw	x,(OFST+5,sp)
 456  0051 7f            	clr	(x)
 457                     ; 171 }
 460  0052 81            	ret
 504                     ; 181 void FLASH_ProgramByte(uint32_t Address, uint8_t Data)
 504                     ; 182 {
 505                     .text:	section	.text,new
 506  0000               _FLASH_ProgramByte:
 508       00000000      OFST:	set	0
 511                     ; 184   assert_param(IS_FLASH_ADDRESS_OK(Address));
 513  0000 96            	ldw	x,sp
 514  0001 1c0003        	addw	x,#OFST+3
 515  0004 cd0000        	call	c_ltor
 517  0007 ae0000        	ldw	x,#L64
 518  000a cd0000        	call	c_lcmp
 520  000d 250f          	jrult	L66
 521  000f 96            	ldw	x,sp
 522  0010 1c0003        	addw	x,#OFST+3
 523  0013 cd0000        	call	c_ltor
 525  0016 ae0004        	ldw	x,#L05
 526  0019 cd0000        	call	c_lcmp
 528  001c 251e          	jrult	L46
 529  001e               L66:
 530  001e 96            	ldw	x,sp
 531  001f 1c0003        	addw	x,#OFST+3
 532  0022 cd0000        	call	c_ltor
 534  0025 ae0008        	ldw	x,#L25
 535  0028 cd0000        	call	c_lcmp
 537  002b 2512          	jrult	L26
 538  002d 96            	ldw	x,sp
 539  002e 1c0003        	addw	x,#OFST+3
 540  0031 cd0000        	call	c_ltor
 542  0034 ae000c        	ldw	x,#L45
 543  0037 cd0000        	call	c_lcmp
 545  003a 2403          	jruge	L26
 546  003c               L46:
 547  003c 4f            	clr	a
 548  003d 2010          	jra	L07
 549  003f               L26:
 550  003f ae00b8        	ldw	x,#184
 551  0042 89            	pushw	x
 552  0043 ae0000        	ldw	x,#0
 553  0046 89            	pushw	x
 554  0047 ae0010        	ldw	x,#L73
 555  004a cd0000        	call	_assert_failed
 557  004d 5b04          	addw	sp,#4
 558  004f               L07:
 559                     ; 185   *(PointerAttr uint8_t*) (MemoryAddressCast)Address = Data;
 561  004f 7b07          	ld	a,(OFST+7,sp)
 562  0051 1e05          	ldw	x,(OFST+5,sp)
 563  0053 f7            	ld	(x),a
 564                     ; 186 }
 567  0054 81            	ret
 602                     ; 195 uint8_t FLASH_ReadByte(uint32_t Address)
 602                     ; 196 {
 603                     .text:	section	.text,new
 604  0000               _FLASH_ReadByte:
 606       00000000      OFST:	set	0
 609                     ; 198   assert_param(IS_FLASH_ADDRESS_OK(Address));
 611  0000 96            	ldw	x,sp
 612  0001 1c0003        	addw	x,#OFST+3
 613  0004 cd0000        	call	c_ltor
 615  0007 ae0000        	ldw	x,#L64
 616  000a cd0000        	call	c_lcmp
 618  000d 250f          	jrult	L001
 619  000f 96            	ldw	x,sp
 620  0010 1c0003        	addw	x,#OFST+3
 621  0013 cd0000        	call	c_ltor
 623  0016 ae0004        	ldw	x,#L05
 624  0019 cd0000        	call	c_lcmp
 626  001c 251e          	jrult	L67
 627  001e               L001:
 628  001e 96            	ldw	x,sp
 629  001f 1c0003        	addw	x,#OFST+3
 630  0022 cd0000        	call	c_ltor
 632  0025 ae0008        	ldw	x,#L25
 633  0028 cd0000        	call	c_lcmp
 635  002b 2512          	jrult	L47
 636  002d 96            	ldw	x,sp
 637  002e 1c0003        	addw	x,#OFST+3
 638  0031 cd0000        	call	c_ltor
 640  0034 ae000c        	ldw	x,#L45
 641  0037 cd0000        	call	c_lcmp
 643  003a 2403          	jruge	L47
 644  003c               L67:
 645  003c 4f            	clr	a
 646  003d 2010          	jra	L201
 647  003f               L47:
 648  003f ae00c6        	ldw	x,#198
 649  0042 89            	pushw	x
 650  0043 ae0000        	ldw	x,#0
 651  0046 89            	pushw	x
 652  0047 ae0010        	ldw	x,#L73
 653  004a cd0000        	call	_assert_failed
 655  004d 5b04          	addw	sp,#4
 656  004f               L201:
 657                     ; 201   return(*(PointerAttr uint8_t *) (MemoryAddressCast)Address); 
 659  004f 1e05          	ldw	x,(OFST+5,sp)
 660  0051 f6            	ld	a,(x)
 663  0052 81            	ret
 707                     ; 212 void FLASH_ProgramWord(uint32_t Address, uint32_t Data)
 707                     ; 213 {
 708                     .text:	section	.text,new
 709  0000               _FLASH_ProgramWord:
 711       00000000      OFST:	set	0
 714                     ; 215   assert_param(IS_FLASH_ADDRESS_OK(Address));
 716  0000 96            	ldw	x,sp
 717  0001 1c0003        	addw	x,#OFST+3
 718  0004 cd0000        	call	c_ltor
 720  0007 ae0000        	ldw	x,#L64
 721  000a cd0000        	call	c_lcmp
 723  000d 250f          	jrult	L211
 724  000f 96            	ldw	x,sp
 725  0010 1c0003        	addw	x,#OFST+3
 726  0013 cd0000        	call	c_ltor
 728  0016 ae0004        	ldw	x,#L05
 729  0019 cd0000        	call	c_lcmp
 731  001c 251e          	jrult	L011
 732  001e               L211:
 733  001e 96            	ldw	x,sp
 734  001f 1c0003        	addw	x,#OFST+3
 735  0022 cd0000        	call	c_ltor
 737  0025 ae0008        	ldw	x,#L25
 738  0028 cd0000        	call	c_lcmp
 740  002b 2512          	jrult	L601
 741  002d 96            	ldw	x,sp
 742  002e 1c0003        	addw	x,#OFST+3
 743  0031 cd0000        	call	c_ltor
 745  0034 ae000c        	ldw	x,#L45
 746  0037 cd0000        	call	c_lcmp
 748  003a 2403          	jruge	L601
 749  003c               L011:
 750  003c 4f            	clr	a
 751  003d 2010          	jra	L411
 752  003f               L601:
 753  003f ae00d7        	ldw	x,#215
 754  0042 89            	pushw	x
 755  0043 ae0000        	ldw	x,#0
 756  0046 89            	pushw	x
 757  0047 ae0010        	ldw	x,#L73
 758  004a cd0000        	call	_assert_failed
 760  004d 5b04          	addw	sp,#4
 761  004f               L411:
 762                     ; 218   FLASH->CR2 |= FLASH_CR2_WPRG;
 764  004f 721c505b      	bset	20571,#6
 765                     ; 219   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NWPRG);
 767  0053 721d505c      	bres	20572,#6
 768                     ; 222   *((PointerAttr uint8_t*)(MemoryAddressCast)Address)       = *((uint8_t*)(&Data));
 770  0057 7b07          	ld	a,(OFST+7,sp)
 771  0059 1e05          	ldw	x,(OFST+5,sp)
 772  005b f7            	ld	(x),a
 773                     ; 224   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 1) = *((uint8_t*)(&Data)+1); 
 775  005c 7b08          	ld	a,(OFST+8,sp)
 776  005e 1e05          	ldw	x,(OFST+5,sp)
 777  0060 e701          	ld	(1,x),a
 778                     ; 226   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 2) = *((uint8_t*)(&Data)+2); 
 780  0062 7b09          	ld	a,(OFST+9,sp)
 781  0064 1e05          	ldw	x,(OFST+5,sp)
 782  0066 e702          	ld	(2,x),a
 783                     ; 228   *(((PointerAttr uint8_t*)(MemoryAddressCast)Address) + 3) = *((uint8_t*)(&Data)+3); 
 785  0068 7b0a          	ld	a,(OFST+10,sp)
 786  006a 1e05          	ldw	x,(OFST+5,sp)
 787  006c e703          	ld	(3,x),a
 788                     ; 229 }
 791  006e 81            	ret
 837                     ; 237 void FLASH_ProgramOptionByte(uint16_t Address, uint8_t Data)
 837                     ; 238 {
 838                     .text:	section	.text,new
 839  0000               _FLASH_ProgramOptionByte:
 841  0000 89            	pushw	x
 842       00000000      OFST:	set	0
 845                     ; 240   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
 847  0001 a34800        	cpw	x,#18432
 848  0004 2508          	jrult	L021
 849  0006 a34880        	cpw	x,#18560
 850  0009 2403          	jruge	L021
 851  000b 4f            	clr	a
 852  000c 2010          	jra	L221
 853  000e               L021:
 854  000e ae00f0        	ldw	x,#240
 855  0011 89            	pushw	x
 856  0012 ae0000        	ldw	x,#0
 857  0015 89            	pushw	x
 858  0016 ae0010        	ldw	x,#L73
 859  0019 cd0000        	call	_assert_failed
 861  001c 5b04          	addw	sp,#4
 862  001e               L221:
 863                     ; 243   FLASH->CR2 |= FLASH_CR2_OPT;
 865  001e 721e505b      	bset	20571,#7
 866                     ; 244   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
 868  0022 721f505c      	bres	20572,#7
 869                     ; 247   if(Address == 0x4800)
 871  0026 1e01          	ldw	x,(OFST+1,sp)
 872  0028 a34800        	cpw	x,#18432
 873  002b 2607          	jrne	L742
 874                     ; 250     *((NEAR uint8_t*)Address) = Data;
 876  002d 7b05          	ld	a,(OFST+5,sp)
 877  002f 1e01          	ldw	x,(OFST+1,sp)
 878  0031 f7            	ld	(x),a
 880  0032 200c          	jra	L152
 881  0034               L742:
 882                     ; 255     *((NEAR uint8_t*)Address) = Data;
 884  0034 7b05          	ld	a,(OFST+5,sp)
 885  0036 1e01          	ldw	x,(OFST+1,sp)
 886  0038 f7            	ld	(x),a
 887                     ; 256     *((NEAR uint8_t*)((uint16_t)(Address + 1))) = (uint8_t)(~Data);
 889  0039 7b05          	ld	a,(OFST+5,sp)
 890  003b 43            	cpl	a
 891  003c 1e01          	ldw	x,(OFST+1,sp)
 892  003e e701          	ld	(1,x),a
 893  0040               L152:
 894                     ; 258   FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
 896  0040 a6fd          	ld	a,#253
 897  0042 cd0000        	call	_FLASH_WaitForLastOperation
 899                     ; 261   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
 901  0045 721f505b      	bres	20571,#7
 902                     ; 262   FLASH->NCR2 |= FLASH_NCR2_NOPT;
 904  0049 721e505c      	bset	20572,#7
 905                     ; 263 }
 908  004d 85            	popw	x
 909  004e 81            	ret
 946                     ; 270 void FLASH_EraseOptionByte(uint16_t Address)
 946                     ; 271 {
 947                     .text:	section	.text,new
 948  0000               _FLASH_EraseOptionByte:
 950  0000 89            	pushw	x
 951       00000000      OFST:	set	0
 954                     ; 273   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
 956  0001 a34800        	cpw	x,#18432
 957  0004 2508          	jrult	L621
 958  0006 a34880        	cpw	x,#18560
 959  0009 2403          	jruge	L621
 960  000b 4f            	clr	a
 961  000c 2010          	jra	L031
 962  000e               L621:
 963  000e ae0111        	ldw	x,#273
 964  0011 89            	pushw	x
 965  0012 ae0000        	ldw	x,#0
 966  0015 89            	pushw	x
 967  0016 ae0010        	ldw	x,#L73
 968  0019 cd0000        	call	_assert_failed
 970  001c 5b04          	addw	sp,#4
 971  001e               L031:
 972                     ; 276   FLASH->CR2 |= FLASH_CR2_OPT;
 974  001e 721e505b      	bset	20571,#7
 975                     ; 277   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NOPT);
 977  0022 721f505c      	bres	20572,#7
 978                     ; 280   if(Address == 0x4800)
 980  0026 1e01          	ldw	x,(OFST+1,sp)
 981  0028 a34800        	cpw	x,#18432
 982  002b 2605          	jrne	L172
 983                     ; 283     *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
 985  002d 1e01          	ldw	x,(OFST+1,sp)
 986  002f 7f            	clr	(x)
 988  0030 2009          	jra	L372
 989  0032               L172:
 990                     ; 288     *((NEAR uint8_t*)Address) = FLASH_CLEAR_BYTE;
 992  0032 1e01          	ldw	x,(OFST+1,sp)
 993  0034 7f            	clr	(x)
 994                     ; 289     *((NEAR uint8_t*)((uint16_t)(Address + (uint16_t)1 ))) = FLASH_SET_BYTE;
 996  0035 1e01          	ldw	x,(OFST+1,sp)
 997  0037 a6ff          	ld	a,#255
 998  0039 e701          	ld	(1,x),a
 999  003b               L372:
1000                     ; 291   FLASH_WaitForLastOperation(FLASH_MEMTYPE_PROG);
1002  003b a6fd          	ld	a,#253
1003  003d cd0000        	call	_FLASH_WaitForLastOperation
1005                     ; 294   FLASH->CR2 &= (uint8_t)(~FLASH_CR2_OPT);
1007  0040 721f505b      	bres	20571,#7
1008                     ; 295   FLASH->NCR2 |= FLASH_NCR2_NOPT;
1010  0044 721e505c      	bset	20572,#7
1011                     ; 296 }
1014  0048 85            	popw	x
1015  0049 81            	ret
1079                     ; 303 uint16_t FLASH_ReadOptionByte(uint16_t Address)
1079                     ; 304 {
1080                     .text:	section	.text,new
1081  0000               _FLASH_ReadOptionByte:
1083  0000 89            	pushw	x
1084  0001 5204          	subw	sp,#4
1085       00000004      OFST:	set	4
1088                     ; 305   uint8_t value_optbyte, value_optbyte_complement = 0;
1090                     ; 306   uint16_t res_value = 0;
1092                     ; 309   assert_param(IS_OPTION_BYTE_ADDRESS_OK(Address));
1094  0003 a34800        	cpw	x,#18432
1095  0006 2508          	jrult	L431
1096  0008 a34880        	cpw	x,#18560
1097  000b 2403          	jruge	L431
1098  000d 4f            	clr	a
1099  000e 2010          	jra	L631
1100  0010               L431:
1101  0010 ae0135        	ldw	x,#309
1102  0013 89            	pushw	x
1103  0014 ae0000        	ldw	x,#0
1104  0017 89            	pushw	x
1105  0018 ae0010        	ldw	x,#L73
1106  001b cd0000        	call	_assert_failed
1108  001e 5b04          	addw	sp,#4
1109  0020               L631:
1110                     ; 311   value_optbyte = *((NEAR uint8_t*)Address); /* Read option byte */
1112  0020 1e05          	ldw	x,(OFST+1,sp)
1113  0022 f6            	ld	a,(x)
1114  0023 6b02          	ld	(OFST-2,sp),a
1115                     ; 312   value_optbyte_complement = *(((NEAR uint8_t*)Address) + 1); /* Read option byte complement */
1117  0025 1e05          	ldw	x,(OFST+1,sp)
1118  0027 e601          	ld	a,(1,x)
1119  0029 6b01          	ld	(OFST-3,sp),a
1120                     ; 315   if(Address == 0x4800)	 
1122  002b 1e05          	ldw	x,(OFST+1,sp)
1123  002d a34800        	cpw	x,#18432
1124  0030 2608          	jrne	L723
1125                     ; 317     res_value =	 value_optbyte;
1127  0032 7b02          	ld	a,(OFST-2,sp)
1128  0034 5f            	clrw	x
1129  0035 97            	ld	xl,a
1130  0036 1f03          	ldw	(OFST-1,sp),x
1132  0038 2023          	jra	L133
1133  003a               L723:
1134                     ; 321     if(value_optbyte == (uint8_t)(~value_optbyte_complement))
1136  003a 7b01          	ld	a,(OFST-3,sp)
1137  003c 43            	cpl	a
1138  003d 1102          	cp	a,(OFST-2,sp)
1139  003f 2617          	jrne	L333
1140                     ; 323       res_value = (uint16_t)((uint16_t)value_optbyte << 8);
1142  0041 7b02          	ld	a,(OFST-2,sp)
1143  0043 5f            	clrw	x
1144  0044 97            	ld	xl,a
1145  0045 4f            	clr	a
1146  0046 02            	rlwa	x,a
1147  0047 1f03          	ldw	(OFST-1,sp),x
1148                     ; 324       res_value = res_value | (uint16_t)value_optbyte_complement;
1150  0049 7b01          	ld	a,(OFST-3,sp)
1151  004b 5f            	clrw	x
1152  004c 97            	ld	xl,a
1153  004d 01            	rrwa	x,a
1154  004e 1a04          	or	a,(OFST+0,sp)
1155  0050 01            	rrwa	x,a
1156  0051 1a03          	or	a,(OFST-1,sp)
1157  0053 01            	rrwa	x,a
1158  0054 1f03          	ldw	(OFST-1,sp),x
1160  0056 2005          	jra	L133
1161  0058               L333:
1162                     ; 328       res_value = FLASH_OPTIONBYTE_ERROR;
1164  0058 ae5555        	ldw	x,#21845
1165  005b 1f03          	ldw	(OFST-1,sp),x
1166  005d               L133:
1167                     ; 331   return(res_value);
1169  005d 1e03          	ldw	x,(OFST-1,sp)
1172  005f 5b06          	addw	sp,#6
1173  0061 81            	ret
1248                     ; 340 void FLASH_SetLowPowerMode(FLASH_LPMode_TypeDef FLASH_LPMode)
1248                     ; 341 {
1249                     .text:	section	.text,new
1250  0000               _FLASH_SetLowPowerMode:
1252  0000 88            	push	a
1253       00000000      OFST:	set	0
1256                     ; 343   assert_param(IS_FLASH_LOW_POWER_MODE_OK(FLASH_LPMode));
1258  0001 a104          	cp	a,#4
1259  0003 270b          	jreq	L441
1260  0005 a108          	cp	a,#8
1261  0007 2707          	jreq	L441
1262  0009 4d            	tnz	a
1263  000a 2704          	jreq	L441
1264  000c a10c          	cp	a,#12
1265  000e 2603          	jrne	L241
1266  0010               L441:
1267  0010 4f            	clr	a
1268  0011 2010          	jra	L641
1269  0013               L241:
1270  0013 ae0157        	ldw	x,#343
1271  0016 89            	pushw	x
1272  0017 ae0000        	ldw	x,#0
1273  001a 89            	pushw	x
1274  001b ae0010        	ldw	x,#L73
1275  001e cd0000        	call	_assert_failed
1277  0021 5b04          	addw	sp,#4
1278  0023               L641:
1279                     ; 346   FLASH->CR1 &= (uint8_t)(~(FLASH_CR1_HALT | FLASH_CR1_AHALT)); 
1281  0023 c6505a        	ld	a,20570
1282  0026 a4f3          	and	a,#243
1283  0028 c7505a        	ld	20570,a
1284                     ; 349   FLASH->CR1 |= (uint8_t)FLASH_LPMode; 
1286  002b c6505a        	ld	a,20570
1287  002e 1a01          	or	a,(OFST+1,sp)
1288  0030 c7505a        	ld	20570,a
1289                     ; 350 }
1292  0033 84            	pop	a
1293  0034 81            	ret
1352                     ; 358 void FLASH_SetProgrammingTime(FLASH_ProgramTime_TypeDef FLASH_ProgTime)
1352                     ; 359 {
1353                     .text:	section	.text,new
1354  0000               _FLASH_SetProgrammingTime:
1356  0000 88            	push	a
1357       00000000      OFST:	set	0
1360                     ; 361   assert_param(IS_FLASH_PROGRAM_TIME_OK(FLASH_ProgTime));
1362  0001 4d            	tnz	a
1363  0002 2704          	jreq	L451
1364  0004 a101          	cp	a,#1
1365  0006 2603          	jrne	L251
1366  0008               L451:
1367  0008 4f            	clr	a
1368  0009 2010          	jra	L651
1369  000b               L251:
1370  000b ae0169        	ldw	x,#361
1371  000e 89            	pushw	x
1372  000f ae0000        	ldw	x,#0
1373  0012 89            	pushw	x
1374  0013 ae0010        	ldw	x,#L73
1375  0016 cd0000        	call	_assert_failed
1377  0019 5b04          	addw	sp,#4
1378  001b               L651:
1379                     ; 363   FLASH->CR1 &= (uint8_t)(~FLASH_CR1_FIX);
1381  001b 7211505a      	bres	20570,#0
1382                     ; 364   FLASH->CR1 |= (uint8_t)FLASH_ProgTime;
1384  001f c6505a        	ld	a,20570
1385  0022 1a01          	or	a,(OFST+1,sp)
1386  0024 c7505a        	ld	20570,a
1387                     ; 365 }
1390  0027 84            	pop	a
1391  0028 81            	ret
1416                     ; 372 FLASH_LPMode_TypeDef FLASH_GetLowPowerMode(void)
1416                     ; 373 {
1417                     .text:	section	.text,new
1418  0000               _FLASH_GetLowPowerMode:
1422                     ; 374   return((FLASH_LPMode_TypeDef)(FLASH->CR1 & (uint8_t)(FLASH_CR1_HALT | FLASH_CR1_AHALT)));
1424  0000 c6505a        	ld	a,20570
1425  0003 a40c          	and	a,#12
1428  0005 81            	ret
1453                     ; 382 FLASH_ProgramTime_TypeDef FLASH_GetProgrammingTime(void)
1453                     ; 383 {
1454                     .text:	section	.text,new
1455  0000               _FLASH_GetProgrammingTime:
1459                     ; 384   return((FLASH_ProgramTime_TypeDef)(FLASH->CR1 & FLASH_CR1_FIX));
1461  0000 c6505a        	ld	a,20570
1462  0003 a401          	and	a,#1
1465  0005 81            	ret
1499                     ; 392 uint32_t FLASH_GetBootSize(void)
1499                     ; 393 {
1500                     .text:	section	.text,new
1501  0000               _FLASH_GetBootSize:
1503  0000 5204          	subw	sp,#4
1504       00000004      OFST:	set	4
1507                     ; 394   uint32_t temp = 0;
1509                     ; 397   temp = (uint32_t)((uint32_t)FLASH->FPR * (uint32_t)512);
1511  0002 c6505d        	ld	a,20573
1512  0005 5f            	clrw	x
1513  0006 97            	ld	xl,a
1514  0007 90ae0200      	ldw	y,#512
1515  000b cd0000        	call	c_umul
1517  000e 96            	ldw	x,sp
1518  000f 1c0001        	addw	x,#OFST-3
1519  0012 cd0000        	call	c_rtol
1521                     ; 400   if(FLASH->FPR == 0xFF)
1523  0015 c6505d        	ld	a,20573
1524  0018 a1ff          	cp	a,#255
1525  001a 2611          	jrne	L554
1526                     ; 402     temp += 512;
1528  001c ae0200        	ldw	x,#512
1529  001f bf02          	ldw	c_lreg+2,x
1530  0021 ae0000        	ldw	x,#0
1531  0024 bf00          	ldw	c_lreg,x
1532  0026 96            	ldw	x,sp
1533  0027 1c0001        	addw	x,#OFST-3
1534  002a cd0000        	call	c_lgadd
1536  002d               L554:
1537                     ; 406   return(temp);
1539  002d 96            	ldw	x,sp
1540  002e 1c0001        	addw	x,#OFST-3
1541  0031 cd0000        	call	c_ltor
1545  0034 5b04          	addw	sp,#4
1546  0036 81            	ret
1656                     ; 417 FlagStatus FLASH_GetFlagStatus(FLASH_Flag_TypeDef FLASH_FLAG)
1656                     ; 418 {
1657                     .text:	section	.text,new
1658  0000               _FLASH_GetFlagStatus:
1660  0000 88            	push	a
1661  0001 88            	push	a
1662       00000001      OFST:	set	1
1665                     ; 419   FlagStatus status = RESET;
1667                     ; 421   assert_param(IS_FLASH_FLAGS_OK(FLASH_FLAG));
1669  0002 a140          	cp	a,#64
1670  0004 2710          	jreq	L271
1671  0006 a108          	cp	a,#8
1672  0008 270c          	jreq	L271
1673  000a a104          	cp	a,#4
1674  000c 2708          	jreq	L271
1675  000e a102          	cp	a,#2
1676  0010 2704          	jreq	L271
1677  0012 a101          	cp	a,#1
1678  0014 2603          	jrne	L071
1679  0016               L271:
1680  0016 4f            	clr	a
1681  0017 2010          	jra	L471
1682  0019               L071:
1683  0019 ae01a5        	ldw	x,#421
1684  001c 89            	pushw	x
1685  001d ae0000        	ldw	x,#0
1686  0020 89            	pushw	x
1687  0021 ae0010        	ldw	x,#L73
1688  0024 cd0000        	call	_assert_failed
1690  0027 5b04          	addw	sp,#4
1691  0029               L471:
1692                     ; 424   if((FLASH->IAPSR & (uint8_t)FLASH_FLAG) != (uint8_t)RESET)
1694  0029 c6505f        	ld	a,20575
1695  002c 1502          	bcp	a,(OFST+1,sp)
1696  002e 2706          	jreq	L725
1697                     ; 426     status = SET; /* FLASH_FLAG is set */
1699  0030 a601          	ld	a,#1
1700  0032 6b01          	ld	(OFST+0,sp),a
1702  0034 2002          	jra	L135
1703  0036               L725:
1704                     ; 430     status = RESET; /* FLASH_FLAG is reset*/
1706  0036 0f01          	clr	(OFST+0,sp)
1707  0038               L135:
1708                     ; 434   return status;
1710  0038 7b01          	ld	a,(OFST+0,sp)
1713  003a 85            	popw	x
1714  003b 81            	ret
1807                     ; 549 IN_RAM(FLASH_Status_TypeDef FLASH_WaitForLastOperation(FLASH_MemType_TypeDef FLASH_MemType)) 
1807                     ; 550 {
1808                     .text:	section	.text,new
1809  0000               _FLASH_WaitForLastOperation:
1811  0000 5203          	subw	sp,#3
1812       00000003      OFST:	set	3
1815                     ; 551   uint8_t flagstatus = 0x00;
1817  0002 0f03          	clr	(OFST+0,sp)
1818                     ; 552   uint16_t timeout = OPERATION_TIMEOUT;
1820  0004 aeffff        	ldw	x,#65535
1821  0007 1f01          	ldw	(OFST-2,sp),x
1822                     ; 557     if(FLASH_MemType == FLASH_MEMTYPE_PROG)
1824  0009 a1fd          	cp	a,#253
1825  000b 2628          	jrne	L316
1827  000d 200e          	jra	L106
1828  000f               L775:
1829                     ; 561         flagstatus = (uint8_t)(FLASH->IAPSR & (uint8_t)(FLASH_IAPSR_EOP |
1829                     ; 562                                                         FLASH_IAPSR_WR_PG_DIS));
1831  000f c6505f        	ld	a,20575
1832  0012 a405          	and	a,#5
1833  0014 6b03          	ld	(OFST+0,sp),a
1834                     ; 563         timeout--;
1836  0016 1e01          	ldw	x,(OFST-2,sp)
1837  0018 1d0001        	subw	x,#1
1838  001b 1f01          	ldw	(OFST-2,sp),x
1839  001d               L106:
1840                     ; 559       while((flagstatus == 0x00) && (timeout != 0x00))
1842  001d 0d03          	tnz	(OFST+0,sp)
1843  001f 261c          	jrne	L706
1845  0021 1e01          	ldw	x,(OFST-2,sp)
1846  0023 26ea          	jrne	L775
1847  0025 2016          	jra	L706
1848  0027               L116:
1849                     ; 570         flagstatus = (uint8_t)(FLASH->IAPSR & (uint8_t)(FLASH_IAPSR_HVOFF |
1849                     ; 571                                                         FLASH_IAPSR_WR_PG_DIS));
1851  0027 c6505f        	ld	a,20575
1852  002a a441          	and	a,#65
1853  002c 6b03          	ld	(OFST+0,sp),a
1854                     ; 572         timeout--;
1856  002e 1e01          	ldw	x,(OFST-2,sp)
1857  0030 1d0001        	subw	x,#1
1858  0033 1f01          	ldw	(OFST-2,sp),x
1859  0035               L316:
1860                     ; 568       while((flagstatus == 0x00) && (timeout != 0x00))
1862  0035 0d03          	tnz	(OFST+0,sp)
1863  0037 2604          	jrne	L706
1865  0039 1e01          	ldw	x,(OFST-2,sp)
1866  003b 26ea          	jrne	L116
1867  003d               L706:
1868                     ; 583   if(timeout == 0x00 )
1870  003d 1e01          	ldw	x,(OFST-2,sp)
1871  003f 2604          	jrne	L126
1872                     ; 585     flagstatus = FLASH_STATUS_TIMEOUT;
1874  0041 a602          	ld	a,#2
1875  0043 6b03          	ld	(OFST+0,sp),a
1876  0045               L126:
1877                     ; 588   return((FLASH_Status_TypeDef)flagstatus);
1879  0045 7b03          	ld	a,(OFST+0,sp)
1882  0047 5b03          	addw	sp,#3
1883  0049 81            	ret
1947                     ; 598 IN_RAM(void FLASH_EraseBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType))
1947                     ; 599 {
1948                     .text:	section	.text,new
1949  0000               _FLASH_EraseBlock:
1951  0000 89            	pushw	x
1952  0001 5206          	subw	sp,#6
1953       00000006      OFST:	set	6
1956                     ; 600   uint32_t startaddress = 0;
1958                     ; 610   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
1960  0003 7b0b          	ld	a,(OFST+5,sp)
1961  0005 a1fd          	cp	a,#253
1962  0007 2706          	jreq	L402
1963  0009 7b0b          	ld	a,(OFST+5,sp)
1964  000b a1f7          	cp	a,#247
1965  000d 2603          	jrne	L202
1966  000f               L402:
1967  000f 4f            	clr	a
1968  0010 2010          	jra	L602
1969  0012               L202:
1970  0012 ae0262        	ldw	x,#610
1971  0015 89            	pushw	x
1972  0016 ae0000        	ldw	x,#0
1973  0019 89            	pushw	x
1974  001a ae0010        	ldw	x,#L73
1975  001d cd0000        	call	_assert_failed
1977  0020 5b04          	addw	sp,#4
1978  0022               L602:
1979                     ; 611   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
1981  0022 7b0b          	ld	a,(OFST+5,sp)
1982  0024 a1fd          	cp	a,#253
1983  0026 2626          	jrne	L556
1984                     ; 613     assert_param(IS_FLASH_PROG_BLOCK_NUMBER_OK(BlockNum));
1986  0028 1e07          	ldw	x,(OFST+1,sp)
1987  002a a30100        	cpw	x,#256
1988  002d 2403          	jruge	L012
1989  002f 4f            	clr	a
1990  0030 2010          	jra	L212
1991  0032               L012:
1992  0032 ae0265        	ldw	x,#613
1993  0035 89            	pushw	x
1994  0036 ae0000        	ldw	x,#0
1995  0039 89            	pushw	x
1996  003a ae0010        	ldw	x,#L73
1997  003d cd0000        	call	_assert_failed
1999  0040 5b04          	addw	sp,#4
2000  0042               L212:
2001                     ; 614     startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
2003  0042 ae8000        	ldw	x,#32768
2004  0045 1f05          	ldw	(OFST-1,sp),x
2005  0047 ae0000        	ldw	x,#0
2006  004a 1f03          	ldw	(OFST-3,sp),x
2008  004c 2024          	jra	L756
2009  004e               L556:
2010                     ; 618     assert_param(IS_FLASH_DATA_BLOCK_NUMBER_OK(BlockNum));
2012  004e 1e07          	ldw	x,(OFST+1,sp)
2013  0050 a30008        	cpw	x,#8
2014  0053 2403          	jruge	L412
2015  0055 4f            	clr	a
2016  0056 2010          	jra	L612
2017  0058               L412:
2018  0058 ae026a        	ldw	x,#618
2019  005b 89            	pushw	x
2020  005c ae0000        	ldw	x,#0
2021  005f 89            	pushw	x
2022  0060 ae0010        	ldw	x,#L73
2023  0063 cd0000        	call	_assert_failed
2025  0066 5b04          	addw	sp,#4
2026  0068               L612:
2027                     ; 619     startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
2029  0068 ae4000        	ldw	x,#16384
2030  006b 1f05          	ldw	(OFST-1,sp),x
2031  006d ae0000        	ldw	x,#0
2032  0070 1f03          	ldw	(OFST-3,sp),x
2033  0072               L756:
2034                     ; 627     pwFlash = (PointerAttr uint32_t *)(MemoryAddressCast)(startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE));
2036  0072 1e07          	ldw	x,(OFST+1,sp)
2037  0074 a680          	ld	a,#128
2038  0076 cd0000        	call	c_cmulx
2040  0079 96            	ldw	x,sp
2041  007a 1c0003        	addw	x,#OFST-3
2042  007d cd0000        	call	c_ladd
2044  0080 be02          	ldw	x,c_lreg+2
2045  0082 1f01          	ldw	(OFST-5,sp),x
2046                     ; 631   FLASH->CR2 |= FLASH_CR2_ERASE;
2048  0084 721a505b      	bset	20571,#5
2049                     ; 632   FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NERASE);
2051  0088 721b505c      	bres	20572,#5
2052                     ; 636     *pwFlash = (uint32_t)0;
2054  008c 1e01          	ldw	x,(OFST-5,sp)
2055  008e a600          	ld	a,#0
2056  0090 e703          	ld	(3,x),a
2057  0092 a600          	ld	a,#0
2058  0094 e702          	ld	(2,x),a
2059  0096 a600          	ld	a,#0
2060  0098 e701          	ld	(1,x),a
2061  009a a600          	ld	a,#0
2062  009c f7            	ld	(x),a
2063                     ; 644 }
2066  009d 5b08          	addw	sp,#8
2067  009f 81            	ret
2172                     ; 655 IN_RAM(void FLASH_ProgramBlock(uint16_t BlockNum, FLASH_MemType_TypeDef FLASH_MemType, 
2172                     ; 656                         FLASH_ProgramMode_TypeDef FLASH_ProgMode, uint8_t *Buffer))
2172                     ; 657 {
2173                     .text:	section	.text,new
2174  0000               _FLASH_ProgramBlock:
2176  0000 89            	pushw	x
2177  0001 5206          	subw	sp,#6
2178       00000006      OFST:	set	6
2181                     ; 658   uint16_t Count = 0;
2183                     ; 659   uint32_t startaddress = 0;
2185                     ; 662   assert_param(IS_MEMORY_TYPE_OK(FLASH_MemType));
2187  0003 7b0b          	ld	a,(OFST+5,sp)
2188  0005 a1fd          	cp	a,#253
2189  0007 2706          	jreq	L422
2190  0009 7b0b          	ld	a,(OFST+5,sp)
2191  000b a1f7          	cp	a,#247
2192  000d 2603          	jrne	L222
2193  000f               L422:
2194  000f 4f            	clr	a
2195  0010 2010          	jra	L622
2196  0012               L222:
2197  0012 ae0296        	ldw	x,#662
2198  0015 89            	pushw	x
2199  0016 ae0000        	ldw	x,#0
2200  0019 89            	pushw	x
2201  001a ae0010        	ldw	x,#L73
2202  001d cd0000        	call	_assert_failed
2204  0020 5b04          	addw	sp,#4
2205  0022               L622:
2206                     ; 663   assert_param(IS_FLASH_PROGRAM_MODE_OK(FLASH_ProgMode));
2208  0022 0d0c          	tnz	(OFST+6,sp)
2209  0024 2706          	jreq	L232
2210  0026 7b0c          	ld	a,(OFST+6,sp)
2211  0028 a110          	cp	a,#16
2212  002a 2603          	jrne	L032
2213  002c               L232:
2214  002c 4f            	clr	a
2215  002d 2010          	jra	L432
2216  002f               L032:
2217  002f ae0297        	ldw	x,#663
2218  0032 89            	pushw	x
2219  0033 ae0000        	ldw	x,#0
2220  0036 89            	pushw	x
2221  0037 ae0010        	ldw	x,#L73
2222  003a cd0000        	call	_assert_failed
2224  003d 5b04          	addw	sp,#4
2225  003f               L432:
2226                     ; 664   if(FLASH_MemType == FLASH_MEMTYPE_PROG)
2228  003f 7b0b          	ld	a,(OFST+5,sp)
2229  0041 a1fd          	cp	a,#253
2230  0043 2626          	jrne	L337
2231                     ; 666     assert_param(IS_FLASH_PROG_BLOCK_NUMBER_OK(BlockNum));
2233  0045 1e07          	ldw	x,(OFST+1,sp)
2234  0047 a30100        	cpw	x,#256
2235  004a 2403          	jruge	L632
2236  004c 4f            	clr	a
2237  004d 2010          	jra	L042
2238  004f               L632:
2239  004f ae029a        	ldw	x,#666
2240  0052 89            	pushw	x
2241  0053 ae0000        	ldw	x,#0
2242  0056 89            	pushw	x
2243  0057 ae0010        	ldw	x,#L73
2244  005a cd0000        	call	_assert_failed
2246  005d 5b04          	addw	sp,#4
2247  005f               L042:
2248                     ; 667     startaddress = FLASH_PROG_START_PHYSICAL_ADDRESS;
2250  005f ae8000        	ldw	x,#32768
2251  0062 1f03          	ldw	(OFST-3,sp),x
2252  0064 ae0000        	ldw	x,#0
2253  0067 1f01          	ldw	(OFST-5,sp),x
2255  0069 2024          	jra	L537
2256  006b               L337:
2257                     ; 671     assert_param(IS_FLASH_DATA_BLOCK_NUMBER_OK(BlockNum));
2259  006b 1e07          	ldw	x,(OFST+1,sp)
2260  006d a30008        	cpw	x,#8
2261  0070 2403          	jruge	L242
2262  0072 4f            	clr	a
2263  0073 2010          	jra	L442
2264  0075               L242:
2265  0075 ae029f        	ldw	x,#671
2266  0078 89            	pushw	x
2267  0079 ae0000        	ldw	x,#0
2268  007c 89            	pushw	x
2269  007d ae0010        	ldw	x,#L73
2270  0080 cd0000        	call	_assert_failed
2272  0083 5b04          	addw	sp,#4
2273  0085               L442:
2274                     ; 672     startaddress = FLASH_DATA_START_PHYSICAL_ADDRESS;
2276  0085 ae4000        	ldw	x,#16384
2277  0088 1f03          	ldw	(OFST-3,sp),x
2278  008a ae0000        	ldw	x,#0
2279  008d 1f01          	ldw	(OFST-5,sp),x
2280  008f               L537:
2281                     ; 676   startaddress = startaddress + ((uint32_t)BlockNum * FLASH_BLOCK_SIZE);
2283  008f 1e07          	ldw	x,(OFST+1,sp)
2284  0091 a680          	ld	a,#128
2285  0093 cd0000        	call	c_cmulx
2287  0096 96            	ldw	x,sp
2288  0097 1c0001        	addw	x,#OFST-5
2289  009a cd0000        	call	c_lgadd
2291                     ; 679   if(FLASH_ProgMode == FLASH_PROGRAMMODE_STANDARD)
2293  009d 0d0c          	tnz	(OFST+6,sp)
2294  009f 260a          	jrne	L737
2295                     ; 682     FLASH->CR2 |= FLASH_CR2_PRG;
2297  00a1 7210505b      	bset	20571,#0
2298                     ; 683     FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NPRG);
2300  00a5 7211505c      	bres	20572,#0
2302  00a9 2008          	jra	L147
2303  00ab               L737:
2304                     ; 688     FLASH->CR2 |= FLASH_CR2_FPRG;
2306  00ab 7218505b      	bset	20571,#4
2307                     ; 689     FLASH->NCR2 &= (uint8_t)(~FLASH_NCR2_NFPRG);
2309  00af 7219505c      	bres	20572,#4
2310  00b3               L147:
2311                     ; 693   for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
2313  00b3 5f            	clrw	x
2314  00b4 1f05          	ldw	(OFST-1,sp),x
2315  00b6               L347:
2316                     ; 695     *((PointerAttr uint8_t*) (MemoryAddressCast)startaddress + Count) = ((uint8_t)(Buffer[Count]));
2318  00b6 1e0d          	ldw	x,(OFST+7,sp)
2319  00b8 72fb05        	addw	x,(OFST-1,sp)
2320  00bb f6            	ld	a,(x)
2321  00bc 1e03          	ldw	x,(OFST-3,sp)
2322  00be 72fb05        	addw	x,(OFST-1,sp)
2323  00c1 f7            	ld	(x),a
2324                     ; 693   for(Count = 0; Count < FLASH_BLOCK_SIZE; Count++)
2326  00c2 1e05          	ldw	x,(OFST-1,sp)
2327  00c4 1c0001        	addw	x,#1
2328  00c7 1f05          	ldw	(OFST-1,sp),x
2331  00c9 1e05          	ldw	x,(OFST-1,sp)
2332  00cb a30080        	cpw	x,#128
2333  00ce 25e6          	jrult	L347
2334                     ; 697 }
2337  00d0 5b08          	addw	sp,#8
2338  00d2 81            	ret
2351                     	xdef	_FLASH_WaitForLastOperation
2352                     	xdef	_FLASH_ProgramBlock
2353                     	xdef	_FLASH_EraseBlock
2354                     	xdef	_FLASH_GetFlagStatus
2355                     	xdef	_FLASH_GetBootSize
2356                     	xdef	_FLASH_GetProgrammingTime
2357                     	xdef	_FLASH_GetLowPowerMode
2358                     	xdef	_FLASH_SetProgrammingTime
2359                     	xdef	_FLASH_SetLowPowerMode
2360                     	xdef	_FLASH_EraseOptionByte
2361                     	xdef	_FLASH_ProgramOptionByte
2362                     	xdef	_FLASH_ReadOptionByte
2363                     	xdef	_FLASH_ProgramWord
2364                     	xdef	_FLASH_ReadByte
2365                     	xdef	_FLASH_ProgramByte
2366                     	xdef	_FLASH_EraseByte
2367                     	xdef	_FLASH_ITConfig
2368                     	xdef	_FLASH_DeInit
2369                     	xdef	_FLASH_Lock
2370                     	xdef	_FLASH_Unlock
2371                     	xref	_assert_failed
2372                     	switch	.const
2373  0010               L73:
2374  0010 73746d38735f  	dc.b	"stm8s_stdperiph_li"
2375  0022 625c6c696272  	dc.b	"b\libraries\stm8s_"
2376  0034 737464706572  	dc.b	"stdperiph_driver\s"
2377  0046 72635c73746d  	dc.b	"rc\stm8s_flash.c",0
2378                     	xref.b	c_lreg
2379                     	xref.b	c_x
2380                     	xref.b	c_y
2400                     	xref	c_ladd
2401                     	xref	c_cmulx
2402                     	xref	c_lgadd
2403                     	xref	c_rtol
2404                     	xref	c_umul
2405                     	xref	c_lcmp
2406                     	xref	c_ltor
2407                     	end
