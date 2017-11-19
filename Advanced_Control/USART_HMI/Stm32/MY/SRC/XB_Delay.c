/*
**File_Name:      XB_Delay.c
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Attention:
*/
#include "XB_Delay.h"
#include "main.h"

uint32_t TimingDelay;
uint16_t Runing_Time_ms;
uint16_t WIFI_Remote_Time_Out;

extern Sys_Status_StructureTypedef Sys_Status;
extern uint16_t ConnectionLostCnt;
extern uint16_t StatusRefreshCnt;
extern uint16_t CO2GetDataTimeOut;
extern uint16_t GetCO2Cnt;

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
	if(TimingDelay != 0x00)
		TimingDelay--;
	Runing_Time_ms++;
	if(Runing_Time_ms >= 1000)
	{
		Runing_Time_ms = 0;
		Sys_Status.Runing_Time_s++;
	}
	if(WIFI_Remote_Time_Out < 1000)
		WIFI_Remote_Time_Out++;
	
	ConnectionLostCnt++;
	if(StatusRefreshCnt < 500)
		StatusRefreshCnt++;
	
	if(CO2GetDataTimeOut < 10)
		CO2GetDataTimeOut++;
	
	if(GetCO2Cnt < 500)
		GetCO2Cnt++;
}

