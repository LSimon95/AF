#include "main.h"

/*
Fre:
HCLK: 72M PCLK1: 36M PCLK2: 72M ADCLK: 36M SYS: 72M;

IRQ_Pri
MMA7660 -Pre 0x05 -Sub 0x05
TIM7    -Pre 0x02 -Sub 0x02
USART2  -Pre 0x02 -Sub 0x02

TIM:

24C02 use status:
Acc_Adjust_x 0x00-0x0b
*/

System_Status_Typedef System_Status;

extern uint16_t XB_ADC_After_Filter[];
extern uint8_t XB_WIFI_RX_USER_Buf[RX_BUF_LEN];

uint8_t number[16] = "0123456789abcdef";
uint16_t Fire_Time_Ctr;
uint8_t WIFI_Control_Val = 0;
XB_WIFI_TypedefStructure XB_WIFI_Structure;
uint8_t Alcohol_Low_Alarm_Cnt = 0;
uint8_t WIFI_Client_Num = 0;
uint16_t WIFI_Send_Ctr;

extern uint8_t Critical_Problem_Handler_Flag;
extern uint8_t RX_Frame_User_Data_Flag;
extern int16_t Temperture;

int main(void)
{
	
	ArtFire_Init();
	STANDBYE();
	
	Set_Play(2);
	System_Status.System_Status = SYSTEM_STANDBYE;
	System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_SAFE;
	
	
	Acc_Adjust();
	
	
	while(1)
	{
		if(System_Status.Safe_Check_Result.Unsafe_Type & SAFE_CHECK_LOW_ALCOHOL)
		{
			if((Alcohol_Low_Alarm_Cnt < 3) && !Set_Play(5))
				Alcohol_Low_Alarm_Cnt++;
		}
		else
			Alcohol_Low_Alarm_Cnt = 0;
		
		if(!IO4 && Fire_Detect() != FIRE_DETECT)
		{
			Delay_ms(10);
			if(!IO4 && Fire_Detect() != FIRE_DETECT)
			{
				while(!IO4);
				Delay_ms(10);
				Pump_Alcohol();
			}
		}	
		
		switch(Get_Remote_Action())
		{
			case STOP:
				STANDBYE();
				break;
			case START_FIRE:
				if(System_Status.System_Status == SYSTEM_STANDBYE 
					&& !(System_Status.Safe_Check_Result.Unsafe_Type & SAFE_CHECK_LOW_ALCOHOL))
				{
					Start_Fire();
					XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
											(uint8_t)(Temperture / 10),
											System_Status.Safe_Check_Result.Unsafe_Type);
				}
				break;
			default:
				break;
		}
		if(Critical_Problem_Handler_Flag)
			Critical_Problem_Handler();
	
	}
}



void ArtFire_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	SystemInit();
	SysTick_Configuration();
	
	/* EEROM 24C02 */
	EEPROM_24C0x_Low_Init();
	
	/* Read Save Parameters*/
	Read_Save_Para();
	
	/* WWDG */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_WWDG, ENABLE);
	
	WWDG_SetPrescaler(WWDG_Prescaler_8);
	WWDG_SetWindowValue(0x50);					//Reload Windows Time(50ms~60ms)
	WWDG_Enable(0x7f);
	
	
	/* Safe_Check Init */
	Safe_Check_Init();
	
	/* GPIO Clock */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD, ENABLE);

	/* Debug USART Init */
	Debug_USART_Init();
	
	/* Bee */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOD, &GPIO_InitStructure);
	
	Bee(0);
	
	/* Port Init */
	/* Fire Heater */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
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
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
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
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	Fan(0);
	
	/* Remote Control */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	/* Status LED */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB|RCC_APB2Periph_GPIOC|RCC_APB2Periph_AFIO, ENABLE);
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/* YF_017 */
	YF017_Init();
	
	/* IO4 */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/* LDHD LDLD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	/* WIFI Init*/
	XB_WIFI_Structure.WIFI_Mode = 2;
	
	XB_WIFI_Structure.AP_Name = "ArtFire";
	XB_WIFI_Structure.AP_Pass = "12345678";
	XB_WIFI_Structure.AP_Chl  = 1;
	XB_WIFI_Structure.AP_Ecn  = 3;
	
	XB_WIFI_Structure.TCPIP_CIPMUX = 1; //Enable Multipath Connection
	
	XB_WIFI_Init(&XB_WIFI_Structure);
}

