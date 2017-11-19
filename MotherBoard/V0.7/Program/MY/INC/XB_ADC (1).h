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

#define  NUM_SAMPLE   30
#define  NUM_CHANNEL  3

#endif
