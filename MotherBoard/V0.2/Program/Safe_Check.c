#include "Safe_Check.h"
#include "DS18B20.h"

Safe_Check_Typedef Safe_Check_Result;
extern System_Status_Typedef System_Status;

/* Unsafe Event Time-Ctr */
uint8_t High_Alcohol_Concentration_Ctr = 0, Get_Alcohol_Concentration_Failed = 0;
uint8_t High_Temperture_Ctr = 0, Get_Temperture_Failed_Ctr = 0;
uint8_t ALDHL_Detect_Ctr = 0;
uint8_t FireH_Detect_Ctr = 0;
uint8_t ALD_Detetc_Ctr = 0;

uint8_t Safe_Check_Init(void)
{
	/* Alcohol(Fire) Detect */
	GPIO_Init(GPIOB, GPIO_PIN_3, GPIO_MODE_IN_PU_NO_IT);
	GPIO_Init(GPIOB, GPIO_PIN_4, GPIO_MODE_IN_FL_NO_IT);
	/* Alcohol Concentration ADC*/
	Alcohol_ADC_Init();
	/* Tim3 Init */
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_TIMER3 , ENABLE);
	TIM3_TimeBaseInit(TIM3_PRESCALER_128, 12500);
	TIM3_ITConfig(TIM3_IT_UPDATE, ENABLE);
	TIM3_Cmd(ENABLE);
	rim();
	return NULL;
}

void Alcohol_ADC_Init(void)
{
	CLK_PeripheralClockConfig(CLK_PERIPHERAL_ADC, ENABLE);
	ADC1_Init(ADC1_CONVERSIONMODE_SINGLE, 
						ADC1_CHANNEL_9,
						ADC1_PRESSEL_FCPU_D18, 
						ADC1_EXTTRIG_TIM, 
						DISABLE, 
						ADC1_ALIGN_RIGHT, 
						ADC1_SCHMITTTRIG_CHANNEL9, 
						DISABLE
						);
	ADC1_AWDChannelConfig(ADC1_CHANNEL_9, ENABLE);
	//ADC1_SetHighThreshold(0x0320);
	//ADC1_SetLowThreshold(0x0010);
	//ADC1_ITConfig(ADC1_IT_AWD, DISABLE); //The Lib has problem, The function here set the IT_Flag but not set the IT_EN_Bit;
	
	//ADC1 -> CSR |= 0x10; //Enable the AWD Interrupt;
	
	ADC1_Cmd(ENABLE);
}

uint8_t Alcohol_Concentration_Check(void)
{
	uint16_t ADC_Val, Ctr;
	/* Alcohol Concentration*/
	while((! ADC1_GetFlagStatus(ADC1_FLAG_EOC)) && (Ctr++) < 50000);
	ADC1_ClearFlag(ADC1_FLAG_EOC);
	ADC_Val = ADC1_GetConversionValue();
	
	ADC1_StartConversion();
	if(Ctr >= 50000)
		return GET_CONCENTRATION_FAILED;
	if(ADC_Val >= 0x0300)
		return HIGH_CONCENTRATION;
	/*
	Pump1(1);
	LED3(0);
	Bee(0);
	*/
	return NULL;
}

uint8_t Temperture_Check(void)
{
	uint16_t Temperture;
	Temperture = DS18B20_Get_Temperture();
	
	if((Temperture > 1200) || (Temperture <= 0))         //if the temperture lower than 0'C, system will sound a warning
	{
		return GET_TEMPERTURE_FAILED;
	}
	if(DS18B20_Get_Temperture() > 800)
	{
		return HIGH_TEMPERTURE;
	}
	return NULL;
}

