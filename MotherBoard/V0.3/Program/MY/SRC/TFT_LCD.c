#include"TFT_LCD.h"

void TFT_LCD_GPIO_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure_A;
	GPIO_InitTypeDef GPIO_InitStructure_B;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB | RCC_APB2Periph_AFIO , ENABLE);   
	//!! APB2->AFIO must be enable.
	
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_Disable,ENABLE);
	
	GPIO_InitStructure_A.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure_A.GPIO_Pin = GPIO_Pin_All;
	GPIO_InitStructure_A.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure_A);
	
	GPIO_InitStructure_B.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
	GPIO_InitStructure_B.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure_B.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure_B);
	
}

void TFT_LCD_Write_Index(uint16_t idx)
{
	TLCD_RS(0);
	TLCD_CS(0);
	
	GPIO_Write(GPIOA, idx);
	
	TLCD_WR(0);
	TLCD_WR(1);
	TLCD_CS(1);
}

void TFT_LCD_Write_Data(uint16_t dat)
{
	TLCD_RS(1);
	TLCD_CS(0);
	
	GPIO_Write(GPIOA, dat);
	
	TLCD_WR(0);
	TLCD_WR(1);
	TLCD_CS(1);
}

void TFT_LCD_Init(void)
{
	TFT_LCD_GPIO_Init();
	TLCD_CS(1);
	TLCD_RD(1);
	Delay_ms(50);
	TLCD_RE(0);
	Delay_ms(150);
	TLCD_RE(1);
	Delay_ms(50);
	
	TFT_LCD_Write_Index(0x11);
	Delay_ms(20);
	TFT_LCD_Write_Index(0xD0);
	TFT_LCD_Write_Data(0x07);
	TFT_LCD_Write_Data(0x42);
	TFT_LCD_Write_Data(0x18);
	
	TFT_LCD_Write_Index(0xD1);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x07);
	TFT_LCD_Write_Data(0x10);
	
	TFT_LCD_Write_Index(0xD2);
	TFT_LCD_Write_Data(0x01);
	TFT_LCD_Write_Data(0x02);
	
	TFT_LCD_Write_Index(0xc0);
	TFT_LCD_Write_Data(0x10);
	TFT_LCD_Write_Data(0x3b);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x02);
	TFT_LCD_Write_Data(0x11);
	
	TFT_LCD_Write_Index(0xc5);
	TFT_LCD_Write_Data(0x03);
	
	TFT_LCD_Write_Index(0xc8);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x32);
	TFT_LCD_Write_Data(0x36);
	TFT_LCD_Write_Data(0x45);
	TFT_LCD_Write_Data(0x06);
	TFT_LCD_Write_Data(0x16);
	TFT_LCD_Write_Data(0x37);
	TFT_LCD_Write_Data(0x75);
	TFT_LCD_Write_Data(0x77);
	TFT_LCD_Write_Data(0x54);
	TFT_LCD_Write_Data(0x0c);
	TFT_LCD_Write_Data(0x00);
	
	TFT_LCD_Write_Index(0x36);
	TFT_LCD_Write_Data(0x0A);
	
	TFT_LCD_Write_Index(0x3A);
	TFT_LCD_Write_Data(0x55);
	
	TFT_LCD_Write_Index(0x2A);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x01);
	TFT_LCD_Write_Data(0x3f);
	
	TFT_LCD_Write_Index(0x2b);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x00);
	TFT_LCD_Write_Data(0x01);
	TFT_LCD_Write_Data(0xe0);
	Delay_ms(120);
	TFT_LCD_Write_Index(0x29);
	TFT_LCD_Write_Index(0x2c);
	
	TFT_LCD_Write_Index(0xD0);
}

void TFT_LCD_ClearScreen(uint16_t BColor)
{
	uint16_t i,j;
	TFT_LCD_SetPos(0,320-1,0,480-1);
	for(i=0; i<480; i++)
	{
		for(j=0; j<320; j++)
			TFT_LCD_Write_Data(BColor);
	}
}

void TFT_LCD_SetPos(uint16_t x0, uint16_t x1, uint16_t y0, uint16_t y1)
{
	TFT_LCD_Write_Index(0x2a);
	TFT_LCD_Write_Data(x0>>8);
	TFT_LCD_Write_Data(x0&0xff);
	TFT_LCD_Write_Data(x1>>8);
	TFT_LCD_Write_Data(x1&0xff);
	TFT_LCD_Write_Index(0x2b);
	TFT_LCD_Write_Data(y0>>8);
	TFT_LCD_Write_Data(y0&0xff);
	TFT_LCD_Write_Data(y1>>8);
	TFT_LCD_Write_Data(y1&0xff);
	
	TFT_LCD_Write_Index(0x2c);
};
