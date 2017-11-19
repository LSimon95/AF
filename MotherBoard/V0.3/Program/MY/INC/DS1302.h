#ifndef DS1302_H
#define DS1302_H

#include "main.h"

#define DS1302_IO_GPIO GPIOA
#define DS1302_IO_PIN  GPIO_Pin_6

#define INPUT  0
#define OUTPUT 1

#define DS1302_SCL(Status) if(Status == 0)GPIO_ResetBits(GPIOA, GPIO_Pin_5);else if(Status == 1)GPIO_SetBits(GPIOA, GPIO_Pin_5)
#define DS1302_IO(Status)  if(Status == 0)GPIO_ResetBits(GPIOA, GPIO_Pin_6);else if(Status == 1)GPIO_SetBits(GPIOA, GPIO_Pin_6)
#define DS1302_RST(Status) if(Status == 0)GPIO_ResetBits(GPIOA, GPIO_Pin_7);else if(Status == 1)GPIO_SetBits(GPIOA, GPIO_Pin_7)

void DS1302_Init(void);
void DS1302_Update_Time(void);


#endif 
