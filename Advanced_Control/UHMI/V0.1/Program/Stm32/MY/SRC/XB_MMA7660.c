/*
**File_Name:      XB_MMA7660.c
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Attention:
*/
#include "XB_MMA7660.h"

void MMA7660_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	/* GPIO init */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = MMA7660_SCL_PIN;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(MMA7660_SCL_GPIO, &GPIO_InitStructure);
	
	MMA7660_SCL(1);
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(1);
	
	MMA7660_Write_Reg(0x07, 0x00);
	MMA7660_Write_Reg(0x08, 0x00);
	MMA7660_Write_Reg(0x07, 0x01);
}

void MMA7660_SDA_Type(uint8_t Type)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Type == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = MMA7660_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(MMA7660_SDA_GPIO, &GPIO_InitStructure);
	}
	else if(Type == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = MMA7660_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(MMA7660_SDA_GPIO, &GPIO_InitStructure);
		MMA7660_SDA(1);
	}
}

void MMA7660_Start(void)
{
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(1);
	Delay_10us();
	MMA7660_SCL(1);
	Delay_10us();
	MMA7660_SDA(0);
	Delay_10us();
}
void MMA7660_End(void)
{
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(0);
	Delay_10us();
	MMA7660_SCL(1);	
	Delay_10us();
	MMA7660_SDA(1);
	Delay_10us();
}

void MMA7660_Write_Byte(uint8_t Byte)
{
	uint8_t Ctr;
	MMA7660_SCL(0);
	Delay_10us();
	MMA7660_SDA_Type(OUTPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		MMA7660_SCL(0);
		Delay_10us();
		if(Byte & 0x80)
		{
			MMA7660_SDA(1);
		}
		else
		{
			MMA7660_SDA(0);
		}
		Byte <<= 1;
		Delay_10us();
		
		MMA7660_SCL(1);
		Delay_10us();
	}
	MMA7660_SCL(0);
}

uint8_t MMA7660_Read_Byte(void)
{
	uint8_t Ctr, Byte;
	MMA7660_SCL(0);
	Delay_10us();
	MMA7660_SDA_Type(INPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		MMA7660_SCL(0);
		Delay_10us();
		Byte <<= 1;
		MMA7660_SCL(1);
		Delay_10us();
		if(GPIO_ReadInputDataBit(MMA7660_SDA_GPIO, MMA7660_SDA_PIN))
		{
			Byte |= 0x01;
		}
	}
	
	MMA7660_SCL(0);
	return Byte;
}

void Ack(void)
{
	MMA7660_SCL(0);
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(0);
	Delay_10us();
	MMA7660_SCL(1);
	Delay_10us();
	MMA7660_SCL(0);
}
void No_Ack(void)
{
	MMA7660_SCL(0);
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(1);
	Delay_10us();
	MMA7660_SCL(1);
	Delay_10us();
	MMA7660_SCL(0);
}

uint8_t Wait_Ack(void)
{
	MMA7660_SDA_Type(INPUT);
	Delay_10us();
	MMA7660_SCL(1);
	Delay_10us();
	if(!GPIO_ReadInputDataBit(MMA7660_SDA_GPIO, MMA7660_SDA_PIN))
	{
		MMA7660_SCL(0);
		Delay_10us();
		return 1;
	}
	MMA7660_SCL(0);
	Delay_10us();
	return 0;
}

uint8_t MMA7660_Write_Reg(uint8_t Reg, uint8_t Byte)
{
	MMA7660_Start();
	
	MMA7660_Write_Byte(0x98);
	if(!Wait_Ack())
		return 1;
	MMA7660_Write_Byte(Reg);
	if(!Wait_Ack())
		return 1;
	MMA7660_Write_Byte(Byte);
	if(!Wait_Ack())
		return 1;
	MMA7660_End();
	return 0;
}

uint8_t MMA7660_Read_Reg(uint8_t Reg, uint8_t *Buf)
{
	MMA7660_Start();
	MMA7660_Write_Byte(0x98);
	if(!Wait_Ack())
		return 1;
	MMA7660_Write_Byte(Reg);
	if(!Wait_Ack())
		return 1;
	MMA7660_Start();
	MMA7660_Write_Byte(0x99);
	if(!Wait_Ack())
		return 1;
	Buf[0] = MMA7660_Read_Byte();
	Ack();
	Buf[1] = MMA7660_Read_Byte();
	Ack();
	Buf[2] = MMA7660_Read_Byte();
	No_Ack();
	MMA7660_End();
	return 0;
}

void Delay_10us(void)
{
	uint16_t Ctr;
	for(Ctr = 0; Ctr < 10; Ctr++)
		__nop();
}

