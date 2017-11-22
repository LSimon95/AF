/*
**File_Name:      XB_Delay.h
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      h
**Size:           1024
**Platform:       Stm32
**Note:
*/
#ifndef _XB_DELAY_H
#define _XB_DELAY_H
#include"stm32f10x.h"

#define SYSTICK_TENMS (*((volatile unsigned long *)0xE000E01C))
#define SYSTICK_CURRENT (*((volatile unsigned long *)0xE000E018))
#define SYSTICK_RELOAD (*((volatile unsigned long *)0xE000E014))
#define SYSTICK_CSR (*((volatile unsigned long *)0xE000E010))

void Delay_ms(unsigned long nTime);
void SysTick_Configuration(void);

#endif
