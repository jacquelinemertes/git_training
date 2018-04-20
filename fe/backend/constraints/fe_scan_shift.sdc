#******************************************************************************#
# PURPOSE : Timing definitions of scan mode in the shift phase.                #
#******************************************************************************#

################################################################################################################
# CASE ANALISYS
################################################################################################################
# Setting scan shift 

#set_case_analysis 0 [ get_ports {sc_cpren }]
#set_case_analysis 0 [ get_ports {sc_spren }] 

set_case_analysis 1 [ get_ports {sc_sen }]
set_case_analysis 1 [ get_ports {rst_async_n }]

################################################################################
# CLOCK DEFINITIONS
################################################################################
create_clock -name "clk_sclk_shift"   -period "${T_SCLK_SHIFT}"   -waveform "${W_SCLK_SHIFT}" [ get_ports {clk} ]
create_clock -name "virtual_clk_shift" -period "${T_SCLK_SHIFT}" -waveform "${W_SCLK_SHIFT}"

################################################################################
# INPUT DEFINITIONS
################################################################################

#Design input signals
set_false_path -from [ get_port { i_valid i_subsampling i_enable i_data_i i_data_q }]

#Scan input signals
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di0 }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di1 }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di2 }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di3 }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di4 }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_cpren }]
set_input_delay -max $MAX_INPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_spren }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di0 }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di1 }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di2 }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di3 }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_di4 }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_cpren }]
set_input_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}]  [ get_port { sc_spren }]

#Scan signals are static
set_multicycle_path -setup 2 -from [ get_port { sc_cpren }]
set_multicycle_path -hold  1 -from [ get_port { sc_cpren }]
set_multicycle_path -setup 2 -from [ get_port { sc_spren }]
set_multicycle_path -hold  1 -from [ get_port { sc_spren }]


################################################################################
# OUTPUT DEFINITIONS
################################################################################

#Design output signals
set_false_path -to [ get_port { o_fo_valid o_fo_value }]

#Scan output signals
set_output_delay -max $MAX_OUTPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do0 }]
set_output_delay -max $MAX_OUTPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do1 }]
set_output_delay -max $MAX_OUTPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do2 }]
set_output_delay -max $MAX_OUTPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do3 }]
set_output_delay -max $MAX_OUTPUT_DELAY_SCLK_SHIFT -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do4 }]
set_output_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do0 }]
set_output_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do1 }]
set_output_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do2 }]
set_output_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do3 }]
set_output_delay -min 0.3 -clock [get_clocks {virtual_clk_shift}] [ get_port { sc_do4 }]

################################################################################
# SET FALSE PATHS AND MULTICYCLES
################################################################################

set_false_path -from [get_ports { *i_static* }]  -to [all_registers]
set_false_path -from [get_ports { rst_async_n }] -to [all_registers]


################################################################################
# FINAL CONSTRAINTS
################################################################################

# CLOCK UNCERTAINTY
set_clock_uncertainty -setup $CLK_UNC_SETUP_SCLK_SHIFT  [get_clocks {clk_sclk_shift}]
set_clock_uncertainty -hold  $CLK_UNC_HOLD_SCLK_SHIFT   [get_clocks {clk_sclk_shift}]

# CLOCK TRANSITION
set_clock_transition -rise $CLK_TRANSITION_SCLK_SHIFT [get_clocks {clk_sclk_shift} ]
set_clock_transition -fall $CLK_TRANSITION_SCLK_SHIFT [get_clocks {clk_sclk_shift} ]

# CLOCK LATENCY
#set_clock_latency $CLK_LATENCY_SCLK_SHIFT -rise [get_clocks {clk_sclk_shift} ]
#set_clock_latency $CLK_LATENCY_SCLK_SHIFT -fall [get_clocks {clk_sclk_shift} ]

#  SET MAXIMUM TRANSITION
set_max_transition $MAX_INPUT_TRANS  [all_inputs]
set_max_transition $MAX_OUTPUT_TRANS [all_outputs]

# SET INPUT TRANSITION
set_input_transition $MAX_INPUT_TRANS_SCLK_SHIFT -max [all_inputs]

# SET OUTPUT LOADS
set_load -pin_load $OUTPUT_LOAD_SCLK_SHIFT [all_outputs]

#SET CAPACITANCE
set_max_capacitance $MAX_INPUT_CAP_SCLK_SHIFT  [all_inputs]
set_max_capacitance $MAX_OUTPUT_CAP_SCLK_SHIFT [ all_outputs ]

# INPUT DRIVING
#Min - Early Analysis
set_driving_cell \
	-lib_cell BUF_X4B_A12TH_C34 \
	-min \
	-input_transition_rise 0.005 \
	-input_transition_fall 0.005 \
	[all_inputs] 

#Max - Late Analysis
set_driving_cell \
	-lib_cell BUF_X4B_A12TH_C34 \
 	-max \
	-input_transition_rise 0.34 \
	-input_transition_fall 0.34 \
	[all_inputs] 

#set_propagated_clock [get_clocks {clk_sclk_shift}]
