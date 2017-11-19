#include "Safe_Check.h"

uint8_t Acc_Ctr = 0;
uint8_t Acc_Buf[10][3];
int8_t AccZ_Last;

uint8_t Detect_Count[NUM_ITEM_CHECK];

extern System_Status_Typedef System_Status;
extern uint16_t XB_ADC_After_Filter[];

void Safe_Check_Init(void)
{
	uint16_t Ctr;
	
	NVIC_InitTypeDef NVIC_InitStructure;
	TIM_TimeBaseInitTypeDef TIM_TimBaseInitStructure;
	
	/* Detect_Count Clear*/
	for(Ctr = 0; Ctr < NUM_ITEM_CHECK; Ctr++)
	{
		Detect_Count[Ctr] = 0x00;
	}
	
	/* Safe_Check Timer */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM7, ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM7_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
	
	NVIC_Init(&NVIC_InitStructure);
	
	TIM_Cmd(TIM7, DISABLE);
	
	TIM_TimBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
	TIM_TimBaseInitStructure.TIM_Period = 2000;
	TIM_TimBaseInitStructure.TIM_Prescaler = 7200;
	
	TIM_TimeBaseInit(TIM7, &TIM_TimBaseInitStructure);
	TIM_ITConfig(TIM7, TIM_IT_Update, ENABLE);
	TIM_Cmd(TIM7, ENABLE);
	/* MMA7660 */
	MMA7660_Init();
	
	/* MMA7660 Timer */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM6, ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM6_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x05;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x05;
	
	NVIC_Init(&NVIC_InitStructure);

	TIM_Cmd(TIM6, DISABLE);
	
	TIM_TimBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
	TIM_TimBaseInitStructure.TIM_Period = 100;
	TIM_TimBaseInitStructure.TIM_Prescaler = 7200;
	
	TIM_TimeBaseInit(TIM6, &TIM_TimBaseInitStructure);
	TIM_ITConfig(TIM6, TIM_IT_Update, ENABLE);
	TIM_Cmd(TIM6, ENABLE);
	
	/* ADC */
	XB_ADC_Init();
	
	/* Temperture 18B20 */
	XB_18B20_Init();
	
	
}



uint8_t Fire_Detect(void)
{
	XB_ADC_Filter();
	if(XB_ADC_After_Filter[0] > 0x0010)
	{
		return FIRE_DETECT;
	}
	else
		return FIRE_UNDETECT;
}

uint8_t Acc_Check(void)
{
	uint8_t Ctr;
	int8_t Acc, AccZ_Dif;
	int16_t SumX = 0, SumY = 0, SumZ = 0;
	for(Ctr = 0; Ctr < 10; Ctr++)
	{
		Acc_Buf[Ctr][0] &= 0x3f;
		Acc_Buf[Ctr][1] &= 0x3f;
		Acc_Buf[Ctr][2] &= 0x3f;
		if(Acc_Buf[Ctr][0] & 0x20)
			Acc_Buf[Ctr][0] |= 0xc0;
		if(Acc_Buf[Ctr][1] & 0x20)
			Acc_Buf[Ctr][1] |= 0xc0;
		if(Acc_Buf[Ctr][2] & 0x20)
			Acc_Buf[Ctr][2] |= 0xc0;
		SumX += (int8_t)Acc_Buf[Ctr][0];
		SumY += (int8_t)Acc_Buf[Ctr][1];
		SumZ += (int8_t)Acc_Buf[Ctr][2];
	}
	if(SumX < 0)
		SumX = -SumX;
	if(SumY < 0)
		SumY = -SumY;
	Acc = (SumX + SumY) / 10;
	if(Acc >= 3)
		return INCLINE;
	Acc = SumZ / 10;
	if(Acc > AccZ_Last)
		AccZ_Dif = Acc - AccZ_Last;
	else
		AccZ_Dif = AccZ_Last - Acc;
	if(AccZ_Dif >= 2)
	{
		AccZ_Last = Acc;
		return EARTHQUAKE;
	}
	AccZ_Last = Acc;
	return NULL; 
}

uint8_t Temperture_Check(void)
{
	int16_t Temperture;
	XB_18B20_Start_Convert();
	Temperture = XB_18B20_Get_Temperture();
	
//	Temperture = 400;
	if(Temperture < 400)
	{
		return NULL;
	}
	else if(Temperture >= 400 && Temperture < 700)
	{
		return HIGH_TEMPERTURE;
	}
	else if(Temperture >= 700)
	{
		return DANGEROUS_TEMPERTURE;
	}
	return NULL;
}

