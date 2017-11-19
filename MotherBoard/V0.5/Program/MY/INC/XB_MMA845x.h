/*
**File_Name:      XB_MMA845x.h
**Version:        1.0
**Date_Modified:  2016-07-17
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#ifndef XB_MMA845x_H
#define XB_MMA845x_H

#include "stm32f10x.h"

/* Function Declaration */
void MMA845x_Init(void);

#define MMA845x_SCL_GPIO GPIOB
#define MMA845x_SCL_PIN  GPIO_Pin_1

#define MMA845x_SDA_GPIO GPIOB
#define MMA845x_SDA_PIN  GPIO_Pin_0

#define INPUT  0
#define OUTPUT 1

void MMA845x_SDA_Type(uint8_t Type);
														
uint8_t MMA845x_Write_Reg(uint8_t Reg, uint8_t Byte);
uint8_t MMA845x_Read_ACC_Buf(uint8_t Reg, uint8_t *Buf);

/* Pin Define */
#define MMA845x_SCL(Status) if(Status == 0)GPIO_ResetBits(MMA845x_SCL_GPIO, MMA845x_SCL_PIN);\
														else if(Status == 1)GPIO_SetBits(MMA845x_SCL_GPIO, MMA845x_SCL_PIN)
															
#define MMA845x_SDA(Status) if(Status == 0)GPIO_ResetBits(MMA845x_SDA_GPIO, MMA845x_SDA_PIN);\
														else if(Status == 1)GPIO_SetBits(MMA845x_SDA_GPIO, MMA845x_SDA_PIN);
															
/* Delay 10us */
void Delay_10us(void);

#endif
