#ifndef _VOICE_H
#define _VOICE_H

#include "main.h"

#define VOICE_MAX 5
#define LANGUAGE_MAX 2

typedef struct 
{
	const unsigned char **Voice_Tab;
	const unsigned int *Voice_Tab_LEN;
	
}Voice_Language_Typedef;

/* Voice_ENG */
extern const unsigned char ENG_IF[];
extern const unsigned char ENG_PON[];
extern const unsigned char ENG_LA[];
extern const unsigned char ENG_POF[];
extern const unsigned char ENG_II[];
/*************/
/* Voice_ENG */
extern const unsigned char CHN_IF[];
extern const unsigned char CHN_PON[];
extern const unsigned char CHN_LA[];
extern const unsigned char CHN_POF[];
extern const unsigned char CHN_II[];
/*************/

void XB_Voice_Init(void);
uint8_t XB_Set_Play(uint8_t Voice_N);
void XB_M62429_Init(void);
void XB_Set_Volume(uint8_t Per);

#define VOICE_PON 2
#define VOICE_POF 1
#define VOICE_II 4
#define VOICE_IF 0
#define VOICE_LA 3

#define M6_Clk(Status) if(Status == 0)GPIO_ResetBits(GPIOA, GPIO_Pin_8);else if(Status == 1)GPIO_SetBits(GPIOA, GPIO_Pin_8)
#define M6_Data(Status) if(Status == 0)GPIO_ResetBits(GPIOA, GPIO_Pin_5);else if(Status == 1)GPIO_SetBits(GPIOA, GPIO_Pin_5)
#define CS_SD(Status) if(Status == 0)GPIO_ResetBits(GPIOB, GPIO_Pin_3);else if(Status == 1)GPIO_SetBits(GPIOB, GPIO_Pin_3)

#endif
