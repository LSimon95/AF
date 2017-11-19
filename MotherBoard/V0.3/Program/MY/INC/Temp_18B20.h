#ifndef Temp_18B20_H
#define Temp_18B20_H

#include "main.h"

#define INPUT  0
#define OUTPUT 1

#define Temp_18B20_IO_GPIO GPIOC
#define Temp_18B20_IO_PIN  GPIO_Pin_8

#define Temp_18B20_IO(Status) if(Status == 0)GPIO_ResetBits(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN);\
																 else if(Status == 1)GPIO_SetBits(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN)
																	
void Temp_18B20_Low_Init(void);		
uint16_t Temp_18B20_Get_Temperture(void);																 
													

#endif
