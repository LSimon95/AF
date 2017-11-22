#ifndef _UHMI_H
#define _UHMI_H

#include "main.h"

void UHMI_USART_Printf(char *fmt, ...);
void Display_Update(void);
void UHMI_USART_Init(void);
void UHMI_USART_Send_Str(char *Str);
void UHMI_USART_Send_Char(uint8_t Char);
#endif
