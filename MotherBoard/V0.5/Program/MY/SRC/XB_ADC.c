/*
**File_Name:      XB_ADC.c
**Version:        1.0
**Date_Modified:  2016-04-14
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/
#include "XB_ADC.h"

#define ADC1_DR_Address    ((u32)0x4001244C)	

__IO u16 ADC_ConvertedValue;  

uint16_t  AD_Value[NUM_CHANNEL * NUM_SAMPLE];     //�������ADCת�������Ҳ��DMA��Ŀ���ַ
uint16_t  XB_ADC_After_Filter[NUM_CHANNEL];    //���������ƽ��ֵ֮��Ľ��

/*���ò���ͨ���˿� ʹ��GPIOʱ��	  ����ADC����PA0�˿��ź�*/
 void ADC_GPIO_Config(void)
{ 
	GPIO_InitTypeDef GPIO_InitStructure;    
	
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
	
  GPIO_InitStructure.GPIO_Pin = XB_ADC_1GPIO_PIN | GPIO_Pin_2;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AIN;		    //GPIO����Ϊģ������
  GPIO_Init(XB_ADC_1GPIO, &GPIO_InitStructure);   
}


 void ADC_Mode_Config(void)
{
  DMA_InitTypeDef DMA_InitStructure;
  ADC_InitTypeDef ADC_InitStructure;	
  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE); //ʹ��MDA1ʱ��
	
	/* DMA channel1 configuration */
  DMA_DeInit(DMA1_Channel1);  //ָ��DMAͨ��
  DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&(ADC1->DR);//����DMA�����ַ
  DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)AD_Value;	//����DMA�ڴ��ַ��ADCת�����ֱ�ӷ���õ�ַ
  DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC; //����Ϊ����Ϊ���ݴ������Դ
  DMA_InitStructure.DMA_BufferSize = NUM_SAMPLE * NUM_CHANNEL;	//DMA����������ΪN*M��
  DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_HalfWord;
  DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_HalfWord;
  DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
  DMA_InitStructure.DMA_Priority = DMA_Priority_High;
  DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
  DMA_Init(DMA1_Channel1, &DMA_InitStructure);
  
  /* Enable DMA channel1 */
  DMA_Cmd(DMA1_Channel1, ENABLE);  //ʹ��DMAͨ��

  RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE);	//ʹ��ADC1ʱ��
     
  /* ADC1 configuration */
  ADC_InitStructure.ADC_Mode = ADC_Mode_Independent; //ʹ�ö���ģʽ��ɨ��ģʽ
  ADC_InitStructure.ADC_ScanConvMode = ENABLE;
  ADC_InitStructure.ADC_ContinuousConvMode = ENABLE; //������Ӵ�����
  ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_None; 
  ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;//ʹ�������Ҷ���
  ADC_InitStructure.ADC_NbrOfChannel = NUM_CHANNEL;  // ֻ��1��ת��ͨ��
  ADC_Init(ADC1, &ADC_InitStructure);

  /* ADC1 regular channel11 configuration */ 
  ADC_RegularChannelConfig(ADC1, ADC_Channel_10, 1, ADC_SampleTime_55Cycles5); //ͨ��10��������55.5��ʱ������
	ADC_RegularChannelConfig(ADC1, ADC_Channel_12, 2, ADC_SampleTime_55Cycles5);

  /* Enable ADC1 DMA */
  ADC_DMACmd(ADC1, ENABLE);	 //ʹ��ADC��DMA
  
  /* Enable ADC1 */
  ADC_Cmd(ADC1, ENABLE); //ʹ��ADC1

  /* Enable ADC1 reset calibaration register */   
  ADC_ResetCalibration(ADC1);
  /* Check the end of ADC1 reset calibration register */
  while(ADC_GetResetCalibrationStatus(ADC1));

  /* Start ADC1 calibaration */
  ADC_StartCalibration(ADC1);
  /* Check the end of ADC1 calibration */
  while(ADC_GetCalibrationStatus(ADC1));
     
  /* Start ADC1 Software Conversion */ 
  ADC_SoftwareStartConvCmd(ADC1, ENABLE);  //��ʼת��
}

/*��ʼ��ADC1 */
void XB_ADC_Init(void)
{
	ADC_GPIO_Config();
	ADC_Mode_Config();
}


/*��ƽ��ֵ����*/
void XB_ADC_Filter(void)
{
	uint32_t  Sum = 0;
	uint8_t Ctr1 = 0, Ctr2 = 0;
	for(Ctr1 = 0; Ctr1 < NUM_CHANNEL; Ctr1++)
	{	
		for ( Ctr2 = 0; Ctr2 < NUM_SAMPLE; Ctr2++)
		{	
			Sum += AD_Value[Ctr2 * Ctr1];
		}
		XB_ADC_After_Filter[Ctr1] = Sum / NUM_SAMPLE;
		Sum = 0;
	}
}



