#ifndef DS18B20_H
#define DS18B20_H

#include "main.h"

#define NOP() _asm("nop");

#define DS18B20_RESET_FAILED 1
uint8_t DS18B20_Reset(void);

uint16_t DS18B20_Get_Temperture(void);

#endif