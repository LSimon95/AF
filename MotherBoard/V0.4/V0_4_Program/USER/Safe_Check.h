#ifndef SAFE_CHECK
#define SAFE_CHECK

#define NUM_ITEM_CHECK 6

#define NUM_FHD                        0x00
#define NUM_HIGH_TEMPERTURE            0x01   
#define NUM_DANGEROUS_TEMPERTURE       0x02
#define NUM_HIGH_ALCOHOL_CONCENTRATION 0x03
#define NUM_ACC_CHECK                  0x04
#define NUM_ALCOHOL_LEAKAGE            0x05


typedef enum
{
	SAFE_CHECK_SAFE = 0,
	SAFE_CHECK_NO_FIRE,
	SAFE_CHECK_REACH_2nd_LEVEL,
	SAFE_CHECK_HIGH_TEMPERTURE,
	SAFE_CHECK_DANGEROUS_TEMPERTURE,
	SAFE_CHECK_HIGH_ALCOHOL_CONCENTRATION,
	SAFE_CHECK_ACC_CHECK,
	SAFE_CHECK_LOW_ALCOHOL, 
	SAFE_CHECK_TIME_OUT_PUMP_ALCOHOL,
	SAFE_CHECK_ALCOHOL_LEAKAGE
}Unsafe_Type;

typedef struct
{
	Unsafe_Type Unsafe_Type;
}Safe_Check_Result_Typedef;

#include "main.h"

/* Safe Check Items */
void Fire_Detect_Init(void);
#define FIRE_DETECT   1
#define FIRE_UNDETECT 0
uint8_t Fire_Detect(void);

#define INCLINE    1
#define EARTHQUAKE 2
uint8_t Acc_Check(void);

#define HIGH_TEMPERTURE      1
#define DANGEROUS_TEMPERTURE 2
uint8_t Temperture_Check(void);

#define HIGH_ALCOHOL_COCENTRATION 1
uint8_t Alcohol_Concentration_Check(void);

void Safe_Check_Init(void);
void Safe_Check(void);




#endif
