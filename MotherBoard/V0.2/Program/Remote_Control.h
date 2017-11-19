#ifndef REMOTE_CONTROL_H
#define REMOTE_CONTROL_H

#include "main.h"

typedef enum
{
	START_FIRE   = (uint8_t)(0x01),
	STOP_FIRE    = (uint8_t)(0x02),
	PUMP_ALCOHOL = (uint8_t)(0x03),
	NO_REMOTE_COMMAND = (uint8_t)(0x00)
}Remote_Command_Typedf;


void TIM2_Capture_Init(void);
Remote_Command_Typedf Remote_Control_Get_Command(void);
void Remote_Control_Init(void);
void Remote_Control_Cmd(FunctionalState Status);


#endif