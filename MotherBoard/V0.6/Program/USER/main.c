#include "main.h"

/*
Fre:
HCLK: 72M PCLK1: 36M PCLK2: 72M ADCLK: 36M SYS: 72M;

24C02 use status:
Language 0x00
Volume   0x01

TIM:
T5 : voice
T6 : MMA
T7 : Safe
T4 : 
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
//uint16_t WIFI_Send_Ctr;
uint32_t FireUpHotCnt;
uint32_t OnFireCnt;


extern uint8_t Critical_Problem_Handler_Flag;
extern uint8_t RX_Frame_User_Data_Flag;
extern int16_t Temperture;
extern uint8_t WIFIStartStopFire;
extern uint16_t WIFICommandCnt;


/* Trough Length Parameter */
uint16_t SpoutsAlcoholTimeout[4] = {19500, 29000, 38500, 19500};
uint16_t SpoutsAlcoholDelay[4] = {3000, 5000, 8000, 3000};

/* Safe Parameter*/

/***************************/

int main(void)
{
	ArtFire_Init();
	STANDBYE();
	
	System_Status.System_Status = SYSTEM_STANDBYE;
	System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_SAFE;	
	while(1)
	{	
		
		XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
											(uint8_t)(Temperture / 10),
											System_Status.Safe_Check_Result.Unsafe_Type);
		
		Delay_ms(500);
		
		if(System_Status.Safe_Check_Result.Unsafe_Type & SAFE_CHECK_LOW_ALCOHOL)
		{
			if((Alcohol_Low_Alarm_Cnt < 3) && !XB_Set_Play(VOICE_LA))
				Alcohol_Low_Alarm_Cnt++;
		}
		else
			Alcohol_Low_Alarm_Cnt = 0;
		
		if(!IO4 
			&& (Fire_Detect() != FIRE_DETECT || !System_Status.System_Setting.Temperture_Fire)
			&& (XB_ADC_After_Filter[1] < TROUGH_SAFE_TEMPERTURE || !System_Status.System_Setting.Temperture_Trough)
			&& !FireUpHotCnt)
		{
			Delay_ms(10);
			if(!IO4)
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
					&& !(System_Status.Safe_Check_Result.Unsafe_Type & SAFE_CHECK_LOW_ALCOHOL)
					&& !FireUpHotCnt)
				{
					Start_Fire();
//					XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
//											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
//											(uint8_t)(Temperture / 10),
//											System_Status.Safe_Check_Result.Unsafe_Type);
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
	
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_3);
	
	/* GPIO Clock */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD, ENABLE);
	
//	/* EEROM 24C02 */
	EEPROM_24C0x_Low_Init();
//	
	Get_System_Setting();
	/* WWDG */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_WWDG, ENABLE);
	
	WWDG_SetPrescaler(WWDG_Prescaler_8);
	WWDG_SetWindowValue(0x50);					//Reload Windows Time(50ms~60ms)
	WWDG_Enable(0x7f);
 
	/* Voice Init */
	XB_Voice_Init();
	
	/* Safe_Check Init */
	Safe_Check_Init();
	
	
	/* Debug USART Init */
	Debug_USART_Init();
	
	/* Bee */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	Bee(0);
	
	/* Port Init */
	/* Fire Heater */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	Fire_Heater(0);
//	
	/* FLD FHD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
//	
	/* AHD ALD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3 | GPIO_Pin_5;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
//	
	/* Pump1 Pump2*/
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1 | GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	Pump1(0);
	Pump2(0);
//	
	/* Fan */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
//	
	Fan(0);
//	
	/* Remote Control */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_14 | GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPD;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
//	
	/* Status LED */
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7 | GPIO_Pin_8;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	LED_Red(1);LED_Yellow(1);LED_Green(1);
//	
//	
	/* IO4 */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
//	
	/* LDHD LDLD */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6 | GPIO_Pin_7;
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
	
	XB_Set_Play(VOICE_PON);
}

