#include "main.h"

Sys_Status_StructureTypedef Sys_Status;
//Receive_Status_StructureTypedef Receive_Status;
char number[10] = "0123456789";

#define N_LANGUAGE 2
/* ERROR */
#define N_ERROR 10
char const *Error_List_CHN[N_ERROR] = {
													"状态正常",                              //0x000
													"状态正常 ",															//0x001
													"酒精触及二级液位",				//0x002
													"状态正常",															//0x004
													"温度过高",								//0x008
													"状态正常",															//0x010
													"地震或者机器倾斜",				//0x020
													"酒精过少",															//0x040
													"抽酒精时间超过限制",			//0x080
													"酒精泄漏"								//0x100
													};
char const *Error_List_ENG[N_ERROR] = {
													"No Warning",                              //0x000
													"No Warning",															//0x001
													"2nd Level Detected Alarm",				//0x002
													"No Warning",															//0x004
													"High Temperture",								//0x008
													"No Warning",															//0x010
													"Earthquake or Incline",				//0x020
													"Lack of Alcohol",															//0x040
													"Pump Alcohol Timeout",			//0x080
													"Alcohol Leakage"								//0x100
													};
char const **ErrorList[N_LANGUAGE] = {
	Error_List_CHN,
	Error_List_ENG
};
/* STATUS */
#define N_STATUS 5
char const *StatusListCHN[N_STATUS] = {
	"等待指令",
	"安全检查未通过",
	"正在燃烧",
	"正在加注酒精",
	"系统等待冷却"
};
char const *StatusListENG[N_STATUS] = {
	"Waitting Command",
	"SafeCheck Not Pass",
	"Igniting",
	"Filling Alcohol",
	"Waitting System Cold"
};
char const **StatusList[N_LANGUAGE] = {
	StatusListCHN,
	StatusListENG
};	
/* SETTING */
#define N_SETTING 5
char const *SettingListCHN[N_SETTING] = {
	"火焰检测：",
	"槽内温度：",
	"漏液检测：",
	"酒精浓度：",
	"CO2浓度 ："
};
char const *SettingListENG[N_SETTING] = {
	"Fire Detect   :",
	"Groove Temp   :",
	"Leakage Detect:",
	"Alcohol ppm   :",
	"CO2 ppm       :"
};
char const **SettingList[N_LANGUAGE] = {
	SettingListCHN,
	SettingListENG
};
char const *SettingStatus[N_LANGUAGE] = {
	"未装！",
	"NO!"
};


extern uint8_t XB_WIFI_RX_USER_Buf[RX_BUF_LEN];
extern uint16_t WIFI_Remote_Time_Out;
extern uint8_t RX_Frame_User_Data_Flag;

uint8_t WIFI_Remote_Send_Byte = 0x00;
uint8_t Cnt;
uint16_t Error_Word;
uint16_t ConnectionLostCnt;
uint16_t StatusRefreshCnt;
uint16_t GetCO2Cnt;
													
