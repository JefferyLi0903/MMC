#include "code_def.h"
#include <string.h>

/*

FM_Receiver_state: 
   STATE                    Command from uart
0: not started                  'B'          
1: started,                     'A'
2: Gain adjust state,           'G'
3: INT adjust state,            'I'
4: FRAC adjust state.           'F'
5: AFC adjust state.            'f'
   Dump IQ data                 'U'
   Dump Audio data              'u'

Channel(MHZ)       Command from uart   Channel NO.

99	          	          	  1                1
94.0	        	          2                2
96.8	        	          3                3
94.7	        	          4                4
93.4	        	          5                5
95.5	        	          6                6
91.4	        	          7                7
89.9	        	          8                8
87.9	        	          9                9
105.7	        	          x                10
97.2	        	          y                11
101.7	        	          z                12
98.1                      	  v                13
100.1                     	  w                14
100.9                     	  a                15
103.7                     	  b                16
102.7                     	  c                17
106.5                     	  d                18
107.2                     	  e                19
107.7                     	  h                20
*/

#define REG_1_Gain_mask 0x16001

//extern unsigned int FM_Receiver_state;  //0: not started 1: started, 2:Gain adjust state, 3: INT adjust state, 4: FRAC adjust state. 
unsigned int FM_Receiver_state=0; 
unsigned int FM_current_gain=20;       //0~63dB, step: 1dB
unsigned int FM_current_INT=31;        //29~36; step:1
unsigned int FM_current_FRAC=400;      //0~2999; step: 10
unsigned int FM_current_AFC=0;         //0~2999; step: 10
unsigned int REG1=0x0000e201;
unsigned int REG2=0x0001f2bc2;
unsigned int REG3=0x00000003;
ChannelControlType ChannelControlDisplay;
ChannelControlType Profile[10];

void initialize()
{
	int ii;
	float frequency[10] = {87.9,89.9,90.9,91.4,93.4,94.0,95.5,103.7,105.7,107.7};
	for (ii=1;ii<=10;ii++){
		Profile[ii-1].channel_no = ii; 
		Profile[ii-1].freq = frequency[ii-1]; 
	}
}

