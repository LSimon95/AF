#include"delay.h"

unsigned long TimingDelay;

uint8_t WWDG_Ctr;

void SysTick_Configuration(void)
{
	SYSTICK_CURRENT = 0;
	SYSTICK_RELOAD = 72000;
	SYSTICK_CSR |= 0x07;
}

void Delay_ms(unsigned long nTime)
{
	TimingDelay = nTime;
	while(TimingDelay != 0);
}

void SysTick_Handler(void)
{
	SYSTICK_CURRENT = 0;
	if(TimingDelay != 0x00)
		TimingDelay--;
	WWDG_Ctr++;			//Clear WWDG
	if(WWDG_Ctr >= 51)
	{
		WWDG_SetCounter(0x7f);
		WWDG_Ctr = 0;
	}
}