int main(void)
{
	uint8_t Cnt;
	uint16_t Temp;
	XB_WIFI_TypedefStructure XB_WIFI_Structure;
	SystemInit();
	SysTick_Configuration();
	
	Debug_USART_Init();
	
	CO2_Init();
	
	Sys_Status.WIFI_Type = 0;
	Sys_Status.HMI_Page = 0;
	Sys_Status.Language = 0;
	Sys_Status.Temperture = 0;
	Sys_Status.Volum = 10;
	Sys_Status.Runing_Time_s = 0;
	Display_Update();
	/* Init Wifi */
	
	XB_WIFI_Structure.WIFI_Mode = 1;
	XB_WIFI_Structure.AP_Name = "ArtFire";
	XB_WIFI_Structure.AP_Pass = "12345678";
	while(XB_WIFI_Init(&XB_WIFI_Structure));
	
	Sys_Status.WIFI_Type = 1;
	Display_Update();
	
	
	while(1)
	{
		
		if(ConnectionLostCnt > 500)
		{
			ConnectionLostCnt = 0;
			/* Change Page? */
			if(WIFI_Remote_Send_Byte == 0x88)
			{
				Sys_Status.HMI_Page = 0;
				WIFI_Remote_Send_Byte = 0;
			}
			else if(WIFI_Remote_Send_Byte == 0x99)
			{
				Sys_Status.HMI_Page = 1;
				WIFI_Remote_Send_Byte = 0;
			}
			
			/* Send Command */
			if(XB_WIFI_STA_Send_Str("%u", WIFI_Remote_Send_Byte + 1))
			{
				if(XB_WIFI_STA_Send_Str("%u", WIFI_Remote_Send_Byte + 1))
				{
					Sys_Status.WIFI_Type = 0;
					
					Debug_USART_Send_Str("vis p1,0");
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					XB_WIFI_Init(&XB_WIFI_Structure);
					
				}
			}
			else
			{
				Sys_Status.WIFI_Type = 1;
			}
			WIFI_Remote_Send_Byte = 0;
		}
		
		if(RX_Frame_User_Data_Flag && XB_WIFI_RX_USER_Buf[31] == 0x88)
		{
			if(Sys_Status.HMI_Page == 0)
			{
				Sys_Status.Fire_Type = (XB_WIFI_RX_USER_Buf[17] == SYSTEM_ON_FIRE) ? 1 : 0;
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[20]) | ((uint16_t)XB_WIFI_RX_USER_Buf[21] << 8); //Temperture
				if((int16_t)Temp < -10 || (int16_t)Temp > 7500 || (int16_t)Temp == 0)
				{
				}
				else
				{
					Sys_Status.Temperture = Temp / 10;	
				}
				Sys_Status.Volum = XB_WIFI_RX_USER_Buf[14];
				Sys_Status.Language = XB_WIFI_RX_USER_Buf[11];
				
				if(StatusRefreshCnt >= 500)
				{
					StatusRefreshCnt = 0;
					Error_Word = (((XB_WIFI_RX_USER_Buf[19]) << 8) | (XB_WIFI_RX_USER_Buf[18]));

					while(!(Error_Word & (0x01 << Cnt)) && Cnt < 9)
						Cnt++;
					Debug_USART_Send_Str("xstr 50,0,200,16,1,RED,WHITE,0,0,1,");
					Debug_USART_Send_Char('"');
					if(Cnt >= 9)
						Cnt = 0;
					Debug_USART_Send_Str((char *)ErrorList[Sys_Status.Language][Cnt + 1]);
					Debug_USART_Send_Char('"');
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					
					Debug_USART_Send_Str("xstr 50,16,200,16,1,RED,WHITE,0,0,1,");
					Debug_USART_Send_Char('"');
					Debug_USART_Send_Str((char *)StatusList[Sys_Status.Language][XB_WIFI_RX_USER_Buf[17]]);
					Debug_USART_Send_Char('"');
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					/* Setting List */
					if(XB_WIFI_RX_USER_Buf[10]) // AC
					{
						Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[26]) | ((uint16_t)XB_WIFI_RX_USER_Buf[27] << 8);
						Debug_USART_Printf("xstr 230,220,200,16,1,BLACK,WHITE,0,0,1,\"%s%d\"", SettingList[Sys_Status.Language][3], Temp);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					else 
					{
						Debug_USART_Printf("xstr 230,220,200,16,1,RED,WHITE,0,0,1,\"%s%s\"", SettingList[Sys_Status.Language][3], SettingStatus[Sys_Status.Language]);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					
					if(XB_WIFI_RX_USER_Buf[16]) // Leakage
					{
						Debug_USART_Printf("xstr 230,204,200,16,1,BLACK,WHITE,0,0,1,\"%s%d\"", SettingList[Sys_Status.Language][2], XB_WIFI_RX_USER_Buf[37]);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					else 
					{
						Debug_USART_Printf("xstr 230,204,200,16,1,RED,WHITE,0,0,1,\"%s%s\"", SettingList[Sys_Status.Language][2], SettingStatus[Sys_Status.Language]);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					
					if(XB_WIFI_RX_USER_Buf[13]) // GT
					{
						Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[24]) | ((uint16_t)XB_WIFI_RX_USER_Buf[25] << 8);
						Debug_USART_Printf("xstr 230,188,200,16,1,BLACK,WHITE,0,0,1,\"%s%d\"", SettingList[Sys_Status.Language][1], Temp);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					else 
					{
						Debug_USART_Printf("xstr 230,188,200,16,1,RED,WHITE,0,0,1,\"%s%s\"", SettingList[Sys_Status.Language][1], SettingStatus[Sys_Status.Language]);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					
					if(XB_WIFI_RX_USER_Buf[12]) // FT
					{
						Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[22]) | ((uint16_t)XB_WIFI_RX_USER_Buf[23] << 8);
						Debug_USART_Printf("xstr 230,172,200,16,1,BLACK,WHITE,0,0,1,\"%s%d\"", SettingList[Sys_Status.Language][0], Temp);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
					else 
					{
						Debug_USART_Printf("xstr 230,172,200,16,1,RED,WHITE,0,0,1,\"%s%s\"", SettingList[Sys_Status.Language][0], SettingStatus[Sys_Status.Language]);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
						Debug_USART_Send_Char(0xff);
					}
				}
			}
			else if(Sys_Status.HMI_Page == 1)
			{
				for(Cnt = 0; Cnt < 6; Cnt++)
				{
					Debug_USART_Printf("t%d.txt=\"%u\"", Cnt, XB_WIFI_RX_USER_Buf[Cnt + 10]);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
				}
				
				Debug_USART_Printf("t6.txt=\"%u\"", XB_WIFI_RX_USER_Buf[17]); //sys_status
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[18]) | ((uint16_t)XB_WIFI_RX_USER_Buf[19] << 8); //unsafe
				Debug_USART_Printf("t7.txt=\"%x\"", Temp);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[20]) | ((uint16_t)XB_WIFI_RX_USER_Buf[21] << 8); //Temperture
				Debug_USART_Printf("t8.txt=\"%d\"", Temp);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[22]) | ((uint16_t)XB_WIFI_RX_USER_Buf[23] << 8); //HC_F
				Debug_USART_Printf("t9.txt=\"%x\"", Temp);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[24]) | ((uint16_t)XB_WIFI_RX_USER_Buf[25] << 8); //HC_T
				Debug_USART_Printf("t10.txt=\"%x\"", Temp);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Temp = ((uint16_t)XB_WIFI_RX_USER_Buf[26]) | ((uint16_t)XB_WIFI_RX_USER_Buf[27] << 8); //AC
				Debug_USART_Printf("t11.txt=\"%x\"", Temp);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
				Debug_USART_Send_Char(0xff);
			
				for(Cnt = 0; Cnt < 10; Cnt++) //OUTPUT
				{
					Debug_USART_Printf("t%d.txt=\"%u\"", Cnt + 22, XB_WIFI_RX_USER_Buf[Cnt + 28]);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
					Debug_USART_Send_Char(0xff);
				}
			}
			RX_Frame_User_Data_Flag = 0;
		}
		if(Sys_Status.HMI_Page == 0)
		{
			Display_Update();
		}
		else if(Sys_Status.HMI_Page == 1)
		{
		}
		
		if(GetCO2Cnt >= 500)
		{
			GetCO2Cnt = 0;
			Debug_USART_Printf("xstr 230,156,200,16,1,BLACK,WHITE,0,0,1,\"%s%04d\"", SettingList[Sys_Status.Language][4], Get_CO2_ppm());
			Debug_USART_Send_Char(0xff);
			Debug_USART_Send_Char(0xff);
			Debug_USART_Send_Char(0xff);
		}
	}
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

