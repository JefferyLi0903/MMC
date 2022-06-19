module FM_HW #(
    parameter FM_ADDR_WIDTH = 13
)(
   input clk,
   input ADC_start,
   input RSTn,
   output [7:0] LED_Out,

   input [FM_ADDR_WIDTH-1:0] wraddr,
   input [FM_ADDR_WIDTH-1:0] rdaddr,
   input [31:0] wdata,
   input [3:0] wea,
   output [31:0] rdata,
   output reg [3:0] FM_HW_state,
   output wire IQ_Write_Done_interrupt,
   output wire Demo_Dump_Done_Interrupt,
   output wire audio_pwm
 );

reg adc_Power_down=1'b1;  //1: power down, 0?power on
wire EOC;

//reg [3:0] FM_HW_state;
reg [7:0] RSSI_Scan_parameters;
reg [4:0] ADC_dump_parameters;

/* 
   parameter dumpIQ_or_audio: 1'b1: dump IQ data; 1'b0:dump audio data
   if you want dump IQ data, set the dumpIQ_or_audio = 1'b1
   then make instance of FM_Dump_Data  as FM_Dump_Data_IQ
   
   if you want dump audio data, set the dumpIQ_or_audio = 1'b0 
   you need make instance of:FM_Dump_Data  FM_Dump_Data_Audio 
*/

localparam dumpIQ_or_audio = 1'b1;  
localparam FM_HW_STATE_IDLE = 4'b0000;
localparam FM_HW_STATE_RCEV = 4'b0010;   //Receiver State, receiver, dump IQ or audio data
localparam FM_HW_STATE_RSSI = 4'b0100;   //RSSI Scan state
localparam FM_HW_STATE_RSSI_SNR_Verify = 4'b1000;

always@(posedge clk or negedge RSTn ) begin
      if (!RSTn) begin
          FM_HW_state <= FM_HW_STATE_IDLE;       
          adc_Power_down <=1'b1;    
      end
      else if ((wraddr==15'h004)&&(wdata[7:4]==4'b0001)&&(wea>3'b0))  begin     //control to normal FM receiver On
           FM_HW_state <= FM_HW_STATE_RCEV;
           adc_Power_down <=1'b0; 
      end 
      else if ((wraddr==15'h004)&&(wdata[7:4]==4'b0010)&&(wea>3'b0))  begin     //control to normal FM receiver OFF
           FM_HW_state <= FM_HW_STATE_IDLE;
           adc_Power_down <=1'b1; 
      end 
      else if ((wraddr==15'h004)&&(wdata[15:8]==8'h01)&&(wea>3'b0)) begin     //RSSI scan parameters
           FM_HW_state <= FM_HW_STATE_RSSI; 
           RSSI_Scan_parameters <= wdata[15:8];
           adc_Power_down <=1'b0; 
      end      

end

wire CW_CLK; //synthesis keep;
wire ADC_CLK;
wire CLK_Lock;
wire clk_PWM1;
wire clk_PWM2;


PLL_Demodulation U1  //use final adc clk 200Khz
(
   .refclk(clk),
   .reset(1'b0),
   .stdby(1'b0),
   .extlock(CLK_Lock),
   .clk0_out(CW_CLK), //ChipWatcher采样时钟 200M
   .clk1_out(ADC_CLK), //ADC工作时钟,6.4M   
   .clk2_out(clk_PWM1),           //20M
   .clk4_out(clk_PWM2)          //40M
);     


/*

// for Model Simulation ONLY

reg [2:0] sim_PWM_clk;
reg sim_clk_PWM1;
always@(posedge clk or negedge RSTn ) begin
  if (!RSTn) begin  sim_clk_PWM1 <= 1'b0; sim_PWM_clk <=3'b000; end 
  else if (sim_PWM_clk == 3'b101) begin
           sim_clk_PWM1 <= 1'b1;
           sim_PWM_clk <=3'b000;
           end
  else begin
           sim_clk_PWM1 <= 1'b0;   
           sim_PWM_clk = sim_PWM_clk+1'b1;
       end
end
*/

//ADC通道4,6轮询
reg[2:0] Channel;

always@(posedge EOC or negedge RSTn ) begin
  if (!RSTn) Channel <= 3'b100;
      else if (Channel == 3'b100)
           Channel <= 3'b110;
           else 
           Channel <= 3'b100;
    
end



//ADC输出数据
wire [11:0]ADC_Data ; //synthesis keep;

//CH6-P12 MSI I data, CH4-M12 MSI Q data 

ADC_Sampling U2
(
 	.eoc(EOC),
	.dout(ADC_Data), 
	.clk(ADC_CLK),
	.pd(adc_Power_down),
        .s(Channel),
	.soc(1'b1)
);


/*

// for Model Simulation ONLY

ADC_Sample_debug ADC_Sample_debug( 
   .eoc(EOC), 
   .dout(ADC_Data), 
   .clk(clk),
   .RSTn(RSTn),
   .channel(Channel)
);   

*/

// select FM_Dump_Data_IQ or FM_Dump_Data_Audio 

FM_Dump_Data  FM_Dump_Data_IQ
(
   .clk(clk),
   .RSTn(RSTn),
   .dump_data_clk(EOC),
   .FM_HW_state(FM_HW_state),
   .wraddr(wraddr),
   .rdaddr(wraddr),
   .wdata(wdata),
   .wea(wea),
   .dump_data(ADC_Data[11:4]),
   .rdata(rdata),
   .Dump_Done_Interrupt(Dump_Done_Interrupt)

 );


wire [9:0] demodulated_signal_downsample;
FM_Demodulation FM_Demodulation
 (
   .EOC(EOC),
   .Channel(Channel),
   .FM_HW_state(FM_HW_state),
   .RSTn(RSTn),
   .ADC_Data(ADC_Data),
   .demod_en(adc_Power_down),
   .demodulated_signal_sample(demodulated_signal_downsample),
   .clk_fm_demo_sampling(clk_fm_demo_sampling)
 );



/*
// select FM_Dump_Data_IQ or FM_Dump_Data_Audio 

FM_Dump_Data  FM_Dump_Data_Audio
(
   .clk(clk),
   .RSTn(RSTn),
   .dump_data_clk(clk_fm_demo_sampling),
   .FM_HW_state(FM_HW_state),

   .wraddr(wraddr),
   .rdaddr(wraddr),
   .wdata(wdata),
   .wea(wea),

   .dump_data(demodulated_signal_downsample[8:1]),

   .rdata(rdata),

   .Dump_Done_Interrupt(Dump_Done_Interrupt)

 );

*/

Aduio_PWM Audio_PWM
(
  .clk_fm_demo_sampling(clk_fm_demo_sampling),
  .clk(clk_PWM1),           //simulating 20K or 40K * 200KHz ADC sampling clk
  //.clk(sim_clk_PWM1),     // for Model Simulation ONLY
  .RSTn(RSTn),  
  .demod_en(adc_Power_down),
  .demodulated_signal_downsample(demodulated_signal_downsample),
  .audio_pwm(audio_pwm)

);


assign LED_Out = {audio_pwm,audio_pwm,audio_pwm,audio_pwm,~audio_pwm,~audio_pwm,~audio_pwm,~audio_pwm};

assign IQ_Write_Done_interrupt = dumpIQ_or_audio? Dump_Done_Interrupt:1'b0;
assign Demo_Dump_Done_Interrupt = (~dumpIQ_or_audio)? Dump_Done_Interrupt:1'b0;


endmodule
