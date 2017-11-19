#ifndef MMA7660_H
#define MMA7660_H

#include "main.h"

/* Function Declaration */
void MMA7660_Init(void);
#define INPUT  0
#define OUTPUT 1
void MMA7660_SDA_Type(uint8_t Type);
														
void MMA7660_Write_Byte(uint8_t Byte);
void MMA7660_Write_Reg(uint8_t Reg, uint8_t Byte);

/* Pin Define */
#define MMA7660_SCL(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_2);\
														else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_2)
															
#define MMA7660_SDA(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_1);\
														else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_1);\
														else if(Status == 2)GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_1)
															
/* Delay 10us */
void Delay_10us(void);

#endif
