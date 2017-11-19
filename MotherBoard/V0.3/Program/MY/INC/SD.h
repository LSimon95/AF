#ifndef _SD_H
#define _SD_H

#include"stm32f10x.h"
#include"delay.h"

uint8_t SD_Init(void);
uint64_t SD_GetCapacity(void);
uint8_t SD_Send_Command_Continue(uint8_t cmd, uint32_t arg, uint8_t crc);
uint8_t SPI2_WriteRead_Byte(uint8_t Send_Byte);
uint8_t SD_Send_Command(uint8_t cmd, uint32_t arg, uint8_t crc);
uint8_t SD_WriteSingleBlock(uint32_t Add, uint8_t *Buffer);
uint8_t SD_ReadSingleBlock(uint32_t Add, uint8_t *Buffer);


#define SPI2_NSS(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_12);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_12)
				
#define CMD0 00
#define CMD55 55
#define CMD58 58
#define ACMD41 41
#define CMD9 9
#define CMD17 17
#define CMD24 24

#endif
