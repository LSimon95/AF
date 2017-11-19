/*
**File_Name:      XB_EEPROM_24C0x.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#ifndef RS24C02_H
#define RS24C02_H

#include "main.h"

#define EEPROM_24C0x_SDA_GPIO GPIOB
#define EEPROM_24C0x_SDA_PIN  GPIO_Pin_13

#define INPUT  0
#define OUTPUT 1

#define EEPROM_ADDRESS 0xA0

#define EEPROM_24C0x_SCL(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_12);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_12)
#define EEPROM_24C0x_SDA(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_13);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_13)

uint8_t EEPROM_24C0x_Write(uint8_t Address, uint8_t Byte);
uint8_t EEPROM_24C0x_Read(uint8_t Address);
void EEPROM_24C0x_Low_Init(void);

#endif
