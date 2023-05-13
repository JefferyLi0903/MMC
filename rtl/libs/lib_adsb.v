/********************************************************************/
/*    Copylight(c) 2003 Panasonic Mobile Communications Co., Ltd.   */
/* -----------------------------------------------------------------*/
/*	(1) File Name      : lib_adsb.v									*/
/*	(2) System Name    : TD-SCDMA Demodulation						*/
/*	(3) System Edition : TSM										*/
/*	(4) Author         : H.Asano(PMCS)								*/
/********************************************************************/

/*** Update Report **************************************************/
/*  Version     Date      Name   [             Comment             ]*/
/*==================================================================*/
/*   0.9.0   2003/05/30  H.Asano  									*/
/********************************************************************/

// Adder-Subtractor

module lib_adsb (
				a,
				b,
				m,

				x
				);

parameter N = 16;	// Default input bit width

input	[N-1:0]	a;
input	[N-1:0]	b;
input			m;	// Arithmetic mode(SUB=1,ADD=0)

output	[N:0]	x;

// Bit extend
	wire [N:0] ea = {a[N-1],a[N-1:0]};
	wire [N:0] eb = {b[N-1],b[N-1:0]};

// Adder-Subtractor
	assign x = (m) ? (ea - eb) : (ea + eb);

endmodule

