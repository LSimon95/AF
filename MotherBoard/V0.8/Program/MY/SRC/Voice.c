#include "Voice.h"

/* Voice_ENG */
#include "ENG_IF.c"
#include "ENG_II.c"
#include "ENG_LA.c"
#include "ENG_POF.c"
#include "ENG_PON.c"
static const unsigned char * Voice_Tab_ENG[] = {
	ENG_IF,
	ENG_POF,
	ENG_PON,
	ENG_LA,
	ENG_II
};

static const unsigned int Voice_Tab_ENG_LEN[] = {
	13824,
	5888,
	4992,
	19072,
	14592
};
/*************/
/* Voice_CHN */
#include "CHN_IF.c"
#include "CHN_II.c"
#include "CHN_LA.c"
#include "CHN_POF.c"
#include "CHN_PON.c"

static const unsigned char *Voice_Tab_CHN[] = {
	CHN_IF,
	CHN_POF,
	CHN_PON,
	CHN_LA,
	CHN_II
};

static const unsigned int Voice_Tab_CHN_LEN[] = {
	14208,
	4480,
	4608,
	16640,
	13184
};
/*************/

Voice_Language_Typedef Voice_Language[LANGUAGE_MAX] =
{
{Voice_Tab_CHN, Voice_Tab_CHN_LEN},
{Voice_Tab_ENG, Voice_Tab_ENG_LEN}
};


#define DAC_DHR8R1_Address 0x40007410

uint8_t Sin[128] = {128, 134, 141, 147, 153, 159, 165, 171, 177, 183, 188, 194, 199, 204, 209, 214, 219, 223, 227, 231, 234, 238, 241, 244, 246, 249, 250, 252, 254, 255, 255, 255, 255, 255, 255, 255, 254, 252, 250, 249, 246, 244, 241, 238, 234, 231, 227, 223, 219, 214, 209, 204, 199, 194, 188, 183, 177, 171, 165, 159, 153, 147, 141, 134, 128, 122, 115, 109, 103, 97, 91, 85, 79, 73, 68, 62, 57, 52, 47, 42, 37, 33, 29, 25, 22, 18, 15, 12, 10, 7, 6, 4, 2, 1, 1, 0, 0, 0, 1, 1, 2, 4, 6, 7, 10, 12, 15, 18, 22, 25, 29, 33, 37, 42, 47, 52, 57, 62, 68, 73, 79, 85, 91, 97, 103, 109, 115, 122};

extern System_Status_Typedef System_Status;
DMA_InitTypeDef DMA_InitStructure;
	

	
void XB_Voice_Init(void)
{
	DAC_InitTypeDef DAC_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	NVIC_InitTypeDef NVIC_InitStructure;
	
	/* RCC_Config */
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA2, ENABLE);
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_DAC, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_TIM5, ENABLE);
	
	//DAC_GPIO_Init();
	/* GPIO_Init */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_4;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AIN;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	TIM_PrescalerConfig(TIM5, 29, TIM_PSCReloadMode_Update);
	TIM_SetAutoreload(TIM5, 375);
	
	TIM_SelectOutputTrigger(TIM5, TIM_TRGOSource_Update);
	
	/* NVIC Config */
	NVIC_InitStructure.NVIC_IRQChannel = DMA2_Channel3_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = DAC_DMA_PRI_PRE;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = DAC_DMA_PRI_SUB;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	
	/* DAC_Config */
	DAC_InitStructure.DAC_Trigger = DAC_Trigger_T5_TRGO;
	DAC_InitStructure.DAC_WaveGeneration = DAC_WaveGeneration_None;
	DAC_InitStructure.DAC_OutputBuffer = DAC_OutputBuffer_Disable;
	DAC_InitStructure.DAC_LFSRUnmask_TriangleAmplitude = DAC_LFSRUnmask_Bit0;
	DAC_Init(DAC_Channel_1, &DAC_InitStructure);
	
	/* DMA_Config */
	DMA_DeInit(DMA2_Channel3);
	
	DMA_InitStructure.DMA_PeripheralBaseAddr = DAC_DHR8R1_Address;
  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)Voice_Tab_CHN[1];
  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralDST;
  DMA_InitStructure.DMA_BufferSize = 4000;
  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_Byte;
  DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
  DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
  DMA_InitStructure.DMA_Priority = DMA_Priority_High;
  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	
	DMA_Init(DMA2_Channel3, &DMA_InitStructure);
	
	/* DMA_IT Config */
	DMA_ITConfig(DMA2_Channel3, DMA_IT_TC, ENABLE);
	
//  /* Enable DMA2 Channel3 */
//  DMA_Cmd(DMA2_Channel3, ENABLE);

  /* Enable DAC Channel1: Once the DAC channel1 is enabled, PA.04 is 
     automatically connected to the DAC converter. */
  DAC_Cmd(DAC_Channel_1, ENABLE);

  /* Enable DMA for DAC Channel1 */
  DAC_DMACmd(DAC_Channel_1, ENABLE);
	
//	TIM_Cmd(TIM5, ENABLE);
	XB_M62429_Init();
	XB_Set_Volume(100);
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE);
	GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable, ENABLE);  
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	GPIO_WriteBit(GPIOB, GPIO_Pin_3, Bit_SET);
	CS_SD(1);
}

void XB_M62429_Init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_8;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	GPIO_WriteBit(GPIOA, GPIO_Pin_5, Bit_SET);
	
}

void Delay_nop(uint16_t Time)
{
	uint16_t Cnt;
	for(Cnt = 0; Cnt < Time; Cnt++)
	{
		__nop();
	}
}

void XB_Set_Volume(uint8_t Per)
{
	uint16_t Vol_Word;
	uint8_t Cnt;
	if(Per <= 100)
	{
		Vol_Word = 0x0782 | (((uint16_t)Per * 21) / 100 << 2);
		for(Cnt = 0; Cnt < 11; Cnt++)
		{
			M6_Clk(0);
			Delay_nop(50);
			if(Vol_Word & 0x0001)
			{
				M6_Data(1);
			}
			else
			{
				M6_Data(0);
			}
			Delay_nop(50);
			M6_Clk(1);
			Delay_nop(50);
			Vol_Word >>= 1;
			M6_Data(0);
			Delay_nop(50);
		}
		M6_Data(1);
		Delay_nop(50);
		M6_Clk(0);
		Delay_nop(50);
	}
}

uint8_t XB_Set_Play(uint8_t Voice_N)
{
	if(!(TIM5->CR1 & (uint16_t)TIM_CR1_CEN) && System_Status.System_Setting.Volume)
	{
		DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)(uint32_t)Voice_Language[System_Status.System_Setting.Language].Voice_Tab[Voice_N];
		DMA_InitStructure.DMA_BufferSize = Voice_Language[System_Status.System_Setting.Language].Voice_Tab_LEN[Voice_N];
		DMA_Init(DMA2_Channel3, &DMA_InitStructure);
		DMA_Cmd(DMA2_Channel3, ENABLE);
		TIM_Cmd(TIM5, ENABLE);
		
		return 0;
	}
	return 1;
}

void DMA2_Channel3_IRQHandler(void)
{
	if(DMA_GetITStatus(DMA2_IT_TC3))
	{
		DMA_ClearITPendingBit(DMA2_IT_TC3);
		DMA_Cmd(DMA2_Channel3, DISABLE);
		TIM_Cmd(TIM5, DISABLE);
	}
}
