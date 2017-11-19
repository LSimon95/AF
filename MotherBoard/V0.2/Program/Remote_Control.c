#include "Remote_Control.h"

uint16_t TIM2_Cap_End_Val = 0;
uint8_t TIM2_Cap_Flag = 0, Signal_Cap_Start_Flag = 0; //0 = First Capture ; 0 = Not Start
uint8_t Signal_Cap_Counter = 0, Signal_Tem_Buffer[22], Remote_Pack[11];

void Remote_Control_Init(void)
{
	uint8_t i;
	for(i = 0; i < 22; i++)
	{
		Signal_Tem_Buffer[i] = 0x00;
	}
	for(i = 0; i < 11; i++)
	{
		Remote_Pack[i] = 0x00;
	}
	TIM2_Capture_Init();
}

void Remote_Control_Cmd(FunctionalState Status)
{
	if(Status == ENABLE)
		TIM2_Cmd(ENABLE);
	else if(Status == DISABLE)
		TIM2_Cmd(DISABLE);
}

void TIM2_Capture_Init(void)
{
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER2, ENABLE);
	TIM2_TimeBaseInit(TIM2_PRESCALER_32, 0xffff);
	TIM2_ARRPreloadConfig(DISABLE);
	TIM2_ICInit(TIM2_CHANNEL_3,
							TIM2_ICPOLARITY_FALLING,	
							TIM2_ICSELECTION_DIRECTTI, 
							TIM2_ICPSC_DIV1,
							5);
	//TIM2_ITConfig(TIM2_IT_UPDATE, ENABLE);
	TIM2_ITConfig(TIM2_IT_CC3, ENABLE);
}

Remote_Command_Typedf Remote_Control_Get_Command(void)
{
	uint8_t i;
	Remote_Command_Typedf Command;
	
	if(Signal_Cap_Counter > 22)
	{
		for(i = 0; i < 11; i ++)
		{
			switch(Signal_Tem_Buffer[i * 2] + Signal_Tem_Buffer[(i * 2) + 1])
			{
				case 2:
					Remote_Pack[i] = 0;
					break;
				case 3:
					Remote_Pack[i] = 2;
					break;
				case 4:
					Remote_Pack[i] = 1;
					break;
				default: 
				break;
			}
			//UART_Send_Char(Remote_Pack[i]);
		}
		Signal_Cap_Counter = 0;
		TIM2_Cmd(ENABLE);
		
		
		for(i = 0; i < 8; i++)
		{
			if(Remote_Pack[i] != 0x00)
				return NO_REMOTE_COMMAND;
		}
		
		if(Remote_Pack[10] == 1)
			return START_FIRE;
		else if(Remote_Pack[9] == 1)
			return STOP_FIRE;
		else if(Remote_Pack[8] == 1)
			return PUMP_ALCOHOL;
	}
	else 
		return NO_REMOTE_COMMAND;
}

@far @interrupt void TIM2_Cap_IRQHanndler(void)
{ 
	if(TIM2_GetITStatus(TIM2_IT_CC3) == SET)
	{
		if(!TIM2_Cap_Flag)
		{
			TIM2_Cap_Flag = 1;
			TIM2_SetCounter(0);
			
			TIM2->CCER2 &= ~0x02;
			
		}
		else if(TIM2_Cap_Flag == 1)
		{
			TIM2_Cap_Flag = 0;
			TIM2_Cap_End_Val = TIM2_GetCapture3();
			
			TIM2->CCER2 |= 0x02;
		}
	}
	if(Signal_Cap_Counter == 0 && TIM2_Cap_Flag != 1)
	{
		if(TIM2_Cap_End_Val <= 3800 && TIM2_Cap_End_Val >= 3100)
		{
			Signal_Cap_Counter = 1;
		}
	}
	else if((Signal_Cap_Counter > 0) && (Signal_Cap_Counter < 23) && TIM2_Cap_Flag != 1)
	{
		if((TIM2_Cap_End_Val <= 500) && (TIM2_Cap_End_Val >= 250))
		{
			Signal_Tem_Buffer[Signal_Cap_Counter - 1] = 1;
			Signal_Cap_Counter++;
		}
		else if((TIM2_Cap_End_Val <= 200) && (TIM2_Cap_End_Val >= 50))
		{
			Signal_Tem_Buffer[Signal_Cap_Counter - 1] = 2;
			Signal_Cap_Counter++;
		}
		else
			Signal_Cap_Counter = 0;
	}
	else if(Signal_Cap_Counter >= 23)
		TIM2_Cmd(DISABLE);
	
	TIM2_ClearITPendingBit(TIM2_IT_CC3);
}

@far @interrupt void TIM2_Update_IRQHanndler(void)
{
	TIM2_Cap_Flag = 0;
	Signal_Cap_Counter = 0;
	TIM2_ClearITPendingBit(TIM2_IT_UPDATE);
}