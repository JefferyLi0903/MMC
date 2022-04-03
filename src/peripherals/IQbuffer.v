module IQbuffer(
    input [11:0] din,
    input writerq,
    input readrq,
    input sclr,
    input clk,
    output [23:0] dout
);
    reg wr_rq_1 = 0;
    reg wr_rq_2 = 1;
    reg wr_reg = 0;
    reg flag=0;
    reg [11:0] dout_1 = 0;
    reg [11:0] dout_2 = 0;
    always@(posedge clk) begin
        if((writerq==1)&&(flag==1)) wr_reg<=1;
        else begin
            wr_reg<=0;
            flag<=1;
        end
    end
    always@(posedge writerq) flag=1;
    always@(posedge clk)
    begin
        if (wr_reg==1) begin
            wr_rq_1 <= ~wr_rq_1;
            wr_rq_2 <= ~wr_rq_2;
        end
    end
    FIFO #(.data_width(12)) bf1(
        .clk(clk),
        .sclr(sclr),
        .rdreq(readrq),
        .wrreq(wr_rq_1),
        .data(din),
        .q(dout_1)
    );

    FIFO #(.data_width(12)) bf2(
        .clk(clk),
        .sclr(sclr),
        .rdreq(readrq),
        .wrreq(wr_rq_2),
        .data(din),
        .q(dout_2)
    );

    assign dout = {dout_1,dout_2};
endmodule