#include "CO2.h"

#define CO2_USART USART1

uint16_t CO2GetDataTimeOut;

void CO2_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	TIM_TimeBaseInitTypeDef TIM_TimeBaseInitStructure;
	TIM_ICInitTypeDef TIM_ICInitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);        
	
	//GPIO_Init//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	//Tim Base//
	TIM_TimeBaseInitStructure.TIM_ClockDivision = 0;
	TIM_TimeBaseInitStructure.TIM_Prescaler = 1098;
	TIM_TimeBaseInitStructure.TIM_CounterMode = TIM_CounterMode_Up;
	TIM_TimeBaseInitStructure.TIM_Period = 65535;
	TIM_TimeBaseInitStructure.TIM_RepetitionCounter = 0;
	
	TIM_TimeBaseInit(TIM5, &TIM_TimeBaseInitStructure);
	
	//IC Init//
	TIM_ICInitStructure.TIM_Channel = TIM_Channel_1;
	TIM_ICInitStructure.TIM_ICFilter = 0x03;
	TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Rising;
	TIM_ICInitStructure.TIM_ICPrescaler = 0;
	TIM_ICInitStructure.TIM_ICSelection = TIM_ICSelection_DirectTI;
	
	TIM_ICInit(TIM5, &TIM_ICInitStructure);
}

void CO2_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(CO2_USART, USART_FLAG_TXE) == RESET)
	{
	}
	USART_SendData(CO2_USART, Char);
}

uint16_t Get_CO2_ppm(void)
{
	uint16_t CO2_ppm = 0;
	return CO2_ppm;
}
