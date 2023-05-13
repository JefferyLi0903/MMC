// Verilog netlist created by TD v5.0.30786
// Thu Aug  5 09:52:18 2021

`timescale 1ns / 1ps
module Simple_DualRAM_8_256  // Simple_DualRAM8_256.v(14)
  (
  addra,
  addrb,
  clka,
  clkb,
  dia,
  wea,
  dob
  );

  input [7:0] addra;  // Simple_DualRAM8_256.v(35)
  input [7:0] addrb;  // Simple_DualRAM8_256.v(36)
  input clka;  // Simple_DualRAM8_256.v(38)
  input clkb;  // Simple_DualRAM8_256.v(39)
  input [7:0] dia;  // Simple_DualRAM8_256.v(34)
  input [0:0] wea;  // Simple_DualRAM8_256.v(37)
  output [7:0] dob;  // Simple_DualRAM8_256.v(31)

  parameter ADDR_WIDTH_A = 8;
  parameter ADDR_WIDTH_B = 8;
  parameter DATA_DEPTH_A = 256;
  parameter DATA_DEPTH_B = 256;
  parameter DATA_WIDTH_A = 8;
  parameter DATA_WIDTH_B = 8;
  parameter REGMODE_A = "NOREG";
  parameter REGMODE_B = "NOREG";
  parameter WRITEMODE_A = "NORMAL";
  parameter WRITEMODE_B = "READBEFOREWRITE";

  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  // address_offset=0;data_offset=0;depth=256;width=8;num_section=1;width_per_section=8;section_size=8;working_depth=1024;working_width=9;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("1"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("9"),
    .DATA_WIDTH_B("9"),
    .MODE("DP8K"),
    .OCEAMUX("0"),
    .OCEBMUX("0"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .RSTAMUX("0"),
    .RSTBMUX("0"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("READBEFOREWRITE"))
    inst_256x8_sub_000000_000 (
    .addra({2'b00,addra,3'b111}),
    .addrb({2'b00,addrb,3'b111}),
    .clka(clka),
    .clkb(clkb),
    .dia({open_n55,dia}),
    .wea(wea),
    .dob({open_n79,dob}));

endmodule 