void ChannelSelection_control(unsigned int data)
{

	unsigned int MSI_SPI_Data= 0;
	char* intstring;
	
	if(data=='A')   // formal FM receiver
	{
		FM_Receiver_state = 1;
		Start_FM_command();
	  UARTString("  Start Reciever  ");
	  WriteUART('\n');
	}
	else if(data=='B')   // formal FM receiver
	{
		FM_Receiver_state = 0;
		Stop_FM_command();
	  UARTString("  Stop Reciever  ");
	  WriteUART('\n');
	}
	else if(data=='C')
	{
		singleFrequencyRSSI();
		UARTString("  RSSI SCAN START!  \n");
		RSSI_scan_cmd();
	}
	else if(data=='U')   // Dump IQ data
	{
		if(FM_Receiver_state==1)
		{
	      UARTString("  Start dump IQ data!   ");
	      WriteUART('\n');
	      IQ_Dump_command(); 
		}else 
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
/*  
	   Dump audio data, make sure the target build is in dump audio data mode.
	   see comments in FM_HW.V:
	   {
	     parameter dumpIQ_or_audio: 1'b1: dump IQ data; 1'b0:dump audio data
       if you want dump IQ data, set the dumpIQ_or_audio = 1'b1
       then make instance of FM_Dump_Data  as FM_Dump_Data_IQ
   
       if you want dump audio data, set the dumpIQ_or_audio = 1'b0 
       you need make instance of:FM_Dump_Data  FM_Dump_Data_Audio 
     }
*/
	
	else if(data=='u')   
	{
		if(FM_Receiver_state==1)
		{
	      UARTString("  Start dump audio data!   ");
	      WriteUART('\n');
	      Demodulated_Data_Dump_command(); 
		}else 
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
	
	else if(data=='G')  // manual adjust Gain in FM ceceiver state
	{
		if(FM_Receiver_state==1)
		{
		    FM_Receiver_state = 2;
	      UARTString("  adjust gain please enter +/-  ");
	      WriteUART('\n');
		}else
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
	else if(data=='I')  // manual adjust INT in FM ceceiver state
	{
		if(FM_Receiver_state==1)
		{
		    FM_Receiver_state = 3;
	      UARTString("  adjust FM INT please enter +/-  step is 1 ");
	      WriteUART('\n');
		}else 
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
  else if(data=='F')  // manual adjust FRAC in FM ceceiver state step 10
	{
		if(FM_Receiver_state==1)
		{
		    FM_Receiver_state = 4;
	      UARTString("  adjust FM FRAC please enter +/-  step is 10 ");
	      WriteUART('\n');
		}else 
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
  else if(data=='f')  // manual adjust AFC in FM ceceiver state step 10
	{
		if(FM_Receiver_state==1)
		{
		    FM_Receiver_state = 5;
	      UARTString("  adjust FM AFC please enter +/-  step is 10 ");
	      WriteUART('\n');
		}else 
		{
			  UARTString("  please enter 'A' to start the FM first!   ");
	      WriteUART('\n');
		}
	}
	
	else if(data=='+')  // manual adjust gain(2) or INT(3) or FRAC(4)
	{
		if(FM_Receiver_state==2)   // manual adjust gain
		{
		  	if(FM_current_gain>0) 
				{
					FM_current_gain=FM_current_gain-1;
					REG1=REG_1_Gain_mask + FM_current_gain*16;
					SPI_RFD(REG1);
					
					UARTString("  current REG1 is:  ");
					intstring=int_to_str(REG1);
					UARTString(intstring);
	        WriteUART('\n');					
					
					UARTString("  current gain is:  ");
					intstring=int_to_str(FM_current_gain);
					UARTString(intstring);
	        WriteUART('\n');
					
				}else 
				{
					 UARTString("  reach maximum BB gain ");
	         WriteUART('\n');
				}

		}else if (FM_Receiver_state==3)  // manual adjust INT
		{
		  	if(FM_current_INT<36)                    //29~36; step:1
				{
					FM_current_INT=FM_current_INT+1;					
					REG2=FM_current_INT*65536 + FM_current_FRAC*16+2;
					SPI_RFD(REG2);
					
					UARTString("  current INT is:  ");
					intstring=int_to_str(FM_current_INT);
					UARTString(intstring);
	        WriteUART('\n');
					
					UARTString("  current FRAC is:  ");
					intstring=int_to_str(FM_current_FRAC);
					UARTString(intstring);
	        WriteUART('\n');					
					
				}else 
				{
					 UARTString("  reach maximum INT value ");
	         WriteUART('\n');
				}

		}else if (FM_Receiver_state==4)  // manual adjust FRAC
		{
		  	if(FM_current_FRAC <= 2980)                    //0~2999; step:10   10KHZ 
				{
					

					FM_current_FRAC=FM_current_FRAC+10;					
					REG2= FM_current_INT*65536 + FM_current_FRAC*16 + 2;
					SPI_RFD(REG2);

					
					UARTString("  current INT is:  ");
					intstring=int_to_str(FM_current_INT);
					UARTString(intstring);
	        WriteUART('\n');
					
					UARTString("  current FRAC is:  ");
					intstring=int_to_str(FM_current_FRAC);
					UARTString(intstring);
	        WriteUART('\n');					
					
				}else 
				{
					 UARTString("  reach maximum FRAC value ");
	         WriteUART('\n');
				}
		}else if (FM_Receiver_state==5)  // manual adjust AFC    0~4096 adjust step 100
		{
		  	if(FM_current_AFC <= 3900)                    //0~4000; step:10   10KHZ 
				{
					FM_current_AFC=FM_current_AFC+100;					
					REG3=FM_current_AFC*16+3;
					SPI_RFD(REG3);
					
					UARTString("  current AFC is:  ");
					intstring=int_to_str(FM_current_AFC);
					UARTString(intstring);
	        WriteUART('\n');

				}else 
				{
					 UARTString("  reach maximum FRAC value ");
	         WriteUART('\n');
				}
		}else 
		{
				UARTString("  please enter the correponding state first!   ");
	      WriteUART('\n');
		}
	}
	

	else if(data=='-')  // manual adjust gain(2) or INT(3) or FRAC(4)
	{
		if(FM_Receiver_state==2)   // manual adjust gain
		{
		  	if(FM_current_gain<63) 
				{
					FM_current_gain=FM_current_gain+1;
					REG1=REG_1_Gain_mask + FM_current_gain*16;
					SPI_RFD(REG1);
					
					UARTString("  current gain is:  ");
					intstring=int_to_str(FM_current_gain);
					UARTString(intstring);
	        WriteUART('\n');
					
				}else 
				{
					 UARTString("  reach minimum BB gain ");
	         WriteUART('\n');
				}

		}else if (FM_Receiver_state==3)  // manual adjust INT
		{
		  	if(FM_current_INT>29)                    //29~36; step:1
				{
					FM_current_INT=FM_current_INT-1;					
					REG2=FM_current_INT*65536 + FM_current_FRAC*16+2;
					SPI_RFD(REG2);

					UARTString("  current REG2 is:  ");
					intstring=int_to_str(REG2);
					UARTString(intstring);
	        WriteUART('\n');

					
					UARTString("  current INT is:  ");
					intstring=int_to_str(FM_current_INT);
					UARTString(intstring);
	        WriteUART('\n');
					
					UARTString("  current FRAC is:  ");
					intstring=int_to_str(FM_current_FRAC);
					UARTString(intstring);
	        WriteUART('\n');					
					
				}else 
				{
					 UARTString("  reach minimum INT value ");
	         WriteUART('\n');
				}
		}else if (FM_Receiver_state==4)  // manual adjust FRAC
		{
		  	if(FM_current_INT>=10)                    //0~2999; step:10   10KHZ 
				{
					FM_current_FRAC=FM_current_FRAC-10;					
					REG2=FM_current_INT*65536 + FM_current_FRAC*16+2;
					SPI_RFD(REG2);
					
					UARTString("  current INT is:  ");
					intstring=int_to_str(FM_current_INT);
					UARTString(intstring);
	        WriteUART('\n');
					
					UARTString("  current FRAC is:  ");
					intstring=int_to_str(FM_current_FRAC);
					UARTString(intstring);
	        WriteUART('\n');					
					
				} else 
				{
					 UARTString("  reach minimum FRAC value ");
	         WriteUART('\n');
				}
		}
		else if (FM_Receiver_state==5)  // manual adjust AFC    0~4096 adjust step 100
		    {
		  	if(FM_current_AFC >=100)                    //0~4000; step:10   10KHZ 
				{
					FM_current_AFC=FM_current_AFC-100;					
					REG3=FM_current_AFC*16+3;
					SPI_RFD(REG3);
					
					UARTString("  current AFC is:  ");
					intstring=int_to_str(FM_current_AFC);
					UARTString(intstring);
	        WriteUART('\n');

				}else 
				{
					 UARTString("  reach minimum AFC value ");
	         WriteUART('\n');
				}
		}else 
		{
				UARTString("  please enter the correponding state first!   ");
	      WriteUART('\n');
		}
	}

	
	
else if(data=='1')   // formal FM receiver
	{
		regWrite(Profile[0].freq);
		Channel_control(Profile[0]);
	}
else if(data=='2')   // formal FM receiver
	{
		regWrite(Profile[1].freq);
		Channel_control(Profile[1]);
	}
else if(data=='3')   // formal FM receiver
	{
		regWrite(Profile[2].freq);
		Channel_control(Profile[2]);
	}
else if(data=='4')   // formal FM receiver
	{
		regWrite(Profile[3].freq);
		Channel_control(Profile[3]);
	}
else if(data=='5')   // formal FM receiver
	{
		regWrite(Profile[4].freq);
		Channel_control(Profile[4]);
	}
else if(data=='6')   // formal FM receiver
	{
		regWrite(Profile[5].freq);
		Channel_control(Profile[5]);
	}
else if(data=='7')   // formal FM receiver
	{
		regWrite(Profile[6].freq);
		Channel_control(Profile[6]);
	}
else if(data=='8')   // formal FM receiver
	{
		regWrite(Profile[7].freq);
		Channel_control(Profile[7]);
	}
else if(data=='9')   // formal FM receiver
	{
		regWrite(Profile[8].freq);
		Channel_control(Profile[8]);
	}
else if(data=='0')   // formal FM receiver
	{
		regWrite(Profile[9].freq);
		Channel_control(Profile[9]);
	}
else  
	{	
	UARTString("  Wrong command!   ");
	WriteUART('\n');	
	}
	
}

