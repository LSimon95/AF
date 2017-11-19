#include"SD.h"
#include"NOKIA5110.h"

uint8_t Su[] = "RES_SUCCESSFUL";
uint8_t Fa[] = "RES_FAIL";
uint8_t Card_Type[] = "Card_Ver:";
uint8_t V1[] = "V1.0";
uint8_t V2[] = "V2.0";
uint8_t HC[] = "HC";
uint8_t MMC[] = "MMC";
uint8_t SD[] = "SD ";
uint8_t Cap[] = "Capacity:";
uint8_t KB[] = "KB";

void SD_GPIO_Init(void)
{
    SPI_InitTypeDef  SPI_InitStructure;
    GPIO_InitTypeDef GPIO_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB, ENABLE);

    RCC_APB1PeriphClockCmd(RCC_APB1Periph_SPI2, ENABLE);


    SPI_Cmd(SPI2, DISABLE);
    SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
    SPI_InitStructure.SPI_Mode = SPI_Mode_Master;
    SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;
    SPI_InitStructure.SPI_CPOL = SPI_CPOL_High;        //CPOL=1
    SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;       //CPHA=1
    SPI_InitStructure.SPI_NSS = SPI_NSS_Soft;
    SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_128;  //2??
    SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;
    SPI_InitStructure.SPI_CRCPolynomial = 7;

    SPI_Init(SPI2, &SPI_InitStructure);
    SPI_Cmd(SPI2, ENABLE);

    //*******SPI2_GPIO*******//
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
    GPIO_Init(GPIOB, &GPIO_InitStructure);

    //*****NSS****//
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_12;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_10MHz;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOB, &GPIO_InitStructure);
}
uint8_t SD_Init(void)
{
    uint16_t i;
    uint8_t Byte_T;
    uint16_t Retry;
    uint8_t Buf[4];
    SD_GPIO_Init();
    SPI2_NSS(1);
    Delay_ms(5);

    for(i = 0; i < 11; i++)
    {
        while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_TXE) == RESET);

        SPI_I2S_SendData(SPI2, 0xff);
    }

    Retry = 0;

    while((Byte_T != 0x01) && (Retry < 200))
    {
        Byte_T = SD_Send_Command(CMD0, 0, 0x95);
        Retry++;
    }

    if(Retry == 200)
    {
        LCD_write_english_string(0, 1, Fa);
        return Byte_T;
    }
    else
        LCD_write_english_string(0, 1, Su);

    //***Get Card Type***//
    LCD_write_english_string(0, 2, Card_Type);
    Delay_ms(10);
    Byte_T = SD_Send_Command(8, 0x1aa, 0x87);

    if((Byte_T == 0x09) || (Byte_T == 0x05))
    {
        LCD_write_english_string(18, 3, V1);
        SPI2_NSS(1);
        SPI2_WriteRead_Byte(0xff);
        Retry = 0;

        do
        {
            SD_Send_Command(CMD55, 0, 0);
            Byte_T = SD_Send_Command(ACMD41, 0, 0);
            Retry++;
        }
        while((Byte_T != 0x00) && (Retry < 2000));

        if(Retry == 400)
        {
            Retry = 0;

            do
            {
                Byte_T = SD_Send_Command(1, 0, 0);
                Retry++;

                if(Retry == 2000)
                    return Byte_T;
            }
            while(Byte_T != 0x00);

            LCD_write_english_string(16, 3, MMC);
        }
        else
        {
            LCD_write_english_string(16, 3, SD);
        }
    }

    //***V2.0***//
    else if(Byte_T == 0x01)
    {
        LCD_write_english_string(34, 3, V2);
        Buf[0] = SPI2_WriteRead_Byte(0xff);
        Buf[1] = SPI2_WriteRead_Byte(0xff);
        Buf[2] = SPI2_WriteRead_Byte(0xff);
        Buf[3] = SPI2_WriteRead_Byte(0xff);
        SPI2_NSS(1);

        Retry = 0;

        do
        {
            SD_Send_Command(CMD55, 0, 0);
            Byte_T = SD_Send_Command(ACMD41, 0x40000000, 0);

            if(Retry > 2000)
                return 1;

            Retry ++;
        }
        while(Byte_T != 0);

        Byte_T = SD_Send_Command_Continue(CMD58, 0, 0);

        if(Byte_T != 0x00)
        {
            SPI2_NSS(1);
            return Byte_T;
        }

        Buf[0] = SPI2_WriteRead_Byte(0xff);
        Buf[1] = SPI2_WriteRead_Byte(0xff);
        Buf[2] = SPI2_WriteRead_Byte(0xff);
        Buf[3] = SPI2_WriteRead_Byte(0xff);

        SPI2_NSS(1);
        SPI2_WriteRead_Byte(0xff);

        if(Buf[0] & 0x40)
        {
            LCD_write_english_string(16, 3, SD);
            LCD_write_english_string(58, 3, HC);
            return 0;
        }
        else
        {
            LCD_write_english_string(16, 3, SD);
            return 0;
        }
    }

    return 1;
}

