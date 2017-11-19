#include"Mpu6050.h"

__IO uint8_t* MPUDataReadPointer;
__IO uint32_t	MPU_Flag_TimeOut = 10000;
__IO uint32_t MPU_TimeOut;

DMA_InitTypeDef MPU6050_DMA_InitStructure;

void MPU_LowLevel_DMAConfig(uint32_t pBuffer, uint32_t BufferSize, uint8_t Direction)
{ 
  /* Initialize the DMA with the new parameters */
  /* Configure the DMA Rx Channel with the buffer address and the buffer size */
	if(Direction == MPU_DMA_DIRECTION_RX)
	{
		DMA_Cmd(DMA1_Channel7, DISABLE);
		MPU6050_DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)pBuffer;
		MPU6050_DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;
		MPU6050_DMA_InitStructure.DMA_BufferSize =(uint32_t)BufferSize;      
		DMA_Init(DMA1_Channel7, &MPU6050_DMA_InitStructure);    
	}
	else if(Direction == MPU_DMA_DIRECTION_TX)
	{
		DMA_Cmd(DMA1_Channel6, DISABLE);
		MPU6050_DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)pBuffer;
		MPU6050_DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralDST;
		MPU6050_DMA_InitStructure.DMA_BufferSize =(uint32_t)BufferSize;
		DMA_Init(DMA1_Channel6, &MPU6050_DMA_InitStructure);
	}
}

void MPU_LowLevel_Init(void)
{
	GPIO_InitTypeDef  GPIO_InitStructure;
	
	/* Enable I2C1 reset state */
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_I2C1, ENABLE);
	/* Release I2C1 from reset state */
	RCC_APB1PeriphResetCmd(RCC_APB1Periph_I2C1, DISABLE);
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_I2C1, ENABLE);
	//***************GPIO_SCL_Init*******************//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	//***************GPIO_SDA_Init*******************//
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_OD;
  GPIO_Init(GPIOB, &GPIO_InitStructure);
}

void MPU_I2C_Init(void)
{
	I2C_InitTypeDef I2C_initStructure;
	NVIC_InitTypeDef NVIC_InitStructure; 

	MPU_LowLevel_Init();
	GPIO_SetBits(GPIOB, GPIO_Pin_6 | GPIO_Pin_7);
	/* Configure and enable I2C DMA TX Channel interrupt */
	NVIC_InitStructure.NVIC_IRQChannel = DMA1_Channel6_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
  /* Configure and enable I2C DMA RX Channel interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = DMA1_Channel7_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
	//NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE; //careful!!
  NVIC_Init(&NVIC_InitStructure);  
  
  /*!< I2C DMA TX and RX channels configuration */
  /* Enable the DMA clock */
  RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);

  /* I2C TX DMA Channel configuration */
  DMA_DeInit(DMA1_Channel6);
  MPU6050_DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)MPU_I2C_DR_Address;
  MPU6050_DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)0;   /* This parameter will be configured durig communication */
  MPU6050_DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;    /* This parameter will be configured durig communication */
  MPU6050_DMA_InitStructure.DMA_BufferSize = 0xFFFF;            /* This parameter will be configured durig communication */
  MPU6050_DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
  MPU6050_DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
  MPU6050_DMA_InitStructure.DMA_PeripheralDataSize = DMA_MemoryDataSize_Byte;
  MPU6050_DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_Byte;
  MPU6050_DMA_InitStructure.DMA_Mode = DMA_Mode_Normal;
  MPU6050_DMA_InitStructure.DMA_Priority = DMA_Priority_VeryHigh;
  MPU6050_DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
  DMA_Init(DMA1_Channel6, &MPU6050_DMA_InitStructure);  
  
  /* I2C RX DMA Channel configuration */
  DMA_DeInit(DMA1_Channel7);
  DMA_Init(DMA1_Channel7, &MPU6050_DMA_InitStructure);  
  
  /* Enable the DMA Channels Interrupts */
  DMA_ITConfig(DMA1_Channel7, DMA_IT_TC, ENABLE);
	DMA_ITConfig(DMA1_Channel6, DMA_IT_TC, ENABLE);
	
	I2C_Cmd(I2C1, DISABLE);
	//****************I2C_Init*******************//
	I2C_initStructure.I2C_Mode = I2C_Mode_I2C;
	I2C_initStructure.I2C_DutyCycle = I2C_DutyCycle_2;
	I2C_initStructure.I2C_OwnAddress1 = 0x88;
	I2C_initStructure.I2C_Ack = I2C_Ack_Enable;
	I2C_initStructure.I2C_AcknowledgedAddress = I2C_AcknowledgedAddress_7bit;
	I2C_initStructure.I2C_ClockSpeed = 50000;
	I2C_Cmd(I2C1, ENABLE);
	
	I2C_Init(I2C1, &I2C_initStructure);
	
	I2C_DMACmd(I2C1, ENABLE);
}

