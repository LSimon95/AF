#include "MMA7660.h"

void MMA7660_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	/* GPIO init */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	MMA7660_SCL(1);
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SDA(1);
}

void MMA7660_SDA_Type(uint8_t Type)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	if(Type == INPUT)
	{
		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
		GPIO_Init(GPIOB, &GPIO_InitStructure);
	}
	else if(Type == OUTPUT)
	{
		GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1;
		GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
		GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
		GPIO_Init(GPIOB, &GPIO_InitStructure);
		MMA7660_SDA(1);
	}
}

void MMA7660_Start(void)
{
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SCL(1);
	MMA7660_SDA(0);
	Delay_10us();
	Delay_10us();

}
void MMA7660_End(void)
{
	MMA7660_SDA_Type(OUTPUT);
	MMA7660_SCL(1);	
	MMA7660_SDA(1);
	Delay_10us();
}

void MMA7660_Write_Byte(uint8_t Byte)
{
	uint8_t Ctr;
	MMA7660_SCL(1);
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
	MMA7660_SDA_Type(INPUT);
	Delay_10us();
	Delay_10us();
	MMA7660_SCL(1);
	Delay_10us();
	MMA7660_SDA_Type(OUTPUT);
}
void MMA7660_Write_Reg(uint8_t Reg, uint8_t Byte)
{
	MMA7660_Start();
	MMA7660_Write_Byte(0x98);
	MMA7660_Write_Byte(Reg);
	MMA7660_Write_Byte(Byte);
	MMA7660_End();
}

void Delay_10us(void)
{
	uint16_t Ctr;
	for(Ctr = 0; Ctr < 2000; Ctr++)
		__nop();
}

