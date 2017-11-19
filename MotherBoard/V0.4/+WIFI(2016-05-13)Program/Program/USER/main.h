#ifndef MAIN_H
#define MAIN_H

#include "stm32f10x.h"

#include "delay.h"
#include "Safe_Check.h"
#include "XB_MMA7660.h"
#include "XB_ADC.h"
#include "XB_18B20.h"

#include "XB_WIFI.h"
#include "WIFI.h"

#define NULL 0
void Critical_Problem_Handler(void);

typedef enum
{
	SYSTEM_STANDBYE = 0,
	SYSTEM_UNSAFE,
	SYSTEM_ON_FIRE,
	SYSTEM_PUMP_ALCOHOL
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
void Set_Play(uint8_t Num);

void YF017_Init(void);
void Set_Play(uint8_t Num);

/* Debug USART */
void Debug_USART_Init(void);
void Debug_USART_Send_Char(uint8_t Char);
void Debug_USART_Send_Str(char *Str);

/* Pin Define */
#define Fire_Heater(Status) if(Status == 1)GPIO_ResetBits(GPIOA, GPIO_Pin_8);else if(Status == 0)GPIO_SetBits(GPIOA, GPIO_Pin_8)

#define Pump1(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_15);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_15)
#define Pump2(Status) if(Status == 1)GPIO_ResetBits(GPIOC, GPIO_Pin_6);else if(Status == 0)GPIO_SetBits(GPIOC, GPIO_Pin_6)

#define Fan(Status)   if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_14);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_14)

#define FHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_11)
#define FLD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_12)

#define AHD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_11)
#define ALD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_12)

#define Bee(Status) if(Status == 0)GPIO_ResetBits(GPIOD, GPIO_Pin_2);else if(Status == 1)GPIO_SetBits(GPIOD, GPIO_Pin_2)


#define LED_Red(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_3);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_3)
#define LED_Green(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_4);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_4)
#define LED_Yellow(Status) if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_5);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_5)

#define YF_Busy GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_13)
#define YF_Data(Status) if(Status == 0)GPIO_ResetBits(GPIOC, GPIO_Pin_14);else if(Status == 1)GPIO_SetBits(GPIOC, GPIO_Pin_14)
#define YF_Reset(Status) if(Status == 0)GPIO_ResetBits(GPIOC, GPIO_Pin_15);else if(Status == 1)GPIO_SetBits(GPIOC, GPIO_Pin_15)

#define IO4 GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_6)

#define LDLD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_10)
#define LDHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_15)

#define STANDBYE()     LED_Red(0);LED_Green(1);LED_Yellow(0)
#define WORKING()      LED_Red(0);LED_Green(0);LED_Yellow(1)
#define WARNNING()     LED_Red(1);LED_Green(0);LED_Yellow(0)
#define STOP_WORKING() STANDBYE();Pump1(0);Pump2(0);Fire_Heater(0)


#endif
