module SPI_24bit(
    input clk,
    input counter_en,
    input RSTn,
    output reg [23:0] reg_val
);
    reg [23:0] mat [6:1];
    reg [23:0] r0 = 24'h043420;
    reg [23:0] r5 = 24'h28bb85;
    reg [23:0] r2 = 24'h1f1902;
    reg [23:0] r1 = 24'h00c0a1;
    reg [23:0] r6 = 24'h200016;
    reg [23:0] r3 = 24'h00fa03;
    reg [2:0] counter;
    initial 
    begin
        mat[6]=r0;
        mat[5]=r5;
        mat[4]=r2;
        mat[3]=r1;
        mat[2]=r6;
        mat[1]=r3;
    end
    always@(posedge clk) begin
        if(counter!=0) begin
            reg_val <= mat[counter];
        end
    end
    always@(negedge clk or negedge RSTn) begin
        if (~RSTn)   counter<=6;
        else if (counter_en&(counter!=0)) counter<=counter-1;
    end
endmodule