void Debug_USART_Init(void)
{
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	NVIC_InitTypeDef NVIC_InitStructure;;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);

	//**********NVIC_Init**************//
	NVIC_InitStructure.NVIC_IRQChannel = USART3_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x04;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x04;
	
	NVIC_Init(&NVIC_InitStructure);
	//********USART3_Init**************//
	USART_Cmd(USART3, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART3, &USART_InitStructure);

	USART3->DR = 0x00;
	USART_ClearFlag(USART3, USART_IT_RXNE);
	USART_ClearITPendingBit(USART3, USART_IT_RXNE);
	USART_ITConfig(USART3, USART_IT_RXNE, ENABLE);
	
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

void Display_Update(void)
{
	Sys_Status.HMI_Page = 0;
	/* Fire Status */
	if(Sys_Status.Fire_Type)
	{
		Debug_USART_Send_Str("vis p0,1");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	else
	{
		Debug_USART_Send_Str("vis p0,0");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	/* WIFI Status */
	if(Sys_Status.WIFI_Type)
	{
		Debug_USART_Send_Str("vis p1,1");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	else
	{
		Debug_USART_Send_Str("vis p1,0");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	/* Mute */
	if(Sys_Status.Volum)
	{
		Debug_USART_Send_Str("vis p2,0");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	else
	{
		Debug_USART_Send_Str("vis p2,1");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	/* ENG */
	if(Sys_Status.Language == 0)
	{
		Debug_USART_Send_Str("vis p3,1");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Str("vis p4,0");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	else if(Sys_Status.Language == 1)
	{
		Debug_USART_Send_Str("vis p3,0");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Str("vis p4,1");
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
		Debug_USART_Send_Char(0xff);
	}
	/* Time */
	Debug_USART_Send_Str("t0.txt=\"");
	Debug_USART_Send_Char(number[Sys_Status.Runing_Time_s / 60 / 60 % 1000 / 100]);
	Debug_USART_Send_Char(number[Sys_Status.Runing_Time_s / 60 / 60 % 100 / 10]);
	Debug_USART_Send_Char(number[Sys_Status.Runing_Time_s / 60 / 60 % 10]);
	Debug_USART_Send_Char('\"');
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Str("t2.txt=\"");
	Debug_USART_Send_Char(number[Sys_Status.Runing_Time_s / 60 % 100 / 10]);
	Debug_USART_Send_Char(number[Sys_Status.Runing_Time_s / 60 % 10]);
	Debug_USART_Send_Char('\"');
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
	/* Temperture */
	Debug_USART_Send_Str("t1.txt=\"");
	Debug_USART_Send_Char(number[Sys_Status.Temperture % 100 / 10]);
	Debug_USART_Send_Char(number[Sys_Status.Temperture % 10]);
	Debug_USART_Send_Char('\"');
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
	Debug_USART_Send_Char(0xff);
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

void USART3_IRQHandler(void)
{
	if(USART_GetITStatus(USART3, USART_IT_RXNE))
	{
		USART_ClearITPendingBit(USART3, USART_IT_RXNE);
		if(WIFI_Remote_Time_Out >= 500)
			WIFI_Remote_Send_Byte = USART_ReceiveData(USART3);
		WIFI_Remote_Time_Out = 0;
	}
}
