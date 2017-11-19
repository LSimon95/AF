#ifndef _ADC_H
#define	_ADC_H

#include "stm32f10x.h"
void ADC1_Init(void);
void Filter(void);

#define  N   50              //每通道采50次
#define  M  2               //为1个通道

#endif
