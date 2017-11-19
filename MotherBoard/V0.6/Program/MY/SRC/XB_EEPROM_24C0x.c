/*
**File_Name:      XB_EEPROM_24C0x.c
**Version:        1.0
**Date_Modified:  2016-07-01
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#include "XB_EEPROM_24C0x.h"

void EEPROM_24C0x_SDA_Mode(uint8_t Mode)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Mode == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = EEPROM_24C0x_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(EEPROM_24C0x_SDA_GPIO, &GPIO_InitStructure);
	}
	else if(Mode == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = EEPROM_24C0x_SDA_PIN;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(EEPROM_24C0x_SDA_GPIO, &GPIO_InitStructure);
		EEPROM_24C0x_SDA(1);
	}
}

void EEPROM_24C0x_Low_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_SDA(1);
}

void EEPROM_24C0x_Delay(void)
{
	uint8_t Ctr;
	for(Ctr = 0; Ctr < 1; Ctr++)
		__nop();
}

void EEPROM_24C0x_Write_Byte(uint8_t Byte)
{
	uint8_t Ctr;
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_SCL(0);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		EEPROM_24C0x_SCL(0);
		if(Byte & 0x80)
		{
			EEPROM_24C0x_SDA(1);
		}
		else
		{
			EEPROM_24C0x_SDA(0);
		}
		Byte <<= 1;
		EEPROM_24C0x_Delay();
		EEPROM_24C0x_SCL(1);
		EEPROM_24C0x_Delay();
	}
	EEPROM_24C0x_SCL(0);
}

uint8_t EEPROM_24C0x_Read_Byte(void)
{
	uint8_t Ctr, Byte = 0x00; 
	EEPROM_24C0x_SDA_Mode(INPUT);
	for(Ctr = 0; Ctr < 8; Ctr++)
	{
		EEPROM_24C0x_SCL(0);
		EEPROM_24C0x_Delay();
		EEPROM_24C0x_SCL(1);
		EEPROM_24C0x_Delay();
		Byte <<= 1;
		if(GPIO_ReadInputDataBit(EEPROM_24C0x_SDA_GPIO, EEPROM_24C0x_SDA_PIN))
		{
			Byte |= 0x01;
		}
	}
	EEPROM_24C0x_SCL(0);
	return Byte;
}

void EEPROM_24C0x_ACK(void)
{
	EEPROM_24C0x_SCL(0);
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SDA(0);
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SCL(0);
}

void EEPROM_24C0x_No_ACK(void)
{
	EEPROM_24C0x_SCL(0);
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SDA(1);
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SCL(0);
}

uint8_t EEPROM_24C0x_Wait_ACK(void)
{
	uint8_t Flag = 0;
	EEPROM_24C0x_SCL(0);
	EEPROM_24C0x_SDA_Mode(INPUT);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_Delay();
	if(GPIO_ReadInputDataBit(EEPROM_24C0x_SDA_GPIO, EEPROM_24C0x_SDA_PIN) == 0)
	{
		Flag = 1;
	}
	else
	{
		Flag = 0;
	}
	EEPROM_24C0x_SCL(0);
	return Flag;
}

void EEPROM_24C0x_Start(void)
{
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_SDA(1);
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SDA(0);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SCL(0);
}

void EEPROM_24C0x_End(void)
{
	EEPROM_24C0x_SDA_Mode(OUTPUT);
	EEPROM_24C0x_SDA(0);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SCL(1);
	EEPROM_24C0x_Delay();
	EEPROM_24C0x_SDA(1);
}

uint8_t EEPROM_24C0x_Write(uint8_t Address, uint8_t Byte)
{
	EEPROM_24C0x_Start();
	EEPROM_24C0x_Write_Byte(EEPROM_ADDRESS & 0xfe);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	EEPROM_24C0x_Write_Byte(Address);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	EEPROM_24C0x_Write_Byte(Byte);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	EEPROM_24C0x_End();
	return NULL;
}

uint8_t EEPROM_24C0x_Read(uint8_t Address)
{
	uint8_t Byte;
	EEPROM_24C0x_Start();
	EEPROM_24C0x_Write_Byte(EEPROM_ADDRESS & 0xfe);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	EEPROM_24C0x_Write_Byte(Address);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	EEPROM_24C0x_Start();
	EEPROM_24C0x_Write_Byte(EEPROM_ADDRESS | 0x01);
	if(!EEPROM_24C0x_Wait_ACK())
		return 1;
	Byte = EEPROM_24C0x_Read_Byte();
	EEPROM_24C0x_No_ACK();
	EEPROM_24C0x_End();
	return Byte;
}
