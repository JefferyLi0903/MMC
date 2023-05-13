// Verilog netlist created by TD v5.0.30786
// Thu Aug  5 11:23:12 2021

`timescale 1ns / 1ps
module FIFO  // FIFO.v(14)
  (
  clk,
  di,
  re,
  rst,
  we,
  afull_flag,
  do,
  empty_flag,
  full_flag
  );

  input clk;  // FIFO.v(24)
  input [7:0] di;  // FIFO.v(23)
  input re;  // FIFO.v(25)
  input rst;  // FIFO.v(22)
  input we;  // FIFO.v(24)
  output afull_flag;  // FIFO.v(29)
  output [7:0] do;  // FIFO.v(27)
  output empty_flag;  // FIFO.v(28)
  output full_flag;  // FIFO.v(29)

  wire empty_flag_neg;
  wire full_flag_neg;

  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  not empty_flag_inv (empty_flag_neg, empty_flag);
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000000000000001100),
    .AEP1(32'b00000000000000000000000000001110),
    .AF(32'b00000000000000000001111111111110),
    .AFM1(32'b00000000000000000001111111111100),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("2"),
    .DATA_WIDTH_B("2"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000000010),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111111110),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"))
    fifo_inst_0_ (
    .clkr(clk),
    .clkw(clk),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia({open_n47,open_n48,open_n49,di[1],open_n50,open_n51,di[0],open_n52,open_n53}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .afull_flag(afull_flag),
    .dob({open_n73,open_n74,open_n75,open_n76,open_n77,open_n78,open_n79,do[1:0]}),
    .empty_flag(empty_flag),
    .full_flag(full_flag));  // FIFO.v(42)
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000000000000001100),
    .AEP1(32'b00000000000000000000000000001110),
    .AF(32'b00000000000000000001111111111110),
    .AFM1(32'b00000000000000000001111111111100),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("2"),
    .DATA_WIDTH_B("2"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000000010),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111111110),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"))
    fifo_inst_1_ (
    .clkr(clk),
    .clkw(clk),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia({open_n80,open_n81,open_n82,di[3],open_n83,open_n84,di[2],open_n85,open_n86}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .dob({open_n107,open_n108,open_n109,open_n110,open_n111,open_n112,open_n113,do[3:2]}));  // FIFO.v(42)
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000000000000001100),
    .AEP1(32'b00000000000000000000000000001110),
    .AF(32'b00000000000000000001111111111110),
    .AFM1(32'b00000000000000000001111111111100),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("2"),
    .DATA_WIDTH_B("2"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000000010),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111111110),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"))
    fifo_inst_2_ (
    .clkr(clk),
    .clkw(clk),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia({open_n116,open_n117,open_n118,di[5],open_n119,open_n120,di[4],open_n121,open_n122}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .dob({open_n143,open_n144,open_n145,open_n146,open_n147,open_n148,open_n149,do[5:4]}));  // FIFO.v(42)
  EG_PHY_FIFO #(
    .AE(32'b00000000000000000000000000001100),
    .AEP1(32'b00000000000000000000000000001110),
    .AF(32'b00000000000000000001111111111110),
    .AFM1(32'b00000000000000000001111111111100),
    .ASYNC_RESET_RELEASE("SYNC"),
    .DATA_WIDTH_A("2"),
    .DATA_WIDTH_B("2"),
    .E(32'b00000000000000000000000000000000),
    .EP1(32'b00000000000000000000000000000010),
    .F(32'b00000000000000000010000000000000),
    .FM1(32'b00000000000000000001111111111110),
    .GSR("DISABLE"),
    .MODE("FIFO8K"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"))
    fifo_inst_3_ (
    .clkr(clk),
    .clkw(clk),
    .csr({2'b11,empty_flag_neg}),
    .csw({2'b11,full_flag_neg}),
    .dia({open_n152,open_n153,open_n154,di[7],open_n155,open_n156,di[6],open_n157,open_n158}),
    .orea(1'b0),
    .oreb(1'b0),
    .re(re),
    .rprst(rst),
    .rst(rst),
    .we(we),
    .dob({open_n179,open_n180,open_n181,open_n182,open_n183,open_n184,open_n185,do[7:6]}));  // FIFO.v(42)
  not full_flag_inv (full_flag_neg, full_flag);

endmodule 

