#ifndef MAIN_H
#define MAIN_H

#include "stm32f10x.h"
#include "delay.h"

#include "Safe_Check.h"

#include "EEPROM_24C0x.h"
#include "DS1302.h"
#include "Temp_18b20.h"
#include "MMA7660.h"

#define NULL 0
void Critical_Problem_Handler(void);

typedef enum
{
	SYSTEM_STANDBYE     = 0,
	SYSTEM_UNSAFE       = 1,
	SYSTEM_ON_FIRE      = 2,
	SYSTEM_PUMP_ALCOHOL = 3
}System_Status_enum;
typedef struct
{
	System_Status_enum System_Status;
	Safe_Check_Result_Typedef Safe_Check_Result;
}System_Status_Typedef;

/* Function declaration */
void ArtFire_Init(void);
#define STOP         0x01
#define START_FIRE   0x02
#define PUMP_ALCOHOL 0x03
uint8_t Get_Remote_Action(void);

uint8_t Pump_Alcohol(void);
uint8_t Start_Fire(void);
/* Debug USART */
void Debug_USART_Init(void);
void Debug_USART_Send_Char(uint8_t Char);
void Debug_USART_Send_Str(char *Str);

/* Pin Define */
#define Fire_Heater(Status) if(Status == 1)GPIO_ResetBits(GPIOC, GPIO_Pin_7);else if(Status == 0)GPIO_SetBits(GPIOC, GPIO_Pin_7)
#define Pump1(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_9);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_9)
#define Pump2(Status) if(Status == 1)GPIO_ResetBits(GPIOC, GPIO_Pin_6);else if(Status == 0)GPIO_SetBits(GPIOC, GPIO_Pin_6)
#define Fan(Status)   if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_15);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_15)

#define FHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_11)
#define FLD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_12)

#define AHD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_11)
#define ALD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_12)

#define LED1(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_3);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_3)
#define LED2(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_4);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_4)
#define LED3(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_5);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_5)

#define STANDBYE()     LED1(1);LED2(0);LED3(0)
#define WORKING()      LED1(0);LED2(1);LED3(0)
#define WARNNING()     LED1(0);LED2(0);LED3(1)
#define STOP_WORKING() STANDBYE();Pump1(0);Pump2(0);Fire_Heater(0)


#endif