uint8_t Start_Fire(void)
{
	uint8_t Command;
	uint8_t Fire_Undetected_Flag = 0;
	uint16_t Ctr;
	
	Set_Play(1);
	System_Status.System_Status = SYSTEM_ON_FIRE;
	
	XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
											(uint8_t)(Temperture / 10),
											System_Status.Safe_Check_Result.Unsafe_Type);
	
	WORKING();
	Fire_Heater(1);
	Command = Get_Remote_Action();
	for(Ctr = 0; Ctr < 2000 && (Command == NULL || Command == START_FIRE) && System_Status.System_Status == SYSTEM_ON_FIRE; Ctr++)
	{
		Delay_ms(1);
		Command = Get_Remote_Action();
	}
	if(Ctr < 2000)
	{
		System_Status.System_Status = SYSTEM_STANDBYE;
		STOP_WORKING();
		return NULL;
	}
	Pump1(1);
	for(Ctr = 0; Ctr < 1000 && !Critical_Problem_Handler_Flag; Ctr++)
	{
		Delay_ms(1);
	}
	Fire_Heater(0);
	Fire_Time_Ctr = 0;
	while(!Critical_Problem_Handler_Flag && Command != STOP) 
	{
		Command = Get_Remote_Action();
		if(System_Status.System_Status != SYSTEM_ON_FIRE)
		{
			break;
		}
		if(System_Status.Safe_Check_Result.Unsafe_Type == SAFE_CHECK_LOW_ALCOHOL)
		{
			break;
		}
		if(Command != NULL && Command != START_FIRE)
		{
			break;
		}
		if(Fire_Time_Ctr >= 30000)
		{
			if(Fire_Detect() != FIRE_DETECT)
			{
				if(Fire_Undetected_Flag >= 1)
				{
					Set_Play(26);
					break;
				}
				else if(Fire_Undetected_Flag < 1)
				{
					Fire_Undetected_Flag++;
					Fire_Time_Ctr = 25000;
				}
			}
			else
			{
				Fire_Undetected_Flag = 0;
				Fire_Time_Ctr = 30000;
			}
		}
		if(!FLD)
		{
			Delay_ms(5);
			if(!FLD)
			{
				Pump1(0);
			}
		}
		if(FLD)
		{
			Delay_ms(5);
			if(FLD)
			{
				Pump1(1);
				Ctr = 0;
				do
				{
					Command = Get_Remote_Action();
					Ctr++;
					Delay_ms(1);
				}
				while(Ctr < 4000 
							&&(Command == NULL || Command == START_FIRE)
						);
			}
		}
		if(WIFI_Send_Ctr > 1000)
		{
			XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
											(uint8_t)(Temperture / 10),
											System_Status.Safe_Check_Result.Unsafe_Type);
			WIFI_Send_Ctr = 0;
		}
	}
	if(!Critical_Problem_Handler_Flag)
		System_Status.System_Status = SYSTEM_STANDBYE;
	
	
	STOP_WORKING();
	return NULL;
	
}

