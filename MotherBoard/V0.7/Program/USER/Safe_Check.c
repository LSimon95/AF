#include "Safe_Check.h"

uint8_t Acc_Ctr = 0;
int16_t Acc_Buf[10 * 3];

float Acc_Adjust_X = 0;
float Acc_Adjust_Y = 0;
float Acc_Adjust_Z = 0;

uint8_t Detect_Count[NUM_ITEM_CHECK];
uint8_t Critical_Problem_Handler_Flag = 0x00;
int16_t Temperture;
uint8_t PerOfAlcohol;

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
	
	/* MMA8452 */
	MMA845x_Init();
	
	/* MMA8452 Timer */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM6, ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM6_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = TIM6_PRI_PRE;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = TIM6_PRI_SUB;
	
	NVIC_Init(&NVIC_InitStructure);

	TIM_Cmd(TIM6, DISABLE);
	
	TIM_TimBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
	TIM_TimBaseInitStructure.TIM_Period = 50;
	TIM_TimBaseInitStructure.TIM_Prescaler = 7200;
	
	TIM_TimeBaseInit(TIM6, &TIM_TimBaseInitStructure);
	TIM_ITConfig(TIM6, TIM_IT_Update, ENABLE);
	TIM_Cmd(TIM6, ENABLE);
	
	Delay_ms(200);
	
	Acc_Adjust();
	/* ADC */
	XB_ADC_Init();
	
	/* Temperture 18B20 */
	XB_18B20_Init();
	
	/* Safe_Check Timer */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM7, ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = TIM7_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = TIM7_PRI_PRE;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = TIM7_PRI_SUB;
	
	NVIC_Init(&NVIC_InitStructure);
	
	TIM_Cmd(TIM7, DISABLE);
	
	TIM_TimBaseInitStructure.TIM_ClockDivision = TIM_CKD_DIV1;
	TIM_TimBaseInitStructure.TIM_Period = 2000;
	TIM_TimBaseInitStructure.TIM_Prescaler = 7200;
	
	TIM_TimeBaseInit(TIM7, &TIM_TimBaseInitStructure);
	TIM_ITConfig(TIM7, TIM_IT_Update, ENABLE);
	TIM_Cmd(TIM7, ENABLE);
}
uint8_t Fire_Detect(void)
{
	XB_ADC_Filter();
	Debug_USART_Send_Char((uint8_t)(XB_ADC_After_Filter[0] >> 8));
		Debug_USART_Send_Char((uint8_t)(XB_ADC_After_Filter[0]));
	if(XB_ADC_After_Filter[0] > FIRE_DETECTED_THRESHOLD)
	{
		
		return FIRE_DETECT;
	}
	else
		return FIRE_UNDETECT;
}

/* Adjust Acc */

void Acc_Adjust(void)
{
//	uint8_t *Pointer;
	uint8_t Cnt1, Cnt2;
	int32_t SumX = 0, SumY = 0, SumZ = 0;
	for(Cnt1 = 0; Cnt1 < 10; Cnt1++)
	{
		for(Cnt2 = 0; Cnt2 < 10; Cnt2++)
		{
			SumX += (int32_t)Acc_Buf[Cnt2 * 3 + 0];
			SumY += (int32_t)Acc_Buf[Cnt2 * 3 + 1];
			SumZ += (int32_t)Acc_Buf[Cnt2 * 3 + 2];
		}
		Delay_ms(200); //Waif for next data
	}
	
	SumX /= 100;
	SumY /= 100;
	SumZ /= 100;
	
	Acc_Adjust_X = 0 - ((float)SumX / 4096 / 4);
	Acc_Adjust_Y = 0 - ((float)SumY / 4096 / 4);
	Acc_Adjust_Z = 1 - ((float)SumZ / 4096 / 4);
	
	/* Write to 24C02 */
//	
//	Pointer = (uint8_t *)&Acc_Adjust_X;
//	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
//	{
//		EEPROM_24C0x_Write(0x00 + Cnt1, *Pointer);
//		Pointer++;
//	}
//	
//	Pointer = (uint8_t *)&Acc_Adjust_Y;
//	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
//	{
//		EEPROM_24C0x_Write(0x04 + Cnt1, *Pointer);
//		Pointer++;
//	}
//	
//	Pointer = (uint8_t *)&Acc_Adjust_Z;
//	for(Cnt1 = 0; Cnt1 < 4; Cnt1++)
//	{
//		EEPROM_24C0x_Write(0x08 + Cnt1, *Pointer);
//		Pointer++;
//	}
}

