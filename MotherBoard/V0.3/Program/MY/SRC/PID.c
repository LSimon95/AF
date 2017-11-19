#include "PID.h"
#include "stdarg.h"	 	 
#include "stdio.h"	 	 
#include "string.h"	 
#include "delay.h"	
#include "math.h"
uint8_t Buf[30];
uint8_t PC_Request_PID_Cmd[] = {0xaa, 0xaf, 0x02, 0x01,  '\0'};
uint8_t PC_PID_Change_Cmd[] = {0xaa, 0xaf, 0x10, 0x12, '\0'};
uint16_t Time_Wait;

DMA_InitTypeDef USART1_DMA_InitStructure;

float Roll_Sum;
float dRoll;
float Last_Roll = 0;

float Roll_P =6;
float Roll_I = 2.5;
float Roll_D = 30;
float Pitch_P;
float Pitch_I;
float Pitch_D;
float Yaw_P;
float Yaw_I;
float Yaw_D;

extern int Speed_R;
extern int Speed_L;

uint8_t Str_Compare(char *Str1, char *Str2, uint16_t Len) 
{
	uint8_t Comfir_Flag;
	Comfir_Flag = 1;
	if(Len == 0)
	{
		while(*Str1 != '\0' && *Str1 != '\n' && *Str2 != '\0' && *Str2 != '\n')
		{
			if(*Str1 != *Str2)
			{
				Comfir_Flag = 0;
				break;
			}
			Str1++;Str2++;
		}			
	}
	else
	{
		while(Len--)
		{
			if(*Str1 != *Str2)
			{
				Comfir_Flag = 0;
				break;
			}
			Str1++;Str2++;
		}
	}
	return Comfir_Flag;
} 

void USART1_NVIC_Init(void)
{
    NVIC_InitTypeDef NVIC_InitStructure;
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_0);
    NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&NVIC_InitStructure);
}

void USART1_GPIO_Init(void)
{
	USART_InitTypeDef USART_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;

	//***********RCC_Init***************//
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);

	USART1_NVIC_Init();
	
	/*USART1 DMA Init*/
  /* I2C TX DMA Channel configuration */
  DMA_DeInit(DMA1_Channel5);
  USART1_DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&USART1->DR;
  USART1_DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)&Buf[0];   
  USART1_DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC; 
  USART1_DMA_InitStructure.DMA_BufferSize = sizeof(Buf);;
  USART1_DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  USART1_DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  USART1_DMA_InitStructure.DMA_PeripheralDataSize = DMA_MemoryDataSize_Byte;
  USART1_DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
  USART1_DMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
  USART1_DMA_InitStructure.DMA_Priority = DMA_Priority_Medium;
  USART1_DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
  DMA_Init(DMA1_Channel5, &USART1_DMA_InitStructure);  

	//********USART1_Init**************//
	USART_Cmd(USART1, DISABLE);

	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_BaudRate = 115200;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;

	USART_Init(USART1, &USART_InitStructure);

	USART_DMACmd(USART1, USART_DMAReq_Rx, ENABLE);
	USART_Cmd(USART1, ENABLE);
	USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
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

int PID_Roll(float Roll,float ww)
{
	int PWM_Pulse_Value;
	dRoll = ww;
	Last_Roll = Roll;
	if (Roll<10&&Roll>-10)
	{
		Roll_Sum += Roll;
		Roll_P = sqrt(fabs(Roll)) * 18;
	}
	else Roll_P=60;
	if((Roll > 30 || Roll < -30)) 
	{
		return 0;
	}
	
	if(Roll_Sum < Integal_Min)
		Roll_Sum = Integal_Min;
	else if(Roll_Sum > Integal_Max)
		Roll_Sum = Integal_Max;
	PWM_Pulse_Value = -Roll_P * Roll + -Roll_I * Roll_Sum + Roll_D * dRoll + (-0.00014 * (float)(Speed_R * fabs((float)Speed_R)));
	
	return PWM_Pulse_Value;
}


void Data_Send_PID(void)
{
	uint8_t _cnt = 0, i;
	uint8_t sum = 0;
	vs16 _temp;
	uint8_t data_to_send[20];
	data_to_send[_cnt++]=0xAA;
	data_to_send[_cnt++]=0xAA;
	data_to_send[_cnt++]=0x10;
	data_to_send[_cnt++]=0;
	
	_temp = (int)(Roll_P * 100);
	data_to_send[_cnt++]=BYTE1(_temp);
	data_to_send[_cnt++]=BYTE0(_temp);
	_temp = (int)(Roll_I * 100);
	data_to_send[_cnt++]=BYTE1(_temp);
	data_to_send[_cnt++]=BYTE0(_temp);
	_temp = (int)(Roll_D * 1000);
	data_to_send[_cnt++]=BYTE1(_temp);
	data_to_send[_cnt++]=BYTE0(_temp);
	
	data_to_send[3] = _cnt-4;
	
	for(i = 0;i<_cnt;i++)
		sum += data_to_send[i];
	data_to_send[_cnt++] = sum;

	for(i = 0; i < _cnt; i++)
	{
		while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
		USART_SendData(USART1, data_to_send[i]);
	}
	
}
void Get_PID_PC(void)
{
	Roll_P = ((float)((uint16_t)Buf[4] << 8 |  (uint16_t)Buf[5]) / 100);
	Roll_I = ((float)((uint16_t)Buf[6] << 8 |  (uint16_t)Buf[7]) / 100);
	Roll_D = ((float)((uint16_t)Buf[8] << 8 |  (uint16_t)Buf[9]) / 1000);
}

void Data_Send_Check(uint16_t Check)
{
	uint8_t data_to_send[20], i, Sum = 0;
	data_to_send[0] = 0xAA;
	data_to_send[1] = 0xAA;
	data_to_send[2] = 0xF0;
	data_to_send[3] = 3;
	data_to_send[4] = 0xBA;
	
	data_to_send[5] = BYTE1(Check);
	data_to_send[6] = BYTE0(Check);
	
	
	for(i = 0;i < 7; i++)
		Sum += data_to_send[i];
	
	data_to_send[7] = Sum;

	for(i = 0; i < 8; i++)
	{
		while(USART_GetFlagStatus(USART1, USART_FLAG_TXE) == RESET);
		USART_SendData(USART1, data_to_send[i]);
	}
}

void PC_Command_Select(void)
{
	switch(Buf[2])
	{
		case 0x02:
			Data_Send_PID();
			break;
		case 0x10:
			Get_PID_PC();
			Data_Send_Check(Buf[22]);
			break;
		case 0x11:
			Data_Send_Check(Buf[22]);
			break;
		case 0x12:
			Data_Send_Check(Buf[22]);
			break;
		case 0x13:
			Data_Send_Check(Buf[22]);
			break;
		case 0x14:
			Data_Send_Check(Buf[22]);
			break;
		case 0x15:
			Data_Send_Check(Buf[16]);
			break;
		default:
			break;
	}
}

void USART1_IRQHandler(void)
{
	if(USART_GetITStatus(USART1, USART_IT_RXNE) == SET)
	{
		USART_ClearITPendingBit(USART1, USART_IT_RXNE);
		USART1_DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)&Buf[0];
		DMA_Init(DMA1_Channel5, &USART1_DMA_InitStructure);
		DMA_Cmd(DMA1_Channel5, ENABLE);
		Time_Wait = 20000;
		while(Time_Wait-- > 0);
		if(Buf[0] == 0xAA && Buf[1] == 0xAF)
		{
			PC_Command_Select();
		}
		DMA_Cmd(DMA1_Channel5, DISABLE);
	}		
}

























