/************************************************************\
 **  Copyright (c) 2011-2021 Anlogic, Inc.
 **  All Right Reserved.
\************************************************************/
/************************************************************\
 ** Log	:	This file is generated by Anlogic IP Generator.
 ** File	:	D:/Documents/MMC/project/al_ip/clkdivider.v
 ** Date	:	2022 04 02
 ** TD version	:	5.0.43066
\************************************************************/

///////////////////////////////////////////////////////////////////////////////
//	Input frequency:             50.000Mhz
//	Clock multiplication factor: 4
//	Clock division factor:       1
//	Clock information:
//		Clock name	| Frequency 	| Phase shift
//		C0        	| 200.000000MHZ	| 0  DEG     
//		C1        	| 16.000000 MHZ	| 0  DEG     
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ns / 100 fs

module clkdivider(refclk,
		reset,
		stdby,
		extlock,
		clk0_out,
		clk1_out);

	input refclk;
	input reset;
	input stdby;
	output extlock;
	output clk0_out;
	output clk1_out;

	wire clk0_buf;

	EG_LOGIC_BUFG bufg_feedback( .i(clk0_buf), .o(clk0_out) );

	EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
		.DYNCFG("DISABLE"),
		.FIN("50.000"),
		.FEEDBK_MODE("NORMAL"),
		.FEEDBK_PATH("CLKC0_EXT"),
		.STDBY_ENABLE("ENABLE"),
		.PLLRST_ENA("ENABLE"),
		.SYNC_ENABLE("DISABLE"),
		.DERIVE_PLL_CLOCKS("DISABLE"),
		.GEN_BASIC_CLOCK("DISABLE"),
		.GMC_GAIN(4),
		.ICP_CURRENT(13),
		.KVCO(4),
		.LPF_CAPACITOR(1),
		.LPF_RESISTOR(4),
		.REFCLK_DIV(1),
		.FBCLK_DIV(4),
		.CLKC0_ENABLE("ENABLE"),
		.CLKC0_DIV(4),
		.CLKC0_CPHASE(3),
		.CLKC0_FPHASE(0),
		.CLKC1_ENABLE("ENABLE"),
		.CLKC1_DIV(50),
		.CLKC1_CPHASE(49),
		.CLKC1_FPHASE(0)	)
	pll_inst (.refclk(refclk),
		.reset(reset),
		.stdby(stdby),
		.extlock(extlock),
		.load_reg(1'b0),
		.psclk(1'b0),
		.psdown(1'b0),
		.psstep(1'b0),
		.psclksel(3'b000),
		.psdone(open),
		.dclk(1'b0),
		.dcs(1'b0),
		.dwe(1'b0),
		.di(8'b00000000),
		.daddr(6'b000000),
		.do({open, open, open, open, open, open, open, open}),
		.fbclk(clk0_out),
		.clkc({open, open, open, clk1_out, clk0_buf}));

endmodule