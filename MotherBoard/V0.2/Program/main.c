/* MAIN.C file
 * 
 * Copyright (c) 2002-2005 XB_Technology
 */

#include "main.h"
extern Safe_Check_Typedef Safe_Check_Result;
System_Status_Typedef System_Status;

void main(void)
{
	char i, Command;
	uint16_t j;
	Init();
	System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
	STANDBYE();
	while (1)
	{
		Command = Remote_Control_Get_Command();
		//UART_Send_Char(Command);
		switch(Command)
		{
			case PUMP_ALCOHOL:
				if(System_Status.System_Status == STATUS_UNSAFE && Safe_Check_Result.Unsafe_Type != STORE_ALCOHOL_LEVE_LOW && Safe_Check_Result.Unsafe_Type != SAFE)
				{
						break;
				}
				System_Status.System_Status = STATUS_PUMP_IN_ALCOHOL;
				Pump_In_Alcohol();
				System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
				Remote_Control_Get_Command(); //Clear Last Command
			break;
			case START_FIRE:
				if(System_Status.System_Status == STATUS_UNSAFE)
				{
					break;
				}
				System_Status.System_Status = STATUS_START_FIRE;
				Start_Fire();
				System_Status.System_Status = STATUS_WAIT_FOR_COMMAND;
				Remote_Control_Get_Command(); //Clear Last Command
			break;
			
			default:
			break;
		}
	}
}

uint8_t Pump_In_Alcohol(void)
{
	uint16_t Ctr = 0x0000;
	WORKING();
	if(!ALDHH)
	{
		Delay_ms(5);			//disappear shakes
		if(!ALDHH)
			return NULL;
	}
	Pump2(0);
	while(ALDHH && (Ctr++ < 50000) && Remote_Control_Get_Command() != STOP_FIRE)
	{
		Delay_ms(1);
	}
	if(Ctr >= 50000)
	{
		WARNNING();
		Pump2(1);
		Safe_Check_Result.Unsafe_Type = TOO_LONG_WAIT_FILL_WITH_ALCOHOL;
		Serious_Problem_Handler();
	}
	STANDBYE();
	Pump2(1);
	return NULL;
}

uint8_t Start_Fire(void)
{
	uint16_t Ctr = 0x0000;
	WORKING();
	AHeater(0);
	for(Ctr = 0; Ctr <= 20000 && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
	{
		Delay_ms(1);
	}
	if(Ctr < 20000)
	{
		STOP_WORKING();
		STANDBYE();
		return NULL;
	}
	Pump1(0);
	for(Ctr = 0; Ctr <= 2000  && Remote_Control_Get_Command() != STOP_FIRE && System_Status.System_Status == STATUS_START_FIRE; Ctr++)
	{
		Delay_ms(1);
	}
	if(Ctr < 2000)
	{
		STOP_WORKING();
		STANDBYE();
		return NULL;
	}
	AHeater(1);
	while(1)
	{
		if(Remote_Control_Get_Command() == STOP_FIRE || System_Status.System_Status != STATUS_START_FIRE)
			break;
		if(!FireDL)
		{
			Delay_ms(5);
			if(!FireDL)
			{
				Pump1(1);
			}
		}
		if(FireDL)
		{
			Delay_ms(5);
			if(FireDL)
			{
				Pump1(0);
			}
		}
	}
	STOP_WORKING();
	WARNNING();
	while(1);
	return NULL;
	//while(Remote_Control_Get_Command()
}

void assert_failed(uint8_t* file, uint32_t line) //assert_failed function
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
		UART_Send_Char(0x01);
  }
}

