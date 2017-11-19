#include"NOKIA5110.h"
#include"english_6x8_pixel.h"

uint8_t Result[10];

void LCD_write_char(unsigned char c);
void LCD_GPIO_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable , ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3 | GPIO_Pin_4 | GPIO_Pin_5 | GPIO_Pin_8;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB	, &GPIO_InitStructure);
}

void LCD_Init(void)
{
	LCD_GPIO_Init();
	LCD_RST(0);
	Delay_ms(1);
	LCD_RST(1);
	
	LCD_CE(0);
	Delay_ms(1);
	LCD_CE(1);
	Delay_ms(1);
	
	LCD_write_byte(0x21, 0);	// 使用扩展命令设置LCD模式
  LCD_write_byte(0xc8, 0);	// 设置偏置电压
  LCD_write_byte(0x06, 0);	// 温度校正
  LCD_write_byte(0x11, 0);	// 1:48
  LCD_write_byte(0x20, 0);	// 使用基本命令
  LCD_clear();	        // 清屏
  LCD_write_byte(0x0c, 0);	// 设定显示模式，正常显示
        
           // 关闭LCD
  LCD_CE(0);
}

void LCD_clear(void)
{
	uint32_t i;
	LCD_write_byte(0x0c,0);
	LCD_write_byte(0x80,0);
	
	for(i=0;i<504;i++)
		LCD_write_byte(0,1);
}

void LCD_write_char(unsigned char c)
{
  unsigned char line;

  c -= 32;

  for (line=0; line<6; line++)
    LCD_write_byte(font6x8[c][line], 1);
}

void LCD_write_byte(uint8_t dat, uint8_t command)
{
	uint8_t i;
	LCD_CE(0);
	if(command == 0)
		LCD_DC(0);
	else
		LCD_DC(1);
	for(i=0;i<8;i++)
	{
		if(dat&0x80)
			LCD_DIN(1);
		else
			LCD_DIN(0);
		LCD_CLK(0);
		dat=dat<<1;
		LCD_CLK(1);
	}
	LCD_CE(1);
}

void LCD_set_XY(uint8_t X,uint8_t Y)
{
	LCD_write_byte(0x40 | Y, 0);
	LCD_write_byte(0x80 | X, 0);
}
void LCD_write_english_string(uint8_t X, uint8_t Y, uint8_t *s)
{
	LCD_set_XY(X,Y);
	while(*s)
	{
		LCD_write_char(*s);
		s++;
	}
}
uint8_t LCD_write_vlaue(uint8_t x, uint8_t y, uint32_t value) 
{
	uint8_t Str_Len;
	Str_Len = sprintf(Result, "%u", value);
	LCD_write_english_string(x, y, Result);
	return Str_Len;
}
