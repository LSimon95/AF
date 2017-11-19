#include "Temp_18B20.h"

void Temp_18B20_Delay_10us(uint8_t T)
{
	uint8_t Ctr1, Ctr2;
	for(Ctr1 = 0; Ctr1 < T; Ctr1++)
	{
		for(Ctr2 = 0; Ctr2 < 75; Ctr2++)
			__nop();            //Nothing to do for waitting
	}
}

void Temp_18B20_IO_Mode(uint8_t Mode)
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

void Temp_18B20_Low_Init(void)
{
	Temp_18B20_IO_Mode(INPUT);
}

uint8_t Temp_18B20_Reset(void)
{
	uint16_t j;
	Temp_18B20_IO_Mode(OUTPUT);
	Temp_18B20_IO(0);
	Temp_18B20_Delay_10us(70);
	Temp_18B20_IO_Mode(INPUT);
	j = 0;
	while(GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN) && ((j++) < 100))
		Temp_18B20_Delay_10us(1);
	if(j >= 100)
		return 1;
	j = 0;
	while(!GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN) && ((j++) < 100))
		Temp_18B20_Delay_10us(1);
	if(j >= 1000)
		return 1;
	Temp_18B20_Delay_10us(50);
	return NULL;
}

uint8_t Temp_18B20_Read_Byte(void)
{
	uint8_t Ctr, Byte = 0x00;
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		Byte >>= 1;
		Temp_18B20_IO_Mode(OUTPUT);
		Temp_18B20_IO(0);
		Temp_18B20_Delay_10us(1);
		Temp_18B20_IO_Mode(INPUT);
		if(GPIO_ReadInputDataBit(Temp_18B20_IO_GPIO, Temp_18B20_IO_PIN))
		{
			Byte |= 0x80;
		}
	}
	return Byte;
}

void Temp_18B20_Write_Byte(uint8_t Byte)
{
	uint8_t i;
	Temp_18B20_IO_Mode(OUTPUT);
	for(i = 0; i < 8; i++)
	{
		Temp_18B20_IO(0);
		Temp_18B20_Delay_10us(1);
		if(Byte & 0x01)
		{
			Temp_18B20_IO(1);
		}
		else
		{
			Temp_18B20_IO(0);
		}
		Temp_18B20_Delay_10us(3);
		Byte >>= 1;
		Temp_18B20_IO(1);
		Temp_18B20_Delay_10us(1);
	}
	Temp_18B20_IO_Mode(INPUT);
}

uint16_t Temp_18B20_Math_Temperture(uint16_t Original_Value)
{
	uint16_t Real_Value;
	long int Temperture;
	Temperture = (long int)Original_Value * 625;
	Real_Value = (uint16_t)(( Temperture % 1000000 / 100000) * 100) + (uint16_t)((Temperture % 100000 / 10000) * 10) + (uint16_t)((Temperture % 10000 / 1000));
	return Real_Value;
}

uint16_t Temp_18B20_Get_Temperture(void)
{
	uint8_t Bytel, Byteh;
	uint16_t Int, Temperture;
	Temp_18B20_Reset();
	Temp_18B20_Write_Byte(0xcc); //CC 44
	Temp_18B20_Write_Byte(0x44);
	Temp_18B20_Delay_10us(100);
	Temp_18B20_Reset();
	Temp_18B20_Write_Byte(0xcc);
	Temp_18B20_Write_Byte(0xbe);
	Bytel = Temp_18B20_Read_Byte();
	Byteh = Temp_18B20_Read_Byte();
	Int = Byteh;
	Int <<= 8;
	Int = Int | Bytel;
	Temperture = Temp_18B20_Math_Temperture(Int);
	return Temperture;
}
