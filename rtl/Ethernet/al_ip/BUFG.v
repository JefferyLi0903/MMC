/************************************************************\
 **  Copyright (c) 2011-2021 Anlogic, Inc.
 **  All Right Reserved.
\************************************************************/
/************************************************************\
 ** Log	:	This file is generated by Anlogic IP Generator.
 ** File	:	D:/EG4S20/EG4S20/Codes/rgmii_ethernet/al_ip/BUFG.v
 ** Date	:	2021 08 04
 ** TD version	:	5.0.30786
\************************************************************/

`timescale 1ns / 1ps

module BUFG ( i, o );
		output 		o;
		input  		i;

		EG_LOGIC_BUFG bufg(
		.i(i),
		.o(o));

endmodule