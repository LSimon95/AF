/*
**File_Name:      XB_18B20.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Attention:
*/
#ifndef Temp_18B20_H
#define Temp_18B20_H

#include "main.h"

#define INPUT  0
#define OUTPUT 1

#define Temp_18B20_IO_GPIO GPIOC
#define Temp_18B20_IO_PIN  GPIO_Pin_8
																	
void XB_18B20_Init(void);
void XB_18B20_Start_Convert(void);
int16_t XB_18B20_Get_Temperture(void);

#define Temp_18B20_IO(Status) if(Status == 0)GPIO_ResetBits(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN);\
																 else if(Status == 1)GPIO_SetBits(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN)
#endif
