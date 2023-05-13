// Verilog netlist created by TD v5.0.30786
// Thu Aug  5 09:44:57 2021

`timescale 1ns / 1ps
module Simple_DualRAM  // Simple_DualRAM.v(14)
  (
  addra,
  addrb,
  clka,
  clkb,
  dia,
  wea,
  dob
  );

  input [10:0] addra;  // Simple_DualRAM.v(35)
  input [10:0] addrb;  // Simple_DualRAM.v(36)
  input clka;  // Simple_DualRAM.v(38)
  input clkb;  // Simple_DualRAM.v(39)
  input [7:0] dia;  // Simple_DualRAM.v(34)
  input [0:0] wea;  // Simple_DualRAM.v(37)
  output [7:0] dob;  // Simple_DualRAM.v(31)

  parameter ADDR_WIDTH_A = 11;
  parameter ADDR_WIDTH_B = 11;
  parameter DATA_DEPTH_A = 2048;
  parameter DATA_DEPTH_B = 2048;
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
  // address_offset=0;data_offset=0;depth=2048;width=4;num_section=1;width_per_section=4;section_size=8;working_depth=2048;working_width=4;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("1"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("4"),
    .DATA_WIDTH_B("4"),
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
    inst_2048x8_sub_000000_000 (
    .addra({addra,2'b11}),
    .addrb({addrb,2'b11}),
    .clka(clka),
    .clkb(clkb),
    .dia({open_n55,open_n56,open_n57,open_n58,open_n59,dia[3:0]}),
    .wea(wea),
    .dob({open_n83,open_n84,open_n85,open_n86,open_n87,dob[3:0]}));
  // address_offset=0;data_offset=4;depth=2048;width=4;num_section=1;width_per_section=4;section_size=8;working_depth=2048;working_width=4;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM #(
    .CEAMUX("1"),
    .CEBMUX("1"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("1"),
    .DATA_WIDTH_A("4"),
    .DATA_WIDTH_B("4"),
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
    inst_2048x8_sub_000000_004 (
    .addra({addra,2'b11}),
    .addrb({addrb,2'b11}),
    .clka(clka),
    .clkb(clkb),
    .dia({open_n96,open_n97,open_n98,open_n99,open_n100,dia[7:4]}),
    .wea(wea),
    .dob({open_n124,open_n125,open_n126,open_n127,open_n128,dob[7:4]}));

endmodule 

