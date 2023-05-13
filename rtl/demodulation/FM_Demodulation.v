`include "../topmodule/header.vh"

module FM_Demodulation
  (
    input clk,
    input             EOC                      ,
    input      [ 2:0] Channel                  ,
    input      [ 3:0] FM_HW_state              ,
    input             RSTn                     ,
    input      [11:0] ADC_Data                 ,
    input             demod_en                 ,
    output reg [13:0] demodulated_signal_sample,
    output clk_fm_demo_sampling,
    output I2S_SDATA,    // data 50bit
    output wire I2S_BCLK,    //clk out
    output wire I2S_LRCLK,       //L R channel enable
    output wire clk_fm_ethernet,
    output wire [31:0] fm_data_ethernet
  );

  // working filter coe
  parameter fir_0_20 = (9'h01);
  parameter fir_1_19 = (9'h02);
  parameter fir_2_18 = (9'h03);
  parameter fir_3_17 = (9'h05);
  parameter fir_4_16 = (9'h07);
  parameter fir_5_15 = (9'h0a);
  parameter fir_6_14 = 9'h0d;
  parameter fir_7_13 = 9'h10;
  parameter fir_8_12 = 9'h12;
  parameter fir_9_11 = 9'h13;
  parameter fir_10 = 9'h14;

  reg [ 7:0] IdataN_1                = 8'h0 ;
  reg [ 7:0] IdataN                  = 8'h0 ;
  reg [ 7:0] QdataN_1                = 8'h0 ;
  reg [ 7:0] QdataN                  = 8'h0 ;
  reg        EOC_Count_Demodulate    = 1'b0 ;
  reg [9:0] demodulated_signal_sample1;


  reg [16:0] dmd_data_filter [20:0];
  //reg [23:0] dmd_data_filtered;

  integer ii;

  initial
  begin
    for(ii=0;ii<5'd21;ii=ii+1)
    begin
      dmd_data_filter[ii]=10'b0;
    end
  end

  reg [7:0] Idata,Qdata; //output to ethernet
  reg [15:0] IQdatatemp1,IQdatatemp2;
  //simple demodulation method: 最小角度法解调：X(n)=Q(n)I(n-1)-I(n)Q(n-1);
  always@(posedge EOC)
  begin
    if(FM_HW_state == 4'b0010)
    begin //normal FM receiver
      if(Channel==3'b110)
      begin     //CH6 is the I Path
        IdataN<=IdataN_1;
        IdataN_1 <= (ADC_Data[11:4]-127);
        Idata <= ADC_Data[11:4];      //output to ethernet
      end
      if(Channel==3'b100)
      begin     //CH6 is the Q Path
        QdataN<=QdataN_1;
        QdataN_1 <= (ADC_Data[11:4]-127);
        Qdata <= ADC_Data[11:4];     //output to ethernet
      end
    end
  end

  wire [15:0] INMultQN_1;
  wire [15:0] QNMultIN_1;
  lib_mult multlIN  (
             .a(IdataN),	    // 8bit
             .b(QdataN_1),	    // 8bit
             .x(INMultQN_1)	    // 16bit
           );

  lib_mult multlQN  (
             .a(QdataN),	    // 8bit
             .b(IdataN_1),	    // 8bit
             .x(QNMultIN_1)	    // 16bit
           );

  wire [16:0] demodulated_signal_temp;
  lib_adsb add    (
             .a(INMultQN_1),	// 16bit
             .b(QNMultIN_1),	// 16bit
             .m(1'b1),	          // subtract mode
             .x(demodulated_signal_temp)		// 17bit
           );
  //	simple demodulation method: 最小角度法解调
  always@(posedge EOC)
  begin
    if(FM_HW_state == 4'b0010)
    begin //normal FM receiver
      if(EOC_Count_Demodulate == 1'b0)
        EOC_Count_Demodulate <= 1'b1;
      else
        EOC_Count_Demodulate<=1'b0;
    end
  end
  reg [4:0] i,j;
  always@(posedge EOC_Count_Demodulate  or negedge RSTn )
  begin
    if(~RSTn)
      for (i=0; i<21; i = i+1'b1)
        dmd_data_filter[i] <=17'b0;
    else
    begin
      IQdatatemp1<=IQdatatemp2;
      IQdatatemp2<={Idata, Qdata};//output to ethernet
      for (j=0; j<20; j = j+1'b1)
        dmd_data_filter[j] <= dmd_data_filter[j+1];
      dmd_data_filter[20]<=demodulated_signal_temp;
    end
  end

  wire [17:0] dmd_data_filter_ADD_0_20 = {dmd_data_filter[20][16], dmd_data_filter[20]}+{dmd_data_filter[0][16], dmd_data_filter[0]};
  wire [17:0] dmd_data_filter_ADD_1_19 = {dmd_data_filter[19][16], dmd_data_filter[19]}+{dmd_data_filter[1][16], dmd_data_filter[1]};
  wire [17:0] dmd_data_filter_ADD_2_18 = {dmd_data_filter[18][16], dmd_data_filter[18]}+{dmd_data_filter[2][16], dmd_data_filter[2]};
  wire [17:0] dmd_data_filter_ADD_3_17 = {dmd_data_filter[17][16], dmd_data_filter[17]}+{dmd_data_filter[3][16], dmd_data_filter[3]};
  wire [17:0] dmd_data_filter_ADD_4_16 = {dmd_data_filter[16][16], dmd_data_filter[16]}+{dmd_data_filter[4][16], dmd_data_filter[4]};
  wire [17:0] dmd_data_filter_ADD_5_15 = {dmd_data_filter[15][16], dmd_data_filter[15]}+{dmd_data_filter[5][16], dmd_data_filter[5]};
  wire [17:0] dmd_data_filter_ADD_6_14 = {dmd_data_filter[14][16], dmd_data_filter[14]}+{dmd_data_filter[6][16], dmd_data_filter[6]};
  wire [17:0] dmd_data_filter_ADD_7_13 = {dmd_data_filter[13][16], dmd_data_filter[13]}+{dmd_data_filter[7][16], dmd_data_filter[7]};
  wire [17:0] dmd_data_filter_ADD_8_12 = {dmd_data_filter[12][16], dmd_data_filter[12]}+{dmd_data_filter[8][16], dmd_data_filter[8]};
  wire [17:0] dmd_data_filter_ADD_9_11 = {dmd_data_filter[11][16], dmd_data_filter[11]}+{dmd_data_filter[9][16], dmd_data_filter[9]};
  wire [17:0] dmd_data_filter_ADD_10 = {dmd_data_filter[10][16], dmd_data_filter[10]};
  wire [26:0] dmd_data_filter_multi_0_20;
  wire [26:0] dmd_data_filter_multi_1_19;
  wire [26:0] dmd_data_filter_multi_2_18;
  wire [26:0] dmd_data_filter_multi_3_17;
  wire [26:0] dmd_data_filter_multi_4_16;
  wire [26:0] dmd_data_filter_multi_5_15;
  wire [26:0] dmd_data_filter_multi_6_14;
  wire [26:0] dmd_data_filter_multi_7_13;
  wire [26:0] dmd_data_filter_multi_8_12;
  wire [26:0] dmd_data_filter_multi_9_11;
  wire [26:0] dmd_data_filter_multi_10;
  lib_mult18M9 multl18M9_0  (
                 .a(dmd_data_filter_ADD_0_20),	    // 18bit
                 .b(fir_0_20),	                   // 9bit
                 .x(dmd_data_filter_multi_0_20)    // 27bit
               );
  lib_mult18M9 multl18M9_1  (
                 .a(dmd_data_filter_ADD_1_19),	    // 18bit
                 .b(fir_1_19),	                   // 9bit
                 .x(dmd_data_filter_multi_1_19)    // 27bit
               );
  lib_mult18M9 multl18M9_2  (
                 .a(dmd_data_filter_ADD_2_18),	    // 18bit
                 .b(fir_2_18),	                   // 9bit
                 .x(dmd_data_filter_multi_2_18)    // 27bit
               );
  lib_mult18M9 multl18M9_3  (
                 .a(dmd_data_filter_ADD_3_17),	    // 18bit
                 .b(fir_3_17),	                   // 9bit
                 .x(dmd_data_filter_multi_3_17)    // 27bit
               );
  lib_mult18M9 multl18M9_4  (
                 .a(dmd_data_filter_ADD_4_16),	    // 18bit
                 .b(fir_4_16),	                   // 9bit
                 .x(dmd_data_filter_multi_4_16)    // 27bit
               );
  lib_mult18M9 multl18M9_5  (
                 .a(dmd_data_filter_ADD_5_15),	    // 18bit
                 .b(fir_5_15),	                   // 9bit
                 .x(dmd_data_filter_multi_5_15)    // 27bit
               );
  lib_mult18M9 multl18M9_6  (
                 .a(dmd_data_filter_ADD_6_14),	    // 18bit
                 .b(fir_6_14),	                   // 9bit
                 .x(dmd_data_filter_multi_6_14)    // 27bit
               );
  lib_mult18M9 multl18M9_7  (
                 .a(dmd_data_filter_ADD_7_13),	    // 18bit
                 .b(fir_7_13),	                   // 9bit
                 .x(dmd_data_filter_multi_7_13)    // 27bit
               );
  lib_mult18M9 multl18M9_8  (
                 .a(dmd_data_filter_ADD_8_12),	    // 18bit
                 .b(fir_8_12),	                   // 9bit
                 .x(dmd_data_filter_multi_8_12)    // 27bit
               );
  lib_mult18M9 multl18M9_9  (
                 .a(dmd_data_filter_ADD_9_11),	    // 18bit
                 .b(fir_9_11),	                   // 9bit
                 .x(dmd_data_filter_multi_9_11)    // 27bit
               );
  lib_mult18M9 multl18M9_10  (
                 .a(dmd_data_filter_ADD_10),	    // 18bit
                 .b(fir_10),	                   // 9bit
                 .x(dmd_data_filter_multi_10)    // 27bit
               );

  wire [27:0] dmd_data_filtered_add_0_20_1_19 = {dmd_data_filter_multi_0_20[26], dmd_data_filter_multi_0_20}+{dmd_data_filter_multi_1_19[26], dmd_data_filter_multi_1_19};
  wire [27:0] dmd_data_filtered_add_2_18_3_17 = {dmd_data_filter_multi_2_18[26], dmd_data_filter_multi_2_18}+{dmd_data_filter_multi_3_17[26], dmd_data_filter_multi_3_17};
  wire [27:0] dmd_data_filtered_add_4_16_5_15 = {dmd_data_filter_multi_4_16[26], dmd_data_filter_multi_4_16}+{dmd_data_filter_multi_5_15[26], dmd_data_filter_multi_5_15};
  wire [27:0] dmd_data_filtered_add_6_14_7_13 = {dmd_data_filter_multi_6_14[26], dmd_data_filter_multi_6_14}+{dmd_data_filter_multi_7_13[26], dmd_data_filter_multi_7_13};
  wire [27:0] dmd_data_filtered_add_8_12_9_11 = {dmd_data_filter_multi_8_12[26], dmd_data_filter_multi_8_12}+{dmd_data_filter_multi_9_11[26], dmd_data_filter_multi_9_11};
  wire [27:0] dmd_data_filtered_add_10 = {dmd_data_filter_multi_10[26], dmd_data_filter_multi_10};


  wire [28:0] dmd_data_filtered_add_0_20_1_19_2_18_3_17={dmd_data_filtered_add_0_20_1_19[27], dmd_data_filtered_add_0_20_1_19}+{dmd_data_filtered_add_2_18_3_17[27], dmd_data_filtered_add_2_18_3_17};
  wire [28:0] dmd_data_filtered_add_4_16_5_15_6_14_7_13={dmd_data_filtered_add_4_16_5_15[27], dmd_data_filtered_add_4_16_5_15}+{dmd_data_filtered_add_6_14_7_13[27], dmd_data_filtered_add_6_14_7_13};
  wire [28:0] dmd_data_filtered_add8_12_9_11_10={dmd_data_filtered_add_8_12_9_11[27], dmd_data_filtered_add_8_12_9_11}+{dmd_data_filtered_add_10[27], dmd_data_filtered_add_10};
  wire [29:0] dmd_data_filtered_add={dmd_data_filtered_add_0_20_1_19_2_18_3_17[28], dmd_data_filtered_add_0_20_1_19_2_18_3_17}+{dmd_data_filtered_add_4_16_5_15_6_14_7_13[28], dmd_data_filtered_add_4_16_5_15_6_14_7_13};
  wire [30:0] dmd_data_filtered_temp = {dmd_data_filtered_add[29], dmd_data_filtered_add}+{dmd_data_filtered_add8_12_9_11_10[28], dmd_data_filtered_add8_12_9_11_10[28],dmd_data_filtered_add8_12_9_11_10};
  //changed to unsigned data and 14bit to PWM
  wire [13:0] dmd_data_filtered_temp1 = {dmd_data_filtered_temp[30],dmd_data_filtered_temp[22:10]};  //[22:10]
  wire [13:0] dmd_data_filtered_14bit = dmd_data_filtered_temp1+14'h1000;
  //changed to signed data and 24bit to I2S
  wire [23:0] dmd_data_filtered_24bit =  {dmd_data_filtered_temp[30],dmd_data_filtered_temp[22:0]};

  reg [23:0] demodulated_signal_sample_24bit;
  wire [15:0] demodulated_signal_16bit = {dmd_data_filtered_temp[22:15],dmd_data_filtered_temp[30],dmd_data_filtered_temp[14:8]}; //lital endian

  reg [15:0] demodulated_signal_sample_16bit_temp1;
  reg [15:0] demodulated_signal_sample_16bit_temp2;

  clk_fm_demo_sample_pwm fm_sample (
                           .FM_demod_en         (demod_en            ),
                           .EOC                 (EOC                 ),
                           .RSTn                (RSTn                ),
                           .clk_fm_demo_sampling(clk_fm_demo_sampling)
                         );

  reg [31:0] demodulated_signal_sample_32bit;
  //downsampling and get the first 10bit for audio data
  always@(posedge clk_fm_demo_sampling  or negedge RSTn  )
  begin
    if(~RSTn)
    begin
      demodulated_signal_sample <= 14'h0;
      demodulated_signal_sample_24bit <=24'h0;
      demodulated_signal_sample_16bit_temp1 <=16'h0;
      demodulated_signal_sample_16bit_temp2 <=16'h0;
    end
    else
    begin             //normal FM receiver
      //for output to PWM
      demodulated_signal_sample <= dmd_data_filtered_14bit;
      //for output to I2S:
      demodulated_signal_sample_24bit <= dmd_data_filtered_24bit;
      //for output to ethernet
      demodulated_signal_sample_16bit_temp1 <= demodulated_signal_sample_16bit_temp2;
      demodulated_signal_sample_16bit_temp2 <= demodulated_signal_16bit;
    end
  end
  //output through I2S
  I2S_TX I2S_TX(
           .clk(clk),            // 50M clk  I2S need a 1M with 20KHz audio data: 20K*(24+1)bit*2 (right+left audio channel)  = 1MHz
           .RSTn(RSTn),
           .Ldata(demodulated_signal_sample_24bit),
           .Rdata(demodulated_signal_sample_24bit),
           .clk_fm_demo_sampling(clk_fm_demo_sampling),
           .I2S_SDATA(I2S_SDATA),    // data 50bit
           .I2S_BCLK(I2S_BCLK),      //clk out
           .I2S_LRCLK(I2S_LRCLK)      //L R channel enable
         );
  //output to ethernet handling
  /* IQ data output to ethernet */
`ifdef ethernet_IQ_output

  localparam IQ_or_Audio = 1; // 1:output IQ data; 0:output audio data.
