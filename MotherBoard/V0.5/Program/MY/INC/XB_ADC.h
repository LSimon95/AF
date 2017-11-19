/*
**File_Name:      XB_ADC.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      h
**Size:           1024
**Platform:       Stm32
**Note:
*/
#ifndef _ADC_H
#define	_ADC_H

#include "stm32f10x.h"
#include "main.h"

void XB_ADC_Init(void);
void XB_ADC_Filter(void);

#define XB_ADC ADC1

#define XB_ADC_1GPIO GPIOC
#define XB_ADC_1GPIO_PIN GPIO_Pin_0

#define XB_ADC_2GPIO GPIOC
#define XB_ADC_2GPIO_PIN GPIO_Pin_2

#define  NUM_SAMPLE   50
#define  NUM_CHANNEL  2

uint16_t Get_SqO2_Percent(void);

#endif
