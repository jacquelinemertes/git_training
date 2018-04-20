#******************************************************************************#
# PURPOSE : Script to include functional timing constraints.                   #
#******************************************************************************#


################################################################################
#             MAIN SDC synthesis constraints                                   #
################################################################################

################################################################################
# CASE ANALISYS
################################################################################
# Setting functional mode
set_case_analysis 0 [ get_ports {sc_sen }]

################################################################################
# CLOCK DEFINITIONS
################################################################################
create_clock -name "clk"            -period "$T_CLK" -waveform "$W_CLK" [ get_ports { clk } ]
create_clock -name "virtual_clk_in" -period "$T_CLK" -waveform "$W_CLK"
create_clock -name "virtual_clk"    -period "$T_CLK" -waveform "$W_CLK"

################################################################################
# INPUT DEFINITIONS
################################################################################

#Design input signals
set_input_delay -max $MAX_INPUT_DELAY -clock [get_clocks {virtual_clk_in}]  [ get_port { i_valid i_subsampling i_enable i_data_i i_data_q }]  
set_input_delay -min 0.7 -clock [get_clocks {virtual_clk_in}]  [ get_port { i_valid i_subsampling i_enable i_data_i i_data_q }]  

#Scan signals are static
set_false_path -from [ get_port { sc_di0 }]
set_false_path -from [ get_port { sc_di1 }]
set_false_path -from [ get_port { sc_di2 }]
set_false_path -from [ get_port { sc_di3 }]
set_false_path -from [ get_port { sc_di4 }]
set_false_path -from [ get_port { sc_cpren }]
set_false_path -from [ get_port { sc_spren }]


################################################################################
# OUTPUT DEFINITIONS
################################################################################

#Design output signals
set_output_delay -max $MAX_OUTPUT_DELAY -clock [get_clocks {virtual_clk}] [ get_port { o_fo_valid o_fo_value}]
set_output_delay -min 0.7 -clock [get_clocks {virtual_clk}] [ get_port { o_fo_valid o_fo_value}]

#Scan signals are static
set_false_path -to [ get_port { sc_do0 }]
set_false_path -to [ get_port { sc_do1 }]
set_false_path -to [ get_port { sc_do2 }]
set_false_path -to [ get_port { sc_do3 }]
set_false_path -to [ get_port { sc_do4 }]


################################################################################
# SET FALSE PATHS AND MULTICYCLES
################################################################################

set_false_path -from [get_ports { *i_static* }]  -to [all_registers]
set_false_path -from [get_ports { rst_async_n }] -to [all_registers]

################################################################################
# FINAL CONSTRAINTS
################################################################################

# CLOCK UNCERTAINTY
set_clock_uncertainty -setup $CLK_UNC_SETUP  [get_clocks {clk}]
set_clock_uncertainty -hold  $CLK_UNC_HOLD   [get_clocks {clk}]

# CLOCK TRANSITION
set_clock_transition -rise $CLK_TRANSITION [get_clocks {clk} ]
set_clock_transition -fall $CLK_TRANSITION [get_clocks {clk} ]

# CLOCK LATENCY
#set_clock_latency $CLK_LATENCY -rise [get_clocks {clk} ]
#set_clock_latency $CLK_LATENCY -fall [get_clocks {clk} ]

#  SET MAXIMUM TRANSITION
set_max_transition $MAX_INPUT_TRANS  [all_inputs]
set_max_transition $MAX_OUTPUT_TRANS [all_outputs]

# SET INPUT TRANSITION
set_input_transition $MAX_INPUT_TRANS -max [all_inputs]

# SET OUTPUT LOADS
set_load -pin_load $OUTPUT_LOAD [all_outputs]

#SET CAPACITANCE
set_max_capacitance $MAX_INPUT_CAP  [ all_inputs ]
set_max_capacitance $MAX_OUTPUT_CAP [ all_outputs ]

########################### UPDATE AFTER CTS ##############################
# CLOCK LATENCY
set_clock_latency 0.8 -rise [get_clocks {virtual_clk} ] #0 or 0.4 or 0.6
set_clock_latency 0.8 -fall [get_clocks {virtual_clk} ]


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

#set_propagated_clock [get_clocks {clk}]