`else
  localparam IQ_or_Audio = 0; // 1:output IQ data; 0:output audio data.
`endif

  reg clk_IQ_to_ethernet=0;
  reg [31:0] IQdata;
  always@(posedge EOC_Count_Demodulate)
  begin
    if(FM_HW_state == 4'b0010)
    begin //normal FM receiver
      if(clk_IQ_to_ethernet == 1'b0)
        clk_IQ_to_ethernet<=1'b1;
      else
        clk_IQ_to_ethernet<=1'b0;
    end
  end
  always@(posedge clk_IQ_to_ethernet  or negedge RSTn )
  begin
    if(~RSTn)
      IQdata <=32'h0;
    else
    begin
      IQdata<={IQdatatemp1, IQdatatemp2};//output to ethernet
    end
  end
  reg clk_fm_demo_2;
  always@(posedge clk_fm_demo_sampling)
  begin
    if(FM_HW_state == 4'b0010)
    begin //normal FM receiver
      if(clk_fm_demo_2 == 1'b0)
        clk_fm_demo_2<=1'b1;
      else
        clk_fm_demo_2<=1'b0;
    end
  end
  always@(posedge clk_fm_demo_2  or negedge RSTn  )
  begin
    if(~RSTn)
    begin
      demodulated_signal_sample_32bit <=32'h0;
    end
    else
    begin             //normal FM receiver
      demodulated_signal_sample_32bit <={demodulated_signal_sample_16bit_temp1,demodulated_signal_sample_16bit_temp2};
    end
  end

  assign clk_fm_ethernet = (IQ_or_Audio)? clk_IQ_to_ethernet:clk_fm_demo_2;

  assign fm_data_ethernet = (IQ_or_Audio)? IQdata:demodulated_signal_sample_32bit;
endmodule
