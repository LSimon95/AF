#include "CO2.h"

#define CO2_USART USART1

uint16_t CO2GetDataTimeOut;
uint8_t CO2FilterCnt;
uint8_t CO2StatusCnt = 0;
uint8_t CO2HighCnt;

uint16_t CO2ppm;

void CO2_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;     
	NVIC_InitTypeDef NVIC_InitStructure;
	EXTI_InitTypeDef EXTI_InitStructure;
	
	//GPIO_Init//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	NVIC_InitStructure.NVIC_IRQChannel = EXTI0_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	
	NVIC_Init(&NVIC_InitStructure);
	
	EXTI_ClearITPendingBit(EXTI_Line0);
	GPIO_EXTILineConfig(GPIO_PortSourceGPIOA, GPIO_PinSource0);
	EXTI_InitStructure.EXTI_Line = EXTI_Line0;
	EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
	EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising_Falling;
	EXTI_InitStructure.EXTI_LineCmd = ENABLE;
	
	EXTI_Init(&EXTI_InitStructure);
}

void CO2_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(CO2_USART, USART_FLAG_TXE) == RESET)
	{
	}
	USART_SendData(CO2_USART, Char);
}

void EXTI0_IRQHandler(void)
{
	if(CO2FilterCnt >= 10)
	{
		if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0))
		{
			if(CO2StatusCnt == 0)
			{
				CO2HighCnt = 0;
				CO2StatusCnt = 1;
			}
			else
			{
				CO2StatusCnt = 0;
				CO2ppm = ((uint32_t)CO2HighCnt - 2) * 2;
			}
		}
	}
	CO2FilterCnt = 0;
	EXTI_ClearITPendingBit(EXTI_Line0);
}