uint8_t Pump_Alcohol(void)
{
	uint16_t Ctr = 0;
	uint8_t Command;
	Alcohol_Low_Alarm_Cnt = 0;
	System_Status.System_Status = SYSTEM_PUMP_ALCOHOL;
	WORKING();
	Pump2(1);
	while(IO4 
				&& AHD 
				&& Ctr++ < 4500
				&& System_Status.System_Status == SYSTEM_PUMP_ALCOHOL
				&& !Critical_Problem_Handler_Flag
				)
	{
		Delay_ms(10);
	}
	Pump2(0);
	if(IO4 == 0)
	{
		while(!IO4);
		Delay_ms(5);
	}
	if(Ctr >= 4500)
	{
		System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_TIME_OUT_PUMP_ALCOHOL;
		System_Status.System_Status = SYSTEM_UNSAFE;
		Critical_Problem_Handler();
	}
	
	if(!Critical_Problem_Handler_Flag)
		System_Status.System_Status = SYSTEM_STANDBYE;
	
	/* Wait Push Again */
	while(!IO4);
	Delay_ms(5);
	STANDBYE();
	return NULL;
}

uint8_t Get_Remote_Action(void)
{
	if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0))
		{
			while(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0));
			if(System_Status.System_Status != SYSTEM_STANDBYE)
				Set_Play(4);
			return STOP;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_1))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_1))
		{
			while(GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_1));
			if(System_Status.System_Status != SYSTEM_STANDBYE)
				Set_Play(4);
			return STOP;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3))
		{
			while(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_3));
			return START_FIRE;
		}
	}
	
	if(RX_Frame_User_Data_Flag)
	{
		WIFI_Client_Num = XB_WIFI_RX_USER_Buf[7] - '0';
		RX_Frame_User_Data_Flag = 0;
		if((XB_WIFI_RX_USER_Buf[9] - '1'))
		{
			if(System_Status.System_Status == SYSTEM_STANDBYE)
				return START_FIRE;
			else if (System_Status.System_Status == SYSTEM_ON_FIRE)
			{
				if(System_Status.System_Status != SYSTEM_STANDBYE)
				Set_Play(4);
				return STOP;
			}
		}
	}
	
	return NULL;
}

/* Update Parameters */
extern float Acc_Adjust_X;
extern float Acc_Adjust_Y;
extern float Acc_Adjust_Z;

void Read_Save_Para(void)
{
	uint8_t *Pointer;
	uint8_t Cnt1;
	
	/* Acc_Adjust Parameters */
	Pointer = (uint8_t *)&Acc_Adjust_X;
	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
	{
		*Pointer = EEPROM_24C0x_Read(0x00 + Cnt1);
		Pointer++;
	}
	
	Pointer = (uint8_t *)&Acc_Adjust_Y;
	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
	{
		*Pointer = EEPROM_24C0x_Read(0x04 + Cnt1);
		Pointer++;
	}
	
	Pointer = (uint8_t *)&Acc_Adjust_Z;
	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
	{
		*Pointer = EEPROM_24C0x_Read(0x08 + Cnt1);
		Pointer++;
	}
	
}

void YF017_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC | RCC_APB2Periph_AFIO, ENABLE);
	
	 PWR_BackupAccessCmd(ENABLE);
   RCC_LSEConfig(RCC_LSE_OFF);
   PWR_BackupAccessCmd(DISABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14 | GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	YF_Reset(0);
	YF_Data(0);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;                                                                                                                                           
	GPIO_Init(GPIOC, &GPIO_InitStructure);
}

uint8_t Set_Play(uint8_t Num)
{
	uint8_t Ctr;
	if(YF_Busy)
	{
		YF_Reset(1);
		Delay_ms(2);
		YF_Reset(0);
		Delay_ms(2);
		for(Ctr = 0; Ctr < Num; Ctr++)
		{
			YF_Data(1);
			Delay_ms(2);
			YF_Data(0);
			Delay_ms(2);
		}
		return 0;
	}
	return 1;
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
	while(USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET)
	{
	}
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
	TIM_Cmd(TIM7, DISABLE); //Disable Safe_Check
	STOP_WORKING();
	WARNNING();
	Bee(1);
	Delay_ms(5000);
	Bee(0);
	while(1)
	{
		XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
											23,
											System_Status.Safe_Check_Result.Unsafe_Type);
		Delay_ms(1000);
		Debug_USART_Send_Char(System_Status.Safe_Check_Result.Unsafe_Type);
	}
}

