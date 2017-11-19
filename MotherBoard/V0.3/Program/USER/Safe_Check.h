#ifndef SAFE_CHECK
#define SAFE_CHECK

typedef enum
{
	SAFE_CHECK_SAFE                = 0,
	SAFE_CHECK_NO_FIRE             = 1,
}Unsafe_Type;

typedef struct
{
	Unsafe_Type Unsafe_Type;
}Safe_Check_Result_Typedef;

#include "main.h"

/* Safe Check Items */
#include "ADC.h"
void Fire_Detect_Init(void);


void Safe_Check_Init(void);
void Safe_Check(void);
#endif
