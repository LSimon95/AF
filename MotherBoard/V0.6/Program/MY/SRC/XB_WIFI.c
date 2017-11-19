 /*
**File_Name:      XB_WIFI.c
**Version:        1.1
**Date_Modified:  2016-07-18
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
Rewrite XB_USART_Init() and USARTx
7-18 Repair Rx Bug
*/

#include "XB_WIFI.h"

uint8_t XB_WIFI_RX_Buf[RX_BUF_LEN];
uint8_t XB_WIFI_RX_USER_Buf[RX_BUF_LEN];

XB_WIFI_TypedefStructure *XB_WIFI_Structure_I;

uint8_t RX_Frame_Data_Flag = 0;
uint8_t RX_Frame_User_Data_Flag = 0;

#define STATUS_SEND_BUF_LEN 29

uint8_t APSendStr[] = "AT+CIPSEND=0,29\r\n";
uint8_t StausSendBuf[STATUS_SEND_BUF_LEN]; uint8_t StausSendBuf[STATUS_SEND_BUF_LEN]; //0 - 6: Setting 7: Status 8 - 9 SafeCheckResult
//10 - 11:Temperture 12-13:HC_F 14 - 15: HC_T 16-17:AC 18 - 27:P1, P2, Fan, Bee, FHD, FLD, AHD, ALD, LDLD, LDHD 
uint8_t StatuSendCnt = 0;
uint8_t WIFIStartStopFire = 0;
uint16_t WIFICommandCnt = 0;

static DMA_InitTypeDef DMA_InitStructure;
extern System_Status_Typedef System_Status;
extern int16_t Temperture;
extern uint8_t WIFI_Client_Num;
extern uint16_t XB_ADC_After_Filter[];
extern uint16_t  AD_Value[]; 

void XB_USART_Init(uint32_t Boud_Rate)
{

	NVIC_InitTypeDef NVIC_InitStructure;
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	TIM_TimeBaseInitTypeDef TIM_TimBaseInitStructure;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART3, ENABLE);
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);

	//**************DMA_Init************//
	//DMA_DeInit(DMA1_Channel6);
	DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(USART3->DR);//设置DMA外设地址
  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)XB_WIFI_RX_Buf;	//设置DMA内存地址
  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC; //外设为设置为数据传输的来源
  DMA_InitStructure.DMA_BufferSize = RX_BUF_LEN;	//DMA缓冲区设置为256；
  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
  DMA_InitStructure.DMA_MemoryDataSize = DMA_PeripheralDataSize_Byte;
  DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
  DMA_InitStructure.DMA_Priority = DMA_Priority_High;
  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	
  DMA_Init(DMA1_Channel3, &DMA_InitStructure);
	
	DMA_Cmd(DMA1_Channel3, ENABLE);
	//**********NVIC_Init**************//
	NVIC_InitStructure.NVIC_IRQChannel = USART3_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x03;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x03;
	
	NVIC_Init(&NVIC_InitStructure);
	//2017 - 05 - 21 Added
	//TX_DMA
	DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(USART3->DR);//设置DMA外设地址
  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)StausSendBuf;	//设置DMA内存地址
  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralDST; 
  DMA_InitStructure.DMA_BufferSize = STATUS_SEND_BUF_LEN;
  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
  DMA_InitStructure.DMA_MemoryDataSize = DMA_PeripheralDataSize_Byte;
  DMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
  DMA_InitStructure.DMA_Priority = DMA_Priority_High;
  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	
  DMA_Init(DMA1_Channel2, &DMA_InitStructure);
	
	//TIM4
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM4, ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM4_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = TIM4_PRI_PRE;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = TIM4_PRI_SUB;
	
	NVIC_Init(&NVIC_InitStructure);
	
	TIM_Cmd(TIM4, DISABLE);
	
	TIM_TimBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
	TIM_TimBaseInitStructure.TIM_Period = 500;
	TIM_TimBaseInitStructure.TIM_Prescaler = 7200;
	
	TIM_TimeBaseInit(TIM4, &TIM_TimBaseInitStructure);
	TIM_ITConfig(TIM4, TIM_IT_Update, ENABLE);
	
	TIM_Cmd(TIM4, DISABLE);
	
	//2017 - 05 - 21 Added
	
	//********USART2_Init**************//
	USART_Cmd(USART3, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = Boud_Rate;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART3, &USART_InitStructure);
	
	USART_ITConfig(USART3, USART_IT_IDLE, ENABLE);

	USART_DMACmd(USART3, USART_DMAReq_Rx | USART_DMAReq_Tx, ENABLE);
	
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

