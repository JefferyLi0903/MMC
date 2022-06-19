

//it is just a normal FIFO
module FIFO_SPI
	#( parameter FIFO_Depth = 24 )
(
    input clock,
    input sclr,

    input rdreq, wrreq,
    output reg full, empty,

    input [24 : 0] data,
    output [24 : 0] q

);

reg [24 : 0] mem [FIFO_Depth-1 : 0];
reg [4 : 0] wp, rp;
reg w_flag, r_flag;

initial
begin
wp=0;
w_flag=0;
rp=0;
r_flag=0;
end


always @(posedge clock) begin
    if (~sclr) begin
        wp <= 0;
        w_flag <= 0;
    end else if(!full && wrreq) begin 
        wp<= (wp==FIFO_Depth-1) ? 0 : wp+1;
        w_flag <= (wp==FIFO_Depth-1) ? ~w_flag : w_flag;
    end
end

always @(posedge clock) begin
    if(wrreq && !full)begin
        mem[wp] <= data;
    end
end

always @(posedge clock) begin
    if (~sclr) begin
        rp<=0;
        r_flag <= 0;
    end else if(!empty && rdreq) begin 
        rp<= (rp==FIFO_Depth-1) ? 0 : rp+1;
        r_flag <= (rp==FIFO_Depth-1) ? ~r_flag : r_flag;
    end
end

assign q = mem[rp];

always @(*) begin
    if(wp==rp)begin
        if(r_flag==w_flag)begin
            full <= 0;
            empty <= 1;
        end else begin
            full <= 1;
            empty <= 0;
        end
    end else begin
        full <= 0;
        empty <= 0;
    end
end



endmodule