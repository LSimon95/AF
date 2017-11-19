#include "UHMI.h"

extern Sys_Status_StructureTypedef Sys_Status;

char number[10] = "0123456789";

void UHMI_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(USART3, USART_FLAG_TXE) == RESET)
	{
	}
	USART_SendData(USART3, Char);
}

void UHMI_USART_Send_Str(char *Str)
{
	char *Str_Send;
	Str_Send = Str;
	while(*Str_Send != '\0')
	{
		UHMI_USART_Send_Char(*Str_Send);
		Str_Send++;
	}
}

void UHMI_USART_Init(void)
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
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
}

void Display_Update(void)
{
	Sys_Status.HMI_Page = 0;
	/* Fire Status */
	if(Sys_Status.Fire_Type)
	{
		UHMI_USART_Send_Str("vis p0,1");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	else
	{
		UHMI_USART_Send_Str("vis p0,0");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	/* WIFI Status */
	if(Sys_Status.WIFI_Type)
	{
		UHMI_USART_Send_Str("vis p1,1");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	else
	{
		UHMI_USART_Send_Str("vis p1,0");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	/* Mute */
	if(Sys_Status.Volum)
	{
		UHMI_USART_Send_Str("vis p2,0");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	else
	{
		UHMI_USART_Send_Str("vis p2,1");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	/* ENG */
	if(Sys_Status.Language == 0)
	{
		UHMI_USART_Send_Str("vis p3,1");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Str("vis p4,0");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	else if(Sys_Status.Language == 1)
	{
		UHMI_USART_Send_Str("vis p3,0");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Str("vis p4,1");
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
		UHMI_USART_Send_Char(0xff);
	}
	/* Temperture */
	UHMI_USART_Send_Str("t1.txt=\"");
	UHMI_USART_Send_Char(number[Sys_Status.Temperture % 100 / 10]);
	UHMI_USART_Send_Char(number[Sys_Status.Temperture % 10]);
	UHMI_USART_Send_Char('\"');
	UHMI_USART_Send_Char(0xff);
	UHMI_USART_Send_Char(0xff);
	UHMI_USART_Send_Char(0xff);

}

void UHMI_USART_Printf(char *fmt, ...)
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
    UHMI_USART_Send_Char(TX_Buf[Cnt2]);
  }
}


