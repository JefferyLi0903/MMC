module keyboard_scan(clk,col,row,key);
    input clk;
    input [3:0] col;             
    output reg [3:0] row = 4'b1110;               
    output reg [15:0] key;  
    reg [31:0] cnt = 0;
    reg scan_clk = 0;
    always@(posedge clk) begin
        if(cnt == 2499) begin
            cnt <= 0;
            scan_clk <= ~scan_clk;
        end
        else
            cnt <= cnt + 1;
    end
    always@(posedge scan_clk)
        row <= {row[2:0],row[3]}; 
    always@(negedge scan_clk) 
        case(row)
            4'b1110 : key[3:0] <= col;
            4'b1101 : key[7:4] <= col;
            4'b1011 : key[11:8] <= col;
            4'b0111 : key[15:12] <= col;
            default : key <= 0;
        endcase
endmodule

module key_filter(clk,rstn,key_in,key_deb,en);
    input clk;
    input rstn;
    input [15:0] key_in;
    output [15:0] key_deb;
    output en;
    // Counting 
    reg [19:0] cnt = 0;
    parameter CNTMAX = 999_999;
    always@(posedge clk or negedge rstn) begin
        if(~rstn)
            cnt <= 0;
        else if(cnt == CNTMAX)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
    end
    // Sampling
    reg [15:0] key_reg0;
    reg [15:0] key_reg1;
    reg [15:0] key_reg2; 
    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            key_reg0 <= 16'hffff;
            key_reg1 <= 16'hffff;
            key_reg2 <= 16'hffff;
        end
        else if(cnt == CNTMAX) begin
            key_reg0 <= key_in;
            key_reg1 <= key_reg0;
            key_reg2 <= key_reg1;                                
        end
    end
    assign key_deb = (~key_reg0&~key_reg1& ~key_reg2)|(~key_reg0&~key_reg1&key_reg2);
    // State_machine
    parameter s0 = 1'b0 ;
    parameter s1 = 1'b1 ;
    reg [2:0] current_state ; //statement
    reg [2:0] next_state ; //statement
    reg [15:0] key_debb;// define the intermediate variable
    reg en;
    always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            current_state <= s0;
            next_state <= s0;
        end
        else begin
            current_state <= next_state;
            key_debb <= key_deb;
            case(current_state)
            s0:if(key_deb == key_debb) begin//s0
                next_state <= s0;
                en <= 0;
            end
            else begin
                next_state <= s1;
                en <= 1;
            end    
            s1:if(key_deb == key_debb) begin//s1
                next_state <= s1;
                en <= 0;
            end
            else begin
                next_state <= s0;
                en <= 0;
            end
            default:next_state<=s0;
        endcase
            end
    end
endmodule

module pulse_gen
    (
    input clk, 
    input RSTn,
    input [15:0] key_signal,
    output [15:0] pulse
    );
    reg [15:0] key_reg_1;
    reg [15:0] key_reg_2;
    always @(posedge clk or negedge RSTn) begin
        if (~RSTn) begin
            key_reg_1 <= 0;
            key_reg_2 <= 0;
        end
        else begin
            key_reg_1 <= key_signal;
            key_reg_2 <= key_reg_1;
        end
    end
    assign pulse = (key_signal) & (~key_reg_2);
endmodule