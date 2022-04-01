`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/23 22:23:35
// Design Name: 
// Module Name: Mul
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


module Mul(
    input [7:0] x1_in,
    input [7:0] x2_in,
    output reg [15:0] x_out
    );
    
    reg [7:0] tmp [15:0];
    reg [15:0] sum=0;
    reg [15:0] ext_a;
    integer i;
    
    generate
        always@(*)
        begin
        
            ext_a=x1_in;
            for(i=0;i<8;i=i+1)
            begin
                if(x2_in[i]) 
                  tmp[i]=ext_a << i;
                else 
                  tmp[i]=0;
            end
            
            sum = tmp[0]+
            tmp[1]+
            tmp[2]+
            tmp[3]+
            tmp[4]+
            tmp[5]+
            tmp[6]+
            tmp[7];

            x_out = sum;
        end
    endgenerate
    
endmodule
