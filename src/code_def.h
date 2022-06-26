#include <stdint.h>

//INTERRUPT DEF
#define NVIC_CTRL_ADDR (*(volatile unsigned *)0xe000e100)
#define NVIC_ICER_ADDR (*(volatile unsigned *)0xe000e180)
#define INT_MAX 2147483647
#define INT_MIN (-2147483647-1)

//#define SIM_PROFILE

//UART DEF
typedef struct{
    volatile uint32_t UARTRX_DATA;
    volatile uint32_t UARTTX_STATE;
    volatile uint32_t UARTTX_DATA;
}UARTType;

#define UART_BASE 0x40000010
#define UART ((UARTType *)UART_BASE)

#define SPI_BASE      0x50000010
#define IQ_Data_BASE       0x60000400
#define FM_Control_Base  0x60000010
#define FM_ChannelControl_Base  0x60000020


typedef struct{
    unsigned int  channel_no;
    float  freq;
	  unsigned int  INT;
	  unsigned int  FRAC;
}ChannelControlType;


typedef struct{
    volatile uint32_t SPITX_DATA;
}SPIType;
#define SPITX ((SPIType*)SPI_BASE)

typedef struct{
		int index;
		int RSSI;
}RSSIType;


typedef struct{
		int No;
	  int freq;
}Sel_Channel;


void Delay(int interval);
char ReadUARTState(void);
char ReadUART(void);
void WriteUART(char data);
void UARTString(char *stri);
void UARTHandle(void);
void SPI_RFD(volatile uint32_t MSI_SPI_Data);
void UARTFM_IQ_Dump_Done_Handle(void);
void IQ_Dump_command(void); 
void Demodulated_Data_Dump_command(void); 
void UARTFM_Demodulated_Data_Dump_Done_Handler(void);
char* int_to_str(int iVal);
void Start_FM_command(void);
void Stop_FM_command(void);
void ChannelSelection_control(unsigned int data);
void Channel_control(ChannelControlType ChanelControlData);
void singleFrequencyRSSI(void);
void SPIwrite(int INT, int FRAC, int AFC, int Gain);
int  RSSI_Read(void);
void RSSIScanHandler(void);
void RSSI_scan_cmd(void);
/*
//Insert your Function declaration here


*/