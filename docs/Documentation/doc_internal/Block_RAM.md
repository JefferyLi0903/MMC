# Entity: Block_RAM 

- **File**: Block_RAM.v
## Diagram

![Diagram](Block_RAM.svg "Diagram")
## Generics

| Generic name | Type | Value | Description |
| ------------ | ---- | ----- | ----------- |
| ADDR_WIDTH   |      | 12    |             |
## Ports

| Port name | Direction | Type             | Description |
| --------- | --------- | ---------------- | ----------- |
| clka      | input     |                  |             |
| addra     | input     | [ADDR_WIDTH-1:0] |             |
| addrb     | input     | [ADDR_WIDTH-1:0] |             |
| dina      | input     | [31:0]           |             |
| wea       | input     | [3:0]            |             |
| doutb     | output    | [31:0]           |             |
## Signals

| Name | Type       | Description |
| ---- | ---------- | ----------- |
| mem  | reg [31:0] |             |
