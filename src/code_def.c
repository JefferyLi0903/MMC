#include "code_def.h"
#include <string.h>
#include <math.h>
#define REG_1_Gain_mask 0xe001
#define RSSI_Base 0x60000050
#define STEP 0.02
#define NUM 1060
#define OUTNUM 16
#define Thresh 1900

//global variables
float freq_I=87.0;
RSSIType rssilist[NUM];
int rssi_index=0;
ChannelControlType channelcontrollist[OUTNUM];

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

void regWrite(float freq)
{
	int INT=floor(freq/3);
	int FRAC=(freq/3-INT)*3000;
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
		/*
 		for(j=0;j<NUM;j++){
				UARTString(int_to_str(rssilist[j].RSSI));
				UARTString("\n");
		} 
		*/
		#endif
		RSSIScanscreen();
		UARTString("Scan done!\n");

	}
}

void RSSIScanscreen()
{
	int i, j, k, n, rssi[OUTNUM];
	float temp, freq;
	freq = 87;
	i = 0;
	n = 1;
	for (j = 0; freq += STEP, j < (NUM - 10); j++)
	{
		if (rssilist[j].RSSI < Thresh)
			continue;
		if ((rssilist[j].RSSI >= rssilist[j - 12].RSSI * 4) && (rssilist[j].RSSI >= rssilist[j + 12].RSSI * 4))
		{
			for (k = 0; (k <= i) && (k < 16); k++)
				if ((freq - channelcontrollist[k].freq) < 0.2)
				{
					channelcontrollist[k].freq = (channelcontrollist[k].freq * n + freq) / (n + 1);
					n += 1;
					break;
				}
			if ((k <= i) && (k < 16))
				continue;
			else if (i == 0)
			{
				channelcontrollist[i].freq = freq;
				rssi[i] = rssilist[j].RSSI;
				i += 1;
			}
			else if (i < OUTNUM)
			{
				channelcontrollist[i].freq = freq;
				rssi[i] = rssilist[j].RSSI;
				if (rssilist[j].RSSI < rssi[0])
				{
					rssi[i] = rssi[0];
					rssi[0] = rssilist[j].RSSI;
					channelcontrollist[i].freq = channelcontrollist[0].freq;
					channelcontrollist[0].freq = freq;
				}
				i += 1;
			}
			else if (rssilist[j].RSSI > rssi[0])
			{
				rssi[0] = rssilist[j].RSSI;
				channelcontrollist[0].freq = freq;
				Bubbling(rssi);
			}
			else
				continue;
			n = 1;
		}

	}
	for (i = 0; i < OUTNUM; i++)
		for (j = 1; j < (OUTNUM - i); j++)
		{
			if (channelcontrollist[j].freq < channelcontrollist[j - 1].freq)
			{
				temp = channelcontrollist[j].freq;
				channelcontrollist[j].freq = channelcontrollist[j - 1].freq;
				channelcontrollist[j - 1].freq = temp;
			}
		}
	for (i = 0; i < OUTNUM; i++)
	{
		channelcontrollist[i].INT = floor(channelcontrollist[i].freq / 3);
		channelcontrollist[i].FRAC = (channelcontrollist[i].freq / 3 - channelcontrollist[i].INT) * 3000;
		channelcontrollist[i].channel_no = i+1;
	}
}

int  Bubbling(int* rssi)
{
	int i, j, k;
	float temp;
	for (i = 0; i < OUTNUM; i++)
		for (j = 1; j < (OUTNUM - i); j++)
		{
			if (rssi[j] < rssi[j - 1])
			{
				k = rssi[j];
				rssi[j] = rssi[j - 1];
				rssi[j - 1] = k;
				temp = channelcontrollist[j].freq;
				channelcontrollist[j].freq = channelcontrollist[j - 1].freq;
				channelcontrollist[j - 1].freq = temp;
			}
		}
	return rssi[0];
}



//Key_interrupt handlers
void KEY0(void)
{
	UARTString("Channel0\n");
	regWrite(channelcontrollist[0].freq);
	Channel_control(channelcontrollist[0]);
}
void KEY1(void)
{
	UARTString("Channel1\n");
	regWrite(channelcontrollist[1].freq);
	Channel_control(channelcontrollist[1]);
}
void KEY2(void)
{
	UARTString("Channel2\n");
	regWrite(channelcontrollist[2].freq);
	Channel_control(channelcontrollist[2]);
}
void KEY3(void)
{
	UARTString("Channel3\n");
	regWrite(channelcontrollist[3].freq);
	Channel_control(channelcontrollist[3]);
}
void KEY4(void)
{
	UARTString("Channel4\n");
	regWrite(channelcontrollist[4].freq);
	Channel_control(channelcontrollist[4]);
}
void KEY5(void)
{
	UARTString("Channel5\n");
	regWrite(channelcontrollist[5].freq);
	Channel_control(channelcontrollist[5]);
}
void KEY6(void)
{
	UARTString("Channel6\n");
	regWrite(channelcontrollist[6].freq);
	Channel_control(channelcontrollist[6]);
}
void KEY7(void)
{
	UARTString("Channel7\n");
	regWrite(channelcontrollist[7].freq);
	Channel_control(channelcontrollist[7]);
}
void KEY8(void)
{
	UARTString("Channel8\n");
	regWrite(channelcontrollist[8].freq);
	Channel_control(channelcontrollist[8]);
}
void KEY9(void)
{
	UARTString("Channel9\n");
	regWrite(channelcontrollist[9].freq);
	Channel_control(channelcontrollist[9]);
}
void KEY10(void)
{
	UARTString("Channel10\n");
	regWrite(channelcontrollist[10].freq);
	Channel_control(channelcontrollist[10]);
}
void KEY11(void)
{
	UARTString("Channel11\n");
	regWrite(channelcontrollist[11].freq);
	Channel_control(channelcontrollist[11]);
}
void KEY12(void)
{
	UARTString("Channel12\n");
	regWrite(channelcontrollist[12].freq);
	Channel_control(channelcontrollist[12]);
}
void KEY13(void)
{
	UARTString("Channel13\n");
	regWrite(channelcontrollist[13].freq);
	Channel_control(channelcontrollist[13]);
}
void KEY14(void)
{
	UARTString("Channel14\n");
	regWrite(channelcontrollist[14].freq);
	Channel_control(channelcontrollist[14]);
}
void KEY15(void)
{
	UARTString("Channel15\n");
	regWrite(channelcontrollist[15].freq);
	Channel_control(channelcontrollist[15]);
}
