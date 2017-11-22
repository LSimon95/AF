/*
**File_Name:      XB_ADC.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      h
**Size:           1024
**Platform:       Stm32
**Attention:
*/
#ifndef _ADC_H
#define	_ADC_H

#include "stm32f10x.h"
#include "main.h"

void XB_ADC_Init(void);
void XB_ADC_Filter(void);


#define  NUM_SAMPLE   1000
#define  NUM_CHANNEL  1

uint16_t Get_SqO2_Percent(void);

#endif