void XB_WIFI_USART_Send_Char(uint8_t Byte)
{
	while(USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET)
	{
	}
		USART_SendData(USART3, Byte);
}

void XB_WIFI_Send_Str(char New_Line, char *fmt, ...)
{
	uint16_t Cnt1, Cnt2;
	uint8_t TX_Buf[MAX_SEND_LEN];
	
	va_list ap;
	va_start(ap, fmt);
	vsprintf((char *)TX_Buf, fmt, ap);
	va_end(ap);
	Cnt1 = strlen((const char*)TX_Buf);
	
	for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
	{
		XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
	}	
	if(New_Line)
	{
		XB_WIFI_USART_Send_Char(0X0D);
		XB_WIFI_USART_Send_Char(0X0A);
	}
}

void XB_Alcohol_AP_Send_Data(uint8_t Client_Num, uint8_t Fire_Status, uint8_t Temperture, uint16_t Error_Word)
{
	XB_WIFI_Send_Str(1, "AT+CIPSEND=%d,%d", Client_Num, 4);
	//Delay_ms(50);
	
	XB_WIFI_USART_Send_Char((Fire_Status + 1));
	XB_WIFI_USART_Send_Char(Temperture);
	XB_WIFI_USART_Send_Char(((uint8_t)(Error_Word >> 8) + 1));
	XB_WIFI_USART_Send_Char(((uint8_t)(Error_Word) + 1));
}

uint8_t XB_WIFI_AP_Send_Str(uint8_t Client_Num, char *fmt, ...)
{
	uint16_t Cnt1, Cnt2, Cnt3;
	uint8_t TX_Buf[MAX_SEND_LEN];
	
	va_list ap;
	va_start(ap, fmt);
	vsprintf((char *)TX_Buf, fmt, ap);
	va_end(ap);
	Cnt1 = strlen((const char*)TX_Buf);
	
	if(Client_Num == 0x0a) //Send All
	{
		for(Cnt3 = 0; Cnt3 < XB_WIFI_Structure_I->Client_Num; Cnt3++)
		{
			XB_WIFI_Send_Str(1, "AT+CIPSEND=%d,%d", Client_Num/* XB_WIFI_Structure_I->Client_ID[Cnt3] */, Cnt1);

//			if(Wait_For_Signal("\r\nOK\r\n> ", 5000))
//				return 1;

			for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
			{
				XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
			}
		}
	}
	else	//Send Select
	{
		for(Cnt3 = 0; Cnt3 < XB_WIFI_Structure_I->Client_Num; Cnt3++)
		{
			XB_WIFI_Send_Str(1, "AT+CIPSEND=%d,%d", Client_Num/* XB_WIFI_Structure_I->Client_ID[Client_Num] */, Cnt1);

//			if(Wait_For_Signal("\r\nOK\r\n> ", 5000))
//				return 1;

			for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
			{
				XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
			}
		}
	}
	
	return 0;
}

uint8_t XB_WIFI_Init(XB_WIFI_TypedefStructure *XB_WIFI_Structure)
{
	XB_WIFI_Structure_I = XB_WIFI_Structure;
	
	XB_USART_Init(115200);
	
	/* Clear Status */
	XB_WIFI_Structure_I->Client_Num = 0;
	
	
	Delay_ms(1000);
	/* Delay For rst */
	
	/* Turn OFF Command Feedback */
	XB_WIFI_Send_Str(1, "ATE0");
	Delay_ms(500);
	
	/* Select Mode */
	XB_WIFI_Send_Str(1, "AT+CWMODE=%d", XB_WIFI_Structure->WIFI_Mode);
	if(Wait_For_Signal("\r\nOK\r\n", 2000))
		return 1;
		
	/* RST */
	XB_WIFI_Send_Str(1, "AT+RST");
	if(Wait_For_Signal("\r\nOK\r\n", 5000))
		return 1;
	if(Wait_For_Signal("\r\nready\r\n", 5000))
		return 1;
	
	/* Turn OFF Command Feedback */
	XB_WIFI_Send_Str(1, "ATE0");
	Delay_ms(500);
	
	/* Build AP */
	XB_WIFI_Send_Str(1, "AT+CWSAP=\"%s\",\"%s\",%d,%d", 
									XB_WIFI_Structure->AP_Name,
									XB_WIFI_Structure->AP_Pass, 
									XB_WIFI_Structure->AP_Chl, 
									XB_WIFI_Structure->AP_Ecn);
	
	if(Wait_For_Signal("\r\nOK\r\n", 2000))
		return 1;
	
	/* CIPMUX */
	XB_WIFI_Send_Str(1, "AT+CIPMUX=%d", XB_WIFI_Structure->TCPIP_CIPMUX);
	if(Wait_For_Signal("\r\nOK\r\n", 2000))
		return 1;
	
	/* CIPSERVER */
	XB_WIFI_Send_Str(1, "AT+CIPSERVER=1,8080"); //Opend Server
	if(Wait_For_Signal("\r\nOK\r\n", 2000))
		return 1;
	
	/* Enable Status Tran */
	//DMA_Cmd(DMA1_Channel2, ENABLE);
	TIM_Cmd(TIM4, ENABLE);
	
	return 0;
}

