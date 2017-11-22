/*
**File_Name:      XB_MMA845x.c
**Version:        1.0
**Date_Modified:  2016-07-17
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#include "XB_MMA845x.h"

void MMA845x_Init(void)
{
	
	GPIO_InitTypeDef GPIO_InitStructure;
	/* GPIO init */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = MMA845x_SCL_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(MMA845x_SCL_GPIO, &GPIO_InitStructure);
	
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_NoJTRST, ENABLE);
	
	MMA845x_SCL(1);
	MMA845x_SDA_Type(OUTPUT);
	MMA845x_SDA(1);
	
	MMA845x_Write_Reg(0x0e, 0x00); //2g
	MMA845x_Write_Reg(0x2a, 0x01); //Active Mode
	MMA845x_Write_Reg(0x2b, 0x02); //High Resolution
}

void MMA845x_SDA_Type(uint8_t Type)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Type == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = MMA845x_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(MMA845x_SDA_GPIO, &GPIO_InitStructure);
	}
	else if(Type == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = MMA845x_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(MMA845x_SDA_GPIO, &GPIO_InitStructure);
		MMA845x_SDA(1);
	}
}

void MMA845x_Start(void)
{
	MMA845x_SDA_Type(OUTPUT);
	MMA845x_SDA(1);
	Delay_10us();
	MMA845x_SCL(1);
	Delay_10us();
	MMA845x_SDA(0);
	Delay_10us();
}
void MMA845x_End(void)
{
	MMA845x_SDA_Type(OUTPUT);
	MMA845x_SDA(0);
	Delay_10us();
	MMA845x_SCL(1);	
	Delay_10us();
	MMA845x_SDA(1);
	Delay_10us();
}

void MMA845x_Write_Byte(uint8_t Byte)
{
	uint8_t Ctr;
	MMA845x_SCL(0);
	Delay_10us();
	MMA845x_SDA_Type(OUTPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		MMA845x_SCL(0);
		Delay_10us();
		if(Byte & 0x80)
		{
			MMA845x_SDA(1);
		}
		else
		{
			MMA845x_SDA(0);
		}
		Byte <<= 1;
		Delay_10us();
		
		MMA845x_SCL(1);
		Delay_10us();
	}
	MMA845x_SCL(0);
}

uint8_t MMA845x_Read_Byte(void)
{
	uint8_t Ctr, Byte;
	MMA845x_SCL(0);
	Delay_10us();
	MMA845x_SDA_Type(INPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		MMA845x_SCL(0);
		Delay_10us();
		Byte <<= 1;
		MMA845x_SCL(1);
		Delay_10us();
		if(GPIO_ReadInputDataBit(MMA845x_SDA_GPIO, MMA845x_SDA_PIN))
		{
			Byte |= 0x01;
		}
	}
	
	MMA845x_SCL(0);
	return Byte;
}

void Ack(void)
{
	MMA845x_SCL(0);
	MMA845x_SDA_Type(OUTPUT);
	MMA845x_SDA(0);
	Delay_10us();
	MMA845x_SCL(1);
	Delay_10us();
	MMA845x_SCL(0);
}
void No_Ack(void)
{
	MMA845x_SCL(0);
	MMA845x_SDA_Type(OUTPUT);
	MMA845x_SDA(1);
	Delay_10us();
	MMA845x_SCL(1);
	Delay_10us();
	MMA845x_SCL(0);
}

uint8_t Wait_Ack(void)
{
	MMA845x_SDA_Type(INPUT);
	Delay_10us();
	MMA845x_SCL(1);
	Delay_10us();
	if(!GPIO_ReadInputDataBit(MMA845x_SDA_GPIO, MMA845x_SDA_PIN))
	{
		MMA845x_SCL(0);
		Delay_10us();
		return 1;
	}
	MMA845x_SCL(0);
	Delay_10us();
	return 0;
}

uint8_t MMA845x_Write_Reg(uint8_t Reg, uint8_t Byte)
{
	MMA845x_Start();
	
	MMA845x_Write_Byte(0x38);
	if(!Wait_Ack())
		return 1;
	MMA845x_Write_Byte(Reg);
	if(!Wait_Ack())
		return 1;
	MMA845x_Write_Byte(Byte);
	if(!Wait_Ack())
		return 1;
	MMA845x_End();
	return 0;
}

uint8_t MMA845x_Read_ACC_Buf(uint8_t Reg, uint8_t *Buf)
{
	MMA845x_Start();
	MMA845x_Write_Byte(0x38);
	if(!Wait_Ack())
		return 1;
	MMA845x_Write_Byte(Reg);
	if(!Wait_Ack())
		return 1;
	MMA845x_Start();
	MMA845x_Write_Byte(0x39);
	if(!Wait_Ack())
		return 1;
	
	Buf[1] = MMA845x_Read_Byte();
	Ack();
	Buf[0] = MMA845x_Read_Byte();
	Ack();
	Buf[3] = MMA845x_Read_Byte();
	Ack();
	Buf[2] = MMA845x_Read_Byte();
	Ack();
	Buf[5] = MMA845x_Read_Byte();
	Ack();
	Buf[4] = MMA845x_Read_Byte();
	No_Ack();
	
	MMA845x_End();
	return 0;
}

void Delay_10us(void)
{
	uint16_t Ctr;
	for(Ctr = 0; Ctr < 10; Ctr++)
		__nop();
}
