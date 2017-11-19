#ifndef _TFT_LCD_H
#define _TFT_LCD_H

#include"stm32f10x.h"
#include"delay.h"

#define TLCD_RE(a) if(a) \
										GPIO_SetBits(GPIOB,GPIO_Pin_11);\
										else			\
										GPIO_ResetBits(GPIOB,GPIO_Pin_11)
#define TLCD_RS(a) if(a) \
										GPIO_SetBits(GPIOB,GPIO_Pin_12);\
										else			\
										GPIO_ResetBits(GPIOB,GPIO_Pin_12)
#define TLCD_WR(a) if(a) \
										GPIO_SetBits(GPIOB,GPIO_Pin_13);\
										else			\
										GPIO_ResetBits(GPIOB,GPIO_Pin_13)
#define TLCD_RD(a) if(a) \
										GPIO_SetBits(GPIOB,GPIO_Pin_14);\
										else			\
										GPIO_ResetBits(GPIOB,GPIO_Pin_14)
#define TLCD_CS(a) if(a) \
										GPIO_SetBits(GPIOB,GPIO_Pin_15);\
										else			\
										GPIO_ResetBits(GPIOB,GPIO_Pin_15)

void TFT_LCD_GPIO_Init(void);
void TFT_LCD_Write_Index(uint16_t idx);
void TFT_LCD_Write_Data(uint16_t dat);
void TFT_LCD_Init(void);
void TFT_LCD_ClearScreen(uint16_t BColor);
void TFT_LCD_SetPos(uint16_t x0, uint16_t x1, uint16_t y0, uint16_t y1);

										
#endif
