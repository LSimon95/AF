#include "TIM4_Sys_Tick.h"

uint16_t Tick_Counter = 0;
uint8_t WWDG_Counter = 0;

void TIM4_Tick_Init(void)
{
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER4 , ENABLE);
	
	TIM4_TimeBaseInit(TIM4_PRESCALER_128, 125);
	TIM4_ITConfig(TIM4_IT_UPDATE, ENABLE);
	TIM4_Cmd(ENABLE);
	rim();
}

void Delay_ms(uint16_t t)
{
	Tick_Counter = 0;
	while(t > Tick_Counter);
}

@far @interrupt void TIM4_Tick_IRQHandler(void)
{
	Tick_Counter++;
	WWDG_Counter++;
	if(WWDG_Counter == 35 )
	{
		WWDG_SetCounter(0x7F);
		WWDG_Counter = 0;
	}
	TIM4_ClearITPendingBit(TIM4_IT_UPDATE);
}