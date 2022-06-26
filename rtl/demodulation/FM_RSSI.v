
module FM_RSSI_SCAN#(
    parameter FM_ADDR_WIDTH = 13
) 
(
  input [FM_ADDR_WIDTH-1:0] rdaddr,
  input clk,
  input EOC,
  input [2:0] Channel,
  input [3:0] FM_HW_state,
  input RSTn,
  input [11:0] ADC_Data,
  output wire RSSI_interrupt,
  output reg [31:0] rdata
);

localparam FM_HW_STATE_RSSI_DONE = 4'b1000;
localparam FM_HW_STATE_RSSI = 4'b0100;   //RSSI Scan state
localparam RSSI_sample_num = 4096;

reg signed [7:0] IdataN=8'h0;
reg signed [7:0] QdataN=8'h0;

reg EOC_Count_Demodulate=1'b0;


always@(posedge EOC) begin
    if(FM_HW_state == FM_HW_STATE_RSSI) begin //normal FM receiver
        if(Channel==3'b110) begin     //CH6 is the I Path
            IdataN <= (ADC_Data[11:4]-127);     
        end
        if(Channel==3'b100) begin     //CH4 is the Q Path            
            QdataN <= (ADC_Data[11:4]-127);     
        end
    end
end

wire [15:0] IIdataN;
wire [15:0] QQdataN;

lib_mult multlII  (
    .a(IdataN),	    // 8bit
    .b(IdataN),	    // 8bit
    .x(IIdataN)	    // 16bit
    );

lib_mult multlQQ  (
    .a(QdataN),	    // 8bit
    .b(QdataN),	    // 8bit
    .x(QQdataN)	    // 16bit
    );

wire [16:0] RSSI_out = IIdataN + QQdataN;


always@(posedge EOC) begin
    if(FM_HW_state == FM_HW_STATE_RSSI) begin //normal FM receiver
        if(EOC_Count_Demodulate == 1'b0)
            EOC_Count_Demodulate<=1'b1;
        else EOC_Count_Demodulate<=1'b0;
    end
    else if(FM_HW_state == FM_HW_STATE_RSSI_DONE) begin
        EOC_Count_Demodulate<=1'b1;
    end
end 

reg [12:0] counter;
wire done_signal;
assign done_signal = (FM_HW_state == FM_HW_STATE_RSSI) && (counter == (RSSI_sample_num+1));

/*eg [16:0] RSSI_out; 
always@(posedge EOC_Count_Demodulate or negedge RSTn ) begin
    if(~RSTn)
        RSSI_out <= 17'h0;
    else if(FM_HW_state == FM_HW_STATE_RSSI)
        RSSI_out <=(IdataN*IdataN + QdataN*QdataN);
    else if(FM_HW_state == FM_HW_STATE_RSSI_DONE)
        RSSI_out <= 0;
end 
*/

reg [29:0] RSSI_SUM;
always@(posedge EOC_Count_Demodulate or negedge RSTn) begin
    if (~RSTn) begin
        RSSI_SUM <= 0;
        counter <= 0;
    end
    else if (counter < (RSSI_sample_num+1)) begin
        RSSI_SUM <= RSSI_SUM + RSSI_out;
        counter <= counter + 1;
    end
    else if ( FM_HW_state == FM_HW_STATE_RSSI_DONE ) begin
        RSSI_SUM <= 0; 
        counter <= 0;       
    end
end 

reg RSSI_reg_1;
reg RSSI_reg_2;

always@(posedge clk) begin
    if(~RSTn)
    begin
        RSSI_reg_1  <=  0;
        RSSI_reg_2  <=  0;
    end
    else
    begin
        RSSI_reg_1  <= done_signal  ;
        RSSI_reg_2  <= RSSI_reg_1 ;
    end
end
assign RSSI_interrupt = done_signal && (~RSSI_reg_2);


always@(posedge clk ) begin
    if ((rdaddr==15'h14)&&((FM_HW_state==FM_HW_STATE_RSSI))) begin   // read the demodulated data out 
        rdata[31:0]<= {15'b0,RSSI_SUM[26:10]};
    end 
end 

endmodule