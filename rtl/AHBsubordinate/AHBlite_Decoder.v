module AHBlite_Decoder
#(
    /*RAMCODE enable parameter*/
    parameter Port0_en = 1,
    /************************/

    /*RAMDATA enable parameter*/
    parameter Port1_en = 1,
    /************************/

    /*WATERLIGHT enable parameter*/
    parameter Port2_en = 1,
    /************************/

    /*UART enable parameter*/
    parameter Port3_en = 1,
    /************************/

    /*SPI enable parameter*/
    parameter Port4_en = 1,
    /************************/
    parameter Port5_en = 1
    /************************/

)(
    input [31:0] HADDR,

    /*RAMCODE OUTPUT SELECTION SIGNAL*/
    output wire P0_HSEL,

    /*RAMDATA OUTPUT SELECTION SIGNAL*/
    output wire P1_HSEL,

    /*WATERLIGHT OUTPUT SELECTION SIGNAL*/
    output wire P2_HSEL,

    /*UART OUTPUT SELECTION SIGNAL*/
    output wire P3_HSEL,       

   /*SPI OUTPUT SELECTION SIGNAL*/
    output wire P4_HSEL,  

    /*SPI OUTPUT SELECTION SIGNAL*/
    output wire P5_HSEL  
      

);

//RAMCODE-----------------------------------

//0x00000000-0x0000ffff
/*Insert RAMCODE decoder code there*/
assign P0_HSEL = (HADDR[31:16] == 16'h0000) ? Port0_en : 1'b0; 
/***********************************/



//PERIPHRAL-----------------------------

//0X40000000 WaterLight MODE
//0x40000004 WaterLight SPEED
/*Insert WaterLight decoder code there*/
assign P2_HSEL = (HADDR[31:4] == 28'h4000000) ? Port2_en : 1'b0; 
/***********************************/

//0X40000010 UART RX DATA
//0X40000014 UART TX STATE
//0X40000018 UART TX DATA
/*Insert UART decoder code there*/
assign P3_HSEL = (HADDR[31:4] == 28'h4000001) ? Port3_en : 1'b0;
/***********************************/

//RAMDATA-----------------------------
//0X20000000-0X2000FFFF
/*Insert RAMDATA decoder code there*/
assign P1_HSEL = (HADDR[31:16] == 16'h2000) ? Port1_en : 1'b0; 
/***********************************/

//SPI TX-----------------------------
//0X50000000-0X50000010
//0X50000010: SPI Tx data
/*Insert SPI TX decoder code there*/
assign P4_HSEL = (HADDR[31:4] == 28'h5000001) ? Port4_en : 1'b0;
/***********************************/

//FM HW Control and memory-----------------------------
//0X60000000-0X60000FFF
//0X60000010: control to get ADC data to Arm core
/*Insert FM_HW decoder code there*/
assign P5_HSEL = (HADDR[31:17] == 15'b011000000000000) ? Port5_en : 1'b0;

/***********************************/

endmodule