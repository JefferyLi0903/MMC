// Verilog testbench created by TD v5.0.43066
// 2022-06-25 11:13:09

`timescale 1ns / 1ps

module CortexM0_SoC_tb();

reg RSTn;
reg RXD;
reg SWCLK;
reg clk;
wire [7:0] LED;
wire MSI_CS;
wire MSI_REFCLK;
reg MSI_SCLK;
wire MSI_SDATA;
wire TXD;
wire audio_pwm;
wire [7:0] seg;
wire [3:0] sel;
wire SWDIO;

//Clock process
parameter PERIOD = 10;
always #(PERIOD/2) MSI_SCLK = ~MSI_SCLK;

//glbl Instantiate
glbl glbl();

//Unit Instantiate
CortexM0_SoC uut(
	.RSTn(RSTn),
	.RXD(RXD),
	.SWCLK(SWCLK),
	.clk(clk),
	.LED(LED),
	.MSI_CS(MSI_CS),
	.MSI_REFCLK(MSI_REFCLK),
	.MSI_SCLK(MSI_SCLK),
	.MSI_SDATA(MSI_SDATA),
	.TXD(TXD),
	.audio_pwm(audio_pwm),
	.seg(seg),
	.sel(sel),
	.SWDIO(SWDIO));

//Stimulus process
initial begin
	clk = 0;
	RSTn=0;
	#100
	RSTn=1;
end

endmodule