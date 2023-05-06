
module clkADC_debug_pwm #(parameter BPS_PARA = 50) (
    input      bps_en       ,
    input      clk          ,
    input      RSTn         ,
    output reg clk_ADC_debug
);

    reg [12:0] cnt = 0;

    always @ (posedge clk or negedge RSTn) begin
        if(~RSTn) cnt <= 13'b0;
        else if((cnt >= BPS_PARA-1)||(!bps_en)) begin
            cnt           <= 13'b0;
            clk_ADC_debug <= 1'b1;
        end
        else begin cnt <= cnt + 1'b1;clk_ADC_debug <= 1'b0; end
    end

ß
endmodule