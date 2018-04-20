#
#  Constraint file
#
#############################
## Clock definition
#############################
## 437.5MHz
create_clock [get_ports clk] -name clk -period 2
#create_clock [get_ports clkx1] -name clkx1 -period 2
#create_clock [get_ports clkx1_sg] -name clkx1_sg -period 2
#create_clock [get_ports clkx1_dac] -name clkx1_dac -period 2

## 8MHz
#create_clock [get_pins Inst_io/Inst_sclk/Y] -name sclk -period 125
#create_clock -name sclk_vir -period 125

#create_generated_clock -name "clkx_mux_1" \
#                       -source [get_ports clkx1] \
#                       -master_clock clkx1 [get_pins Inst_digi/Ins_clk_mux_DONT_TOUCH/Y] \
#                       -add \
#                       -combinational

#create_generated_clock -name "clkx_mux_2" \
#                       -source [get_pins Inst_io/Inst_clkex/Y] \
#                       -master_clock clkex [get_pins Inst_digi/Ins_clk_mux_DONT_TOUCH/Y] \
#                       -add \
#                       -combinational

## 875MHz
#create_clock [get_ports clkx2] -name clkx2 -period 1

#create_generated_clock -name clkx2 \
#  -source [get_ports clkx1] \
#  -multiply_by 2      \
#  [get_ports clkx2] \
#  -add \
#  -master_clock clkx1

#############################
## Mutually Exclusive clocks
#############################
## From MXGL2_X1B_A12TR_C38
#set_clock_groups -logically_exclusive -name LOG_EXCLUSIVE \
#		 -group {clkex} \
#		 -group {clkx1} \
#      	 -group {clkx1_sg} \
#     	 -group {clkx1_dac}

#############################
## Asynchronous clocks
#############################
#set_clock_groups -asynchronous -name ASYNC_CLKS \
#		 -group {clkx1_sg} \
#		 -group {clkx1} \
#		 -group {clkx2 clkx1_dac} \
#		 -group {sclk_vir} \
#        -group {clkex}

#############################
## Slew clock
#############################
set_clock_transition 0.1 [get_clocks clk]
#set_clock_transition 0.1 [get_clocks clkx1]
#set_clock_transition 0.1 [get_clocks clkx1_sg]
#set_clock_transition 0.05 [get_clocks clkx2]

###############################
## Network and source latency
###############################
#set_clock_latency -source 0 [get_clocks clkex]
#set_clock_latency -source 0 [get_clocks clkx1]
#set_clock_latency -source 0 [get_clocks clkx2]
#set_clock_latency 1.0 [get_clocks clkex]
#set_clock_latency 1.1 [get_clocks clkx1]
#set_clock_latency 0 [get_clocks clkx2]

#############################
## False Paths/Multicycle
#############################
set_false_path -from [get_ports { *i_static* }] -to [all_registers]
set_false_path -from [get_ports { rst_async_n }] -to [all_registers]
## 100 / 2.2 = 45 * 2.2 = 99ns. 70ns of in/out delay = 29ns remaining - 0.3 = 28.7ns
#set_multicycle_path 45 -from {pad_ss pad_mosi pad_clk_sel}
#set_multicycle_path 45 -to {pad_miso}

#############################
## Input/Output delay
#############################
## Use virtual clocks to input/output delays because they are all related
## to a outside CTS that should have close latency to the CTS inside core
## SPI delay
set_input_delay 1.4 -clock [get_clocks clk] {i_valid i_subsampling i_enable i_data_i i_data_q}
set_output_delay 1.4 -clock [get_clocks clk] {o_valid o_data_fo}

#############################
## Clock network after CTS
#############################
## For hold = slowest CTS. For setup = fastest CTS.
#set_clock_latency 0.406 clkx2_vir -max
#set_clock_latency 0.457 clkx2_vir -min

#set_clock_latency 1.366 clkx1_vir -max
#set_clock_latency 1.446 clkx1_vir -min

#set_clock_latency 1.586 clkex_vir -max
#set_clock_latency 1.666 clkex_vir -min

#set_clock_latency 1.465 clkx1_sg_vir -max
#set_clock_latency 1.546 clkx1_sg_vir -min


#############################
## Clock Uncertainty
#############################
set_clock_uncertainty 0.15 -setup [get_clocks clk]

#############################
## Max transition
#############################
## ARM Recomendation is 2/3 of the definition at liberty file at slowest PVT. 0.632 * 2/3 = 0.4
## Maximum Transition time = (clock period) x 0.2 = 1 x 0.2 = 0.2
## Set clock paths and the data paths launched by clkx2 for 0.2
set_max_transition 0.4 [get_clocks clk]

#############################
## Dont touch
#############################
#  puts " SET DONT TOUCH ON STUB DESIGNS]\n"
#set_dont_touch [get_cells -hierarchical *DONT_TOUCH*]

#############################
## Set case analysis
#############################
## Set case analysis for power shutdown blocks (always on)
#set_case_analysis 0 Inst_digi/DUT_tx/pwr_sd
#set_case_analysis 0 Inst_digi/DUT_rx/pwr_sd

