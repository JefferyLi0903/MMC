`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Module Name:    ethernet_test 
//////////////////////////////////////////////////////////////////////////////////
module ethernet_test
(
input               sys_clk,                         //system clock 50Mhz on board
input               rst_n,                           //reset ,low active
input               clk,
output              e_mdc,                           //phy emdio clock
inout               e_mdio,                          //phy emdio data
output[3:0]         rgmii_txd,                       //phy data send
output              rgmii_txctl,                     //phy data send control
output              rgmii_txc,                       //Clock for sending data
input[3:0]          rgmii_rxd,                       //recieve data
input               rgmii_rxctl,                     //Control signal for receiving data
input               rgmii_rxc, //Clock for recieving data
input clk_fm_ethernet,
input [31:0] fm_data_ethernet
);

/*
reg [12:0] cnt = 0;
reg [31:0]  IQorAudioData;
reg clk_fm_demo_sampling;

always @ (posedge sys_clk ) begin
	if(cnt >= 50) begin 	
         cnt <= 13'b0;		
         clk_fm_demo_sampling <= 1'b1;		
         end
	else begin cnt <= cnt + 1'b1;clk_fm_demo_sampling <= 1'b0; end
end

always@(posedge clk_fm_demo_sampling ) begin
    IQorAudioData <= $random %16777215;
end
*/

wire   [ 7:0]       gmii_txd;                       //gmii data                
wire                gmii_tx_en;                     //gmii send enable
wire                gmii_tx_er;
wire                gmii_tx_clk;                    //gmii send clock
wire                gmii_crs;
wire                gmii_col;
wire   [ 7:0]       gmii_rxd;                       //gmii recieving data                    
wire                gmii_rx_dv;                     //gmii recieving data valid
wire                gmii_rx_er;
wire                gmii_rx_clk;                    //gmii recieve clock
wire  [ 1:0]        speed_selection;                // 1x gigabit, 01 100Mbps, 00 10mbps
wire                duplex_mode;                    // 1 full, 0 half
wire                rgmii_rxcpll;

assign speed_selection = 2'b10;
assign duplex_mode = 1'b1;
/*************************************************************************
MDIO register configuration
****************************************************************************/
miim_top miim_top_m0(
.reset_i            (1'b0),
.miim_clock_i       (gmii_tx_clk),
.mdc_o              (e_mdc),
.mdio_io            (e_mdio),
.link_up_o          (),                  //link status
.speed_o            (),                  //link speed
.speed_override_i   (2'b11)              //11: autonegoation
);
	
/*************************************************************************
GMII and RGMII data conversion
****************************************************************************/
util_gmii_to_rgmii util_gmii_to_rgmii_m0(
.reset(1'b0),

.rgmii_td(rgmii_txd),
.rgmii_tx_ctl(rgmii_txctl),
.rgmii_txc(rgmii_txc),
.rgmii_rd(rgmii_rxd),
.rgmii_rx_ctl(rgmii_rxctl),
.gmii_rx_clk(gmii_rx_clk),
.gmii_txd(gmii_txd),
.gmii_tx_en(gmii_tx_en),
.gmii_tx_er(1'b0),
.gmii_tx_clk(gmii_tx_clk),
.gmii_crs(gmii_crs),
.gmii_col(gmii_col),
.gmii_rxd(gmii_rxd),
.rgmii_rxc(rgmii_rxc),//add
.gmii_rx_dv(gmii_rx_dv),
.gmii_rx_er(gmii_rx_er),
.speed_selection(speed_selection),
.duplex_mode(duplex_mode)
);
/*************************************************************************
Mac layer protocol test
****************************************************************************/

mac_test mac_test0
(
.clk(clk),
.gmii_tx_clk            (gmii_tx_clk),
.gmii_rx_clk            (gmii_rx_clk) ,
.rst_n                  (rst_n),
.gmii_rx_dv             (gmii_rx_dv),
.gmii_rxd               (gmii_rxd ),
.gmii_tx_en             (gmii_tx_en),
.gmii_txd               (gmii_txd ),
.IQorAudioData          (fm_data_ethernet),
.clk_fm_demo_sampling   (clk_fm_ethernet)
); 

endmodule