uint8_t Alcohol_Concentration_Check(void)
{
	if(XB_ADC_After_Filter[1] > 0x3000)
		return  HIGH_ALCOHOL_COCENTRATION;
	else
		return NULL;
}

void Safe_Check(void)
{
	System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_SAFE;
	/* FHD */
	if(!FHD)
	{
		Detect_Count[NUM_FHD]++;
	}
	else
	{
		Detect_Count[NUM_FHD] = 0;
	}
	if(Detect_Count[NUM_FHD] >= 10)
	{
		System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_REACH_2nd_LEVEL;
		System_Status.System_Status = SYSTEM_UNSAFE;
//		Critical_Problem_Handler();
	}
	/* Temperture */
	switch(Temperture_Check())
	{
		case HIGH_TEMPERTURE:
			Detect_Count[NUM_HIGH_TEMPERTURE]++;
			if(Detect_Count[NUM_HIGH_TEMPERTURE] > 10)
			{
				Fan(1);
				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_HIGH_TEMPERTURE;
			}
			break;
		case DANGEROUS_TEMPERTURE:
			Detect_Count[NUM_DANGEROUS_TEMPERTURE]++;
			if(Detect_Count[NUM_DANGEROUS_TEMPERTURE] > 20)
			{
				Fan(1);
				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_DANGEROUS_TEMPERTURE;
				System_Status.System_Status = SYSTEM_UNSAFE;
//				Critical_Problem_Handler();
			}
			break;
		case NULL:
			Fan(0);
			Detect_Count[NUM_HIGH_TEMPERTURE] = 0;
			Detect_Count[NUM_DANGEROUS_TEMPERTURE] = 0;
			break;
	}
	/* Alcohol Concentration */
	if(Alcohol_Concentration_Check())
	{
		Detect_Count[NUM_HIGH_ALCOHOL_CONCENTRATION]++;
		if(Detect_Count[NUM_HIGH_ALCOHOL_CONCENTRATION] > 20)
		{
			System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_HIGH_ALCOHOL_CONCENTRATION;
			System_Status.System_Status = SYSTEM_UNSAFE;
		}
	}
	else
	{
		Detect_Count[NUM_HIGH_ALCOHOL_CONCENTRATION] = 0;
	}
	/* Acc Check */
//	switch(Acc_Check())
//	{
//		case INCLINE:
//			Detect_Count[NUM_ACC_CHECK]++;
//			if(Detect_Count[NUM_ACC_CHECK] > 10)
//			{
//				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_ACC_CHECK;
//				System_Status.System_Status = SYSTEM_UNSAFE;
////				Critical_Problem_Handler();
//			}
//			break;
//		case EARTHQUAKE:
//			Detect_Count[NUM_ACC_CHECK] += 2;
//			if(Detect_Count[NUM_ACC_CHECK] > 10)
//			{
//				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_ACC_CHECK;
//				System_Status.System_Status = SYSTEM_UNSAFE;
////				Critical_Problem_Handler();
//			}
//			break;
//		case NULL:
//			if(Detect_Count[NUM_ACC_CHECK] != 0)
//				Detect_Count[NUM_ACC_CHECK]--;
//			break;
//	}
	/* ALD */
	if(ALD == 0)
	{
		System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_LOW_ALCOHOL;
	}
	
	/* ALCOHOL LEAKAGE */
	if(!LDHD)
	{
		Detect_Count[NUM_ALCOHOL_LEAKAGE]++;
		if(Detect_Count[NUM_ALCOHOL_LEAKAGE] >= 10)
		{
			System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_ALCOHOL_LEAKAGE;
			System_Status.System_Status = SYSTEM_UNSAFE;
//			Critical_Problem_Handler();
		}
	}
	else
	{
		Detect_Count[NUM_ALCOHOL_LEAKAGE] = 0;
	}
}

void TIM6_IRQHandler(void)
{
	if(TIM_GetITStatus(TIM6, TIM_IT_Update))
	{
		TIM_ClearITPendingBit(TIM6, TIM_IT_Update);
		Acc_Ctr++;
		if(Acc_Ctr >= 10)
		{
			Acc_Ctr = 0;
		}
		MMA7660_Read_Reg(0x00, Acc_Buf[Acc_Ctr]);
	}
}

void TIM7_IRQHandler(void)
{
	if(TIM_GetITStatus(TIM7, TIM_IT_Update))
	{
		TIM_ClearITPendingBit(TIM7, TIM_IT_Update);
		Safe_Check();
	}
}


