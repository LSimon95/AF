#include "main.h"

System_Status_Typedef System_Status;

extern uint16_t After_filter[];
extern uint8_t DS1302_Time[];

int main(void)
{
	uint16_t i;
	ArtFire_Init();
	STANDBYE();
	System_Status.System_Status = SYSTEM_STANDBYE;
	System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_SAFE;
	
	while(1)
	{
				MMA7660_Write_Reg(0x0a, 0x88);
		Delay_ms(100);
		/*i = Temp_18B20_Get_Temperture();
		Debug_USART_Send_Char(i >> 8);
		Debug_USART_Send_Char(i);
		Delay_ms(100);*/
		
//		switch(Get_Remote_Action())
//		{
//			case STOP:
//				STANDBYE();
//				break;
//			case START_FIRE:
//				Start_Fire();
//				break;
//			case PUMP_ALCOHOL:
//				Pump_Alcohol();
//				break;
//			default:
//				break;
//		}
	}
}

void ArtFire_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	SystemInit();
	SysTick_Configuration();
	/* EEROM 24C02 */
	EEPROM_24C0x_Low_Init();
	
	/* WWDG */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_WWDG, ENABLE);
	
	WWDG_SetPrescaler(WWDG_Prescaler_8);
	WWDG_SetWindowValue(0x50);					//Reload Windows Time(50ms~60ms)
	WWDG_Enable(0x7f);
	
	Delay_ms(1000); //Don't delete, for debug waiting
	
	/* Safe_Check Init */
	Safe_Check_Init();
	
	/* GPIO Clock */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	/* Debug USART Init */
	Debug_USART_Init();
	
	/* MMA7660 */
	MMA7660_Init();
	
	/* DS1302 Init */
	DS1302_Init();
	
	/* Temperture 18B20 */
	Temp_18B20_Low_Init();
	
	/* Port Init */
	/* Fire Heater */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	Fire_Heater(0);
	
	/* FLD FHD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	/* AHD ALD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	/* Pump1 */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	Pump1(0);
	
	/* Pump2 */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	Pump2(0);
	
	/* Fan */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	Fan(0);
	
	/* Remote Control */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1 | GPIO_Pin_2 | GPIO_Pin_3;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	/* Status LED */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB|RCC_APB2Periph_GPIOC|RCC_APB2Periph_AFIO, ENABLE);
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_Disable, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
}

uint8_t Start_Fire(void)
{
	uint8_t Command;
	uint16_t Ctr;
	System_Status.System_Status = SYSTEM_ON_FIRE;
	WORKING();
	Fire_Heater(1);
	for(Ctr = 0; Ctr <20000 && Get_Remote_Action() == NULL; Ctr++)
	{
		Delay_ms(1);
	}
	if(Ctr < 20000)
	{
		STOP_WORKING();
		return NULL;
	}
	Pump1(1);
	Fire_Heater(0);
	Delay_ms(2000);
	while(1)
	{
		Command = Get_Remote_Action();
		if((Command != NULL && Command != START_FIRE) || System_Status.System_Status != SYSTEM_ON_FIRE)
			break;
		if(!FLD)
		{
			Delay_ms(5);
			if(!FLD)
			{
				Pump1(0);
			}
		}
		if(FHD)
		{
			Delay_ms(5);
			if(FLD)
			{
				Pump1(1);
			}
		}
	}
	STOP_WORKING();
	return NULL;
	
}

uint8_t Pump_Alcohol(void)
{
	uint16_t Ctr = 0;
	uint8_t Command;
	System_Status.System_Status = SYSTEM_PUMP_ALCOHOL;
	WORKING();
	Pump2(1);
	while(System_Status.System_Status == SYSTEM_PUMP_ALCOHOL && AHD && Ctr++ < 4500)
	{
		Delay_ms(10);
		Command = Get_Remote_Action();
		if(Command != NULL && Command != PUMP_ALCOHOL)
			break;
	}
	Pump2(0);
	if(Ctr >= 4500)
		Critical_Problem_Handler();
	STANDBYE();
	return NULL;
}

uint8_t Get_Remote_Action(void)
{
	if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_1))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_1))
		{
			while(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_1));
			return START_FIRE;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_2))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_2))
		{
			while(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_2));
			return PUMP_ALCOHOL;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3))
		{
			while(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3));
			return STOP;
		}
	}
	return NULL;
}


void Debug_USART_Init(void)
{
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);

	//********USART1_Init**************//
	USART_Cmd(USART3, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART3, &USART_InitStructure);

	USART_Cmd(USART3, ENABLE);

	//********USART_GPIO_Init************//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
}

void Debug_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET);
		USART_SendData(USART3, Char);
}

void Debug_USART_Send_Str(char *Str)
{
	char *Str_Send;
	Str_Send = Str;
	while(*Str_Send != '\0')
	{
		Debug_USART_Send_Char(*Str_Send);
		Str_Send++;
	}
}

void Critical_Problem_Handler(void)
{
	WARNNING();
	STOP_WORKING();
	while(1)
		Debug_USART_Send_Char(System_Status.Safe_Check_Result.Unsafe_Type);
}

