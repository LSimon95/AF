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

#define VOICE_PON 2
#define VOICE_POF 1
#define VOICE_II 4
#define VOICE_IF 0
#define VOICE_LA 3

#endif