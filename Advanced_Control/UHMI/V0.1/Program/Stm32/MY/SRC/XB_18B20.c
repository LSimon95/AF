/*
**File_Name:      XB_18B20.c
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Attention:
*/
#include "XB_18B20.h"

void XB_18B20_IO_Mode(uint8_t Mode)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Mode == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = Temp_18B20_IO_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(Temp_18B20_IO_GPIO, &GPIO_InitStructure);
	}
	else if(Mode == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = Temp_18B20_IO_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(Temp_18B20_IO_GPIO, &GPIO_InitStructure);
		Temp_18B20_IO(1);
	}
}
void XB_18B20_Low_Init(void)
{
	XB_18B20_IO_Mode(INPUT);
}
void XB_18B20_Delay_10us(uint8_t T)
{
	uint8_t Ctr1, Ctr2;
	for(Ctr1 = 0; Ctr1 < T; Ctr1++)
	{
		for(Ctr2 = 0; Ctr2 < 75; Ctr2++)
			__nop();            //Nothing to do for waitting
	}
}

uint8_t XB_18B20_Reset(void)
{
	uint16_t j;
	XB_18B20_IO_Mode(OUTPUT);
	Temp_18B20_IO(0);
	XB_18B20_Delay_10us(70);
	XB_18B20_IO_Mode(INPUT);
	j = 0;
	while(GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN) && ((j++) < 100))
		XB_18B20_Delay_10us(1);
	if(j >= 100)
		return 1;
	j = 0;
	while(!GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN) && ((j++) < 100))
		XB_18B20_Delay_10us(1);
	if(j >= 1000)
		return 1;
	XB_18B20_Delay_10us(50);
	return NULL;
}

uint8_t XB_18B20_Read_Byte(void)
{
	uint8_t Ctr, Byte = 0x00;
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		Byte >>= 1;
		XB_18B20_IO_Mode(OUTPUT);
		Temp_18B20_IO(0);
		XB_18B20_Delay_10us(1);
		XB_18B20_IO_Mode(INPUT);
		if(GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN))
		{
			Byte |= 0x80;
		}
		XB_18B20_Delay_10us(3);
	}
	return Byte;
}

void XB_18B20_Write_Byte(uint8_t Byte)
{
	uint8_t i;
	XB_18B20_IO_Mode(OUTPUT);
	for(i = 0; i < 8; i++)
	{
		Temp_18B20_IO(0);
		XB_18B20_Delay_10us(1);
		if(Byte & 0x01)
		{
			Temp_18B20_IO(1);
		}
		else
		{
			Temp_18B20_IO(0);
		}
		XB_18B20_Delay_10us(3);
		Byte >>= 1;
		Temp_18B20_IO(1);
		XB_18B20_Delay_10us(1);
	}
	XB_18B20_IO_Mode(INPUT);
}

int16_t XB_18B20_Math_Temperture(int16_t Original_Value)
{
	int16_t Real_Value;
	long int Temperture;
	Temperture = (long int)Original_Value * 625;
	Real_Value = (int16_t)(( Temperture % 1000000 / 100000) * 100) + (int16_t)((Temperture % 100000 / 10000) * 10) + (int16_t)((Temperture % 10000 / 1000));
	return Real_Value;
}

void XB_18B20_Init(void)
{
	XB_18B20_Low_Init();
	XB_18B20_Reset();
	XB_18B20_Write_Byte(0xcc);
	XB_18B20_Write_Byte(0x4e);
	XB_18B20_Write_Byte(0xff);
	XB_18B20_Write_Byte(0xff);
	XB_18B20_Write_Byte(0x00);
	XB_18B20_Write_Byte(0x00);
	XB_18B20_Write_Byte(0x1f);
}

void XB_18B20_Start_Convert(void)
{
	XB_18B20_Reset();
	XB_18B20_Write_Byte(0xcc); //Start Convert
	XB_18B20_Write_Byte(0x44);
}

int16_t XB_18B20_Get_Temperture(void)
{
	uint8_t Bytel, Byteh;
	int16_t Int, Temperture;
	XB_18B20_Reset();
	XB_18B20_Write_Byte(0xcc);
	XB_18B20_Write_Byte(0xbe);
	Bytel = XB_18B20_Read_Byte();
	Byteh = XB_18B20_Read_Byte();
	Int = Byteh;
	Int <<= 8;
	Int = Int | Bytel;
	Temperture = XB_18B20_Math_Temperture(Int);
	return Temperture;
}
