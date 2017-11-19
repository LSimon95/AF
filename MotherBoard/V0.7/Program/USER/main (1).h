#ifndef MAIN_H
#define MAIN_H

#include "stm32f10x.h"
#define ARM_MATH_CM3
#include "arm_math.h"

#include "XB_Delay.h"
#include "Safe_Check.h"
//#include "XB_MMA7660.h"
#include "XB_MMA845x.h"
#include "XB_ADC.h"
#include "XB_18B20.h"
#include "XB_WIFI.h"
#include "XB_EEPROM_24C0x.h"
#include "Voice.h"

#define NULL 0

/*
IRQ_Pri
TIM7(Safe)    -Pre 0x02 -Sub 0x00
TIM6(MMA)     -Pre 0x01 -Sub 0x00
DAC_DMA       -Pre 0x00 -Sub 0x00
USART3        -Pre 0x03 -Sub 0x00
TIM4(WIFI)    -Pre 0x04 -Sub 0x00
*/

#define TIM7_PRI_PRE 0x02
#define TIM7_PRI_SUB 0x00

#define TIM6_PRI_PRE 0x01
#define TIM6_PRI_SUB 0x00

#define DAC_DMA_PRI_PRE 0x00
#define DAC_DMA_PRI_SUB 0x00

#define USART3_PRI_PRE 0x03
#define USART3_PRI_SUB 0x00

#define TIM4_PRI_PRE 0x04
#define TIM4_PRI_SUB 0x00

void Critical_Problem_Handler(void);

typedef enum
{
	SYSTEM_STANDBYE = 0,
	SYSTEM_UNSAFE,
	SYSTEM_ON_FIRE,
	SYSTEM_PUMP_ALCOHOL,
	SYSTEM_HOT_WAIT3MIN
}System_Status_enum;

typedef struct
{
	uint8_t Trough_Len; //0 - 60cm 1 - 
	uint8_t Temperture_Fire; //0 - On 1 - on
	uint8_t Temperture_Trough; //0 - off 1 - on
	uint8_t WIFI; //0 - off 1 - on
	uint8_t Volume; //0 - mute
	uint8_t Language; //0 - CHN 1 - ENG 2 - CAN
	uint8_t Alcohol_Concentration;//0 - OFF 1 - ON 	
	uint8_t LeakageDetect; //0 - OFF 1 - ON
}System_Setting_Typedef;

typedef struct
{
	System_Status_enum System_Status;
	Safe_Check_Result_Typedef Safe_Check_Result;
	System_Setting_Typedef System_Setting;
}System_Status_Typedef;

/* Function declaration */
void ArtFire_Init(void);
#define STOP         0x01
#define START_FIRE   0x02
#define PUMP_ALCOHOL 0x03

void Get_System_Setting(void);
uint8_t Get_Remote_Action(void);

uint8_t Pump_Alcohol(void);
uint8_t Start_Fire(void);

/* Debug USART */
void Debug_USART_Init(void);
void Debug_USART_Send_Char(uint8_t Char);
void Debug_USART_Printf(char *fmt, ...);

/* Pin Define */
#define Fire_Heater(Status) if(Status == 1)GPIO_ResetBits(GPIOC, GPIO_Pin_2);else if(Status == 0)GPIO_SetBits(GPIOC, GPIO_Pin_2)

#define Pump1(Status) if(Status == 1)GPIO_ResetBits(GPIOA, GPIO_Pin_1);else if(Status == 0)GPIO_SetBits(GPIOA, GPIO_Pin_1)
#define Pump2(Status) if(Status == 1)GPIO_ResetBits(GPIOA, GPIO_Pin_2);else if(Status == 0)GPIO_SetBits(GPIOA, GPIO_Pin_2)

#define Fan(Status)   if(Status == 1)GPIO_ResetBits(GPIOB, GPIO_Pin_2);else if(Status == 0)GPIO_SetBits(GPIOB, GPIO_Pin_2)

#define FHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0)
#define FLD GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3)

#define AHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_3)
#define ALD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_15)

#define Bee(Status) if(Status == 0)GPIO_ResetBits(GPIOC, GPIO_Pin_7);else if(Status == 1)GPIO_SetBits(GPIOC, GPIO_Pin_7)


#define LED_Red(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_6);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_6)
#define LED_Yellow(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_7);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_7)
#define LED_Green(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_8);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_8)

#define IO4 GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_9)

#define LDLD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_6)
#define LDHD GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_7)

#define STANDBYE()     LED_Red(0);LED_Green(1);LED_Yellow(0)
#define WORKING()      LED_Red(0);LED_Green(0);LED_Yellow(1)
#define WARNNING()     LED_Red(1);LED_Green(0);LED_Yellow(0)
#define STOP_WORKING() STANDBYE();Pump1(0);Pump2(0);Fire_Heater(0)

#define FIRE_DETECTED_THRESHOLD 600
#define TROUGH_SAFE_TEMPERTURE 80


#endif
