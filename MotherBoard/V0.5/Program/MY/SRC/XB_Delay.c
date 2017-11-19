/*
**File_Name:      XB_Delay.c
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#include "XB_Delay.h"
#include "main.h"

unsigned long TimingDelay;
uint8_t WWDG_Ctr;

extern uint16_t Fire_Time_Ctr;
extern uint32_t Wait_For_Cool;
extern uint16_t WIFI_Send_Ctr;

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
	Fire_Time_Ctr++;
	if(TimingDelay != 0x00)
		TimingDelay--;
	WWDG_Ctr++;			//Clear WWDG
	WIFI_Send_Ctr++;
	if(WWDG_Ctr >= 51)
	{
		WWDG_SetCounter(0x7f);
		WWDG_Ctr = 0;
	}
}

