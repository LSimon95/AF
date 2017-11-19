#ifndef SAFE_CHECK_H
#define SAFE_CHECK_H

#include "main.h"

typedef enum 
{
	SAFE = 0,
	HIGH_TEMPERTURE                   = 1,
	GET_TEMPERTURE_FAILED             = 2,
	ALCOHOL_REACH_2nd_LEVEL           = 3,
	HIGH_ALCOHOL_CONCENTRATION        = 4,
	GET_ALCOHOL_CONCENTRATION_FAILED  = 5,
	STORE_ALCOHOL_LEVE_LOW            = 6,
	TOO_LONG_WAIT_FILL_WITH_ALCOHOL   = 7,
	SAFE_CHECK_INIT_FAILED            = 8,
	ALCOHOL_LEAKAGE                   = 9
}UnSafe_Type_Typedef;
#define SAFE   0
#define UNSAFE 1
typedef struct
{
	uint8_t Safe_Flag;
	UnSafe_Type_Typedef Unsafe_Type;
}Safe_Check_Typedef;

/* Alcohol Concentration */
void Alcohol_ADC_Init(void);
#define HIGH_CONCENTRATION       1
#define GET_CONCENTRATION_FAILED 2
uint8_t Alcohol_Concentration_Check(void);

/* Temperture Check */
#define HIGH_TEMPERTURE       1
#define GET_TEMPERTURE_FAILED 2
uint8_t Temperture_Check(void);

/* Safe Check */
uint8_t Safe_Check_Init(void);
Safe_Check_Typedef Safe_Check(void);



#endif