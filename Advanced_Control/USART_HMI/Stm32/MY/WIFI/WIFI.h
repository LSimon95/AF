#ifndef __WIFI_H
#define __WIFI_H 
#include "stdio.h"	  
#include "main.h"
	
#define u16 uint16_t
#define u32 uint32_t
#define u8  uint8_t
	
#define delay_ms Delay_ms

#define USART2_MAX_RECV_LEN		800					//�����ջ����ֽ���
#define USART2_MAX_SEND_LEN		800					//����ͻ����ֽ���
#define USART2_RX_EN 			1					//0,������;1,����.

extern u8  USART2_RX_BUF[USART2_MAX_RECV_LEN]; 		//���ջ���,���USART3_MAX_RECV_LEN�ֽ�
extern u8  USART2_TX_BUF[USART2_MAX_SEND_LEN]; 		//���ͻ���,���USART3_MAX_SEND_LEN�ֽ�
extern vu16 USART2_RX_STA;   						//��������״̬

void usart2_init(u32 pclk1,u32 bound);
void u2_printf(char* fmt,...);
void TIM3_Int_Init(u16 arr,u16 psc);

u8 analyse_wificontrol(void);
void WIFISEND(u8 data);
void Start_Wifi(void);

void Delay_100ms(void);

u8 WifiAnalyse(void);
#endif	   
















