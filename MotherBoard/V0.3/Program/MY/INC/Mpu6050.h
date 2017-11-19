#ifndef _MPU6050_H
#define _MPU6050_H

#include"stm32f10x.h"
#include"Nokia5110.h"

#define	MPU_SMPLRT_DIV		0x19	
#define	MPU_CONFIG			  0x1A	
#define	MPU_GYRO_CONFIG		0x1B	
#define	MPU_ACCEL_CONFIG	0x1C
#define	MPU_ACCEL_XOUT_H	0x3B
#define	MPU_ACCEL_XOUT_L	0x3C
#define	MPU_ACCEL_YOUT_H	0x3D
#define	MPU_ACCEL_YOUT_L	0x3E
#define	MPU_ACCEL_ZOUT_H	0x3F
#define	MPU_ACCEL_ZOUT_L	0x40
#define	MPU_TEMP_OUT_H		0x41
#define	MPU_TEMP_OUT_L		0x42
#define	MPU_GYRO_XOUT_H		0x43
#define	MPU_GYRO_XOUT_L		0x44
#define	MPU_GYRO_YOUT_H		0x45
#define	MPU_GYRO_YOUT_L		0x46
#define	MPU_GYRO_ZOUT_H		0x47
#define	MPU_GYRO_ZOUT_L		0x48
#define	MPU_PWR_MGMT_1		0x6B
#define	MPU_WHO_AM_I			0x75
#define	MPU_SlaveAddress	0xD0

#define MPU_6050_I2C_ADDRESS 0xD0

#define MPU_I2C_DR_Address               ((uint32_t)0x40005410)

#define MPU_DMA_DIRECTION_TX                 0
#define MPU_DMA_DIRECTION_RX                 1 


void MPU_Init(void);
uint8_t I2C_Write_Buf(uint8_t Dev_Addr, uint8_t Reg, uint8_t Len, uint8_t *Buf);
uint8_t I2C_Read_Buf(uint8_t Dev_Addr, uint8_t Reg, uint8_t Len, uint8_t *Buf);
uint8_t Time_Out_Call_Reset(void);

#endif