uint8_t Rx_Data_Hanndle(void)
{
	if(!XB_WIFI_RX_Buf[0])
		return 1;
	else if(XB_WIFI_RX_Buf[0] >= '0' && XB_WIFI_RX_Buf[0] <= '9')
	{
		if(!strcmp((char *)XB_WIFI_RX_Buf + 2, "CONNECT\r\n"))
		{
			XB_WIFI_Structure_I->Client_ID[XB_WIFI_Structure_I->Client_Num] = atoi((char *)XB_WIFI_RX_Buf);
			WIFI_Client_Num = XB_WIFI_Structure_I->Client_ID[XB_WIFI_Structure_I->Client_Num];
			XB_WIFI_Structure_I->Client_Num++;
			return 0;
		} 
		else if(!strcmp((char *)XB_WIFI_RX_Buf + 2, "CLOSED\r\n"))
		{
			XB_WIFI_Structure_I->Client_Num--;
			return 0;
		}
	}
	else if(XB_WIFI_RX_Buf[2] == '+' && XB_WIFI_RX_Buf[3] == 'I')
	{
		if(WIFICommandCnt >= 500)
		{
			if((XB_WIFI_RX_Buf[11] - '1') == 1)
			{
				WIFIStartStopFire = 1;
				WIFICommandCnt = 0;
			}
			else if((XB_WIFI_RX_Buf[11] - '1') == 2)
			{
				if(System_Status.System_Setting.Volume)
				{
					System_Status.System_Setting.Volume = 0;
				}
				else
				{
					System_Status.System_Setting.Volume = 0xff;
				}
				EEPROM_24C0x_Write(0x01, System_Status.System_Setting.Volume);
				WIFICommandCnt = 0;
			}
			else if((XB_WIFI_RX_Buf[11] - '1') == 3)
			{
				if(System_Status.System_Setting.Language)
				{
					System_Status.System_Setting.Language = 0;
				}
				else
				{
					System_Status.System_Setting.Language = 1;
				}
				EEPROM_24C0x_Write(0x00, System_Status.System_Setting.Language);
				WIFICommandCnt = 0;
			}
		}
		return 0;
	}
	else if(XB_WIFI_RX_Buf[13] == '+' && XB_WIFI_RX_Buf[14] == 'I')
	{
		if(WIFICommandCnt >= 500)
		{
			if((XB_WIFI_RX_Buf[22] - '1') == 1)
			{
				WIFIStartStopFire = 1;
				WIFICommandCnt = 0;
			}
			else if((XB_WIFI_RX_Buf[22] - '1') == 2)
			{
				if(System_Status.System_Setting.Volume)
				{
					System_Status.System_Setting.Volume = 0;
				}
				else
				{
					System_Status.System_Setting.Volume = 0xff;
				}
				EEPROM_24C0x_Write(0x01, System_Status.System_Setting.Volume);
				WIFICommandCnt = 0;
			}
			else if((XB_WIFI_RX_Buf[22] - '1') == 3)
			{
				if(System_Status.System_Setting.Language)
				{
					System_Status.System_Setting.Language = 0;
				}
				else
				{
					System_Status.System_Setting.Language = 1;
				}
				EEPROM_24C0x_Write(0x00, System_Status.System_Setting.Language);
				WIFICommandCnt = 0;
			}
		}
	}
	else if(XB_WIFI_RX_Buf[2] == 'O' && XB_WIFI_RX_Buf[3] == 'K')
	{
		if(StatuSendCnt == 1)
			StatuSendCnt++;
	}
	return 1;
}

uint8_t Wait_For_Signal(char *Signal, uint16_t TimeOutms)
{
	while(TimeOutms-- > 0)
	{
		Delay_ms(1);
		if(!strncmp((char *)XB_WIFI_RX_Buf, Signal, strlen(Signal)) && RX_Frame_Data_Flag)
		{
			XB_WIFI_RX_Buf[0] = '\0';
			RX_Frame_Data_Flag = 0;
			return 0;
		}			
	}
	RX_Frame_Data_Flag = 0;
	return 1;
}

