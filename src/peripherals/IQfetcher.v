module IQfetcher(
    input clk,
    input RSTn,
    input fetch_en,
    output [11:0] dout,
    output EOC
);
    wire CW_CLK;
    wire ADC_CLK;
    wire CLK_Lock;
    reg [2:0] Channel;
    always@(posedge EOC or negedge RSTn) begin
        if(~RSTn) Channel<=3'b100;
        else if (Channel==3'b100) Channel<=3'b110;
            else Channel<=3'b100;
    end
    clkdivider adcclk
    (
        .refclk(clk),
        .reset(1'b0),
        .stdby(1'b0),
        .extlock(CLK_Lock),
        .clk0_out(CW_CLK),
        .clk1_out(ADC_CLK)
    );
    IQ_ADC ADC(
        .eoc(EOC),
        .dout(dout),
        .clk(ADC_CLK),
        .pd(1'b0),
        .s(Channel),
        .soc(fetch_en)
    );

endmodule