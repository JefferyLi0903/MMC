#include "code_def.h"
#include <string.h>
#include <math.h>
#define REG_1_Gain_mask 0xe001
#define RSSI_Base 0x60000050
#define STEP 0.02
#define NUM 1060

//global variables
float freq_I=87.0;
RSSIType rssilist[NUM];
int rssi_index=0;
/*
//Insert your output declaration here

*/

/*

FM_Receiver_state: 
   STATE                    Command from uart
0: not started              'B'          
1: started,                 'A'
2: Gain adjust state,       'G'
3: INT adjust state,        'I'
4: FRAC adjust state.       'F'
5: FRAC adjust state.       'f'

*/

//extern unsigned int FM_Receiver_state;  //0: not started 1: started, 2:Gain adjust state, 3: INT adjust state, 4: FRAC adjust state. 
/*
unsigned int FM_Receiver_state=0; 
unsigned int FM_current_gain=20;       //0~63dB, step: 1dB
unsigned int FM_current_INT=31;        //29~36; step:1
unsigned int FM_current_FRAC=400;      //0~2999; step: 10
unsigned int FM_current_AFC=0;         //0~2999; step: 10
unsigned int REG1=0x0000e201;
unsigned int REG2=0x0001f2bc2;
unsigned int REG3=0x00000003;
*/


void Delay(int interval)
{
    int i = 0;
    while(1) 
		{
			i = i + 1;
			if(i == interval) break;
		}
}
 
char ReadUARTState()
{
    char state;
	state = UART -> UARTTX_STATE;
    return(state);
}

char ReadUART()
{
    char data;
	data = UART -> UARTRX_DATA;
    return(data);
}

void WriteUART(char data)
{
    while(ReadUARTState());
	UART -> UARTTX_DATA = data;
}

void UARTString(char *stri)
{
	int i;
	for(i=0;i<(strlen(stri));i++)
	{
	  Delay(1000);
		WriteUART(stri[i]);
	}
}

void UARTHandle()
{
	unsigned int data;
	//unsigned int MSI_SPI_Data= 0;
	//char* intstring;
	
	data = ReadUART();
	
  ChannelSelection_control(data);

	
}

void SPI_RFD(volatile uint32_t MSI_SPI_Data)
{
    SPITX->SPITX_DATA = MSI_SPI_Data;
}



void Start_FM_command(void)
{
     	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)16;
}

void Stop_FM_command(void)
{
     	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)32;
}

void IQ_Dump_command(void)
{
     	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)1;
}


void UARTFM_IQ_Dump_Done_Handler(void)
{
	unsigned int IQdata,ii;
	char* intstring;
  NVIC_ICER_ADDR=0;
#ifndef SIM_PROFILE
	UARTString("Start dump IQ Data! \n");
#endif
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 2; 
	for(ii=0;ii<=7935;ii++)
	{
		 IQdata=*(volatile unsigned int *)(IQ_Data_BASE+ii*4);
		 intstring=int_to_str(IQdata);
#ifndef SIM_PROFILE
		 UARTString(intstring);
		 UARTString("\n");
#endif
	}
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 4;
}

void Demodulated_Data_Dump_command(void)
{
     	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)64;
}


void UARTFM_Demodulated_Data_Dump_Done_Handler(void)
{
	unsigned int DemodulatedData,ii;
	char* intstring;
#ifndef SIM_PROFILE
	UARTString("Start dump demodulated Data! \n");
#endif
	
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 128;   
	for(ii=0;ii<=7935;ii++) 
	{
		 DemodulatedData=*(volatile unsigned int *)(IQ_Data_BASE+ii*4);
		 intstring=int_to_str(DemodulatedData);
#ifndef SIM_PROFILE
		 UARTString(intstring);
		 UARTString("\n");
#endif
	}	
	
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 192;

}

void Channel_control(ChannelControlType ChanelControlData)
{
	unsigned int controldisplay;
	unsigned int freq;
	controldisplay = ChanelControlData.channel_no;
	freq = (unsigned int)((ChanelControlData.freq)*10); //changed to int
	controldisplay = 	controldisplay + (freq%10)*32;  //fraction part
	freq = freq/10;
	controldisplay = 	controldisplay + (freq%10)*512;  //single digit part
	freq = freq/10;
	controldisplay = 	controldisplay + (freq%10)*8192;  //percentage digit part
	freq = freq/10;
	controldisplay = 	controldisplay + (freq%10)*131072;  //percentage digit part
	(*(volatile unsigned int *)FM_ChannelControl_Base)=controldisplay;
};

void SPIwrite(int INT, int FRAC, int AFC, int Gain)
{
	SPI_RFD(0x00043420);
	SPI_RFD(0x0028bb85);
	SPI_RFD(INT*65536 + FRAC*16 + 2);
	SPI_RFD(0x16001 + Gain*16);
	SPI_RFD(0x00200016);
	SPI_RFD(0x00000004);
	SPI_RFD(AFC*16+3);
}

void singleFrequencyRSSI()
{
	int INT=floor(freq_I/3);
	int FRAC=(freq_I/3-INT)*3000;
	int Gain=15;
	int AFC=0;
	SPIwrite(INT,FRAC,AFC,Gain);
}
void RSSI_scan_cmd(void)
{
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)256;
}
int RSSI_read(void)
{
	return (*(volatile unsigned int *)(RSSI_Base));
}
void RSSI_done(void)
{
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)512;
}
void RSSIScanHandler(void)
{
	int j;
	rssilist[rssi_index].RSSI=RSSI_read();
	RSSI_done();
	rssilist[rssi_index].index=rssi_index;
	freq_I += STEP;
	rssi_index += 1;
	if(freq_I<108){ 
		singleFrequencyRSSI();
		RSSI_scan_cmd();
	}
	else{
		freq_I=87;
		rssi_index=0;
		#ifndef SIM_PROFILE
		// Used for Debug mode. 
		for(j=0;j<NUM;j++){
				UARTString(int_to_str(rssilist[j].RSSI));
				UARTString("\n");
		}
		#endif
		/*
		//The function is supposed to be called here.

		*/
	}
}

/*
//Insert the complete function here

*/
