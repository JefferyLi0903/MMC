# Entity: FIFO 

- **File**: FIFO.v
## Diagram

![Diagram](FIFO.svg "Diagram")
## Ports

| Port name | Direction | Type    | Description |
| --------- | --------- | ------- | ----------- |
| clock     | input     |         |             |
| sclr      | input     |         |             |
| rdreq     | input     |         |             |
| wrreq     | input     |         |             |
| full      | output    |         |             |
| empty     | output    |         |             |
| data      | input     | [7 : 0] |             |
| q         | output    | [7 : 0] |             |
## Signals

| Name   | Type        | Description |
| ------ | ----------- | ----------- |
| mem    | reg [7 : 0] |             |
| wp     | reg [3 : 0] |             |
| rp     | reg [3 : 0] |             |
| w_flag | reg         |             |
| r_flag | reg         |             |
