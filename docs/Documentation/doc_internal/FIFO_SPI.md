# Entity: FIFO_SPI 

- **File**: FIFO_SPI.v
## Diagram

![Diagram](FIFO_SPI.svg "Diagram")
## Generics

| Generic name | Type | Value | Description |
| ------------ | ---- | ----- | ----------- |
| FIFO_Depth   |      | 24    |             |
## Ports

| Port name | Direction | Type     | Description |
| --------- | --------- | -------- | ----------- |
| clock     | input     |          |             |
| sclr      | input     |          |             |
| rdreq     | input     |          |             |
| wrreq     | input     |          |             |
| full      | output    |          |             |
| empty     | output    |          |             |
| data      | input     | [24 : 0] |             |
| q         | output    | [24 : 0] |             |
## Signals

| Name   | Type         | Description |
| ------ | ------------ | ----------- |
| mem    | reg [24 : 0] |             |
| wp     | reg [4 : 0]  |             |
| rp     | reg [4 : 0]  |             |
| w_flag | reg          |             |
| r_flag | reg          |             |
