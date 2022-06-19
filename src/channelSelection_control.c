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

99	          	          1                1
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
98.1                      v                13
100.1                     w                14
100.9                     a                15
103.7                     b                16
102.7                     c                17
106.5                     d                18
107.2                     e                19
107.7                     h                20
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
					REG2=FM_current_INT*65535 + FM_current_FRAC*16+2;
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
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		REG2 = 0x210002;   //Reg2: INT=33,FRAC=0 99.0MHz in Shanghai 
    SPI_RFD(REG2);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    REG3 = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(REG3);		
		
		FM_current_gain=20;
    FM_current_INT=33;
    FM_current_FRAC=1700;
		
	  ChannelControlDisplay.channel_no =1;
	  ChannelControlDisplay.freq =99.0;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		

		
	  UARTString("  Channel: 99.0MHz  ");
	  WriteUART('\n');
	}
 else if(data=='2')   // formal FM receiver
	{
				MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		REG2 = 0x1e3842;   //Reg2: INT=30,FRAC=900 97.7MHz in Shanghai 
    SPI_RFD(REG2);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    REG3 = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(REG3);		
		
		FM_current_gain=20;
    FM_current_INT=30;
    FM_current_FRAC=900;

	  ChannelControlDisplay.channel_no =2;
	  ChannelControlDisplay.freq =90.9;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		
	  UARTString("  Channel: 90.9MHz  ");
	  WriteUART('\n');
	}
 else if(data=='3')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1f3e822;   //Reg2: INT=31,FRAC=1000 96.8MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=31;
    FM_current_FRAC=1000;
		
	  ChannelControlDisplay.channel_no =3;
	  ChannelControlDisplay.freq =94.0;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		UARTString("  Channel: 94.0MHz  ");
	  WriteUART('\n');
	}
 else if(data=='4')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1f6a42;   //Reg2: INT=31,FRAC=1700 94.7MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=31;
    FM_current_FRAC=1700;
	  ChannelControlDisplay.channel_no =4;
	  ChannelControlDisplay.freq =94.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		
		UARTString("  Channel: 94.7MHz  ");
	  WriteUART('\n');
	}
else if(data=='5')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1f1902;   //Reg2: INT=31,FRAC=400 93.4MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=31;
    FM_current_FRAC=400;
	  ChannelControlDisplay.channel_no =5;
	  ChannelControlDisplay.freq =93.4;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		
		UARTString("  Channel: 93.4MHz Shanghai 990 ");
	  WriteUART('\n');
	}
else if(data=='6')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1f9c42;   //Reg2: INT=30,FRAC=2400 92.4MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=30;
    FM_current_FRAC=2400;

	  ChannelControlDisplay.channel_no =6;
	  ChannelControlDisplay.freq =95.5;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		UARTString("  Channel: 95.5MHz  ");
	  WriteUART('\n');
	}
else if(data=='7')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1e5782;   //Reg2: INT=30,FRAC=1400 91.4MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=30;
    FM_current_FRAC=1400;

	  ChannelControlDisplay.channel_no =7;
	  ChannelControlDisplay.freq =91.4;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
			
		
		UARTString("  Channel: CNR 91.4MHz Jingji ");
	  WriteUART('\n');
	}
else if(data=='8')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1db542;   //Reg2: INT=29,FRAC=2900 89.9MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=29;
    FM_current_FRAC=2900;

	  ChannelControlDisplay.channel_no =8;
	  ChannelControlDisplay.freq =89.9;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		UARTString("  Channel: 89.9MHz Dushi 792 ");
	  WriteUART('\n');
	}
else if(data=='9')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x1d3842;   //Reg2: INT=29,FRAC=900 97.9MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=29;
    FM_current_FRAC=900;

	  ChannelControlDisplay.channel_no =9;
	  ChannelControlDisplay.freq =87.9;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		UARTString("  Channel: 87.9MHz   CNR 87.9 ");
	  WriteUART('\n');
	}
else if(data=='z')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x232bc2;   //Reg2: INT=35,FRAC=700 105.7MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=35;
    FM_current_FRAC=700;

	  ChannelControlDisplay.channel_no =10;
	  ChannelControlDisplay.freq =105.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				

		
		UARTString("  Channel: 105.7MHz  ");
	  WriteUART('\n');
	}
