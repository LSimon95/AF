#include "WIFI.h"	  
#include "stdarg.h"	 	 
#include "stdio.h"	 	 
#include "string.h"

u8 ConnectClient = 0;
u32 SYSTMESTATUS = 0;
extern System_Status_Typedef System_Status;

extern uint8_t WIFI_Control_Val;

	NVIC_InitTypeDef NVIC_InitStructure;

//串口三gps数据接收配置文件
//串口发送缓存区 	
__align(8) u8 USART2_TX_BUF[USART2_MAX_SEND_LEN]; 	//发送缓冲,最大USART2_MAX_SEND_LEN字节
//串口接收缓存区 	
u8 USART2_RX_BUF[USART2_MAX_RECV_LEN]; 				//接收缓冲,最大USART2_MAX_RECV_LEN个字节.

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
	if(USART2->SR&(1<<5))//接收到数据
	{	 
		
		res=USART2->DR; 			
	
		if((USART2_RX_STA&(1<<15))==0)//接收完的一批数据,还没有被处理,则不再接收其他数据
		{ 
			if(USART2_RX_STA<USART2_MAX_RECV_LEN)	//还可以接收数据
			{
				TIM3->CNT=0;         				//计数器清空
				if(USART2_RX_STA==0) 				//使能定时器7的中断 
				{
					TIM3->CR1|=1<<0;     			//使能定时器7
				}
				USART2_RX_BUF[USART2_RX_STA++]=res;	//记录接收到的值	 
		}
	}  				 											 
} 
}  

//初始化IO 串口3
//pclk1:PCLK1时钟频率(Mhz)
//bound:波特率 
void usart2_init(u32 pclk1,u32 bound)
{  	 
	float temp;
	u16 mantissa;
	u16 fraction;	   
	temp=(float)(pclk1*1000000)/(bound*16);//得到USARTDIV,OVER8设置为0
	mantissa=temp;				 	//得到整数部分
	fraction=(temp-mantissa)*16; 	//得到小数部分,OVER8设置为0	 
    mantissa<<=4;
	mantissa+=fraction; 
	RCC->APB2ENR|=1<<2;   //使能PORTA口时钟  
	RCC->APB1ENR|=1<<17;  //使能串口时钟 
	GPIOA->CRL&=0XFFFF00FF; 
	GPIOA->CRL|=0X00008B00;//IO状态设置
		RCC->APB1RSTR|=1<<17;   //复位串口1
	RCC->APB1RSTR&=~(1<<17);//停止复位	   
	
 	USART2->BRR=(pclk1*1000000)/(bound);// 波特率设置	 
	USART2->CR1|=0X200C;  	//1位停止,无校验位.	
	
	USART2->CR3=1<<7;   	//使能串口1的DMA发送

	USART2->CR1|=1<<8;    	//PE中断使能
	USART2->CR1|=1<<5;    	//接收缓冲区非空中断使能	    	

  //MY_NVIC_Init(2,2,USART2_IRQChannel,2);//组2，优先级0,0,最高优先级 
	
	NVIC_InitStructure.NVIC_IRQChannel = USART2_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x02;
	
	NVIC_Init(&NVIC_InitStructure);
	
	TIM3_Int_Init(500-1,7200-1);	//10ms中断一次
	TIM3->CR1&=~(1<<0);				//关闭定时器7
	USART2_RX_STA=0;				//清零 
}


//通过判断接收连续2个字符之间的时间差不大于10ms来决定是不是一次连续的数据.
//如果2个字符接收间隔超过10ms,则认为不是1次连续数据.也就是超过10ms没有接收到
//任何数据,则表示此次接收完毕.
//接收到的数据状态
//[15]:0,没有接收到数据;1,接收到了一批数据.
//[14:0]:接收到的数据长度

//串口3,printf 函数
//确保一次发送数据不超过USART2_MAX_SEND_LEN字节
void u2_printf(char* fmt,...)  
{  
	u16 i,j;
	va_list ap;
	va_start(ap,fmt);
	vsprintf((char*)USART2_TX_BUF,fmt,ap);
	va_end(ap);
	i=strlen((const char*)USART2_TX_BUF);//此次发送数据的长度
	for(j=0;j<i;j++)//循环发送数据
	{
		while((USART2->SR&0X40)==0);//循环发送,直到发送完毕   
		USART2->DR=USART2_TX_BUF[j];  
	}
}





void TIM3_IRQHandler(void)
{ 	  
	if(TIM3->SR&0X01)//是更新中断
	{	 			   
		USART2_RX_STA|=1<<15;	//标记接收完成
		TIM3->SR&=~(1<<0);		//清除中断标志位		
		TIM3->CR1&=~(1<<0);		//关闭定时器7	  
	}	      											 
} 

void TIM3_Int_Init(u16 arr,u16 psc)
{
	RCC->APB1ENR|=1<<1;	//TIM3时钟使能    
 	TIM3->ARR=arr;  	//设定计数器自动重装值 
	TIM3->PSC=psc;  	//预分频器	  
	TIM3->DIER|=1<<0;   //允许更新中断	  
	TIM3->CR1|=0x01;    //使能定时器3
  //	MY_NVIC_Init(1,2,TIM7_IRQChannel,2);	//抢占1，子优先级3，组2									 
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
if(USART2_RX_STA&0X8000)	//接收到GPS数据了	//接收到一次数据了
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
	
	u2_printf("AT+RST\r\n") ;  
	delay_ms(1000);delay_ms(1000);
	 if(USART2_RX_STA&0X8000)	//接收到GPS数据了	//接收到一次数据了
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
		  u2_printf("AT+CIPMUX=1\r\n") ;
		delay_ms(1000);

 if(USART2_RX_STA&0X8000)	//接收到GPS数据了	//接收到一次数据了
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
	//	LCD_write_english_size8string(0,1,RX_BUF);
		}
	u2_printf("AT+CWSAP=\"ArtFire\",\"12345678\",1,3\r\n") ;delay_ms(1000);
	
  if(USART2_RX_STA&0X8000)	//接收到GPS数据了	//接收到一次数据了
		{	
			max_wifi=USART2_RX_STA&0X7FFF;	
for(i=0;i<max_wifi;i++)RX_BUF[i]=USART2_RX_BUF[i];	RX_BUF[i]=0;		
 			USART2_RX_STA=0;
		//LCD_write_english_size8string(0,1,RX_BUF);
		}
	
	 	u2_printf("AT+CIPSERVER=1,8080\r\n") ;delay_ms(1000);

  if(USART2_RX_STA&0X8000)	//接收到GPS数据了	//接收到一次数据了
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
		if(USART2_RX_STA&0X8000)	//接收到WIFI数据了	
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





           








