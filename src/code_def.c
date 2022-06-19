#include "code_def.h"
#include <string.h>

#define REG_1_Gain_mask 0xe001

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
	char temp;
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
     	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int)1; ;
}

void UARTFM_IQ_Dump_Done_Handler()
{
	unsigned int IQdata,ii;
	char* intstring;
  NVIC_ICER_ADDR=0;
	UARTString("Start dump IQ Data! \n");
	
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 2;   

 for(ii=0;ii<=7935;ii++)
	{
		 IQdata=*(volatile unsigned int *)(IQ_Data_BASE+ii*4);
		 intstring=int_to_str(IQdata);
		 UARTString(intstring);
		 UARTString("\n");
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
	UARTString("Start dump demodulated Data! \n");
	
	(*(volatile unsigned int *)FM_Control_Base)=( unsigned int) 128;   
	
	for(ii=0;ii<=7935;ii++) 
	{
		 DemodulatedData=*(volatile unsigned int *)(IQ_Data_BASE+ii*4);
		 intstring=int_to_str(DemodulatedData);
		 UARTString(intstring);
		 UARTString("\n");
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


