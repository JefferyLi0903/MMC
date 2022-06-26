#
# Create work library
#
vlib work
#
# Compile sources
#
vlog  D:/Documents/MMC/project/simulation/CortexM0_SoC_tb.v
#
# Call vsim to invoke simulator
#
vsim -L D:/intelFPGA_pro/21.2/al3_10_ver -gui -novopt work.
#
# Add waves
#
add wave *
#
# Run simulation
#
run 1000ns
#
# End