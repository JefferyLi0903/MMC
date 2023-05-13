module I2S_TX(
    input clk,            // 50M clk  I2S need a 1M with 20KHz audio data: 20K*(24+1)bit*2 (right+left audio channel)  = 1MHz
    input RSTn,
    input [23:0] Ldata,
    input [23:0] Rdata,
    input clk_fm_demo_sampling,
    output I2S_SDATA,    // data 50bit
    output wire I2S_BCLK,    //clk out
    output reg I2S_LRCLK       //L R channel enable 
);    

wire i2s_1m_clk;
I2S_1M i2s_1m(
    .clk(clk),
    .RSTn(RSTn),
    .i2s_1m_clk(i2s_1m_clk)
);

wire [49:0] data_add_onebit_0;
reg [49:0] data_add_onebit,data_add_onebit_1,data_add_onebit_2;

assign data_add_onebit_0 = {Ldata[23],Ldata,Rdata[23],Rdata};
//input data delay 3 1M clock(i2s_1m_clk)
always@(posedge i2s_1m_clk or negedge RSTn) begin  
  if(~RSTn)begin
     data_add_onebit_1 <= 50'h0;
     data_add_onebit_2 <= 50'h0;
     data_add_onebit <= 50'h0;
  end
  else begin
     data_add_onebit_1 <= data_add_onebit_0;
     data_add_onebit_2 <= data_add_onebit_1;
     data_add_onebit <= data_add_onebit_2;
  end 
end  


//1 audio channle use 24bit + 1bit , so left channel + right channle need 50bit so we use 6 bit counter
reg [5:0] counter;     
reg N_1=1'b0;
reg N=1'b0;     
//counter shall be aligned to boundary of clk_fm_demo_sampling 
always@(posedge i2s_1m_clk or negedge RSTn) begin  
  if(~RSTn) counter <= 6'h0;
  else begin
            N_1<=N;
            N<=clk_fm_demo_sampling;
            if(N>N_1) begin           
              counter <= 6'h0;              
             end
            else begin
               counter <= counter + 1'b1;                     
            end
  end 
end  

reg data_temp;
always@(posedge i2s_1m_clk  or negedge RSTn) begin
   if(~RSTn) begin
        I2S_LRCLK <= 1'b1;           
        data_temp<=1'b0;
        end
   else begin      
                case(counter) 	     	       
                    6'd0:  I2S_LRCLK <= 1'b0;                                       
                    6'd1:  data_temp <= data_add_onebit[48];
                    6'd2:  data_temp <= data_add_onebit[47]; 
                    6'd3:  data_temp <= data_add_onebit[46]; 
                    6'd4:  data_temp <= data_add_onebit[45];
                    6'd5:  data_temp <= data_add_onebit[44];
                    6'd6:  data_temp <= data_add_onebit[43];
                    6'd7:  data_temp <= data_add_onebit[42];
                    6'd8:  data_temp <= data_add_onebit[41];
                    6'd9:  data_temp <= data_add_onebit[40];
                    6'd10: data_temp <= data_add_onebit[39];
                    6'd11: data_temp <= data_add_onebit[38];
                    6'd12: data_temp <= data_add_onebit[37];
                    6'd13: data_temp <= data_add_onebit[36];
                    6'd14: data_temp <= data_add_onebit[35];
                    6'd15: data_temp <= data_add_onebit[34];
                    6'd16: data_temp <= data_add_onebit[33];
                    6'd17: data_temp <= data_add_onebit[32];
                    6'd18: data_temp <= data_add_onebit[31];
                    6'd19: data_temp <= data_add_onebit[30];
                    6'd20: data_temp <= data_add_onebit[29];
                    6'd21: data_temp <= data_add_onebit[28];
                    6'd22: data_temp <= data_add_onebit[27];
                    6'd23: data_temp <= data_add_onebit[26];                     
                    6'd24: data_temp <= data_add_onebit[25];                         
                    6'd25: begin I2S_LRCLK <= 1'b1; data_temp <= data_add_onebit[24]; end    
                    6'd26:  data_temp <= data_add_onebit[23];
                    6'd27:  data_temp <= data_add_onebit[22]; 
                    6'd28:  data_temp <= data_add_onebit[21]; 
                    6'd29:  data_temp <= data_add_onebit[20];
                    6'd30:  data_temp <= data_add_onebit[19];
                    6'd31:  data_temp <= data_add_onebit[18];
                    6'd32:  data_temp <= data_add_onebit[17];
                    6'd33:  data_temp <= data_add_onebit[16];
                    6'd34:  data_temp <= data_add_onebit[15];
                    6'd35: data_temp <= data_add_onebit[14];
                    6'd36: data_temp <= data_add_onebit[13];
                    6'd37: data_temp <= data_add_onebit[12];
                    6'd38: data_temp <= data_add_onebit[11];
                    6'd39: data_temp <= data_add_onebit[10];
                    6'd40: data_temp <= data_add_onebit[9];
                    6'd41: data_temp <= data_add_onebit[8];
                    6'd42: data_temp <= data_add_onebit[7];
                    6'd43: data_temp <= data_add_onebit[6];
                    6'd44: data_temp <= data_add_onebit[5];
                    6'd45: data_temp <= data_add_onebit[4];
                    6'd46: data_temp <= data_add_onebit[3];
                    6'd47: data_temp <= data_add_onebit[2];
                    6'd48: data_temp <= data_add_onebit[1];                     
                    6'd49: data_temp <= data_add_onebit[0];                         
                    //6'd50: I2S_clk_en<=1'b0;          
                    //default: begin I2S_clk_en <= 1'b0; end                                     
               endcase
end	               
end 

assign I2S_SDATA = data_temp;
//assign I2S_BCLK = I2S_clk_en?i2s_1m_clk:1'b0;
assign I2S_BCLK = i2s_1m_clk;


endmodule