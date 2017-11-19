#ifndef HEAD_H
#define HEAD_H
#include "stm8s.h"

#define NULL 0

#include "TIM4_Sys_Tick.h"
#include "Remote_Control.h"
#include "Safe_Check.h"
#include "DS18B20.h"

void Serious_Problem_Handler(void);

/* Function Declaration */
ErrorStatus Sys_Clk_Init(void);
void Init(void);
void UART_Init(void);
void UART_Send_Char(uint8_t C);

#define Fire_Up(status) if(status == 1) GPIO_WriteHigh(GPIOA, GPIO_PIN_4); else if(status == 0) GPIO_WriteLow(GPIOA, GPIO_PIN_4); else if(status == 2) GPIO_WriteReverse(GPIOA, GPIO_PIN_4);

/* LED */
#define LED1(status) if(status == 1) GPIO_WriteHigh(GPIOB, GPIO_PIN_6); else if(status == 0) GPIO_WriteLow(GPIOB, GPIO_PIN_6); else if(status == 2) GPIO_WriteReverse(GPIOB, GPIO_PIN_6);
#define LED2(status) if(status == 1) GPIO_WriteHigh(GPIOB, GPIO_PIN_7); else if(status == 0) GPIO_WriteLow(GPIOB, GPIO_PIN_7); else if(status == 2) GPIO_WriteReverse(GPIOB, GPIO_PIN_7);
#define LED3(status) if(status == 1) GPIO_WriteHigh(GPIOA, GPIO_PIN_6); else if(status == 0) GPIO_WriteLow(GPIOA, GPIO_PIN_6); else if(status == 2) GPIO_WriteReverse(GPIOA, GPIO_PIN_6);

/* Bee */
#define Bee(status) if(status == 1) GPIO_WriteHigh(GPIOC, GPIO_PIN_3); else if(status == 0) GPIO_WriteLow(GPIOC, GPIO_PIN_3); else if(status == 2) GPIO_WriteReverse(GPIOC, GPIO_PIN_3);

/* Pump */
#define Pump1(status) if(status == 1) GPIO_WriteHigh(GPIOC, GPIO_PIN_1); else if(status == 0) GPIO_WriteLow(GPIOC, GPIO_PIN_1);
#define Pump2(status) if(status == 1) GPIO_WriteHigh(GPIOC, GPIO_PIN_2); else if(status == 0) GPIO_WriteLow(GPIOC, GPIO_PIN_2);

/* Alcohol Heater */
#define AHeater(status) if(status == 1) GPIO_WriteHigh(GPIOA, GPIO_PIN_4); else if(status == 0) GPIO_WriteLow(GPIOA, GPIO_PIN_4);

#define WORKING()                    LED1(0);LED2(1);LED3(1)
#define STANDBYE()                   LED1(1);LED2(0);LED3(1)
#define WARNNING()                   LED1(1);LED2(1);LED3(0)
#define LOW_ALCOHOL()                LED1(0);LED2(1);LED3(0)
#define STOP_WORKING()               Pump1(1);Pump2(1);AHeater(1)
#define FIRE_DETECT_2ndLevel_ERROR() LED1(0);LED2(0);LED3(1)

/* Fire Detect */
#define FireDH GPIO_ReadInputPin(GPIOB, GPIO_PIN_3)
#define FireDL GPIO_ReadInputPin(GPIOB, GPIO_PIN_4)

/* Alcohol Detect */
#define ALDHL GPIO_ReadInputPin(GPIOB, GPIO_PIN_0)
#define ALDHH GPIO_ReadInputPin(GPIOB, GPIO_PIN_1)

/* Alcohol Leakage Detect */
#define ALD GPIO_ReadInputPin(GPIOB, GPIO_PIN_5)

/* System Work Statues */
typedef enum
{
	STATUS_WAIT_FOR_COMMAND = 0,
	STATUS_UNSAFE           = 1,
	STATUS_START_FIRE       = 2,
	STATUS_PUMP_IN_ALCOHOL  = 3
}System_Status_Enum_Typedef;

typedef struct
{
	System_Status_Enum_Typedef System_Status;
}System_Status_Typedef;

/* Working */
uint8_t Pump_In_Alcohol(void);
uint8_t Start_Fire(void);
#endif