uint8_t Start_Fire(void)
{
	uint8_t Command;
	uint8_t Fire_Undetected_Flag = 0;
	uint16_t Ctr, SpoutsAlcoholTimeoutCnt;
	
	System_Status.System_Status = SYSTEM_ON_FIRE;
	OnFireCnt = 0;
//	XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
//											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
//											(uint8_t)(Temperture / 10),
//											System_Status.Safe_Check_Result.Unsafe_Type);
	XB_Set_Play(VOICE_II);
	
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
		XB_Set_Play(VOICE_POF);
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
	while(!Critical_Problem_Handler_Flag) 
	{
		if(Command == STOP)
		{
			XB_Set_Play(VOICE_POF);
			break;
		}
		Command = Get_Remote_Action();
		if(System_Status.System_Status != SYSTEM_ON_FIRE)
		{
			XB_Set_Play(VOICE_POF);
			break;
		}
		if(System_Status.Safe_Check_Result.Unsafe_Type == SAFE_CHECK_LOW_ALCOHOL)
		{
			XB_Set_Play(VOICE_POF);
			break;
		}
		
		if(Fire_Time_Ctr >= 30000 && System_Status.System_Setting.Temperture_Fire)
		{
			if(Fire_Detect() != FIRE_DETECT)
			{
				if(Fire_Undetected_Flag >= 1)
				{
					XB_Set_Play(VOICE_IF);
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
				Ctr = 0;
				while(Ctr < SpoutsAlcoholDelay[System_Status.System_Setting.Trough_Len] && (Command == NULL || Command == START_FIRE))
				{
					Command = Get_Remote_Action();
					Ctr++;
					if(SpoutsAlcoholTimeoutCnt >= 10)
						SpoutsAlcoholTimeoutCnt -= 10;
					Delay_ms(1);
				}
				Pump1(0);
			}
		}
		
		if(FLD)
		{
			Delay_ms(5);
			if(FLD)
			{
				Pump1(1);
				if(SpoutsAlcoholTimeoutCnt <= SpoutsAlcoholTimeout[System_Status.System_Setting.Trough_Len] / 5)
					SpoutsAlcoholTimeoutCnt++;
				else
				{
					XB_Set_Play(VOICE_IF);
					break;
				}
				
			}
		}
		
//		if(WIFI_Send_Ctr > 1000)
//		{
//			XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
//											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
//											(uint8_t)(Temperture / 10),
//											System_Status.Safe_Check_Result.Unsafe_Type);
//			WIFI_Send_Ctr = 0;
//		}
	}
	
	
	if(OnFireCnt >= 120000 && !Critical_Problem_Handler_Flag)
	{
		FireUpHotCnt = 180000;
		System_Status.System_Status = SYSTEM_HOT_WAIT3MIN;
		while(FireUpHotCnt && !Critical_Problem_Handler_Flag);
		System_Status.System_Status = SYSTEM_STANDBYE;
	}
	else if(!Critical_Problem_Handler_Flag)
	{
		System_Status.System_Status = SYSTEM_STANDBYE;
	}
	
	
	STOP_WORKING();
	return NULL;
	
}

uint8_t Pump_Alcohol(void)
{
	uint16_t Ctr = 0;
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
	if(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_15))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_15))
		{
			while(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_15));
//			if(System_Status.System_Status != SYSTEM_STANDBYE)
			return STOP;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_6))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_6))
		{
			while(GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_6));
//			if(System_Status.System_Status != SYSTEM_STANDBYE)
//				XB_Set_Play(4);
			return STOP;
		}
	}
	else if(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_14))
	{
		Delay_ms(5);
		if(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_14))
		{
			while(GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_14));
			return START_FIRE;
		}
	}
	
	if(WIFIStartStopFire)
	{
		WIFIStartStopFire = 0;
		if(System_Status.System_Status == SYSTEM_STANDBYE)
			return START_FIRE;
		else if (System_Status.System_Status == SYSTEM_ON_FIRE)
		{
//				if(System_Status.System_Status != SYSTEM_STANDBYE)
//				XB_Set_Play(4);
			return STOP;
		}
	}
	
	return NULL;
}

/*
DIP

Trough_Len0  -|=|-|
Trough_Len1  -|=|-|
Temperture_F -|=|-|
Temperture_T -|=|-|
WIFI         -|=|-|
Leakage      -|=|-|
             -|=|-|
Alcohol      -|=|-|
								 GND
*/
void Get_System_Setting(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9 | GPIO_Pin_10 | GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	
	GPIO_Init(GPIOD, &GPIO_InitStructure);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_2MHz;
	
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	System_Status.System_Setting.Trough_Len = 0x03 - (GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_10) + (GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_11) << 1));
		System_Status.System_Setting.Volume = EEPROM_24C0x_Read(0x01);
	System_Status.System_Setting.Language = EEPROM_24C0x_Read(0x00);
	if(System_Status.System_Setting.Language != 0x00 && System_Status.System_Setting.Language != 0x01)
	{
		System_Status.System_Setting.Language = 0x00;
		EEPROM_24C0x_Write(0x00, System_Status.System_Setting.Language);
	}
	System_Status.System_Setting.Temperture_Fire = 0x01 - GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_12);
	System_Status.System_Setting.Temperture_Trough = 0x01 - GPIO_ReadInputDataBit(GPIOD, GPIO_Pin_2);
	System_Status.System_Setting.WIFI =  0x01 - GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_12);
	System_Status.System_Setting.Alcohol_Concentration = 0x01 - GPIO_ReadInputDataBit(GPIOC, GPIO_Pin_8);
	System_Status.System_Setting.LeakageDetect = 0x01 - GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_11);
}

void Debug_USART_Init(void)
{
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

	//********USART1_Init**************//
	USART_Cmd(USART1, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART1, &USART_InitStructure);

	USART_Cmd(USART1, ENABLE);

	//********USART_GPIO_Init************//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
}

void Debug_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET)
	{
	}
		USART_SendData(USART1, Char);
}

void Debug_USART_Printf(char *fmt, ...)
{
	uint16_t Cnt1, Cnt2;
  uint8_t TX_Buf[256];
  
  va_list ap;
  va_start(ap, fmt);
  vsprintf((char *)TX_Buf, fmt, ap);
  va_end(ap);
  Cnt1 = strlen((const char*)TX_Buf);
  
  for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
  {
    Debug_USART_Send_Char(TX_Buf[Cnt2]);
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
//		XB_Alcohol_AP_Send_Data(WIFI_Client_Num, 
//											(System_Status.System_Status == SYSTEM_ON_FIRE)?1:0,
//											23,
//											System_Status.Safe_Check_Result.Unsafe_Type);
		Delay_ms(1000);
		Debug_USART_Send_Char(System_Status.Safe_Check_Result.Unsafe_Type);
	}
}

