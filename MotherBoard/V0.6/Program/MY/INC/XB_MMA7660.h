/*
**File_Name:      XB_MMA7660.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#ifndef _MMA7660_H
#define _MMA7660_H

#include "main.h"

/* Function Declaration */
void MMA7660_Init(void);

#define MMA7660_SCL_GPIO GPIOB
#define MMA7660_SCL_PIN  GPIO_Pin_2

#define MMA7660_SDA_GPIO GPIOB
#define MMA7660_SDA_PIN  GPIO_Pin_1

#define INPUT  0
#define OUTPUT 1
void MMA7660_SDA_Type(uint8_t Type);
														
uint8_t MMA7660_Write_Reg(uint8_t Reg, uint8_t Byte);
uint8_t MMA7660_Read_Reg(uint8_t Reg, uint8_t *Buf);

/* Pin Define */
#define MMA7660_SCL(Status) if(Status == 0)GPIO_ResetBits(MMA7660_SCL_GPIO, MMA7660_SCL_PIN);\
														else if(Status == 1)GPIO_SetBits(MMA7660_SCL_GPIO, MMA7660_SCL_PIN)
															
#define MMA7660_SDA(Status) if(Status == 0)GPIO_ResetBits(MMA7660_SDA_GPIO, MMA7660_SDA_PIN);\
														else if(Status == 1)GPIO_SetBits(MMA7660_SDA_GPIO, MMA7660_SDA_PIN);
															
/* Delay 10us */
void Delay_10us(void);

#endif
