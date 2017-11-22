#include "WIFI.h"	  
#include "stdarg.h"	 	 
#include "stdio.h"	 	 
#include "string.h"

u8 ConnectClient = 0;
u32 SYSTMESTATUS = 0;
extern System_Status_Typedef System_Status;

extern uint8_t WIFI_Control_Val;

	NVIC_InitTypeDef NVIC_InitStructure;

//������gps���ݽ��������ļ�
//���ڷ��ͻ����� 	
__align(8) u8 USART2_TX_BUF[USART2_MAX_SEND_LEN]; 	//���ͻ���,���USART2_MAX_SEND_LEN�ֽ�
//���ڽ��ջ����� 	
u8 USART2_RX_BUF[USART2_MAX_RECV_LEN]; 				//���ջ���,���USART2_MAX_RECV_LEN���ֽ�.

void Delay_100ms(void)
{
	uint32_t Ctr;
	for(Ctr = 0; Ctr < 400000; Ctr++)
	{
		__nop();

	}
}

vu16 USART2_RX_STA=0;   	 
void USART2_IRQHandler(void)
{
	u8 res;	     
	if(USART2->SR&(1<<5))//���յ�����
	{	 
		
		res=USART2->DR; 			
	
		if((USART2_RX_STA&(1<<15))==0)//�������һ������,��û�б�����,���ٽ�����������
		{ 
			if(USART2_RX_STA<USART2_MAX_RECV_LEN)	//�����Խ�������
			{
				TIM3->CNT=0;         				//���������
				if(USART2_RX_STA==0) 				//ʹ�ܶ�ʱ��7���ж� 
				{
					TIM3->CR1|=1<<0;     			//ʹ�ܶ�ʱ��7
				}
				USART2_RX_BUF[USART2_RX_STA++]=res;	//��¼���յ���ֵ	 
		}
	}  				 											 
} 
}  

//��ʼ��IO ����3
//pclk1:PCLK1ʱ��Ƶ��(Mhz)
//bound:������ 
void usart2_init(u32 pclk1,u32 bound)
{  	 
	float temp;
	u16 mantissa;
	u16 fraction;	   
	temp=(float)(pclk1*1000000)/(bound*16);//�õ�USARTDIV,OVER8����Ϊ0
	mantissa=temp;				 	//�õ���������
	fraction=(temp-mantissa)*16; 	//�õ�С������,OVER8����Ϊ0	 
    mantissa<<=4;
	mantissa+=fraction; 
	RCC->APB2ENR|=1<<2;   //ʹ��PORTA��ʱ��  
	RCC->APB1ENR|=1<<17;  //ʹ�ܴ���ʱ�� 
	GPIOA->CRL&=0XFFFF00FF; 
	GPIOA->CRL|=0X00008B00;//IO״̬����
		RCC->APB1RSTR|=1<<17;   //��λ����1
	RCC->APB1RSTR&=~(1<<17);//ֹͣ��λ	   
	
 	USART2->BRR=(pclk1*1000000)/(bound);// ����������	 
	USART2->CR1|=0X200C;  	//1λֹͣ,��У��λ.	
	
	USART2->CR3=1<<7;   	//ʹ�ܴ���1��DMA����

	USART2->CR1|=1<<8;    	//PE�ж�ʹ��
	USART2->CR1|=1<<5;    	//���ջ������ǿ��ж�ʹ��	    	

  //MY_NVIC_Init(2,2,USART2_IRQChannel,2);//��2�����ȼ�0,0,������ȼ� 
	
	NVIC_InitStructure.NVIC_IRQChannel = USART2_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x02;
	
	NVIC_Init(&NVIC_InitStructure);
	
	TIM3_Int_Init(500-1,7200-1);	//10ms�ж�һ��
	TIM3->CR1&=~(1<<0);				//�رն�ʱ��7
	USART2_RX_STA=0;				//���� 
}


//ͨ���жϽ�������2���ַ�֮���ʱ������10ms�������ǲ���һ������������.
//���2���ַ����ռ������10ms,����Ϊ����1����������.Ҳ���ǳ���10msû�н��յ�
//�κ�����,���ʾ�˴ν������.
//���յ�������״̬
//[15]:0,û�н��յ�����;1,���յ���һ������.
//[14:0]:���յ������ݳ���

//����3,printf ����
//ȷ��һ�η������ݲ�����USART2_MAX_SEND_LEN�ֽ�
void u2_printf(char* fmt,...)  
{  
	u16 i,j;
	va_list ap;
	va_start(ap,fmt);
	vsprintf((char*)USART2_TX_BUF,fmt,ap);
	va_end(ap);
	i=strlen((const char*)USART2_TX_BUF);//�˴η������ݵĳ���
	for(j=0;j<i;j++)//ѭ����������
	{
		while((USART2->SR&0X40)==0);//ѭ������,ֱ���������   
		USART2->DR=USART2_TX_BUF[j];  
	}
}





void TIM3_IRQHandler(void)
{ 	  
	if(TIM3->SR&0X01)//�Ǹ����ж�
	{	 			   
		USART2_RX_STA|=1<<15;	//��ǽ������
		TIM3->SR&=~(1<<0);		//����жϱ�־λ		
		TIM3->CR1&=~(1<<0);		//�رն�ʱ��7	  
	}	      											 
} 

