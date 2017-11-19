#include "DS1302.h"

uint8_t DS1302_Time[7];

void DS1302_IO_Mode(uint8_t Mode)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Mode == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = DS1302_IO_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(DS1302_IO_GPIO, &GPIO_InitStructure);
	}
	else if(Mode == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = DS1302_IO_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(DS1302_IO_GPIO, &GPIO_InitStructure);
		DS1302_IO(1);
	}
}

void DS1302_Low_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	DS1302_SCL(0);
	DS1302_IO_Mode(OUTPUT);
	DS1302_IO(0);
}

void DS1302_Delay(void)
{
	uint8_t Ctr;
	for(Ctr = 0; Ctr < 40; Ctr++)
		__nop();
}

void DS1302_Write_Byte(uint8_t Byte)
{
	uint8_t Ctr;
	DS1302_IO_Mode(OUTPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		DS1302_SCL(0);
		DS1302_Delay();
		DS1302_IO((Byte & 0x01));
		Byte >>= 1;
		DS1302_SCL(1);
		DS1302_Delay();
	}
	DS1302_SCL(0);
	DS1302_IO(0);
}

uint8_t DS1302_Read_Byte(void)
{
	uint8_t Ctr, Byte = 0x00;
	DS1302_IO_Mode(INPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		DS1302_SCL(0);
		DS1302_Delay();
		Byte >>= 1;
		if(GPIO_ReadInputDataBit(DS1302_IO_GPIO, DS1302_IO_PIN))
		{
			Byte |= 0x80;
		}
		DS1302_SCL(1);
		DS1302_Delay();
	}
	DS1302_SCL(0);
	DS1302_IO(0);
	return Byte;
}

void DS1302_Init(void)
{
	DS1302_Low_Init();
	DS1302_SCL(0);
	DS1302_RST(0);
	DS1302_Delay();
	DS1302_RST(1);
	DS1302_Delay();
	DS1302_Write_Byte(0x8e); //Clear the WP bit before writing
	DS1302_Write_Byte(0x00);
	DS1302_RST(0);
	DS1302_Delay();
	DS1302_RST(1);
	DS1302_Delay();
	DS1302_Write_Byte(0x81);
	if(DS1302_Read_Byte() & 0x80) //if DS1302 Clock is stop
	{
		DS1302_RST(0);	//Enable DS1302
		DS1302_Delay();
		DS1302_RST(1);
		DS1302_Delay();
		DS1302_Write_Byte(0x80);
		DS1302_Write_Byte(0x00);
	}
	else
		DS1302_RST(0);
}

void DS1302_Update_Time(void)
{
	uint8_t Ctr;
	DS1302_RST(1);
	DS1302_Delay();
	DS1302_Write_Byte(0xbf);	//Burst mode
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		DS1302_Time[Ctr] = DS1302_Read_Byte();
	}
	DS1302_RST(0);
}
