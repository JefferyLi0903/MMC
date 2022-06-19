# Entity: SPI_TX 

- **File**: SPI_TX.v
## Diagram

![Diagram](SPI_TX.svg "Diagram")
## Ports

| Port name  | Direction | Type   | Description                  |
| ---------- | --------- | ------ | ---------------------------- |
| clk        | input     |        |                              |
| CW_CLK_MSI | input     |        |                              |
| RSTn       | input     |        |                              |
| data       | input     | [23:0] |                              |
| SPI_tx_en  | input     |        |                              |
| MSI_SDATA  | output    |        | port 30, connected to pin N9 |
| MSI_SCLK   | output    | wire   | port 29, connected to pin M9 |
| MSI_CS     | output    |        | port 31, connected to pin P9 |
## Signals

| Name            | Type        | Description |
| --------------- | ----------- | ----------- |
| FIFOrd_en       | wire        |             |
| FIFOwr_en       | wire        |             |
| FIFOdata        | wire [24:0] |             |
| FIFOempty       | wire        |             |
| FIFOfull        | wire        |             |
| data_add_onebit | wire [24:0] |             |
| count_en        | reg         |             |
| counter         | reg [13:0]  |             |
| trans_finish    | wire        |             |
| trans_start     | wire        |             |
| data_temp       | reg         |             |
| MSI_clk_en      | reg         |             |
| read_fifo       | wire [24:0] |             |
## Instantiations

- FIFO_SPI: FIFO_SPI
