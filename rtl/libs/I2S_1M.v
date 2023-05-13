
module I2S_1M 
	#( parameter BPS_PARA = 50 )    //input clk = 50M,divid by 50 get the 1M clk
	(
	input clk,     //50M
	input RSTn,		
	output reg i2s_1m_clk		
);	
 
reg	[5:0] cnt = 0;
always @ (posedge clk or negedge RSTn) begin
	if(~RSTn) cnt <= 6'b0;
	else if((cnt >= BPS_PARA-1)) begin 	
                cnt <= 6'b0;		
                i2s_1m_clk <= 1'b1;		
                end
	else begin cnt <= cnt + 1'b1; i2s_1m_clk <= 1'b0; end
end
 
endmodule