#include "Safe_Check.h"

extern uint16_t After_filter[M];

void Fire_Detect_Init(void)
{
	ADC1_Init();				//ADC1 Fire_Detect
}

void Safe_Check_Init(void)
{
	Fire_Detect_Init();
}

void Safe_Check(void)
{
	/* ADC(Fire_Dectect */
	Filter();
	Debug_USART_Send_Char(After_filter[0] >> 8);
	Debug_USART_Send_Char(After_filter[0]); 
	
}