void TIM3_Int_Init(u16 arr,u16 psc)
{
	RCC->APB1ENR|=1<<1;	//TIM3ʱ��ʹ��    
 	TIM3->ARR=arr;  	//�趨�������Զ���װֵ 
	TIM3->PSC=psc;  	//Ԥ��Ƶ��	  
	TIM3->DIER|=1<<0;   //��������ж�	  
	TIM3->CR1|=0x01;    //ʹ�ܶ�ʱ��3
  //	MY_NVIC_Init(1,2,TIM7_IRQChannel,2);	//��ռ1�������ȼ�3����2									 
		NVIC_InitStructure.NVIC_IRQChannel = TIM3_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x02;
	
	NVIC_Init(&NVIC_InitStructure);
}

	u8 RX_BUF[100];
void Start_Wifi()
{
	int i=0;
	int max_wifi=0;
u2_printf("AT+CWMODE=3\r\n") ;
delay_ms(1000);
if(USART2_RX_STA&0X8000)	//���յ�GPS������	//���յ�һ��������
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
	
	u2_printf("AT+RST\r\n") ;  
	delay_ms(1000);delay_ms(1000);
	 if(USART2_RX_STA&0X8000)	//���յ�GPS������	//���յ�һ��������
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
		  u2_printf("AT+CIPMUX=1\r\n") ;
		delay_ms(1000);

 if(USART2_RX_STA&0X8000)	//���յ�GPS������	//���յ�һ��������
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
	u2_printf("AT+CWSAP=\"ArtFire\",\"12345678\",1,3\r\n") ;delay_ms(1000);
	
  if(USART2_RX_STA&0X8000)	//���յ�GPS������	//���յ�һ��������
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
		//LCD_write_english_size8string(0,1,RX_BUF);
		}
	
	 	u2_printf("AT+CIPSERVER=1,8080\r\n") ;delay_ms(1000);

  if(USART2_RX_STA&0X8000)	//���յ�GPS������	//���յ�һ��������
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	
		}

}
u8 AnalyseWificontrol()
{ u8 res=0;
int i=0;
	for(i=0;i<20;i++)
			 {     if(RX_BUF[i]=='A'&&RX_BUF[i+1]=='R'&&RX_BUF[i+2]=='T'&&RX_BUF[i+3]=='O'&&RX_BUF[i+4]=='N'&&RX_BUF[i+5]=='N')
							res=1;
	             if(RX_BUF[i]=='A'&&RX_BUF[i+1]=='R'&&RX_BUF[i+2]=='T'&&RX_BUF[i+3]=='O'&&RX_BUF[i+4]=='F'&&RX_BUF[i+5]=='F')
							res=2;
						    if(RX_BUF[i]=='A'&&RX_BUF[i+1]=='R'&&RX_BUF[i+2]=='T'&&RX_BUF[i+3]=='T'&&RX_BUF[i+4]=='O'&&RX_BUF[i+5]=='M')
							res=3;
					 if(RX_BUF[i]=='A'&&RX_BUF[i+1]=='R'&&RX_BUF[i+2]=='T'&&RX_BUF[i+3]=='T'&&RX_BUF[i+4]=='N'&&RX_BUF[i+5]=='M')
							res=4;
						if(RX_BUF[i]=='+'&&RX_BUF[i+1]=='I'&&RX_BUF[i+2]=='P'&&RX_BUF[i+3]=='D'&&RX_BUF[i+4]==',')
						{if(RX_BUF[i+5]>=48&&RX_BUF[i+5]<=57)ConnectClient=1<<(RX_BUF[i+5]-48);}
	
				}
		 for(i=0;i<30;i++)RX_BUF[i]=0;
		 return res;
}

u8 WifiAnalyse()
{	static int max_wifi=0;int i=0;
	u8 ret=0;
		if(USART2_RX_STA&0X8000)	//���յ�WIFI������	
									{	
										max_wifi=USART2_RX_STA&0X7FFF;	
										for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];
										RX_BUF[i]=0;		
										USART2_RX_STA=0;
									//	LCD_write_english_size8string(0,1,RX_BUF);
									WIFI_Control_Val = AnalyseWificontrol();
										//	if(Alcohol.WifiVal)LCD_write_english_size8string(0,1,"YES");else LCD_write_english_size8string(0,1,"   ");
										 ret=WIFI_Control_Val;
									}

return ret;
}






void WIFISEND(u8 data)
{char p2[17]={0};u8 condev=0;
	if(ConnectClient>0)
	{
		switch(ConnectClient)
		{
			case 1: condev=0; break;
			case 2: condev=1; break;
      case 4: condev=2; break;
      case 8: condev=3; break;
			case 16:condev=4;  break;
			case 32:condev=5;  break;
      case 64:condev=6;  break;
      case 128:condev=7;  break;
		}
	  sprintf((char*)p2,"AT+CIPSEND=%d,8\r\n",condev);        
    u2_printf(p2);
		Delay_ms(100);
		sprintf((char*)p2,"%2x%2x%2x%2x\r\n",(u8)(System_Status.Safe_Check_Result.Unsafe_Type>>24&0xff),(u8)(System_Status.Safe_Check_Result.Unsafe_Type>>16&0xff),(u8)(System_Status.Safe_Check_Result.Unsafe_Type>>8&0xff),(u8)(System_Status.Safe_Check_Result.Unsafe_Type&0xff));
		u2_printf(p2);
	}
 ConnectClient=0;
}





           








