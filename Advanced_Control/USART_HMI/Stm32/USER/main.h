#ifndef MAIN_H
#define MAIN_H

#include "stm32f10x.h"

#include "XB_Delay.h"

#include "XB_WIFI.h"

#include "CO2.h"

/* Debug USART */
void Debug_USART_Init(void);
void Debug_USART_Send_Char(uint8_t Char);
void Debug_USART_Send_Str(char *Str);
void Debug_USART_Printf(char *fmt, ...);
typedef struct
{
	uint16_t Temperture;
	uint32_t Runing_Time_s;
	uint8_t  Fire_Type;
	uint8_t  WIFI_Type;
	uint8_t  HMI_Page;
	uint8_t Volum;
	uint8_t Language;
}Sys_Status_StructureTypedef;
typedef enum
{
	SYSTEM_STANDBYE = 0,
	SYSTEM_UNSAFE,
	SYSTEM_ON_FIRE,
	SYSTEM_PUMP_ALCOHOL
}System_Status_enum;

void Display_Update(void);

#endif
