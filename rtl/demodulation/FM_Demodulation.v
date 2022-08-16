
module FM_Demodulation 
 (
   input EOC,
   input [2:0] Channel,
   input [3:0] FM_HW_state,
   input RSTn,
   input [11:0] ADC_Data,
   input demod_en,
   output reg [9:0] demodulated_signal_sample,
   output clk_fm_demo_sampling
 );

// workable filter, filtering audio data:
parameter fir_0 = 8'h11;
parameter fir_1 = 8'h22;
parameter fir_2 = 8'h39;
parameter fir_3 = 8'h55;
parameter fir_4 = 8'h76;
parameter fir_5 = 8'h98;
parameter fir_6 = 8'hb9;
parameter fir_7 = 8'hd7;
parameter fir_8 = 8'hef;
parameter fir_9 = 9'hfe;
parameter fir_10 = 9'h103;
parameter fir_11 = 8'hfe;
parameter fir_12= 8'hef;
parameter fir_13 = 8'hd7;
parameter fir_14 = 8'hb9;
parameter fir_15 = 8'h98;
parameter fir_16 = 8'h76;
parameter fir_17 = 8'h55;
parameter fir_18 = 8'h39;
parameter fir_19 = 8'h22;
parameter fir_20 = 8'h11;

reg [7:0] IdataN_1=8'h0;
reg [7:0] IdataN=8'h0;
reg [7:0] QdataN_1=8'h0;
reg [7:0] QdataN=8'h0;
reg EOC_Count_Demodulate=1'b0;
reg [16:0] demodulated_signal_temp=17'h0;


reg [9:0] dmd_data_filter [20:0];
reg [23:0] dmd_data_filtered;

integer ii;

initial begin
     for(ii=0;ii<5'd21;ii=ii+1) begin
         dmd_data_filter[ii]=10'b0;
     end
end

always@(posedge EOC) begin
      if(FM_HW_state == 4'b0010) begin //normal FM receiver
          if(Channel==3'b110) begin     //CH6 is the I Path
               IdataN<=IdataN_1;
               IdataN_1 <= ADC_Data[11:4];     
          end
          if(Channel==3'b100) begin     //CH4 is the Q Path   
               QdataN<=QdataN_1;          
               QdataN_1 <= ADC_Data[11:4];     
          end
      end
end  



always@(posedge EOC) begin
      if(FM_HW_state == 4'b0010) begin //normal FM receiver
         if(EOC_Count_Demodulate == 1'b0)
            EOC_Count_Demodulate<=1'b1;
         else EOC_Count_Demodulate<=1'b0;
      end
end 

always@(posedge EOC_Count_Demodulate  or negedge RSTn ) begin
          if(~RSTn)
               demodulated_signal_temp <= 17'h0;
          else demodulated_signal_temp <=((IdataN*QdataN_1+17'h10000) - QdataN*IdataN_1);
end 

//filtering 

always@(posedge EOC_Count_Demodulate  or negedge RSTn ) begin
          if(~RSTn)
               dmd_data_filtered <= 24'h0;
          else begin
               dmd_data_filter[20] <= demodulated_signal_temp[16:7];     
               dmd_data_filter[19] <= dmd_data_filter[20]; 
               dmd_data_filter[18] <= dmd_data_filter[19]; 
               dmd_data_filter[17] <= dmd_data_filter[18]; 
               dmd_data_filter[16] <= dmd_data_filter[17]; 
               dmd_data_filter[15] <= dmd_data_filter[16]; 
               dmd_data_filter[14] <= dmd_data_filter[15]; 
               dmd_data_filter[13] <= dmd_data_filter[14]; 
               dmd_data_filter[12] <= dmd_data_filter[13]; 
               dmd_data_filter[11] <= dmd_data_filter[12]; 
               dmd_data_filter[10] <= dmd_data_filter[11]; 
               dmd_data_filter[9] <= dmd_data_filter[10]; 
               dmd_data_filter[8] <= dmd_data_filter[9]; 
               dmd_data_filter[7] <= dmd_data_filter[8]; 
               dmd_data_filter[6] <= dmd_data_filter[7]; 
               dmd_data_filter[5] <= dmd_data_filter[6]; 
               dmd_data_filter[4] <= dmd_data_filter[5]; 
               dmd_data_filter[3] <= dmd_data_filter[4]; 
               dmd_data_filter[2] <= dmd_data_filter[3]; 
               dmd_data_filter[1] <= dmd_data_filter[2]; 
               dmd_data_filter[0] <= dmd_data_filter[1]; 

          dmd_data_filtered <= dmd_data_filter[20]*fir_0 + dmd_data_filter[19]*fir_1 + dmd_data_filter[18]*fir_2 + 
                                  dmd_data_filter[17]*fir_3 + dmd_data_filter[16]*fir_4 + dmd_data_filter[15]*fir_5 + 
                                  dmd_data_filter[14]*fir_6 + dmd_data_filter[13]*fir_7 + dmd_data_filter[12]*fir_8 + 
                                  dmd_data_filter[11]*fir_9 + dmd_data_filter[10]*fir_10 + dmd_data_filter[9]*fir_11 + 
                                  dmd_data_filter[8]*fir_12 + dmd_data_filter[7]*fir_13 + dmd_data_filter[6]*fir_14 + 
                                  dmd_data_filter[5]*fir_15 + dmd_data_filter[4]*fir_16 + dmd_data_filter[3]*fir_17 + 
                                  dmd_data_filter[2]*fir_18 + dmd_data_filter[1]*fir_19 + dmd_data_filter[0]*fir_20;
 /*                                 
           dmd_data_filtered <=  (32768+dmd_data_filter[19]*fir_1 + dmd_data_filter[18]*fir_2 + 
                                  dmd_data_filter[17]*fir_3 + dmd_data_filter[13]*fir_7 + dmd_data_filter[12]*fir_8 + 
                                  dmd_data_filter[11]*fir_9 + dmd_data_filter[10]*fir_10 + dmd_data_filter[9]*fir_11 + 
                                  dmd_data_filter[8]*fir_12 + dmd_data_filter[7]*fir_13 + dmd_data_filter[3]*fir_17 + 
                                  dmd_data_filter[2]*fir_18 + dmd_data_filter[1]*fir_19)  -                                   
                                 (dmd_data_filter[20]*fir_0 +dmd_data_filter[16]*fir_4 + dmd_data_filter[15]*fir_5 +                                    
                                  dmd_data_filter[14]*fir_6 + dmd_data_filter[6]*fir_14 + dmd_data_filter[5]*fir_15 +                                  
                                 dmd_data_filter[4]*fir_16 + dmd_data_filter[0]*fir_20);                                 
 */                                  
         end                                  

end 


clk_fm_demo_sample_pwm fm_sample
(
    .FM_demod_en(demod_en),
    .EOC(EOC),
    .RSTn(RSTn),
    .clk_fm_demo_sampling(clk_fm_demo_sampling)
);


//downsampling
always@(posedge clk_fm_demo_sampling  or negedge RSTn  ) begin
       if(~RSTn)
               demodulated_signal_sample <= 10'h0;
       else begin             //normal FM receiver
           demodulated_signal_sample[9:0]<=dmd_data_filtered[22:13];
       end
end 


endmodule