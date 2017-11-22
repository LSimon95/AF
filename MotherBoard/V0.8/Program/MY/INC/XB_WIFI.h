/*
**File_Name:      XB_WIFI.h
**Version:        1.1
**Date_Modified:  2016-07-09
**File_Type:      C
**Size:           1024
**Platform:       Stm32
**Note:
*/

#ifndef _XB_WIFI_H
#define _XB_WIFI_H

#include "stm32f10x.h"
#include "stdio.h"
#include "stdlib.h"
#include "stdarg.h"
#include "string.h"

#include "main.h"

#define XB_WIFI_ESP8266_07    

typedef struct
{
	/* WIFI Mode */
	uint8_t WIFI_Mode;	//1.Sta 2.AP 3.AP+Sta
	
	/* AP Configuration */
	char *AP_Name;
	char *AP_Pass;
	uint8_t AP_Chl;
	uint8_t AP_Ecn;	//0.OPEN 1.WEP 2.WAP_PSK
									//3.WPA2_PSK 4.WPA_WPA2_PSK
	
	/* TCP/IP Configuration */
	uint8_t TCPIP_CIPMUX;	//0.Siglepath 1.Multipath
	
	uint8_t Client_Num;
	uint8_t Client_ID[10];
	
	/* Flag */
	
	
}XB_WIFI_TypedefStructure;

#define RX_BUF_LEN 256
#define MAX_SEND_LEN 256

#ifndef XB_WIFI_ESP8266_07
#error "Please define a WIFI device"
#endif 

uint8_t XB_WIFI_Init(XB_WIFI_TypedefStructure *XB_WIFI_Structure);
uint8_t XB_WIFI_AP_Send_Str(uint8_t Client_Num, char *fmt, ...);

void XB_Alcohol_AP_Send_Data(uint8_t Client_Num, uint8_t Fire_Status, uint8_t Temperture, uint16_t Error_Word);

void XB_USART_Init(uint32_t Boud_Rate);

uint8_t *XB_WIFI_Get_Data(void);

uint8_t Wait_For_Signal(char *Signal, uint16_t TimeOutms);

#ifdef XB_WIFI_ESP8266_07

#endif

#endif
