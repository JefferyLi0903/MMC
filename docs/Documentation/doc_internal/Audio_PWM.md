# Entity: Aduio_PWM 

- **File**: Audio_PWM.v
## Diagram

![Diagram](Audio_PWM.svg "Diagram")
## Ports

| Port name                     | Direction | Type       | Description |
| ----------------------------- | --------- | ---------- | ----------- |
| clk_fm_demo_sampling          | input     |            |             |
| clk                           | input     |            |             |
| RSTn                          | input     |            |             |
| demod_en                      | input     |            |             |
| demodulated_signal_downsample | input     | wire [9:0] |             |
| audio_pwm                     | output    | wire       |             |
## Signals

| Name          | Type       | Description |
| ------------- | ---------- | ----------- |
| cnt           | reg	[11:0] |             |
| audio_pwm_reg | reg        |             |
| N_1           | reg        |             |
| N             | reg        |             |