uint8_t Acc_Check(void)
{
	float Acc_gZ, Acc_gX, Acc_gY, Acc_gSX2Y2;
	uint8_t Cnt;
	int32_t SumZ, SumX, SumY;
	
	SumZ = SumX = SumY = 0;
		
	for(Cnt = 0; Cnt < 10; Cnt++)
	{
		SumX += (int32_t)Acc_Buf[Cnt * 3];
		SumY += (int32_t)Acc_Buf[Cnt * 3 + 1];
		SumZ += (int32_t)Acc_Buf[Cnt * 3 + 2];
	}
	
	SumX = SumX / 10;
	SumY = SumY / 10;
	SumZ = SumZ / 10;
	
	Acc_gX = ((float)SumX / 4096 / 4) + Acc_Adjust_X;
	Acc_gY = ((float)SumY / 4096 / 4) + Acc_Adjust_Y;
	Acc_gZ = ((float)SumZ / 4096 / 4) + Acc_Adjust_Z;
	
	arm_sqrt_f32(((Acc_gX * Acc_gX) + (Acc_gY * Acc_gY)), &Acc_gSX2Y2);
	
	if(Acc_gSX2Y2 > 0.03 || Acc_gZ < 0.984 || Acc_gZ > 1.1)
	{
		return 1;
	}
	return 0;
}

uint8_t Temperture_Check(void)
{
	int16_t Temp;
	XB_18B20_Start_Convert();
	Temp = XB_18B20_Get_Temperture();
	if(Temp != 0)
	{
		Temperture = Temp;
	}
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

uint8_t Get_Alcohol_Level(void)
{
	uint16_t AlcoholADVal;

	XB_ADC_Filter();
	AlcoholADVal = XB_ADC_After_Filter[3];
	if(AlcoholADVal < 0x00ff)
		AlcoholADVal = 0;
	else
		AlcoholADVal -= 0x00ff;
	PerOfAlcohol = (uint8_t)((uint32_t)AlcoholADVal * 100 / 0x0e01);
	
	return PerOfAlcohol;
}

void Safe_Check(void)
{
	System_Status.Safe_Check_Result.Unsafe_Type = SAFE_CHECK_SAFE;
	/* FHD */
	if(!GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_0))
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
		Critical_Problem_Handler_Flag = 1;
		TIM_Cmd(TIM7, DISABLE); 
		//Disable Safe_Check
		//Critical_Problem_Handler();
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
				Critical_Problem_Handler_Flag = 1;
				TIM_Cmd(TIM7, DISABLE); //Disable Safe_Check
				//Critical_Problem_Handler();
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
	switch(Acc_Check())
	{
		case INCLINE:
			Detect_Count[NUM_ACC_CHECK]++;
			if(Detect_Count[NUM_ACC_CHECK] > 10)
			{
				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_ACC_CHECK;
				System_Status.System_Status = SYSTEM_UNSAFE;
				Critical_Problem_Handler_Flag = 1;
				TIM_Cmd(TIM7, DISABLE); //Disable Safe_Check
				//Critical_Problem_Handler();
			}
			break;
		case EARTHQUAKE:
			Detect_Count[NUM_ACC_CHECK] += 2;
			if(Detect_Count[NUM_ACC_CHECK] > 10)
			{
				System_Status.Safe_Check_Result.Unsafe_Type |= SAFE_CHECK_ACC_CHECK;
				System_Status.System_Status = SYSTEM_UNSAFE;
				Critical_Problem_Handler_Flag = 1;
				TIM_Cmd(TIM7, DISABLE); //Disable Safe_Check
				//Critical_Problem_Handler();
			}
			break;
		case NULL:
			if(Detect_Count[NUM_ACC_CHECK] != 0)
				Detect_Count[NUM_ACC_CHECK]--;
			break;
	}
	/* ALD */
	if(Get_Alcohol_Level() <= 1)
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
			Critical_Problem_Handler_Flag = 1;
			TIM_Cmd(TIM7, DISABLE); //Disable Safe_Check
				//Critical_Problem_Handler();
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
		MMA845x_Read_ACC_Buf(0x01, (uint8_t *)&Acc_Buf[Acc_Ctr * 3]);
		Acc_Ctr++;
		if(Acc_Ctr >= 10)
			Acc_Ctr = 0;
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


