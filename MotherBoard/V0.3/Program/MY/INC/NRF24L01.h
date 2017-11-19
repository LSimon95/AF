#ifndef _NRF24L01_H
#define _NRF24L01_H

#include "stm32f10x.h"
#include "delay.h"
#include "NOKIA5110.h"

#define BYTE_BIT(Byte,N) ((Byte>>N)&0x01)

//********************NRF_COMMOND_REG*********************//
#define TX_ADR_WIDTH    5   	// 5 uints TX address width
#define RX_ADR_WIDTH    5   	// 5 uints RX address width
#define TX_PLOAD_WIDTH  7  	// 2 uints TX payload
#define RX_PLOAD_WIDTH  1  	// 2 uints TX payload
//********************************************************//
#define NRF_READ_REG        0x00
#define NRF_WRITE_REG       0x20
#define NRF_RD_RX_PLOAD     0x61
#define NRF_WR_TX_PLOAD     0xA0
#define NRF_FLUSH_TX        0xE1
#define NRF_FLUSH_RX        0xE2
#define NRF_REUSE_TX_PL     0xE3 
#define NRF_NOP             0xFF
//********************************************************//
#define NRF_CONFIG          0x00 
#define NRF_EN_AA           0x01
#define NRF_EN_RXADDR       0x02
#define NRF_SETUP_AW        0x03
#define NRF_SETUP_RETR      0x04
#define NRF_RF_CH           0x05
#define NRF_RF_SETUP        0x06
#define NRF_STATUS          0x07
#define NRF_OBSERVE_TX      0x08
#define NRF_CD              0x09  
#define NRF_RX_ADDR_P0      0x0A
#define NRF_RX_ADDR_P1      0x0B
#define NRF_RX_ADDR_P2      0x0C
#define NRF_RX_ADDR_P3      0x0D
#define NRF_RX_ADDR_P4      0x0E
#define NRF_RX_ADDR_P5      0x0F
#define NRF_TX_ADDR         0x10
#define NRF_RX_PW_P0        0x11
#define NRF_RX_PW_P1        0x12
#define NRF_RX_PW_P2        0x13
#define NRF_RX_PW_P3        0x14
#define NRF_RX_PW_P4        0x15
#define NRF_RX_PW_P5        0x16
#define NRF_FIFO_STATUS     0x17
//********************************************************//


void NRF_SPI_RCC_Config(void);
void NRF_SPI_Low_Level_Config(void);
uint8_t NRF_Init(void);
uint8_t NRF_ReadWrite(uint8_t Byte);
uint8_t NRF_Write_Reg(uint8_t Reg, uint8_t Value);
uint8_t NRF_Read_Reg(uint8_t Reg);
uint8_t NRF_Read_Buf(uint8_t Reg, uint8_t *Buf, uint8_t Num);
uint8_t NRF_Write_Buf(uint8_t Reg, uint8_t *Buf, uint8_t Num);
void NRF_Set_Rx_Mode(void);
uint8_t NRF24L01_RxPacket(uint8_t *Rx_Buf);
void NRF24L01_TxPacket(uint8_t * Tx_Buf);



#define NRF_NSS(a) if(a)\
				GPIO_SetBits(GPIOB, GPIO_Pin_12);\
				else \
				GPIO_ResetBits(GPIOB, GPIO_Pin_12)	
				
#define NRF_CE(a) if(a)\
				GPIO_SetBits(GPIOB, GPIO_Pin_11);\
				else \
				GPIO_ResetBits(GPIOB, GPIO_Pin_11)	


#endif