void USART3_IRQHandler(void)
{
	uint8_t i;
	if(USART_GetITStatus(USART3, USART_IT_IDLE))
	{
		DMA_Cmd(DMA1_Channel3, DISABLE);

		XB_WIFI_RX_Buf[RX_BUF_LEN - DMA_GetCurrDataCounter(DMA1_Channel3)] = '\0';
		DMA_SetCurrDataCounter(DMA1_Channel3, RX_BUF_LEN); //For receiving new data	

		i = USART3->DR;
		i = USART3->SR;
		
		if(Rx_Data_Hanndle())
		{
			RX_Frame_Data_Flag = 1;
		}
		DMA_Cmd(DMA1_Channel3, ENABLE);
	}
}


void TIM4_IRQHandler(void)
{
	
	static uint8_t Cnt;
	static uint8_t Sum;

	if(TIM_GetITStatus(TIM4, TIM_IT_Update))
	{
		if(StatuSendCnt == 0)
		{
			APSendStr[11] = '0' + WIFI_Client_Num;
			DMA1_Channel2->CCR &= (uint16_t)(~DMA_CCR1_EN);
			DMA1_Channel2->CMAR = (uint32_t)APSendStr;
			DMA1_Channel2->CNDTR = 17;
			DMA1_Channel2->CCR |= DMA_CCR1_EN;
			TIM_ClearITPendingBit(TIM4, TIM_IT_Update);
			StatuSendCnt++;
		}
		else if(StatuSendCnt == 1)
			StatuSendCnt = 0;
		else if(StatuSendCnt == 2)
		{
			StausSendBuf[0] =  System_Status.System_Setting.Alcohol_Concentration;
			StausSendBuf[1] =  System_Status.System_Setting.Language;
			StausSendBuf[2] =  System_Status.System_Setting.Temperture_Fire;
			StausSendBuf[3] =  System_Status.System_Setting.Temperture_Trough;
			StausSendBuf[4] =  System_Status.System_Setting.Volume;
			StausSendBuf[5] =  System_Status.System_Setting.WIFI;
			StausSendBuf[6] =  System_Status.System_Setting.LeakageDetect;
			
			StausSendBuf[7] =  System_Status.System_Status;
			
			StausSendBuf[8] =  (uint8_t)System_Status.Safe_Check_Result.Unsafe_Type;
			StausSendBuf[9] =  (uint8_t)(System_Status.Safe_Check_Result.Unsafe_Type >> 8);
			
			StausSendBuf[10] = (uint8_t)Temperture;
			StausSendBuf[11] = (uint8_t)((uint16_t)Temperture >> 8);
			
			//XB_ADC_Filter();
			
			StausSendBuf[12] = (uint8_t)AD_Value[0];
			StausSendBuf[13] = (uint8_t)(AD_Value[0] >> 8);
			
			StausSendBuf[14] = (uint8_t)AD_Value[1];
			StausSendBuf[15] = (uint8_t)(AD_Value[1] >> 8);
			
			StausSendBuf[16] = (uint8_t)AD_Value[2];
			StausSendBuf[17] = (uint8_t)(AD_Value[2] >> 8);
			
			StausSendBuf[18] = (GPIOA->ODR & GPIO_Pin_1)?1:0;
			StausSendBuf[19] = (GPIOA->ODR & GPIO_Pin_2)?1:0;
			StausSendBuf[20] = (GPIOB->ODR & GPIO_Pin_2)?1:0;
			StausSendBuf[21] = 0x88;
			
			StausSendBuf[22] = (GPIOA->IDR & GPIO_Pin_0)?1:0;
			StausSendBuf[23] = (GPIOC->IDR & GPIO_Pin_3)?1:0;
			StausSendBuf[24] = (GPIOA->IDR & GPIO_Pin_3)?1:0;
			StausSendBuf[25] = (GPIOA->IDR & GPIO_Pin_5)?1:0;
			StausSendBuf[26] = (GPIOA->IDR & GPIO_Pin_6)?1:0;
			StausSendBuf[27] = (GPIOA->IDR & GPIO_Pin_7)?1:0;
			
			Sum = 0;
			for(Cnt = 0; Cnt < 28; Cnt++)
			{
				Sum += StausSendBuf[Cnt];
			}
			StausSendBuf[28] = Sum;
			
			DMA1_Channel2->CCR &= (uint16_t)(~DMA_CCR1_EN);
			DMA1_Channel2->CMAR = (uint32_t)StausSendBuf;
			DMA1_Channel2->CNDTR = STATUS_SEND_BUF_LEN;
			DMA1_Channel2->CCR |= DMA_CCR1_EN;
			TIM_ClearITPendingBit(TIM4, TIM_IT_Update);
			StatuSendCnt = 0;
		}
	}
}
