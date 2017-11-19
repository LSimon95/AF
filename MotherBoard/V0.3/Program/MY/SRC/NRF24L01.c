#include "NRF24L01.h"

uint8_t NRF_FIFO_Sta;
uint8_t NRF_Sta;

uint8_t const TX_ADDRESS_P0[TX_ADR_WIDTH]= {0x34, 0x43, 0x10, 0x10, 0x01};						//定义地址


void NRF_SPI_RCC_Config(void)
{
	//RCC_AHBPeriphClockCmd
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI2, ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);
}

void NRF_SPI_Low_Level_Config(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	SPI_InitTypeDef  SPI_InitStructure;
	NRF_SPI_RCC_Config();
	
	/*SPI_PIN*/
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/*NSS_PIN*/
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_11;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/* IRQ_PIN */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOB, &GPIO_InitStructure);
	
	/*SPI_Config*/
	SPI_Cmd(SPI2, DISABLE);
	SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
	SPI_InitStructure.SPI_Mode = SPI_Mode_Master;
	SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;
	SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;        //CPOL = 0
	SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;       //CPHA = 0
	SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;
	SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_128;  //Hz?
	SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;
	SPI_InitStructure.SPI_CRCPolynomial = 7;

	SPI_Init(SPI2, &SPI_InitStructure);
	SPI_Cmd(SPI2, ENABLE);
}

void Check_NRF(void)
{
	uint8_t Buf[5], i;
	NRF_Write_Buf(NRF_WRITE_REG + NRF_TX_ADDR, (uint8_t *)TX_ADDRESS_P0, TX_ADR_WIDTH);
	NRF_Read_Buf(NRF_TX_ADDR, Buf, TX_ADR_WIDTH);
	for(i = 0; i < TX_ADR_WIDTH; i++)
	{
		if(Buf[i] != TX_ADDRESS_P0[i])
		{
			LCD_write_english_string(0, 1, (uint8_t *)"NRF Error!");
			while(1);
		}
	}
	
}

uint8_t NRF_Init(void)
{
	NRF_SPI_Low_Level_Config();
	Delay_ms(1);
	NRF_CE(0);
	NRF_NSS(1);
	NRF_NSS(0);
	Check_NRF();
	NRF_Write_Buf(NRF_WRITE_REG + NRF_TX_ADDR, (uint8_t *)TX_ADDRESS_P0, TX_ADR_WIDTH);
	NRF_Write_Buf(NRF_WRITE_REG + NRF_RX_ADDR_P0, (uint8_t *)TX_ADDRESS_P0, RX_ADR_WIDTH);
	
	NRF_Write_Reg(NRF_WRITE_REG + NRF_SETUP_RETR, 0x3f);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_EN_AA, 0x01); //Changed but have not tested & Remeber to add the flush TX code!!
	NRF_Write_Reg(NRF_WRITE_REG + NRF_EN_RXADDR, 0x01); 
	NRF_Write_Reg(NRF_WRITE_REG + NRF_RF_CH, 0);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_RX_PW_P0, RX_PLOAD_WIDTH);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_RX_PW_P1, RX_PLOAD_WIDTH);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_RF_SETUP, 0x07);
		
	return 0;
}

uint8_t NRF_ReadWrite(uint8_t Byte)
{
	uint8_t Return_Byte;
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_TXE) == RESET);
	SPI_I2S_SendData(SPI2, Byte);
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_RXNE) == RESET);
	Return_Byte = SPI_I2S_ReceiveData(SPI2);
	
	return Return_Byte;
}

uint8_t NRF_Write_Reg(uint8_t Reg, uint8_t Value)
{
	uint8_t Status;
	
	NRF_NSS(0);
	
	Status = NRF_ReadWrite(Reg);
	NRF_ReadWrite(Value);
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_BSY) == SET);
	NRF_NSS(1);
	
	return(Status);
}

uint8_t NRF_Read_Reg(uint8_t Reg)
{
	uint8_t Reg_Value;
	
	NRF_NSS(0);
	
	NRF_ReadWrite(Reg);
	Reg_Value = NRF_ReadWrite(0x00);
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_BSY) == SET);
	NRF_NSS(1);
	
	return Reg_Value;
}

uint8_t NRF_Read_Buf(uint8_t Reg, uint8_t *Buf, uint8_t Num)
{
	uint8_t Status, i;
	
	NRF_NSS(0);
	
	Status = NRF_ReadWrite(Reg);
	for(i = 0; i < Num; i++)
		Buf[i] = NRF_ReadWrite(0x00);
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_BSY) == SET);
	NRF_NSS(1);	
	
	return(Status);
}

uint8_t NRF_Write_Buf(uint8_t Reg, uint8_t *Buf, uint8_t Num)
{
	uint8_t Status, i;
	
	NRF_NSS(0);
	
	Status = NRF_ReadWrite(Reg);
	
	for(i = 0; i < Num; i++)
		NRF_ReadWrite(Buf[i]);
	
	while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_BSY) == SET);
	NRF_NSS(1);
	
	return(Status);
}

void NRF_Set_Rx_Mode(void)
{
	NRF_CE(0);
	
	NRF_Write_Reg(NRF_WRITE_REG + NRF_CONFIG, 0x0f);
	
	NRF_CE(1);
}

uint8_t NRF24L01_RxPacket(uint8_t *Rx_Buf)						//接受数据
{
  uint8_t Return_Byte = 0;
	
	NRF_FIFO_Sta = NRF_Read_Reg(NRF_FIFO_STATUS);
	NRF_Sta = NRF_Read_Reg(NRF_STATUS);
	NRF_Read_Reg(NRF_CONFIG);
	if(BYTE_BIT(NRF_FIFO_Sta, 0) != 0x01)
	{
	  NRF_CE(0); //Rturn to Standby mode. Must set NRF to Rx_Mode again before receive data
		NRF_Read_Buf(NRF_RD_RX_PLOAD, Rx_Buf, RX_PLOAD_WIDTH);
		Return_Byte = 1;    		
	}
	NRF_Write_Reg(NRF_WRITE_REG + NRF_STATUS, NRF_Sta);
	NRF_Read_Reg(NRF_FIFO_STATUS);
	
	return Return_Byte;
}

void NRF24L01_TxPacket(uint8_t * Tx_Buf)						//发送数据
{
	NRF_CE(0);
	
	NRF_Sta = NRF_Read_Reg(NRF_STATUS);
	NRF_Read_Reg(NRF_FIFO_STATUS);
	NRF_Write_Buf(NRF_WRITE_REG + NRF_RX_ADDR_P1, (uint8_t *)TX_ADDRESS_P0, TX_ADR_WIDTH);
	NRF_Write_Buf(NRF_WR_TX_PLOAD, Tx_Buf, TX_PLOAD_WIDTH);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_CONFIG, 0x0e);
	NRF_Write_Reg(NRF_WRITE_REG + NRF_STATUS, NRF_Sta);
	NRF_Read_Reg(NRF_STATUS);
	
	NRF_CE(1);
	
	Delay_ms(1);
}

