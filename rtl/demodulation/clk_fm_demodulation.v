
module clk_fm_demo_sample_pwm 
	#( parameter BPS_PARA = 10 )    //200Khz/BPS_PARA = audio samping rate. BPS_PARA=10: 20kHz
	(
	input FM_demod_en,
	input EOC,
	input RSTn,		
	output reg clk_fm_demo_sampling		
);	
 
reg	[5:0] cnt = 0;
always @ (posedge EOC or negedge RSTn) begin
	if(~RSTn) cnt <= 6'b0;
        else if (~FM_demod_en) begin
	    if((cnt >= BPS_PARA-1)||(FM_demod_en)) begin 	
                cnt <= 6'b0;		
                clk_fm_demo_sampling <= 1'b1;		
                end
	    else begin cnt <= cnt + 1'b1;clk_fm_demo_sampling <= 1'b0; end
        end
        else clk_fm_demo_sampling <= 1'b0;
end
 
endmodule