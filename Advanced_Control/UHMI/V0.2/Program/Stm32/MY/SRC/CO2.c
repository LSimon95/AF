#include "CO2.h"

#define CO2_USART USART1

uint16_t CO2GetDataTimeOut;

void CO2_Init(void)
{
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
//	NVIC_InitTypeDef NVIC_InitStructure;;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

//	//**********NVIC_Init**************//
//	NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
//	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
//	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x04;
//	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x04;
//	
//	NVIC_Init(&NVIC_InitStructure);
	//********USART3_Init**************//
	USART_Cmd(CO2_USART, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = 9600;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(CO2_USART, &USART_InitStructure);

//	USART1->DR = 0x00;
//	USART_ClearFlag(CO2_USART, USART_IT_RXNE);
//	USART_ClearITPendingBit(USART1, USART_IT_RXNE);
//	USART_ITConfig(CO2_USART, USART_IT_RXNE, ENABLE);
	
	USART_Cmd(CO2_USART, ENABLE);

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

void CO2_USART_Send_Char(uint8_t Char)
{
	while(USART_GetFlagStatus(CO2_USART, USART_FLAG_TXE) == RESET)
	{
	}
	USART_SendData(CO2_USART, Char);
}

uint16_t Get_CO2_ppm(void)
{
	uint8_t Buf[9];
	uint16_t CO2_ppm = 0;
	uint8_t Cnt;
	
	Buf[Cnt] = USART_ReceiveData(CO2_USART);
	
	CO2_USART_Send_Char(0xff);
	CO2_USART_Send_Char(0x01);
	CO2_USART_Send_Char(0x86);
	CO2_USART_Send_Char(0x00);
	CO2_USART_Send_Char(0x00);
	CO2_USART_Send_Char(0x00);
	CO2_USART_Send_Char(0x00);
	CO2_USART_Send_Char(0x00);
	CO2_USART_Send_Char(0x79);
	CO2GetDataTimeOut = 0;
	for(Cnt = 0; Cnt < 9; Cnt++)
	{
		CO2GetDataTimeOut = 0;
		while(!USART_GetFlagStatus(CO2_USART, USART_FLAG_RXNE) && CO2GetDataTimeOut < 10);
		Buf[Cnt] = USART_ReceiveData(CO2_USART);
	}
	
	CO2_ppm = (((uint16_t)Buf[2] << 8 )| (uint16_t)Buf[3]);
	return CO2_ppm;
}