void Init(void)
{
	uint8_t ERROR; 
	/* Sys Clk Init */
	while(Sys_Clk_Init() != SUCCESS);
	TIM4_Tick_Init();
	
	FLASH_Unlock(FLASH_MEMTYPE_DATA);
	FLASH_EraseByte(0x4000);
	FLASH_Lock(FLASH_MEMTYPE_DATA);
	
	/* Uart Init */
	UART_Init();
	/* LED */
	GPIO_Init(GPIOB, GPIO_PIN_6, GPIO_MODE_OUT_PP_HIGH_SLOW);
	GPIO_Init(GPIOB, GPIO_PIN_7, GPIO_MODE_OUT_PP_HIGH_SLOW);
	GPIO_Init(GPIOA, GPIO_PIN_6, GPIO_MODE_OUT_PP_HIGH_SLOW);
	/* Check EEPROM ERROR */
	FLASH_Unlock(FLASH_MEMTYPE_DATA);
	ERROR = FLASH_ReadByte(0x4000);
	FLASH_Lock(FLASH_MEMTYPE_DATA);
	if((ERROR == HIGH_TEMPERTURE) || (ERROR == GET_TEMPERTURE_FAILED) || (ERROR == GET_ALCOHOL_CONCENTRATION_FAILED) || (ERROR == TOO_LONG_WAIT_FILL_WITH_ALCOHOL) || (ERROR == ALCOHOL_LEAKAGE))
	{
		sim();
		WARNNING();
		while(1)
		{
			while(!UART2_GetFlagStatus(UART2_FLAG_TXE));
			UART2_SendData8(ERROR);
		}
	}
	
	/* Watch-Dog Init */
	WWDG_Init(0x7F, 0x57);	//Enable WWDG, about 30 - 49 ms is refresh Window Time
	
	/* GPIO_Init */
	/* Bee */
	GPIO_Init(GPIOC, GPIO_PIN_3, GPIO_MODE_OUT_PP_HIGH_SLOW);
	/* Pump */
	GPIO_Init(GPIOC, GPIO_PIN_1, GPIO_MODE_OUT_PP_HIGH_SLOW);
	GPIO_Init(GPIOC, GPIO_PIN_2, GPIO_MODE_OUT_PP_HIGH_SLOW);
	/* DS18B20 */
	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_SLOW);
	/* Alcohol Pump In Detect */
	GPIO_Init(GPIOB, GPIO_PIN_0, GPIO_MODE_IN_PU_NO_IT);
	GPIO_Init(GPIOB, GPIO_PIN_1, GPIO_MODE_IN_PU_NO_IT);
	/* Remote_Control_Init */
	Remote_Control_Init();
	Remote_Control_Cmd(ENABLE);
	/* Fire Detect */
	GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_IN_FL_NO_IT);
	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
	/* Alcohol Heater */
	GPIO_Init(GPIOA, GPIO_PIN_4, GPIO_MODE_OUT_PP_HIGH_SLOW);
	/* Alcohol Leakage Detect */
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_IN_FL_NO_IT);
	/* Safe_Check_Init */
	if(Safe_Check_Init())
	{
		Safe_Check_Result.Unsafe_Type = SAFE_CHECK_INIT_FAILED;
		Safe_Check_Result.Safe_Flag = UNSAFE;
		Serious_Problem_Handler();
	}
}

void UART_Init(void)
{
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_UART2, ENABLE);
	
	UART2_Init(38400, UART2_WORDLENGTH_8D, UART2_STOPBITS_1, UART2_PARITY_NO, UART2_SYNCMODE_CLOCK_DISABLE, UART2_MODE_TX_ENABLE);
	UART2_Cmd(ENABLE);
}

void UART_Send_Char(uint8_t C)
{
	while(!UART2_GetFlagStatus(UART2_FLAG_TXE));
	sim();
	UART2_SendData8(C);
	rim(); //!!
}

ErrorStatus Sys_Clk_Init(void)
{
	return CLK_ClockSwitchConfig(CLK_SWITCHMODE_AUTO, CLK_SOURCE_HSE, DISABLE, CLK_CURRENTCLOCKSTATE_ENABLE);
}

void Serious_Problem_Handler(void)
{
	WARNNING();
	STOP_WORKING();
	sim();
	FLASH_Unlock(FLASH_MEMTYPE_DATA);
	FLASH_EraseByte(0x4000);
	FLASH_ProgramByte(0x4000, (uint8_t)Safe_Check_Result.Unsafe_Type);
	FLASH_Lock(FLASH_MEMTYPE_DATA);
	while(1)
	{
		if((WWDG_GetCounter() & 0x7f) < 0x50)
		{
			WWDG_SetCounter(0x7F);
		}
	}
}