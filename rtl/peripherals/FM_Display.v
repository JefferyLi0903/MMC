`timescale 1 ns/ 1 ps

module FM_Display#(
    parameter FM_ADDR_WIDTH = 13
)(
   input clk,
   input RSTn,
   input [FM_ADDR_WIDTH-1:0] wraddr,
   input [FM_ADDR_WIDTH-1:0] rdaddr,
   input [31:0] wdata,
   input [3:0] wea,
   input [3:0] FM_HW_state,
   output reg [7:0] seg,
   output reg [3:0] sel
 );



reg [25:0] conter;
reg clk_1Hz;
reg [4:0] channel_NO=4'b0;
reg [3:0] frac_digit=4'b0;
reg [3:0] single_digit=4'b0;
reg [3:0] percentage_digit=4'b0;
reg [3:0] thousand_digit=4'b0;
localparam FM_HW_STATE_RCEV = 4'b0010;

//get the display data
always@(posedge clk or negedge RSTn ) begin
      if (!RSTn) begin    
           channel_NO<=4'b0;
           frac_digit<=4'b0;
           single_digit<=4'b0;
           percentage_digit<=4'b0;
           thousand_digit<=4'b0;
      end
      else if((wraddr==15'h008)&&(wea==4'hf))  begin    
           channel_NO<=wdata[4:0];
           frac_digit<=wdata[8:5];
           single_digit<=wdata[12:9];
           percentage_digit<=wdata[16:13];
           thousand_digit<=wdata[20:17];
      end 
end

//generate a 1HZ clk
always@(posedge clk or negedge RSTn ) begin
      if (!RSTn) begin    
          conter <=26'b0;  
          clk_1Hz  <=1'b0;  
          end
      else if (conter==26'h2faf080) begin
//      else if(conter==26'h3f) begin
            clk_1Hz <=1'b1; 
            conter <=26'b0;
           end
      else if(conter < 26'h2faf080) begin 
//      else if(conter < 26'h3f) begin 
           conter <=conter+1'b1;
           clk_1Hz <= 1'b0; 
      end
end

reg [15:0] counter_1Khz;
reg clk_1KHz;
//generate a 1KHZ clk
always@(posedge clk or negedge RSTn ) begin
      if (!RSTn) begin    
          counter_1Khz <=16'b0;  
          clk_1KHz  <=1'b0;  
          end
      else if (counter_1Khz==16'hc350) begin
//      else if(counter_1Khz==16'h0f) begin
            clk_1KHz <=1'b1; 
            counter_1Khz <=16'b0;
           end
      else if(counter_1Khz < 16'hc350) begin 
//      else if(counter_1Khz < 16'h0f) begin 
           counter_1Khz <=counter_1Khz+1'b1;
           clk_1KHz <= 1'b0; 
      end
end



reg ChannelNO_or_FREQ;

always@(posedge clk_1Hz or negedge RSTn ) begin
  if (!RSTn) ChannelNO_or_FREQ <= 1'b0;
      else if (ChannelNO_or_FREQ == 1'b1)
           ChannelNO_or_FREQ <= 1'b0;
           else 
           ChannelNO_or_FREQ <= 3'b1;
end

reg ctrl_channel_NO = 1'b0;
reg [1:0] ctrl_freq = 2'b0;

always@(posedge clk_1KHz) begin
    if ((ChannelNO_or_FREQ==1'b0)&&(FM_HW_state==FM_HW_STATE_RCEV)) begin  // display channel no
           if (channel_NO>=5'ha) begin
                   if(ctrl_channel_NO==1'b0)begin
                       sel <= 4'b1011;
                     case(channel_NO)                       
                        /*
                         5'h0 : seg <= 8'h3f; 
                         5'h1 : seg <= 8'h06; 
                         5'h2 : seg <= 8'h5b; 
                         5'h3 : seg <= 8'h4f; 
                         5'h4 : seg <= 8'h66; 
                         5'h5 : seg <= 8'h6d; 
                         5'h6 : seg <= 8'h7d; 
                         5'h7 : seg <= 8'h07; 
                         5'h8 : seg <= 8'h7f; 
                         5'h9 : seg <= 8'h6f; 
                         */
                         5'ha : seg <= 8'h3f;
                         5'hb : seg <= 8'h06;
                         5'hc : seg <= 8'h5b;
                         5'hd : seg <= 8'h4f;
                         5'he : seg <= 8'h66;
                         5'hf : seg <= 8'h6d;
                         5'h10 : seg <= 8'h7d; 
                         5'h11 : seg <= 8'h07; 
                         5'h12 : seg <= 8'h7f; 
                         5'h13 : seg <= 8'h6f; 

                         5'h14 : seg <= 8'h3f;
                         5'h15 : seg <= 8'h06;
                         5'h16 : seg <= 8'h5b;
                         5'h17 : seg <= 8'h4f;
                         5'h18 : seg <= 8'h66;
                         5'h19 : seg <= 8'h6d;
                       endcase
                           ctrl_channel_NO<=ctrl_channel_NO+1'b1;
                     end  
                    else begin
                           sel <= 4'b0111;

                      case(channel_NO)
                          /*
                         5'h0 : seg <= 8'h3f; 
                         5'h1 : seg <= 8'h06; 
                         5'h2 : seg <= 8'h5b; 
                         5'h3 : seg <= 8'h4f; 
                         5'h4 : seg <= 8'h66; 
                         5'h5 : seg <= 8'h6d; 
                         5'h6 : seg <= 8'h7d; 
                         5'h7 : seg <= 8'h07; 
                         5'h8 : seg <= 8'h7f; 
                         5'h9 : seg <= 8'h6f; 
                          */
                         5'ha : seg <= 8'h06;
                         5'hb : seg <= 8'h06;
                         5'hc : seg <= 8'h06;
                         5'hd : seg <= 8'h06;
                         5'he : seg <= 8'h06;
                         5'hf : seg <= 8'h06;
                         5'h10 : seg <= 8'h06; 
                         5'h11 : seg <= 8'h06; 
                         5'h12 : seg <= 8'h06; 
                         5'h13 : seg <= 8'h06; 

                         5'h14 : seg <= 8'h5b;
                         5'h15 : seg <= 8'h5b;
                         5'h16 : seg <= 8'h5b;
                         5'h17 : seg <= 8'h5b;
                         5'h18 : seg <= 8'h5b;
                         5'h19 : seg <= 8'h5b;
                        endcase
                        ctrl_channel_NO<=ctrl_channel_NO+1'b1;                          
                    end  
              end
           else begin
                     sel <= 4'b1011;
                     case(channel_NO) 
                         5'h0 : seg <= 8'h3f; 
                         5'h1 : seg <= 8'h06; 
                         5'h2 : seg <= 8'h5b; 
                         5'h3 : seg <= 8'h4f; 
                         5'h4 : seg <= 8'h66; 
                         5'h5 : seg <= 8'h6d; 
                         5'h6 : seg <= 8'h7d; 
                         5'h7 : seg <= 8'h07; 
                         5'h8 : seg <= 8'h7f; 
                         5'h9 : seg <= 8'h6f; 
                         /*
                         5'ha : seg <= 8'h3f;
                         5'hb : seg <= 8'h06;
                         5'hc : seg <= 8'h5b;
                         5'hd : seg <= 8'h4f;
                         5'he : seg <= 8'h66;
                         5'hf : seg <= 8'h6d;
                         5'h10 : seg <= 8'h7d; 
                         5'h11 : seg <= 8'h07; 
                         5'h12 : seg <= 8'h7f; 
                         5'h13 : seg <= 8'h6f; 

                         5'h14 : seg <= 8'h3f;
                         5'h15 : seg <= 8'h06;
                         5'h16 : seg <= 8'h5b;
                         5'h17 : seg <= 8'h4f;
                         5'h18 : seg <= 8'h66;
                         5'h19 : seg <= 8'h6d;                         
                         */
                      endcase
                      ctrl_channel_NO<=ctrl_channel_NO+1'b1;
                end
        end
    else if ((ChannelNO_or_FREQ==1'b1)&&(FM_HW_state==FM_HW_STATE_RCEV))  begin // display freq
           if(ctrl_freq==2'b00) begin  //display frac digital number
                      sel <= 4'b1110;
                      case(frac_digit)
                         4'h0 : seg <= 8'h3f; 
                         4'h1 : seg <= 8'h06; 
                         4'h2 : seg <= 8'h5b; 
                         4'h3 : seg <= 8'h4f; 
                         4'h4 : seg <= 8'h66; 
                         4'h5 : seg <= 8'h6d; 
                         4'h6 : seg <= 8'h7d; 
                         4'h7 : seg <= 8'h07; 
                         4'h8 : seg <= 8'h7f; 
                         4'h9 : seg <= 8'h6f; 
                       endcase
                      ctrl_freq<=ctrl_freq+1'b1;               
           end
           else if(ctrl_freq==2'b01) begin  //dispplay single digital number
               sel <= 4'b1101;
                      case(single_digit)
                         4'h0 : seg <= (8'h3f+8'h80); 
                         4'h1 : seg <= (8'h06+8'h80); 
                         4'h2 : seg <= (8'h5b+8'h80); 
                         4'h3 : seg <= (8'h4f+8'h80); 
                         4'h4 : seg <= (8'h66+8'h80); 
                         4'h5 : seg <= (8'h6d+8'h80); 
                         4'h6 : seg <= (8'h7d+8'h80); 
                         4'h7 : seg <= (8'h07+8'h80); 
                         4'h8 : seg <= (8'h7f+8'h80); 
                         4'h9 : seg <= (8'h6f+8'h80); 
                       endcase
                    ctrl_freq<=ctrl_freq+1'b1;               
           end
           else if(ctrl_freq==2'b10) begin  //dispplay percentage digital number
               sel <= 4'b1011;           
                       case(percentage_digit)
                         4'h0 : seg <= 8'h3f; 
                         4'h1 : seg <= 8'h06; 
                         4'h2 : seg <= 8'h5b; 
                         4'h3 : seg <= 8'h4f; 
                         4'h4 : seg <= 8'h66; 
                         4'h5 : seg <= 8'h6d; 
                         4'h6 : seg <= 8'h7d; 
                         4'h7 : seg <= 8'h07; 
                         4'h8 : seg <= 8'h7f; 
                         4'h9 : seg <= 8'h6f; 
                       endcase
               ctrl_freq<=ctrl_freq+1'b1;               
           end
           else if(ctrl_freq==2'b11) begin  //dispplay thousanddigital number
               if(thousand_digit>4'b0) begin
                  sel <= 4'b0111;
                      case(thousand_digit)
                         4'h0 : seg <= 8'h3f; 
                         4'h1 : seg <= 8'h06; 
                         4'h2 : seg <= 8'h5b; 
                         4'h3 : seg <= 8'h4f; 
                         4'h4 : seg <= 8'h66; 
                         4'h5 : seg <= 8'h6d; 
                         4'h6 : seg <= 8'h7d; 
                         4'h7 : seg <= 8'h07; 
                         4'h8 : seg <= 8'h7f; 
                         4'h9 : seg <= 8'h6f; 
                       endcase
               end
               ctrl_freq<=ctrl_freq+1'b1;               
           end
      end
end

endmodule
