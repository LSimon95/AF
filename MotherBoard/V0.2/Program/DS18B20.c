#include "DS18B20.h"

void Delay_10us(uint8_t t)
{
	uint8_t i, j;
	for(i = 0; i < t; i++)
	{
		for(j = 0; j < 16; j++)
			NOP();                //Nothing to do for waitting
	}
}

uint8_t DS18B20_Reset(void)
{
	uint16_t j;
	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_HIGH_SLOW);
	GPIO_WriteLow(GPIOA, GPIO_PIN_5);
	Delay_10us(70);
	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
	j = 0;
	while(GPIO_ReadInputPin(GPIOA, GPIO_PIN_5) && ((j++) < 100))
		Delay_10us(1);
	if(j >= 10000)
		return DS18B20_RESET_FAILED;
	j = 0;
	while(!GPIO_ReadInputPin(GPIOA, GPIO_PIN_5) && ((j++) < 5000))
		Delay_10us(1);
	if(j >= 5000)
		return DS18B20_RESET_FAILED;
	Delay_10us(50);
	return NULL;
}

uint8_t DS18B20_Read_Byte(void)
{
	uint8_t i, Byte = 0x00;
	for(i = 0; i < 8; i++)
	{
		Byte >>= 1;
		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_SLOW);
		Delay_10us(1);
		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
		if(GPIO_ReadInputPin(GPIOA, GPIO_PIN_5))
			Byte |= 0x80;
		Delay_10us(5);
	}
	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
	return Byte;
}

void DS18B20_Write_Byte(uint8_t Byte)
{
	uint8_t i;
	for(i = 0; i < 8; i++)
	{
		GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_SLOW);
		Delay_10us(1);
		if(Byte & 0x01)
			GPIO_WriteHigh(GPIOA, GPIO_PIN_5);
		else
			GPIO_WriteLow(GPIOA, GPIO_PIN_5);
		Delay_10us(3);
		Byte >>= 1;
		GPIO_WriteHigh(GPIOA, GPIO_PIN_5);
	}
	GPIO_Init(GPIOA, GPIO_PIN_5, GPIO_MODE_IN_PU_NO_IT);
}

uint16_t DS18B20_Math_Temperture(uint16_t Original_Value)
{
	uint16_t Real_Value;
	long int Temperture;
	Temperture = (long int)Original_Value * 625;
	Real_Value = (uint16_t)(( Temperture % 1000000 / 100000) * 100) + (uint16_t)((Temperture % 100000 / 10000) * 10) + (uint16_t)((Temperture % 10000 / 1000));
	return Real_Value;
}

uint16_t DS18B20_Get_Temperture(void)
{
	uint8_t Bytel, Byteh;
	uint16_t Int, Temperture;
	DS18B20_Reset();
	DS18B20_Write_Byte(0xcc);
	DS18B20_Write_Byte(0x44);
	Delay_10us(100);
	DS18B20_Reset();
	DS18B20_Write_Byte(0xcc);
	DS18B20_Write_Byte(0xbe);
	Bytel = DS18B20_Read_Byte();
	Byteh = DS18B20_Read_Byte();
	Int = Byteh;
	Int <<= 8;
	Int = Int | Bytel;
	Temperture = DS18B20_Math_Temperture(Int);
	return Temperture;
}