uint8_t SD_Send_Command(uint8_t cmd, uint32_t arg, uint8_t crc)
{
    uint8_t Retry = 0;
    uint8_t r1;
    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);
    SPI2_NSS(0);
    SPI2_WriteRead_Byte(cmd | 0x40);
    SPI2_WriteRead_Byte(arg >> 24);
    SPI2_WriteRead_Byte(arg >> 16);
    SPI2_WriteRead_Byte(arg >> 8);
    SPI2_WriteRead_Byte(arg);
    SPI2_WriteRead_Byte(crc);

    while((r1 = SPI2_WriteRead_Byte(0xff)) == 0xff)
    {
        Retry++;

        if(Retry > 200)
            break;
    }

    SPI2_NSS(1);
    SPI2_WriteRead_Byte(0xFF);
    return r1;
}

uint8_t SD_Send_Command_Continue(uint8_t cmd, uint32_t arg, uint8_t crc)
{
    uint8_t Retry = 0;
    uint8_t Byte_T;
    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);
    SPI2_NSS(0);
    SPI2_WriteRead_Byte(cmd | 0x40);
    SPI2_WriteRead_Byte(arg >> 24);
    SPI2_WriteRead_Byte(arg >> 16);
    SPI2_WriteRead_Byte(arg >> 8);
    SPI2_WriteRead_Byte(arg);
    SPI2_WriteRead_Byte(crc);

    while((Byte_T = SPI2_WriteRead_Byte(0xff)) == 0xff)
    {
        Retry++;

        if(Retry > 200)
            break;
    }

    return Byte_T;
}


uint8_t SPI2_WriteRead_Byte(uint8_t Send_Byte)
{
    uint8_t Receive_Byte;

    while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_TXE) == RESET);

    SPI_I2S_SendData(SPI2, Send_Byte);

    while(SPI_I2S_GetFlagStatus(SPI2, SPI_I2S_FLAG_RXNE) == RESET);

    Receive_Byte = SPI_I2S_ReceiveData(SPI2);
    return (Receive_Byte);
}
uint8_t SD_GetResponse(uint8_t C_Response)
{
    uint16_t Count = 0x0FFF;

    while((SPI2_WriteRead_Byte(0xff) != C_Response) && Count)
        Count--;

    if(Count == 0)
        return 1;
    else
        return 0;
}

uint8_t SD_ReceiveData(uint8_t *data, uint16_t Len, uint8_t Release)
{
    SPI2_NSS(0);

    if(SD_GetResponse(0xfe) == 1)
    {
        SPI2_NSS(1);
        return 1;
    }

    while(Len--)
    {
        *data++ = SPI2_WriteRead_Byte(0xff);
    }

    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);

    if(Release)
    {
        SPI2_NSS(1);
        SPI2_WriteRead_Byte(0xff);
    }

    return 0;
}

uint8_t SD_GetCSD(uint8_t *Csd_Data)
{
    uint8_t Byte_T;
    Byte_T = SD_Send_Command(CMD9, 0, 0xff);

    if(Byte_T != 0x00)
        return Byte_T;

    SD_ReceiveData(Csd_Data, 16, 1);
    return 0;
}

uint64_t SD_GetCapacity(void)
{
    uint8_t Csd[16], LEN;
    uint32_t Capacity = 0;

    if(SD_GetCSD(Csd) == 1)
        return 1;

    Capacity = ((u32)Csd[9]);
    Capacity |= ((u32)Csd[8] << 8);
    Capacity |= ((u32)Csd[7] << 16);
    Capacity += 1;
    Capacity *= 512;

    LCD_write_english_string(0, 4, Cap);
    LEN = LCD_write_vlaue(16, 5, Capacity);
    LCD_write_english_string((16 + (LEN * 6)), 5, KB);
    return (u32)Capacity;
}

uint8_t SD_ReadSingleBlock(uint32_t Add, uint8_t *Buffer)
{
    uint8_t Byte_T;  //SDHC only
    Byte_T = SD_Send_Command(CMD17, Add, 0);

    if(Byte_T != 0x00)
        return Byte_T;

    Byte_T = SD_ReceiveData(Buffer, 512, 1);

    if(Byte_T == 1)
        return 1;
    else
        return 0;
}

uint8_t SD_WriteSingleBlock(uint32_t Add, uint8_t *Buffer)
{
    uint8_t Byte_T;
    uint16_t i;
    uint16_t Retry;

    Byte_T = SD_Send_Command_Continue(CMD24, Add, 0x00);

    if(Byte_T != 0x00)
    {
        return Byte_T;
    }

    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);

    SPI2_WriteRead_Byte(0xfe);

    for(i = 0; i < 512; i++)
    {
        SPI2_WriteRead_Byte(*Buffer++);
    }

    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);
    SPI2_WriteRead_Byte(0xff);

    Byte_T = SPI2_WriteRead_Byte(0xff);

    if((Byte_T & 0x1f) != 0x05)
    {
        SPI2_NSS(1);
        return Byte_T;
    }

    Retry = 0;

    while(!SPI2_WriteRead_Byte(0xff))
    {
        Retry++;

        if(Retry > 40000)
        {
            SPI2_NSS(1);
            return 1;
        }
    }

    SPI2_NSS(1);
    SPI2_WriteRead_Byte(0xff);
    return 1;
}