else if(data=='y')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x204b02;   //Reg2: INT=32,FRAC=1200 97.2MHz in Shanghai 
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=34;
    FM_current_FRAC=2500;

	  ChannelControlDisplay.channel_no =11;
	  ChannelControlDisplay.freq =97.2;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);				
		
		UARTString("  Channel: 97.2MHz  ");
	  WriteUART('\n');
	}			
else if(data=='x')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x21a8c2;   //Reg2: INT=33,FRAC=2700 101.7MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=33;
    FM_current_FRAC=2700;

	  ChannelControlDisplay.channel_no =12;
	  ChannelControlDisplay.freq =101.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 101.7MHz  Donggan 101.7 ");
	  WriteUART('\n');
	}		
	
else if(data=='v')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x208342;   //Reg2: INT=32,FRAC=2100 101.7MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=32;
    FM_current_FRAC=2100;

	  ChannelControlDisplay.channel_no =13;
	  ChannelControlDisplay.freq =98.1;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 98.1MHz ");
	  WriteUART('\n');
	}
	
else if(data=='w')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x2144c2;   //Reg2: INT=33,FRAC=1100 100.1MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=32;
    FM_current_FRAC=2100;

	  ChannelControlDisplay.channel_no =14;
	  ChannelControlDisplay.freq =100.1;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 100.1MHz ");
	  WriteUART('\n');
	}		
else if(data=='a')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x2176c2;   //Reg2: INT=33,FRAC=1900 100.9MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=33;
    FM_current_FRAC=1900;

	  ChannelControlDisplay.channel_no =15;
	  ChannelControlDisplay.freq =100.9;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 100.9 MHz ");
	  WriteUART('\n');	
	}

else if(data=='b')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x226a42;   //Reg2: INT=34,FRAC=1700 103.7MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=34;
    FM_current_FRAC=1700;

	  ChannelControlDisplay.channel_no =16;
	  ChannelControlDisplay.freq =103.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 103.7 MHz ");
	  WriteUART('\n');	
	}	
	
else if(data=='c')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x222bc2;   //Reg2: INT=34,FRAC=700 102.7MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=34;
    FM_current_FRAC=700;

	  ChannelControlDisplay.channel_no =17;
	  ChannelControlDisplay.freq =102.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 102.7 MHz ");
	  WriteUART('\n');	
	}		

else if(data=='d')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x235dc2;   //Reg2: INT=35,FRAC=1500 106.5MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=35;
    FM_current_FRAC=1500;

	  ChannelControlDisplay.channel_no =18;
	  ChannelControlDisplay.freq =106.5;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 106.5 MHz ");
	  WriteUART('\n');	
	}			
	
else if(data=='e')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x238982;   //Reg2: INT=35,FRAC=2200 107.2MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=35;
    FM_current_FRAC=1500;

	  ChannelControlDisplay.channel_no =19;
	  ChannelControlDisplay.freq =107.2;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 107.2 MHz ");
	  WriteUART('\n');	
	}			

else if(data=='h')   // formal FM receiver
	{
		MSI_SPI_Data = 0x00043420;  //reg 0: 24M clk
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0028bb85;  //reg5: THRESH=3000
		
    SPI_RFD(MSI_SPI_Data);
		MSI_SPI_Data = 0x23a8c2;   //Reg2: INT=35,FRAC=2700 107.7MHz in Shanghai 

    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x0000e141;   //Reg1: BB Gain decrease 20dB  LNA Gain redcution: 23dB
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00200016;   //Reg6: DC default value
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000004;   //Reg4: Aux features
    SPI_RFD(MSI_SPI_Data);
    MSI_SPI_Data = 0x00000003;   //Reg3:AFC = 0
    SPI_RFD(MSI_SPI_Data);	
		
		FM_current_gain=20;
    FM_current_INT=35;
    FM_current_FRAC=1500;

	  ChannelControlDisplay.channel_no =20;
	  ChannelControlDisplay.freq =107.7;
	  ChannelControlDisplay.INT =FM_current_INT;
	  ChannelControlDisplay.FRAC =FM_current_FRAC;
	  Channel_control(ChannelControlDisplay);		


		UARTString("  Channel: 107.7 MHz ");
	  WriteUART('\n');	
	}		
	
else  
	{	
		
		UARTString("  Wrong command!   ");
	  WriteUART('\n');	
	}
	
}