Safe_Check_Typedef Safe_Check(void)
{
	Safe_Check_Typedef Safe_Check_Result;
	sim();
	TIM3_Cmd(DISABLE);
	/* Alcohol Concentration Check */
	switch(Alcohol_Concentration_Check())
	{
		case GET_ALCOHOL_CONCENTRATION_FAILED:
			Get_Alcohol_Concentration_Failed++;
			if(Get_Alcohol_Concentration_Failed >= 20)
			{
				Safe_Check_Result.Unsafe_Type = GET_ALCOHOL_CONCENTRATION_FAILED;
				Safe_Check_Result.Safe_Flag = UNSAFE;
				//UART_Send_Char(Safe_Check_Result.Unsafe_Type);
				return Safe_Check_Result;
			}
		break;
		case HIGH_ALCOHOL_CONCENTRATION:
			High_Alcohol_Concentration_Ctr++;
			if(High_Alcohol_Concentration_Ctr >= 20)
			{
				Safe_Check_Result.Unsafe_Type = HIGH_ALCOHOL_CONCENTRATION;
				Safe_Check_Result.Safe_Flag = UNSAFE;
				//UART_Send_Char(Safe_Check_Result.Unsafe_Type);
				return Safe_Check_Result;
			}
		break;
		case NULL:
			Get_Alcohol_Concentration_Failed = 0;
			High_Alcohol_Concentration_Ctr = 0;
		break;
	}
	/* Temperture Check */
	switch(Temperture_Check())
	{
		case HIGH_TEMPERTURE:
			High_Temperture_Ctr++;
			if(High_Temperture_Ctr >= 20)
			{
				Safe_Check_Result.Unsafe_Type = HIGH_TEMPERTURE;
				Safe_Check_Result.Safe_Flag = UNSAFE;
				//UART_Send_Char(Safe_Check_Result.Unsafe_Type);
				return Safe_Check_Result;
			}
		break;
		case GET_TEMPERTURE_FAILED:
			Get_Temperture_Failed_Ctr++;
			if(Get_Temperture_Failed_Ctr >= 20)
			{
				Safe_Check_Result.Unsafe_Type = GET_TEMPERTURE_FAILED;
				Safe_Check_Result.Safe_Flag = UNSAFE;
				//UART_Send_Char(Safe_Check_Result.Unsafe_Type);
				return Safe_Check_Result;
			}
		break;
		case NULL:
			High_Temperture_Ctr = 0;
			Get_Temperture_Failed_Ctr = 0;
		break;
	}
	/* Stored Alcohol Level Low */
	if(!ALDHL)
	{
		ALDHL_Detect_Ctr++;
		if(ALDHL_Detect_Ctr >= 10)
		{
			Safe_Check_Result.Unsafe_Type = STORE_ALCOHOL_LEVE_LOW;
			Safe_Check_Result.Safe_Flag = UNSAFE;
			return Safe_Check_Result;
		}
	}
	else
		ALDHL_Detect_Ctr = 0;
	/* 2nd Alcohol Level Detect */
	if(!FireDH)
	{
		FireH_Detect_Ctr++;
		if(FireH_Detect_Ctr >= 10)
		{
			Safe_Check_Result.Unsafe_Type = ALCOHOL_REACH_2nd_LEVEL;
			Safe_Check_Result.Safe_Flag = UNSAFE;
			return Safe_Check_Result;
		}
	}
	/* Alcohol Leakage */
	if(!ALD)
	{
		ALD_Detetc_Ctr++;
		if(ALD_Detetc_Ctr >= 10)
		{
			Safe_Check_Result.Unsafe_Type = ALCOHOL_LEAKAGE;
			Safe_Check_Result.Safe_Flag = UNSAFE;
			return Safe_Check_Result;
		}
	}
	else
		ALD_Detetc_Ctr = 0;
	
	Safe_Check_Result.Unsafe_Type = SAFE;
	Safe_Check_Result.Safe_Flag = SAFE;
	rim();
	TIM3_Cmd(ENABLE);
	return Safe_Check_Result;
}

@far @interrupt void TIM3_Safe_Check_IRQHandler(void)
{
	TIM3_ClearITPendingBit(TIM3_IT_UPDATE);
	Safe_Check_Result = Safe_Check();
	if(Safe_Check_Result.Safe_Flag != SAFE)
	{
		if((Safe_Check_Result.Unsafe_Type == STORE_ALCOHOL_LEVE_LOW))
		{
			System_Status.System_Status = STATUS_UNSAFE;
			UART_Send_Char(Safe_Check_Result.Unsafe_Type);
			LOW_ALCOHOL();
			rim();
			TIM3_Cmd(ENABLE);
		}
		else if((Safe_Check_Result.Unsafe_Type == ALCOHOL_REACH_2nd_LEVEL))
		{
			System_Status.System_Status = STATUS_UNSAFE;
			FIRE_DETECT_2ndLevel_ERROR();
			STOP_WORKING();
			UART_Send_Char(Safe_Check_Result.Unsafe_Type);
			while(1)
			{
				if((WWDG_GetCounter() & 0x7f) < 0x50)
				{
					WWDG_SetCounter(0x7F);
				}
			}
		}
		else
		{
			System_Status.System_Status = STATUS_UNSAFE;
			Serious_Problem_Handler();
		}
	}
}