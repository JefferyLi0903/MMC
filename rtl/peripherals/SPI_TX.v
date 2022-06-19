module SPI_TX(
    input clk,
    input CW_CLK_MSI,
    input RSTn,
    input [23:0] data,
    input SPI_tx_en,
    output MSI_SDATA,    //! port 30, connected to pin N9
    output wire MSI_SCLK,    //! port 29, connected to pin M9
    output reg MSI_CS       //! port 31, connected to pin P9
);    


//FIFO 24bit-24depth
wire FIFOrd_en;
wire FIFOwr_en;
wire [24:0] FIFOdata;
wire FIFOempty;
wire FIFOfull;
wire [24:0] data_add_onebit;

assign data_add_onebit = {data[23],data};

FIFO_SPI FIFO_SPI( 
    .clock(clk),
    .sclr(RSTn),
    .rdreq(FIFOrd_en),
    .wrreq(FIFOwr_en),
    .full(FIFOfull),
    .empty(FIFOempty),
    .data(data_add_onebit),
    .q(FIFOdata)
);

//FIFO write control
assign FIFOwr_en = (~FIFOfull) & SPI_tx_en;

//SPI TX 
reg count_en;
//according to MSI001 datasheet, 1 SPI Word will transmit 24bit, 
//interword delay need 300ns. now we use 50M clk which the interword delay need 15000 clk. 
//so the counter will be 15024, we need 14bit to store the counter
reg [13:0] counter;     

wire trans_finish;

assign trans_finish = (counter == 14'd15024); //14'd15024

wire trans_start;
assign trans_start = (~FIFOempty) & (~count_en);


always@(posedge clk or negedge RSTn) begin
    if(~RSTn) count_en <= 1'b0;
    else if(trans_start) count_en <= 1'b1;
    else if(trans_finish) begin count_en <= 1'b0; end    
end
     
always@(posedge clk or negedge RSTn) begin  
  if(~RSTn) counter <= 14'h0;
  else if(counter == 14'd15024)  counter <= 14'h0; //14'd15025    
  else if(count_en) counter <= counter + 1'b1;
end  



reg data_temp;
reg MSI_clk_en;
wire [24:0] read_fifo;
assign read_fifo = FIFOdata;

always@(posedge clk  or negedge RSTn) begin
   if(~RSTn) begin
        MSI_CS <= 1'b1;      
        MSI_clk_en<=1'b0;        
        data_temp<=25'h0;
        end
   else if(count_en) begin      
                case(counter) 	     	       
                    14'd0:  begin MSI_CS <= 1'b0; data_temp <= read_fifo[24]; MSI_clk_en<=1'b0; end                                        
                    14'd1:  begin data_temp <= read_fifo[23]; MSI_clk_en<=1'b1;end
                    14'd2:  data_temp <= read_fifo[22]; 
                    14'd3:  data_temp <= read_fifo[21]; 
                    14'd4:  data_temp <= read_fifo[20];
                    14'd5:  data_temp <= read_fifo[19];
                    14'd6:  data_temp <= read_fifo[18];
                    14'd7:  data_temp <= read_fifo[17];
                    14'd8:  data_temp <= read_fifo[16];
                    14'd9:  data_temp <= read_fifo[15];
                    14'd10: data_temp <= read_fifo[14];
                    14'd11: data_temp <= read_fifo[13];
                    14'd12: data_temp <= read_fifo[12];
                    14'd13: data_temp <= read_fifo[11];
                    14'd14: data_temp <= read_fifo[10];
                    14'd15: data_temp <= read_fifo[9];
                    14'd16: data_temp <= read_fifo[8];
                    14'd17: data_temp <= read_fifo[7];
                    14'd18: data_temp <= read_fifo[6];
                    14'd19: data_temp <= read_fifo[5];
                    14'd20: data_temp <= read_fifo[4];
                    14'd21: data_temp <= read_fifo[3];
                    14'd22: data_temp <= read_fifo[2];
                    14'd23: data_temp <= read_fifo[1];                     
                    14'd24: data_temp <= read_fifo[0];                         
                    14'd25: MSI_clk_en<=1'b0;          
                    default: begin MSI_CS <= 1'b1; end                    
               endcase
end	               
end 


assign MSI_SDATA = data_temp;
assign MSI_SCLK = MSI_clk_en?~clk:1'b0;

//FIFO read control
assign FIFOrd_en = (~FIFOempty) & trans_finish;


endmodule