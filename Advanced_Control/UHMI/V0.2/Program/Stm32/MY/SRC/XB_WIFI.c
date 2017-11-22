/*
**File_Name:      XB_WIFI.c
**Version:        1.1
**Date_Modified:  2016-07-18
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Attention:
Rewrite XB_USART_Init() and USARTx
7-18 Repair Rx Bug
*/

/* 

Fire - Remoter      : 01 (status(01 - OFF)(02 - ON)) 00(Temperture)

*/

#include "XB_WIFI.h"
#include "main.h"

uint8_t XB_WIFI_RX_Buf[RX_BUF_LEN];
uint8_t XB_WIFI_RX_USER_Buf[RX_BUF_LEN];

XB_WIFI_TypedefStructure *XB_WIFI_Structure_I;

uint8_t RX_Frame_Data_Flag = 0;
uint8_t RX_Frame_User_Data_Flag = 0;

extern Sys_Status_StructureTypedef Sys_Status;

void XB_USART_Init(uint32_t Boud_Rate)
{
	DMA_InitTypeDef DMA_InitStructure;
	NVIC_InitTypeDef NVIC_InitStructure;
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);

	//**************DMA_Init************//
	//DMA_DeInit(DMA1_Channel6);
	DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(USART1->DR);//设置DMA外设地址
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
	
  DMA_Init(DMA1_Channel5, &DMA_InitStructure);
	
	DMA_Cmd(DMA1_Channel5, ENABLE);
	//**********NVIC_Init**************//
	NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x03;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x03;
	
	NVIC_Init(&NVIC_InitStructure);
	//********USART2_Init**************//
	USART_Cmd(USART1, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = Boud_Rate;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART1, &USART_InitStructure);
	
	USART_ITConfig(USART1, USART_IT_IDLE, ENABLE);

	USART_DMACmd(USART1, USART_DMAReq_Rx, ENABLE);

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

void XB_WIFI_USART_Send_Char(uint8_t Byte)
{
	while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET)
	{
	}
		USART_SendData(USART1, Byte);
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

uint8_t XB_WIFI_STA_Send_Str(char *fmt, ...)
{
	uint16_t Cnt1, Cnt2;
	uint8_t TX_Buf[MAX_SEND_LEN];
	
	va_list ap;
	va_start(ap, fmt);
	vsprintf((char *)TX_Buf, fmt, ap);
	va_end(ap);
	Cnt1 = strlen((const char*)TX_Buf);
	
	XB_WIFI_Send_Str(1, "AT+CIPSEND=%d", Cnt1);
	if(Wait_For_Signal("\r\nOK\r\n> ", 500))
	{
		for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
		{
			XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
		}
		if(Wait_For_Signal("\r\nSEND OK\r\n", 1000))
				return 1;
		return 0;
	}
	
	for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
	{
		XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
	}
	if(Wait_For_Signal("\r\nSEND OK\r\n", 1000))
				return 1;
	return 0;
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
			XB_WIFI_Send_Str(1, "AT+CIPSEND=%d,%d", XB_WIFI_Structure_I->Client_ID[Cnt3], Cnt1);

			if(Wait_For_Signal("\r\nOK\r\n> ", 5000))
				return 1;

			for(Cnt2 = 0; Cnt2 < Cnt1; Cnt2++)
			{
				XB_WIFI_USART_Send_Char(TX_Buf[Cnt2]);
			}
			
			if(Wait_For_Signal("\r\nSEND OK\r\n", 5000))
				return 1;
		}
	}
	else	//Send Select
	{
		for(Cnt3 = 0; Cnt3 < XB_WIFI_Structure_I->Client_Num; Cnt3++)
		{
			XB_WIFI_Send_Str(1, "AT+CIPSEND=%d,%d", XB_WIFI_Structure_I->Client_ID[Client_Num], Cnt1);

			if(Wait_For_Signal("\r\nOK\r\n> ", 5000))
				return 1;

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
//	if(Wait_For_Signal("\r\nOK\r\n", 5000))
//		return 1;
//	if(Wait_For_Signal("\r\nready\r\n", 5000))
//		return 1;
		Delay_ms(1000);
	
	/* Turn OFF Command Feedback */
	XB_WIFI_Send_Str(1, "ATE0");
	Delay_ms(500);
	
	/* Build AP */
	XB_WIFI_Send_Str(1, "AT+CWJAP=\"%s\",\"%s\"", 
									XB_WIFI_Structure->AP_Name,
									XB_WIFI_Structure->AP_Pass);
	
	if(Wait_For_Signal("\r\nOK\r\n", 10000))
		return 1;
	
	/* CIPMUX */
	XB_WIFI_Send_Str(1, "AT+CIPSTART=\"TCP\",\"192.168.4.1\",8080");
	if(Wait_For_Signal("CONNECT\r\n\r\nOK\r\n", 10000))
		return 1;
	
	return 0;
}



uint8_t Rx_Data_Hanndle(void)
{
	uint8_t Cnt;
	if(!XB_WIFI_RX_Buf[0])
		return 1;
	if(XB_WIFI_RX_Buf[2] == '+' && XB_WIFI_RX_Buf[3] == 'I')
	{
		RX_Frame_User_Data_Flag = 1;
		for(Cnt = 0; Cnt < 40; Cnt++)
			XB_WIFI_RX_USER_Buf[Cnt] = XB_WIFI_RX_Buf[Cnt];
		
		if(XB_WIFI_RX_Buf[40] == 'O' && XB_WIFI_RX_Buf[41] == 'K')
		{
			for(Cnt = 0; Cnt < 8; Cnt++)
			{
				XB_WIFI_RX_Buf[Cnt] = XB_WIFI_RX_Buf[Cnt + 38];
			}
			return 1;
		}
		else if(XB_WIFI_RX_Buf[40] == 'S' && XB_WIFI_RX_Buf[41] == 'E')
		{
			for(Cnt = 0; Cnt < 11; Cnt++)
			{
				XB_WIFI_RX_Buf[Cnt] = XB_WIFI_RX_Buf[Cnt + 38];
			}
			return 1;
		}
		return 0;
	}
	return 1;
}

uint8_t Wait_For_Signal(char *Signal, uint16_t TimeOutms)
{
	while(TimeOutms-- > 0)
	{
		Delay_ms(1);
		if(RX_Frame_Data_Flag  && !strncmp((char *)XB_WIFI_RX_Buf, Signal, strlen(Signal)))
		{
			XB_WIFI_RX_Buf[0] = '\0';
			RX_Frame_Data_Flag = 0;
			return 0;
		}			
	}
	RX_Frame_Data_Flag = 0;
	return 1;
}

void USART1_IRQHandler(void)
{
	uint8_t i;
	if(USART_GetITStatus(USART1, USART_IT_IDLE))
	{
		DMA_Cmd(DMA1_Channel5, DISABLE);

		XB_WIFI_RX_Buf[RX_BUF_LEN - DMA_GetCurrDataCounter(DMA1_Channel5)] = '\0';
		DMA_SetCurrDataCounter(DMA1_Channel5, RX_BUF_LEN); //For receiving new data	

		i = USART1->DR;
		i = USART1->SR;
		
		if(Rx_Data_Hanndle())
		{
			RX_Frame_Data_Flag = 1;
		}
		DMA_Cmd(DMA1_Channel5, ENABLE);
	}
}

