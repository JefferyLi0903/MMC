// Verilog netlist created by TD v5.0.30786
// Thu Aug  5 11:12:59 2021

`timescale 1ns / 1ps
module RAMFIFO  // RAMFIFO.v(14)
  (
  clkr,
  clkw,
  di,
  re,
  rst,
  we,
  do,
  empty_flag,
  full_flag,
  rdusedw,
  wrusedw
  );

  input clkr;  // RAMFIFO.v(25)
  input clkw;  // RAMFIFO.v(24)
  input [31:0] di;  // RAMFIFO.v(23)
  input re;  // RAMFIFO.v(25)
  input rst;  // RAMFIFO.v(22)
  input we;  // RAMFIFO.v(24)
  output [31:0] do;  // RAMFIFO.v(27)
  output empty_flag;  // RAMFIFO.v(28)
  output full_flag;  // RAMFIFO.v(29)
  output [4:0] rdusedw;  // RAMFIFO.v(30)
  output [4:0] wrusedw;  // RAMFIFO.v(31)

  wire and_and__al_n1_q0_al_o;
  wire and_and__al_n1_q0_ne_o;
  wire and_and_and__al_n1_q_o;
  wire and_and_and__al_n1_q_o_al_n20;
  wire and_and_and_and__al__o;
  wire and_and_and_and__al__o_al_n21;
  wire and_or_q5_al_n19_q4__o;
  wire and_or_q5_q4_o_and_a_o;
  wire and_q1_al_n15_and__a_o;
  wire and_q1_and__al_n1_q0_o;
  wire and_q2_al_n16_and_an_o;
  wire and_q2_and_and__al_n_o;
  wire and_q3_al_n17_and_an_o;
  wire and_q3_and_and_and___o;
  wire and_re_empty_equal_o_o;
  wire and_we_full_equal_o__o;
  wire delayed_wrptr_g0;
  wire delayed_wrptr_g1;
  wire delayed_wrptr_g2;
  wire delayed_wrptr_g3;
  wire delayed_wrptr_g4;
  wire \empty_equal/or_or_xor_i0[0]_i1[0_o ;
  wire \empty_equal/or_xor_i0[0]_i1[0]_o_o ;
  wire \empty_equal/or_xor_i0[2]_i1[2]_o_o ;
  wire \empty_equal/or_xor_i0[3]_i1[3]_o_o ;
  wire \empty_equal/xor_i0[0]_i1[0]_o ;
  wire \empty_equal/xor_i0[1]_i1[1]_o ;
  wire \empty_equal/xor_i0[2]_i1[2]_o ;
  wire \empty_equal/xor_i0[3]_i1[3]_o ;
  wire \empty_equal/xor_i0[4]_i1[4]_o ;
  wire empty_equal_o_neg;
  wire \full_equal/or_or_xor_i0[0]_i1[0_o ;
  wire \full_equal/or_xor_i0[0]_i1[0]_o_o ;
  wire \full_equal/or_xor_i0[2]_i1[2]_o_o ;
  wire \full_equal/or_xor_i0[3]_i1[3]_o_o ;
  wire \full_equal/xor_i0[0]_i1[0]_o ;
  wire \full_equal/xor_i0[1]_i1[1]_o ;
  wire \full_equal/xor_i0[2]_i1[2]_o ;
  wire \full_equal/xor_i0[3]_i1[3]_o ;
  wire \full_equal/xor_i0[4]_i1[4]_o ;
  wire full_equal_o_neg;
  wire gray_counter_mux_o0;
  wire gray_counter_mux_o0_al_n23;
  wire gray_counter_mux_o1;
  wire gray_counter_mux_o1_al_n24;
  wire gray_counter_mux_o2;
  wire gray_counter_mux_o2_al_n25;
  wire gray_counter_mux_o3;
  wire gray_counter_mux_o3_al_n26;
  wire gray_counter_mux_o4;
  wire gray_counter_mux_o4_al_n27;
  wire gray_counter_mux_o5;
  wire gray_counter_mux_o5_al_n28;
  wire mux_o0;
  wire mux_o0_al_n29;
  wire mux_o1;
  wire mux_o1_al_n30;
  wire mux_o2;
  wire mux_o2_al_n31;
  wire mux_o3;
  wire mux_o3_al_n32;
  wire mux_o4;
  wire mux_o4_al_n33;
  wire or_q5_al_n19_q4_al_n_o;
  wire or_q5_q4_o;
  wire q0;
  wire q0_al_n14;
  wire q0_al_n14_neg;
  wire q0_neg;
  wire q1;
  wire q1_al_n15;
  wire q1_al_n15_neg;
  wire q1_neg;
  wire q2;
  wire q2_al_n16;
  wire q2_al_n16_neg;
  wire q2_neg;
  wire q3;
  wire q3_al_n17;
  wire q3_al_n17_neg;
  wire q3_neg;
  wire q4;
  wire q4_al_n18;
  wire q5;
  wire q5_al_n19;
  wire rdptr_g0;
  wire rdptr_g1;
  wire rdptr_g2;
  wire rdptr_g3;
  wire rdptr_g4;
  wire rdptr_g_bin_d10;
  wire rdptr_g_bin_d11;
  wire rdptr_g_bin_d12;
  wire rdptr_g_bin_d13;
  wire rdptr_g_bin_d14;
  wire \rdusedw_sub/c0 ;
  wire \rdusedw_sub/c1 ;
  wire \rdusedw_sub/c2 ;
  wire \rdusedw_sub/c3 ;
  wire \rdusedw_sub/c4 ;
  wire sync_delayed_wrptr_g0;
  wire sync_delayed_wrptr_g1;
  wire sync_delayed_wrptr_g2;
  wire sync_delayed_wrptr_g3;
  wire sync_delayed_wrptr_g4;
  wire sync_delayed_wrptr_g_bin_d10;
  wire sync_delayed_wrptr_g_bin_d11;
  wire sync_delayed_wrptr_g_bin_d12;
  wire sync_delayed_wrptr_g_bin_d13;
  wire sync_delayed_wrptr_g_bin_d14;
  wire sync_rdptr_g0;
  wire sync_rdptr_g1;
  wire sync_rdptr_g2;
  wire sync_rdptr_g3;
  wire sync_rdptr_g3_neg;
  wire sync_rdptr_g4;
  wire sync_rdptr_g4_neg;
  wire sync_rdptr_g_bin_d10;
  wire sync_rdptr_g_bin_d11;
  wire sync_rdptr_g_bin_d12;
  wire sync_rdptr_g_bin_d13;
  wire sync_rdptr_g_bin_d14;
  wire wrptr_g0;
  wire wrptr_g1;
  wire wrptr_g2;
  wire wrptr_g3;
  wire wrptr_g4;
  wire wrptr_g_bin_d10;
  wire wrptr_g_bin_d11;
  wire wrptr_g_bin_d12;
  wire wrptr_g_bin_d13;
  wire \wrusedw_sub/c0 ;
  wire \wrusedw_sub/c1 ;
  wire \wrusedw_sub/c2 ;
  wire \wrusedw_sub/c3 ;
  wire \wrusedw_sub/c4 ;
  wire xor_q1_al_n15_and_q0_o;
  wire xor_q1_and_q0__al_n1_o;
  wire xor_q2_al_n16_and_q1_o;
  wire xor_q2_and_q1_and__a_o;
  wire xor_q3_al_n17_and_q2_o;
  wire xor_q3_and_q2_and_an_o;
  wire xor_q4_al_n18_and_q3_o;
  wire xor_q4_and_q3_and_an_o;
  wire xor_q5_al_n19_and_or_o;
  wire xor_q5_and_or_q5_q4__o;
  wire xor_rdptr_g4_rdptr_g_o;
  wire xor_sync_delayed_wrp_o;
  wire xor_sync_rdptr_g4_sy_o;
  wire xor_wrptr_g4_wrptr_g_o;
  wire xor_xor_rdptr_g4_rdp_o;
  wire xor_xor_sync_delayed_o;
  wire xor_xor_sync_rdptr_g_o;
  wire xor_xor_wrptr_g4_wrp_o;
  wire xor_xor_xor_rdptr_g4_o;
  wire xor_xor_xor_sync_del_o;
  wire xor_xor_xor_sync_rdp_o;
  wire xor_xor_xor_wrptr_g4_o;
  wire xor_xor_xor_xor_rdpt_o;
  wire xor_xor_xor_xor_sync_o;
  wire xor_xor_xor_xor_sync_o_al_n56;
  wire xor_xor_xor_xor_wrpt_o;

  and and_and__al_n1_q0_al (and_and__al_n1_q0_al_o, q0_al_n14_neg, q1_al_n15_neg);
  and and_and__al_n1_q0_ne (and_and__al_n1_q0_ne_o, q0_neg, q1_neg);
  and and_and_and__al_n1_q (and_and_and__al_n1_q_o, and_and__al_n1_q0_ne_o, q2_neg);
  and and_and_and__al_n1_q_al_u14 (and_and_and__al_n1_q_o_al_n20, and_and__al_n1_q0_al_o, q2_al_n16_neg);
  and and_and_and_and__al_ (and_and_and_and__al__o, and_and_and__al_n1_q_o, q3_neg);
  and and_and_and_and__al__al_u15 (and_and_and_and__al__o_al_n21, and_and_and__al_n1_q_o_al_n20, q3_al_n17_neg);
  and and_or_q5_al_n19_q4_ (and_or_q5_al_n19_q4__o, or_q5_al_n19_q4_al_n_o, and_and_and_and__al__o_al_n21);
  and and_or_q5_q4_o_and_a (and_or_q5_q4_o_and_a_o, or_q5_q4_o, and_and_and_and__al__o);
  and and_q1_al_n15_and__a (and_q1_al_n15_and__a_o, q1_al_n15, q0_al_n14_neg);
  and and_q1_and__al_n1_q0 (and_q1_and__al_n1_q0_o, q1, q0_neg);
  and and_q2_al_n16_and_an (and_q2_al_n16_and_an_o, q2_al_n16, and_and__al_n1_q0_al_o);
  and and_q2_and_and__al_n (and_q2_and_and__al_n_o, q2, and_and__al_n1_q0_ne_o);
  and and_q3_al_n17_and_an (and_q3_al_n17_and_an_o, q3_al_n17, and_and_and__al_n1_q_o_al_n20);
  and and_q3_and_and_and__ (and_q3_and_and_and___o, q3, and_and_and__al_n1_q_o);
  and and_re_empty_equal_o (and_re_empty_equal_o_o, re, empty_equal_o_neg);
  and and_we_full_equal_o_ (and_we_full_equal_o__o, we, full_equal_o_neg);
  EG_PHY_CONFIG #(
    .DONE_PERSISTN("ENABLE"),
    .INIT_PERSISTN("ENABLE"),
    .JTAG_PERSISTN("DISABLE"),
    .PROGRAMN_PERSISTN("DISABLE"))
    config_inst ();
  not \empty_equal/none_diff  (empty_flag, \empty_equal/or_or_xor_i0[0]_i1[0_o );
  or \empty_equal/or_or_xor_i0[0]_i1[0  (\empty_equal/or_or_xor_i0[0]_i1[0_o , \empty_equal/or_xor_i0[0]_i1[0]_o_o , \empty_equal/or_xor_i0[2]_i1[2]_o_o );
  or \empty_equal/or_xor_i0[0]_i1[0]_o  (\empty_equal/or_xor_i0[0]_i1[0]_o_o , \empty_equal/xor_i0[0]_i1[0]_o , \empty_equal/xor_i0[1]_i1[1]_o );
  or \empty_equal/or_xor_i0[2]_i1[2]_o  (\empty_equal/or_xor_i0[2]_i1[2]_o_o , \empty_equal/xor_i0[2]_i1[2]_o , \empty_equal/or_xor_i0[3]_i1[3]_o_o );
  or \empty_equal/or_xor_i0[3]_i1[3]_o  (\empty_equal/or_xor_i0[3]_i1[3]_o_o , \empty_equal/xor_i0[3]_i1[3]_o , \empty_equal/xor_i0[4]_i1[4]_o );
  xor \empty_equal/xor_i0[0]_i1[0]  (\empty_equal/xor_i0[0]_i1[0]_o , sync_delayed_wrptr_g0, rdptr_g0);
  xor \empty_equal/xor_i0[1]_i1[1]  (\empty_equal/xor_i0[1]_i1[1]_o , sync_delayed_wrptr_g1, rdptr_g1);
  xor \empty_equal/xor_i0[2]_i1[2]  (\empty_equal/xor_i0[2]_i1[2]_o , sync_delayed_wrptr_g2, rdptr_g2);
  xor \empty_equal/xor_i0[3]_i1[3]  (\empty_equal/xor_i0[3]_i1[3]_o , sync_delayed_wrptr_g3, rdptr_g3);
  xor \empty_equal/xor_i0[4]_i1[4]  (\empty_equal/xor_i0[4]_i1[4]_o , sync_delayed_wrptr_g4, rdptr_g4);
  not empty_equal_o_inv (empty_equal_o_neg, empty_flag);
  // address_offset=0;data_offset=0;depth=16;width=18;num_section=1;width_per_section=18;section_size=32;working_depth=512;working_width=18;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM #(
    .CEBMUX("1"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("SIG"),
    .DATA_WIDTH_A("18"),
    .DATA_WIDTH_B("18"),
    .MODE("PDPW8K"),
    .OCEAMUX("1"),
    .OCEBMUX("1"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WEAMUX("1"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    fifo_bram_16x32_sub_000000_000 (
    .addra({5'b00000,xor_wrptr_g4_wrptr_g_o,wrptr_g2,wrptr_g1,wrptr_g0,4'b1111}),
    .addrb({5'b00000,xor_rdptr_g4_rdptr_g_o,rdptr_g2,rdptr_g1,rdptr_g0,4'b1111}),
    .cea(and_we_full_equal_o__o),
    .clka(clkw),
    .clkb(clkr),
    .csb({and_re_empty_equal_o_o,open_n51,open_n52}),
    .dia(di[8:0]),
    .dib(di[17:9]),
    .rsta(rst),
    .rstb(rst),
    .doa(do[8:0]),
    .dob(do[17:9]));
  // address_offset=0;data_offset=18;depth=16;width=14;num_section=1;width_per_section=14;section_size=32;working_depth=512;working_width=18;mode_ecc=0;address_step=1;bytes_in_per_section=1;
  EG_PHY_BRAM #(
    .CEBMUX("1"),
    .CSA0("1"),
    .CSA1("1"),
    .CSA2("1"),
    .CSB0("1"),
    .CSB1("1"),
    .CSB2("SIG"),
    .DATA_WIDTH_A("18"),
    .DATA_WIDTH_B("18"),
    .MODE("PDPW8K"),
    .OCEAMUX("1"),
    .OCEBMUX("1"),
    .REGMODE_A("NOREG"),
    .REGMODE_B("NOREG"),
    .RESETMODE("SYNC"),
    .WEAMUX("1"),
    .WEBMUX("0"),
    .WRITEMODE_A("NORMAL"),
    .WRITEMODE_B("NORMAL"))
    fifo_bram_16x32_sub_000000_018 (
    .addra({5'b00000,xor_wrptr_g4_wrptr_g_o,wrptr_g2,wrptr_g1,wrptr_g0,4'b1111}),
    .addrb({5'b00000,xor_rdptr_g4_rdptr_g_o,rdptr_g2,rdptr_g1,rdptr_g0,4'b1111}),
    .cea(and_we_full_equal_o__o),
    .clka(clkw),
    .clkb(clkr),
    .csb({and_re_empty_equal_o_o,open_n61,open_n62}),
    .dia(di[26:18]),
    .dib({open_n63,open_n64,open_n65,open_n66,di[31:27]}),
    .rsta(rst),
    .rstb(rst),
    .doa(do[26:18]),
    .dob({open_n71,open_n72,open_n73,open_n74,do[31:27]}));
  not \full_equal/none_diff  (full_flag, \full_equal/or_or_xor_i0[0]_i1[0_o );
  or \full_equal/or_or_xor_i0[0]_i1[0  (\full_equal/or_or_xor_i0[0]_i1[0_o , \full_equal/or_xor_i0[0]_i1[0]_o_o , \full_equal/or_xor_i0[2]_i1[2]_o_o );
  or \full_equal/or_xor_i0[0]_i1[0]_o  (\full_equal/or_xor_i0[0]_i1[0]_o_o , \full_equal/xor_i0[0]_i1[0]_o , \full_equal/xor_i0[1]_i1[1]_o );
  or \full_equal/or_xor_i0[2]_i1[2]_o  (\full_equal/or_xor_i0[2]_i1[2]_o_o , \full_equal/xor_i0[2]_i1[2]_o , \full_equal/or_xor_i0[3]_i1[3]_o_o );
  or \full_equal/or_xor_i0[3]_i1[3]_o  (\full_equal/or_xor_i0[3]_i1[3]_o_o , \full_equal/xor_i0[3]_i1[3]_o , \full_equal/xor_i0[4]_i1[4]_o );
  xor \full_equal/xor_i0[0]_i1[0]  (\full_equal/xor_i0[0]_i1[0]_o , wrptr_g0, sync_rdptr_g0);
  xor \full_equal/xor_i0[1]_i1[1]  (\full_equal/xor_i0[1]_i1[1]_o , wrptr_g1, sync_rdptr_g1);
  xor \full_equal/xor_i0[2]_i1[2]  (\full_equal/xor_i0[2]_i1[2]_o , wrptr_g2, sync_rdptr_g2);
  xor \full_equal/xor_i0[3]_i1[3]  (\full_equal/xor_i0[3]_i1[3]_o , wrptr_g3, sync_rdptr_g3_neg);
  xor \full_equal/xor_i0[4]_i1[4]  (\full_equal/xor_i0[4]_i1[4]_o , wrptr_g4, sync_rdptr_g4_neg);
  not full_equal_o_inv (full_equal_o_neg, full_flag);
  AL_MUX \gray_counter_mux_al_u17_b0/al_mux_b0_0_0  (
    .i0(q0_al_n14),
    .i1(q0_al_n14_neg),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o0_al_n23));
  AL_MUX \gray_counter_mux_al_u17_b1/al_mux_b0_0_0  (
    .i0(q1_al_n15),
    .i1(xor_q1_al_n15_and_q0_o),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o1_al_n24));
  AL_MUX \gray_counter_mux_al_u17_b2/al_mux_b0_0_0  (
    .i0(q2_al_n16),
    .i1(xor_q2_al_n16_and_q1_o),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o2_al_n25));
  AL_MUX \gray_counter_mux_al_u17_b3/al_mux_b0_0_0  (
    .i0(q3_al_n17),
    .i1(xor_q3_al_n17_and_q2_o),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o3_al_n26));
  AL_MUX \gray_counter_mux_al_u17_b4/al_mux_b0_0_0  (
    .i0(q4_al_n18),
    .i1(xor_q4_al_n18_and_q3_o),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o4_al_n27));
  AL_MUX \gray_counter_mux_al_u17_b5/al_mux_b0_0_0  (
    .i0(q5_al_n19),
    .i1(xor_q5_al_n19_and_or_o),
    .sel(and_re_empty_equal_o_o),
    .o(gray_counter_mux_o5_al_n28));
  AL_MUX \gray_counter_mux_b0/al_mux_b0_0_0  (
    .i0(q0),
    .i1(q0_neg),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o0));
  AL_MUX \gray_counter_mux_b1/al_mux_b0_0_0  (
    .i0(q1),
    .i1(xor_q1_and_q0__al_n1_o),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o1));
  AL_MUX \gray_counter_mux_b2/al_mux_b0_0_0  (
    .i0(q2),
    .i1(xor_q2_and_q1_and__a_o),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o2));
  AL_MUX \gray_counter_mux_b3/al_mux_b0_0_0  (
    .i0(q3),
    .i1(xor_q3_and_q2_and_an_o),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o3));
  AL_MUX \gray_counter_mux_b4/al_mux_b0_0_0  (
    .i0(q4),
    .i1(xor_q4_and_q3_and_an_o),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o4));
  AL_MUX \gray_counter_mux_b5/al_mux_b0_0_0  (
    .i0(q5),
    .i1(xor_q5_and_or_q5_q4__o),
    .sel(and_we_full_equal_o__o),
    .o(gray_counter_mux_o5));
  AL_DFF_X gray_counter_reg_al_u18_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(gray_counter_mux_o0_al_n23),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q0_al_n14));
  AL_DFF_X gray_counter_reg_al_u18_b1 (
    .ar(1'b0),
    .as(rst),
    .clk(clkr),
    .d(gray_counter_mux_o1_al_n24),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q1_al_n15));
  AL_DFF_X gray_counter_reg_al_u18_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(gray_counter_mux_o2_al_n25),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q2_al_n16));
  AL_DFF_X gray_counter_reg_al_u18_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(gray_counter_mux_o3_al_n26),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q3_al_n17));
  AL_DFF_X gray_counter_reg_al_u18_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(gray_counter_mux_o4_al_n27),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q4_al_n18));
  AL_DFF_X gray_counter_reg_al_u18_b5 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(gray_counter_mux_o5_al_n28),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q5_al_n19));
  AL_DFF_X gray_counter_reg_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(gray_counter_mux_o0),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q0));
  AL_DFF_X gray_counter_reg_b1 (
    .ar(1'b0),
    .as(rst),
    .clk(clkw),
    .d(gray_counter_mux_o1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q1));
  AL_DFF_X gray_counter_reg_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(gray_counter_mux_o2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q2));
  AL_DFF_X gray_counter_reg_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(gray_counter_mux_o3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q3));
  AL_DFF_X gray_counter_reg_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(gray_counter_mux_o4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q4));
  AL_DFF_X gray_counter_reg_b5 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(gray_counter_mux_o5),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(q5));
  AL_MUX \mux_al_u19_b0/al_mux_b0_0_0  (
    .i0(rdptr_g0),
    .i1(q1_al_n15),
    .sel(and_re_empty_equal_o_o),
    .o(mux_o0_al_n29));
  AL_MUX \mux_al_u19_b1/al_mux_b0_0_0  (
    .i0(rdptr_g1),
    .i1(q2_al_n16),
    .sel(and_re_empty_equal_o_o),
    .o(mux_o1_al_n30));
  AL_MUX \mux_al_u19_b2/al_mux_b0_0_0  (
    .i0(rdptr_g2),
    .i1(q3_al_n17),
    .sel(and_re_empty_equal_o_o),
    .o(mux_o2_al_n31));
  AL_MUX \mux_al_u19_b3/al_mux_b0_0_0  (
    .i0(rdptr_g3),
    .i1(q4_al_n18),
    .sel(and_re_empty_equal_o_o),
    .o(mux_o3_al_n32));
  AL_MUX \mux_al_u19_b4/al_mux_b0_0_0  (
    .i0(rdptr_g4),
    .i1(q5_al_n19),
    .sel(and_re_empty_equal_o_o),
    .o(mux_o4_al_n33));
  AL_MUX \mux_b0/al_mux_b0_0_0  (
    .i0(wrptr_g0),
    .i1(q1),
    .sel(and_we_full_equal_o__o),
    .o(mux_o0));
  AL_MUX \mux_b1/al_mux_b0_0_0  (
    .i0(wrptr_g1),
    .i1(q2),
    .sel(and_we_full_equal_o__o),
    .o(mux_o1));
  AL_MUX \mux_b2/al_mux_b0_0_0  (
    .i0(wrptr_g2),
    .i1(q3),
    .sel(and_we_full_equal_o__o),
    .o(mux_o2));
  AL_MUX \mux_b3/al_mux_b0_0_0  (
    .i0(wrptr_g3),
    .i1(q4),
    .sel(and_we_full_equal_o__o),
    .o(mux_o3));
  AL_MUX \mux_b4/al_mux_b0_0_0  (
    .i0(wrptr_g4),
    .i1(q5),
    .sel(and_we_full_equal_o__o),
    .o(mux_o4));
  or or_q5_al_n19_q4_al_n (or_q5_al_n19_q4_al_n_o, q5_al_n19, q4_al_n18);
  or or_q5_q4 (or_q5_q4_o, q5, q4);
  not q0_al_n14_inv (q0_al_n14_neg, q0_al_n14);
  not q0_inv (q0_neg, q0);
  not q1_al_n15_inv (q1_al_n15_neg, q1_al_n15);
  not q1_inv (q1_neg, q1);
  not q2_al_n16_inv (q2_al_n16_neg, q2_al_n16);
  not q2_inv (q2_neg, q2);
  not q3_al_n17_inv (q3_al_n17_neg, q3_al_n17);
  not q3_inv (q3_neg, q3);
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \rdusedw_sub/u0  (
    .a(sync_delayed_wrptr_g_bin_d10),
    .b(rdptr_g_bin_d10),
    .c(\rdusedw_sub/c0 ),
    .o({\rdusedw_sub/c1 ,rdusedw[0]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \rdusedw_sub/u1  (
    .a(sync_delayed_wrptr_g_bin_d11),
    .b(rdptr_g_bin_d11),
    .c(\rdusedw_sub/c1 ),
    .o({\rdusedw_sub/c2 ,rdusedw[1]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \rdusedw_sub/u2  (
    .a(sync_delayed_wrptr_g_bin_d12),
    .b(rdptr_g_bin_d12),
    .c(\rdusedw_sub/c2 ),
    .o({\rdusedw_sub/c3 ,rdusedw[2]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \rdusedw_sub/u3  (
    .a(sync_delayed_wrptr_g_bin_d13),
    .b(rdptr_g_bin_d13),
    .c(\rdusedw_sub/c3 ),
    .o({\rdusedw_sub/c4 ,rdusedw[3]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \rdusedw_sub/u4  (
    .a(sync_delayed_wrptr_g_bin_d14),
    .b(rdptr_g_bin_d14),
    .c(\rdusedw_sub/c4 ),
    .o({open_n75,rdusedw[4]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB_CARRY"))
    \rdusedw_sub/ucin  (
    .a(1'b0),
    .o({\rdusedw_sub/c0 ,open_n78}));
  AL_DFF_X reg_deleay_wrptr_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(wrptr_g0),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(delayed_wrptr_g0));
  AL_DFF_X reg_deleay_wrptr_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(wrptr_g1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(delayed_wrptr_g1));
  AL_DFF_X reg_deleay_wrptr_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(wrptr_g2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(delayed_wrptr_g2));
  AL_DFF_X reg_deleay_wrptr_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(wrptr_g3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(delayed_wrptr_g3));
  AL_DFF_X reg_deleay_wrptr_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(wrptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(delayed_wrptr_g4));
  AL_DFF_X reg_rdptr_al_u28_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(rdptr_g0),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g0));
  AL_DFF_X reg_rdptr_al_u28_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(rdptr_g1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g1));
  AL_DFF_X reg_rdptr_al_u28_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(rdptr_g2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g2));
  AL_DFF_X reg_rdptr_al_u28_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(rdptr_g3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g3));
  AL_DFF_X reg_rdptr_al_u28_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(rdptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g4));
  AL_DFF_X reg_rdptr_al_u30_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(delayed_wrptr_g0),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g0));
  AL_DFF_X reg_rdptr_al_u30_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(delayed_wrptr_g1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g1));
  AL_DFF_X reg_rdptr_al_u30_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(delayed_wrptr_g2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g2));
  AL_DFF_X reg_rdptr_al_u30_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(delayed_wrptr_g3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g3));
  AL_DFF_X reg_rdptr_al_u30_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(delayed_wrptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g4));
  AL_DFF_X reg_rdptr_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(mux_o0_al_n29),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g0));
  AL_DFF_X reg_rdptr_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(mux_o1_al_n30),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g1));
  AL_DFF_X reg_rdptr_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(mux_o2_al_n31),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g2));
  AL_DFF_X reg_rdptr_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(mux_o3_al_n32),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g3));
  AL_DFF_X reg_rdptr_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(mux_o4_al_n33),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g4));
  AL_DFF_X reg_rdptr_d1_al_u32_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_xor_xor_sync_o_al_n56),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g_bin_d10));
  AL_DFF_X reg_rdptr_d1_al_u32_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_xor_sync_del_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g_bin_d11));
  AL_DFF_X reg_rdptr_d1_al_u32_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_sync_delayed_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g_bin_d12));
  AL_DFF_X reg_rdptr_d1_al_u32_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_sync_delayed_wrp_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g_bin_d13));
  AL_DFF_X reg_rdptr_d1_al_u32_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(sync_delayed_wrptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_delayed_wrptr_g_bin_d14));
  AL_DFF_X reg_rdptr_d1_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_xor_xor_sync_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g_bin_d10));
  AL_DFF_X reg_rdptr_d1_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_xor_sync_rdp_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g_bin_d11));
  AL_DFF_X reg_rdptr_d1_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_sync_rdptr_g_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g_bin_d12));
  AL_DFF_X reg_rdptr_d1_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_sync_rdptr_g4_sy_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g_bin_d13));
  AL_DFF_X reg_rdptr_d1_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(sync_rdptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(sync_rdptr_g_bin_d14));
  AL_DFF_X reg_wrptr_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(mux_o0),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g0));
  AL_DFF_X reg_wrptr_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(mux_o1),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g1));
  AL_DFF_X reg_wrptr_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(mux_o2),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g2));
  AL_DFF_X reg_wrptr_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(mux_o3),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g3));
  AL_DFF_X reg_wrptr_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(mux_o4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g4));
  AL_DFF_X reg_wrptr_d1_al_u34_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_xor_xor_rdpt_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g_bin_d10));
  AL_DFF_X reg_wrptr_d1_al_u34_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_xor_rdptr_g4_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g_bin_d11));
  AL_DFF_X reg_wrptr_d1_al_u34_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_xor_rdptr_g4_rdp_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g_bin_d12));
  AL_DFF_X reg_wrptr_d1_al_u34_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(xor_rdptr_g4_rdptr_g_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g_bin_d13));
  AL_DFF_X reg_wrptr_d1_al_u34_b4 (
    .ar(rst),
    .as(1'b0),
    .clk(clkr),
    .d(rdptr_g4),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(rdptr_g_bin_d14));
  AL_DFF_X reg_wrptr_d1_b0 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_xor_xor_wrpt_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g_bin_d10));
  AL_DFF_X reg_wrptr_d1_b1 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_xor_wrptr_g4_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g_bin_d11));
  AL_DFF_X reg_wrptr_d1_b2 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_xor_wrptr_g4_wrp_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g_bin_d12));
  AL_DFF_X reg_wrptr_d1_b3 (
    .ar(rst),
    .as(1'b0),
    .clk(clkw),
    .d(xor_wrptr_g4_wrptr_g_o),
    .en(1'b1),
    .sr(1'b0),
    .ss(1'b0),
    .q(wrptr_g_bin_d13));
  not sync_rdptr_g3_inv (sync_rdptr_g3_neg, sync_rdptr_g3);
  not sync_rdptr_g4_inv (sync_rdptr_g4_neg, sync_rdptr_g4);
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \wrusedw_sub/u0  (
    .a(wrptr_g_bin_d10),
    .b(sync_rdptr_g_bin_d10),
    .c(\wrusedw_sub/c0 ),
    .o({\wrusedw_sub/c1 ,wrusedw[0]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \wrusedw_sub/u1  (
    .a(wrptr_g_bin_d11),
    .b(sync_rdptr_g_bin_d11),
    .c(\wrusedw_sub/c1 ),
    .o({\wrusedw_sub/c2 ,wrusedw[1]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \wrusedw_sub/u2  (
    .a(wrptr_g_bin_d12),
    .b(sync_rdptr_g_bin_d12),
    .c(\wrusedw_sub/c2 ),
    .o({\wrusedw_sub/c3 ,wrusedw[2]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \wrusedw_sub/u3  (
    .a(wrptr_g_bin_d13),
    .b(sync_rdptr_g_bin_d13),
    .c(\wrusedw_sub/c3 ),
    .o({\wrusedw_sub/c4 ,wrusedw[3]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB"))
    \wrusedw_sub/u4  (
    .a(delayed_wrptr_g4),
    .b(sync_rdptr_g_bin_d14),
    .c(\wrusedw_sub/c4 ),
    .o({open_n79,wrusedw[4]}));
  AL_MAP_ADDER #(
    .ALUTYPE("SUB_CARRY"))
    \wrusedw_sub/ucin  (
    .a(1'b0),
    .o({\wrusedw_sub/c0 ,open_n82}));
  xor xor_q1_al_n15_and_q0 (xor_q1_al_n15_and_q0_o, q1_al_n15, q0_al_n14);
  xor xor_q1_and_q0__al_n1 (xor_q1_and_q0__al_n1_o, q1, q0);
  xor xor_q2_al_n16_and_q1 (xor_q2_al_n16_and_q1_o, q2_al_n16, and_q1_al_n15_and__a_o);
  xor xor_q2_and_q1_and__a (xor_q2_and_q1_and__a_o, q2, and_q1_and__al_n1_q0_o);
  xor xor_q3_al_n17_and_q2 (xor_q3_al_n17_and_q2_o, q3_al_n17, and_q2_al_n16_and_an_o);
  xor xor_q3_and_q2_and_an (xor_q3_and_q2_and_an_o, q3, and_q2_and_and__al_n_o);
  xor xor_q4_al_n18_and_q3 (xor_q4_al_n18_and_q3_o, q4_al_n18, and_q3_al_n17_and_an_o);
  xor xor_q4_and_q3_and_an (xor_q4_and_q3_and_an_o, q4, and_q3_and_and_and___o);
  xor xor_q5_al_n19_and_or (xor_q5_al_n19_and_or_o, q5_al_n19, and_or_q5_al_n19_q4__o);
  xor xor_q5_and_or_q5_q4_ (xor_q5_and_or_q5_q4__o, q5, and_or_q5_q4_o_and_a_o);
  xor xor_rdptr_g4_rdptr_g (xor_rdptr_g4_rdptr_g_o, rdptr_g4, rdptr_g3);
  xor xor_sync_delayed_wrp (xor_sync_delayed_wrp_o, sync_delayed_wrptr_g4, sync_delayed_wrptr_g3);
  xor xor_sync_rdptr_g4_sy (xor_sync_rdptr_g4_sy_o, sync_rdptr_g4, sync_rdptr_g3);
  xor xor_wrptr_g4_wrptr_g (xor_wrptr_g4_wrptr_g_o, wrptr_g4, wrptr_g3);
  xor xor_xor_rdptr_g4_rdp (xor_xor_rdptr_g4_rdp_o, xor_rdptr_g4_rdptr_g_o, rdptr_g2);
  xor xor_xor_sync_delayed (xor_xor_sync_delayed_o, xor_sync_delayed_wrp_o, sync_delayed_wrptr_g2);
  xor xor_xor_sync_rdptr_g (xor_xor_sync_rdptr_g_o, xor_sync_rdptr_g4_sy_o, sync_rdptr_g2);
  xor xor_xor_wrptr_g4_wrp (xor_xor_wrptr_g4_wrp_o, xor_wrptr_g4_wrptr_g_o, wrptr_g2);
  xor xor_xor_xor_rdptr_g4 (xor_xor_xor_rdptr_g4_o, xor_xor_rdptr_g4_rdp_o, rdptr_g1);
  xor xor_xor_xor_sync_del (xor_xor_xor_sync_del_o, xor_xor_sync_delayed_o, sync_delayed_wrptr_g1);
  xor xor_xor_xor_sync_rdp (xor_xor_xor_sync_rdp_o, xor_xor_sync_rdptr_g_o, sync_rdptr_g1);
  xor xor_xor_xor_wrptr_g4 (xor_xor_xor_wrptr_g4_o, xor_xor_wrptr_g4_wrp_o, wrptr_g1);
  xor xor_xor_xor_xor_rdpt (xor_xor_xor_xor_rdpt_o, xor_xor_xor_rdptr_g4_o, rdptr_g0);
  xor xor_xor_xor_xor_sync (xor_xor_xor_xor_sync_o, xor_xor_xor_sync_rdp_o, sync_rdptr_g0);
  xor xor_xor_xor_xor_sync_al_u31 (xor_xor_xor_xor_sync_o_al_n56, xor_xor_xor_sync_del_o, sync_delayed_wrptr_g0);
  xor xor_xor_xor_xor_wrpt (xor_xor_xor_xor_wrpt_o, xor_xor_xor_wrptr_g4_o, wrptr_g0);

endmodule 

module AL_DFF_X
  (
  ar,
  as,
  clk,
  d,
  en,
  sr,
  ss,
  q
  );

  input ar;
  input as;
  input clk;
  input d;
  input en;
  input sr;
  input ss;
  output q;

  wire enout;
  wire srout;
  wire ssout;

  AL_MUX u_en (
    .i0(q),
    .i1(d),
    .sel(en),
    .o(enout));
  AL_MUX u_reset (
    .i0(ssout),
    .i1(1'b0),
    .sel(sr),
    .o(srout));
  AL_DFF u_seq (
    .clk(clk),
    .d(srout),
    .reset(ar),
    .set(as),
    .q(q));
  AL_MUX u_set (
    .i0(enout),
    .i1(1'b1),
    .sel(ss),
    .o(ssout));

endmodule 

module AL_MUX
  (
  input i0,
  input i1,
  input sel,
  output o
  );

  wire not_sel, sel_i0, sel_i1;
  not u0 (not_sel, sel);
  and u1 (sel_i1, sel, i1);
  and u2 (sel_i0, not_sel, i0);
  or u3 (o, sel_i1, sel_i0);

endmodule

module AL_DFF
  (
  input reset,
  input set,
  input clk,
  input d,
  output reg q
  );

  parameter INI = 1'b0;

  // synthesis translate_off
  tri0 gsrn = glbl.gsrn;

  always @(gsrn)
  begin
    if(!gsrn)
      assign q = INI;
    else
      deassign q;
  end
  // synthesis translate_on

  always @(posedge reset or posedge set or posedge clk)
  begin
    if (reset)
      q <= 1'b0;
    else if (set)
      q <= 1'b1;
    else
      q <= d;
  end

endmodule

