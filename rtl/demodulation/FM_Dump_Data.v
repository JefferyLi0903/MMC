
module FM_Dump_Data #(parameter FM_ADDR_WIDTH = 13) (
    input                           clk                ,
    input                           RSTn               ,
    input                           dump_data_clk      ,
    input       [FM_ADDR_WIDTH-1:0] wraddr             ,
    input       [FM_ADDR_WIDTH-1:0] rdaddr             ,
    input       [             31:0] wdata              ,
    input       [              3:0] wea                ,
    input       [              3:0] FM_HW_state        ,
    input       [              7:0] dump_data          ,
    output reg  [             31:0] rdata              ,
    output wire                     Dump_Done_Interrupt
);

//(* ram_style="block" *)reg [31:0] mem_IQ [0:(2**(FM_ADDR_WIDTH))-1];
    reg [7:0] mem_IQ[(2**(FM_ADDR_WIDTH))-1:0];

    parameter Dump_Data_STATE_IDLE      = 4'b0000;
    parameter Dump_Data_STATE_Capture   = 4'b0001; // capture to memory
    parameter Dump_Data_STATE_Read      = 4'b0010; //read to PC by UART
    parameter Dump_Data_STATE_Read_done = 4'b0100;
    parameter FM_HW_STATE_IDLE          = 4'b0000;
    parameter FM_HW_STATE_RCEV          = 4'b0010; //Receiver State, receiver, dump IQ or audio data
    parameter FM_HW_STATE_RSSI          = 4'b0100; //RSSI Scan state

    reg [3:0] Data_dump_state = 4'b0;

    always@(posedge clk or negedge RSTn ) begin
        if (!RSTn) begin
            Data_dump_state <= Dump_Data_STATE_IDLE;
        end
        else if ((wraddr==15'h004)&&(wdata[7:4]==4'b0100)&&(wea==4'hf)&& (FM_HW_state == FM_HW_STATE_RCEV)) begin  //control to dump audio data in receiver state
            Data_dump_state <= Dump_Data_STATE_Capture;
        end
        else if ((wraddr==15'h004)&&(wdata[7:4]==4'b1000)&&(wea==4'hf)&&(FM_HW_state == FM_HW_STATE_RCEV)) begin     //start  dump audio data
            Data_dump_state <= Dump_Data_STATE_Read;
        end
        else if ((wraddr==15'h004)&&(wdata[7:4]==4'b1100)&&(wea==4'hf)&&(FM_HW_state == FM_HW_STATE_RCEV)) begin     //finished dump audio data
            Data_dump_state <= Dump_Data_STATE_Read_done;
        end
        else if ((wraddr==15'h004)&&(wdata[3:0]==4'b0001)&&(wea==4'hf)&& (FM_HW_state == FM_HW_STATE_RCEV)) begin  //control to dump IQ data in receiver state
            Data_dump_state <= Dump_Data_STATE_Capture;
        end
        else if ((wraddr==15'h004)&&(wdata[3:0]==4'b0010)&&(wea==4'hf)&&(FM_HW_state == FM_HW_STATE_RCEV)) begin     //start  dump IQ data
            Data_dump_state <= Dump_Data_STATE_Read;
        end
        else if ((wraddr==15'h004)&&(wdata[3:0]==4'b0100)&&(wea==4'hf)&&(FM_HW_state == FM_HW_STATE_RCEV)) begin     //finished dump IQ data
            Data_dump_state <= Dump_Data_STATE_Read_done;
        end
    end



    reg                     dump_done_en   = 1'b0;
    reg                     dump_temp      = 1'b0;
    reg                     Dump_done      = 1'b0;
    reg [FM_ADDR_WIDTH-1:0] dump_data_addr       ;
//reg [1:0] dump_data_addr_byte;

    always@(posedge dump_data_clk or negedge RSTn ) begin
        if (!RSTn) begin
            dump_data_addr <= 15'h100;
            dump_done_en   <= 1'b0;
            //dump_data_addr_byte <= 2'b0;
        end
        else if((dump_data_addr < 15'h1FFF)&&(~Dump_done)&&(Data_dump_state == Dump_Data_STATE_Capture)) begin
            /* 4 Bytes control
            if(dump_data_addr_byte==2'b0) begin
            dump_data_addr_byte = dump_data_addr_byte+1'b1;
            end
            else if(dump_data_addr_byte<2'b11)begin
            dump_data_addr_byte = dump_data_addr_byte+1'b1;
            end
            else if(dump_data_addr_byte==2'b11)begin
            dump_data_addr_byte = 2'b0;
            dump_data_addr      <= dump_data_addr+1'b1;
            end
            */
            // 1 byte control
            dump_data_addr      <= dump_data_addr+1'b1;
        end
        else if((dump_data_addr == 15'h1FFF)&&(~Dump_done)&&(Data_dump_state == Dump_Data_STATE_Capture))begin
            dump_done_en   <= 1'b1;
            dump_data_addr <= 15'h100;
        end
        else if (dump_done_en)  dump_done_en<=1'b0;
    end

    always@(posedge clk or negedge RSTn ) begin
        if (!RSTn) begin
            dump_temp <= 1'b0;
            Dump_done <= 1'b0;
        end
        else if((dump_done_en==1'b1)&&(dump_temp==1'b0)) begin
            Dump_done <= 1'b1;
            dump_temp <= 1'b1;
        end
        else if(Dump_done==1'b1) begin
            Dump_done <= 1'b0;
        end
        else if(Data_dump_state == Dump_Data_STATE_Read_done) begin
            dump_temp <= 1'b0;
        end
    end


    always@(posedge dump_data_clk) begin
        if((~Dump_done)&&(FM_HW_state==FM_HW_STATE_RCEV)&&(Data_dump_state == Dump_Data_STATE_Capture)) begin //control to get data to Arm core
            /* 4 Bytes control
            if(dump_data_addr_byte==2'b01)
            mem_IQ[dump_data_addr][7:0]   <= dump_data;
            else if   (dump_data_addr_byte==2'b10)
            mem_IQ[dump_data_addr][15:8]  <= dump_data;
            else if   (dump_data_addr_byte==2'b11)
            mem_IQ[dump_data_addr][23:16] <= dump_data;
            else if   (dump_data_addr_byte==2'b00)
            mem_IQ[dump_data_addr][31:24] <= dump_data;
            */
            // 1 byte output
            mem_IQ[dump_data_addr]        <= dump_data;
        end
    end

/*
reg [31:0] addra;
always@(*) begin
    if(~Dump_done) addra=dump_data_addr;
    else addra=rdaddr;
end


FM_Dump_Data_RAM mem_DUMP(
    .doa(mem_IQ),
    .dia(tmp),
    .wea(dump_data_ea),
    .addra(addra),
    .clka(dump_data_clk),
    .cea(1'b1),
    .ocea(1'b1),
    .rsta(RSTn)
);
*/
/*
always@(posedge clk ) begin
    if ((rdaddr>=15'h100)&&((FM_HW_state==FM_HW_STATE_RCEV)&&(Data_dump_state == Dump_Data_STATE_Read))) begin   // read the demodulated data out
    // rdata<= mem_IQ;
    rdata<=32'b1;
    end
end
*/

    always@(posedge clk ) begin
        if ((rdaddr>=15'h100)&&((FM_HW_state==FM_HW_STATE_RCEV)&&(Data_dump_state == Dump_Data_STATE_Read))) begin   // read the demodulated data out
            rdata <= mem_IQ[rdaddr];
        end
    end


    assign Dump_Done_Interrupt = (Dump_done) ? 1'b1 : 1'b0;


endmodule