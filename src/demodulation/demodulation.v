`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 22:11:04
// Design Name: 
// Module Name: demodulation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module demodulation(
    input clk,
    input [7:0] I,
    input [7:0] Q,
    input rst,
    output reg [15:0] m
    );
    
    reg [7:0]I_last=0;
    reg [7:0]Q_last=0;
    reg [15:0]m1,m2;
    
     Mul u1(I,Q_last,m1);
     Mul u2(Q,I_last,m2);
    
    always @(negedge clk)
      begin
        if(rst)
          begin
            I_last<=0;
            Q_last<=0;
          end
        else
          begin
            I_last<=I;
            Q_last<=Q;
          end
      end
    
    always @(posedge clk)
      begin
        m<=m1-m2;
      end
    
endmodule
