#ifndef _PID_H
#define _PID_H

#include "stm32f10x.h"
#include "delay.h"

#define USART1_DR_Address 0x40013c04
#define BYTE1(a) a>>8
#define BYTE0(a) a

#define BALANCE_ANGLE_MAX 4
#define BALANCE_ANGLE_MIN -4

#define ANGLE_C 1
#define SPEED_C 0.005

//#define WISH_ANGLE1 4
//#define WISH_ANGLE2 -4

#define MPU6050_ANGLE_ERROR -1.5

#define Integal_Max 70
#define Integal_Min -70



void USART1_GPIO_Init(void);
uint8_t Str_Compare(char *Str1, char *Str2, uint16_t Len);
int PID_Roll(float Roll,float ww);

/*Remote_Control Command*/
#define START_RUN 0x88

#endif
