#include "code_def.h"
#include <string.h>
#include <stdint.h>


#define SPI_interword_interval 50000

int main()
{ 	
/*
	char string[32] = {0};

	unsigned int MSI_SPI_Data= 0;
	ChannelControlType ChannelControlDisplay;
	MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x001f1902;   //Reg2: INT=31,FRAC=400 LNA close; 93.4MHz in Shanghai 
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB    LNA Gain redcution: 23dB
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x00200016;        //Reg6: DC default value
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x00000004;        //Reg4: Aux features
	SPI_RFD(MSI_SPI_Data);
	MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
	SPI_RFD(MSI_SPI_Data);


	// UARTString("start the normal FM receiver!\n");
	// UARTString("start Dump Audio data!\n");
	//Start_FM_command();
	//Demodulated_Data_Dump_command();
	 
	// UARTString("start the normal FM receiver!\n");
	// UARTString("start Dump IQ data!\n");

	ChannelControlDisplay.channel_no =5;
	ChannelControlDisplay.freq =93.4;
	ChannelControlDisplay.INT =31;
	ChannelControlDisplay.FRAC =400;	
	Channel_control(ChannelControlDisplay);

	Start_FM_command();
	IQ_Dump_data();
*/
	NVIC_CTRL_ADDR = 0xFFFFF;  //enable lowest 2 interrupts
	initialize();
	
	
while(1)
{
	    
	  Delay(15000);
}


}