uint8_t I2C_Write_Buf(uint8_t Dev_Addr, uint8_t Reg, uint8_t Len, uint8_t *Buf)
{
	while(I2C_GetFlagStatus(I2C1, I2C_FLAG_BUSY));
	
	I2C_GenerateSTART(I2C1, ENABLE);
	/*Test EV5*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	I2C_Send7bitAddress(I2C1, Dev_Addr, I2C_Direction_Transmitter);	
	
	/*Test on EV6*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	I2C_SendData(I2C1, Reg);
	/*Test EV8*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_BYTE_TRANSMITTED))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	MPU_LowLevel_DMAConfig((uint32_t)Buf, Len, MPU_DMA_DIRECTION_TX);
	
	DMA_Cmd(DMA1_Channel6, ENABLE);
	
	return 0;
}

uint8_t I2C_Read_Buf(uint8_t Dev_Addr, uint8_t Reg, uint8_t Len, uint8_t *Buf)
{
	MPUDataReadPointer = &Len;
	
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(I2C_GetFlagStatus(I2C1, I2C_FLAG_BUSY))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	I2C_GenerateSTART(I2C1, ENABLE);
	/*Test EV5*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	I2C_Send7bitAddress(I2C1, Dev_Addr, I2C_Direction_Transmitter);
	/*Test on EV6*/
	MPU_TimeOut = MPU_Flag_TimeOut;
  while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_TRANSMITTER_MODE_SELECTED))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
	
	I2C_SendData(I2C1, Reg);
	/*Test EV8*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(I2C_GetFlagStatus(I2C1, I2C_FLAG_BTF) == RESET)
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}
		
	I2C_GenerateSTART(I2C1, ENABLE);
	/*Test EV5*/
	MPU_TimeOut = MPU_Flag_TimeOut;
	while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_MODE_SELECT))
	{
		if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
	}

	I2C_Send7bitAddress(I2C1, Dev_Addr, I2C_Direction_Receiver);  
	if(Len < 2)
	{
		/* Wait on ADDR flag to be set (ADDR is still not cleared at this level */
		MPU_TimeOut = MPU_Flag_TimeOut;
		while(I2C_GetFlagStatus(I2C1, I2C_FLAG_ADDR) == RESET)
		{
			if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
		}

		I2C_AcknowledgeConfig(I2C1, DISABLE);
	
		__disable_irq();
	
		I2C1->SR2;
	
		I2C_GenerateSTOP(I2C1, ENABLE);

		__enable_irq();
		
		MPU_TimeOut = MPU_Flag_TimeOut;
		while(I2C_GetFlagStatus(I2C1, I2C_FLAG_RXNE) == RESET)
		{
			if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
		}

		*Buf = I2C_ReceiveData(I2C1);
		
		MPU_TimeOut = MPU_Flag_TimeOut;
		while(I2C1->CR1 & I2C_CR1_STOP)
		{
			if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
		}
	}
	else
	{
		 /*!< Test on EV6 and clear it */
		MPU_TimeOut = MPU_Flag_TimeOut;
		while(!I2C_CheckEvent(I2C1, I2C_EVENT_MASTER_RECEIVER_MODE_SELECTED))
		{
			if((MPU_TimeOut--) == 0) return Time_Out_Call_Reset();
		}
		
		MPU_LowLevel_DMAConfig((uint32_t)Buf, Len, MPU_DMA_DIRECTION_RX);
		
		/* Inform the DMA that the next End Of Transfer Signal will be the last one */
    I2C_DMALastTransferCmd(I2C1, ENABLE); 
		/* Enable the DMA Rx Channel */
		DMA_Cmd(DMA1_Channel7, ENABLE); 
	}
	
	return 0;
}

void MPU_Init(void)
{
	MPU_I2C_Init();
	/*
	I2C_Write_Byte(MPU_PWR_MGMT_1, 0x00);
	I2C_Write_Byte(MPU_SMPLRT_DIV, 0x07);
	I2C_Write_Byte(MPU_CONFIG, 0x06);
	I2C_Write_Byte(MPU_ACCEL_CONFIG, 0x00);
	I2C_Write_Byte(MPU_GYRO_CONFIG, 0x18);
	*/
}

uint8_t Time_Out_Call_Reset(void)
{
	MPU_I2C_Init();
	LCD_write_vlaue(0, 1, 0);
	return 0;
}

void DMA1_Channel7_IRQHandler(void)
{
  /* Check if the DMA transfer is complete */
  if(DMA_GetFlagStatus(DMA1_IT_TC7) != RESET)
  {      
    /*!< Send STOP Condition */
    I2C_GenerateSTOP(I2C1, ENABLE);    
    /* Disable the DMA Rx Channel and Clear all its Flags */  
    DMA_Cmd(DMA1_Channel7, DISABLE);
    DMA_ClearFlag(DMA1_IT_GL7);
		
    /* Reset the variable holding the number of data to be read */
    *MPUDataReadPointer = 0;
  }
}

void DMA1_Channel6_IRQHandler(void)
{
	/* Check if the DMA transfer is complete */ 
  if(DMA_GetFlagStatus(DMA1_IT_TC6) != RESET)
  {  
		LCD_write_vlaue(0, 2, DMA1_Channel6->CNDTR);
    /* Disable the DMA Tx Channel and Clear all its Flags */  
    DMA_Cmd(DMA1_Channel6, DISABLE);
    DMA_ClearFlag(DMA1_FLAG_GL6);

    /*!< Wait till all data have been physically transferred on the bus */
    MPU_TimeOut = MPU_Flag_TimeOut;
		while(!I2C_GetFlagStatus(I2C1, I2C_FLAG_BTF))
		{
			if((MPU_TimeOut--) == 0) Time_Out_Call_Reset();
		}
    
    /*!< Send STOP condition */
    I2C_GenerateSTOP(I2C1, ENABLE);
    
    /* Perform a read on SR1 and SR2 register to clear eventualaly pending flags */
    (void)I2C1->SR1;
    (void)I2C1->SR2;
	}
}
