#ifndef _NOKIA5110_H
#define _NOKIA5110_H

#include"stm32f10x.h"
#include"delay.h"

#define LCD_RST(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_3);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_3)
				
#define LCD_CLK(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_8);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_8)
				
#define LCD_CE(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_5);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_5)
				
#define LCD_DC(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_4);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_4)		
				
#define LCD_DIN(a) if(a)\
				GPIO_SetBits(GPIOB,GPIO_Pin_9);\
				else \
				GPIO_ResetBits(GPIOB,GPIO_Pin_9)				

void LCD_GPIO_Init(void);
void LCD_write_byte(uint8_t dat, uint8_t command);
void LCD_Init(void);
void LCD_clear(void);
void LCD_write_char(unsigned char c);
void LCD_write_english_string(uint8_t X, uint8_t Y, uint8_t *s);
uint8_t LCD_write_vlaue(uint8_t x, uint8_t y, uint32_t value); 
				
#endif
				
