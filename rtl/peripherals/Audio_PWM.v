
module Audio_PWM 
(
	input clk_fm_demo_sampling,
	input clk,
	input RSTn,		
    input demod_en,
    //input wire [9:0] demodulated_signal_downsample,	    
    input wire [13:0] demodulated_signal_downsample,	
	output wire audio_pwm    
);	


//pwm generation simulate the DAC using 10bit range
reg	[15:0] cnt = 0;
reg audio_pwm_reg;

reg N_1=1'b0;
reg N=1'b0;

always @ (posedge clk or negedge RSTn) begin
	if(~RSTn) cnt <= 10'b0;
        else begin
            N_1<=N;
            N<=clk_fm_demo_sampling;
            if(N>N_1)
               cnt <= 10'b0;
            else 
               cnt <= cnt + 1'b1;
        end
end

always @ (posedge clk or negedge RSTn) begin
	if(~RSTn) audio_pwm_reg <= 1'b0;
    else if(cnt >= (demodulated_signal_downsample)) audio_pwm_reg <= 1'b1;
	else audio_pwm_reg <= 1'b0;	
end

assign audio_pwm = (~demod_en)?audio_pwm_reg:1'b0;

 
endmodule