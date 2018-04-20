#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : ccop_config.tcl                                                #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Setup script for Clock Tree Concurrent Optimization            #
#*******************************************************************************#

#************************************************************************************
# These options was adapted from Jeroen's script
#************************************************************************************

# CCOpt settings
#set_ccopt_property effort high
#set_ccopt_mode -cts_opt_priority  power

set_ccopt_property update_io_latency true

set_ccopt_mode -cts_opt_priority insertion_delay

# Define which cells to use. Only HVt, skip the delay cells for the clock tree, wider gates (lower leakage)
# The cells set defined by Jeroen was around 30 cells. Decreasing the number of cells to 5 or 6 cells, reduces the choices to the tool, so decreases the runtime.
set_ccopt_property inverter_cells     {    INV_X0P5B_A12TR_C38     INV_X0P6B_A12TR_C38    INV_X0P7B_A12TR_C38    INV_X0P8B_A12TR_C38   INV_X11B_A12TR_C38    INV_X13B_A12TR_C38    INV_X16B_A12TR_C38    INV_X1B_A12TR_C38    INV_X1P2B_A12TR_C38    INV_X1P4B_A12TR_C38   INV_X1P7B_A12TR_C38    INV_X2B_A12TR_C38    INV_X2P5B_A12TR_C38    INV_X3B_A12TR_C38    INV_X3P5B_A12TR_C38    INV_X4B_A12TR_C38   INV_X5B_A12TR_C38    INV_X6B_A12TR_C38    INV_X7P5B_A12TR_C38    INV_X9B_A12TR_C38    INV_X0P5B_A12TH_C38 INV_X0P6B_A12TH_C38 INV_X0P7B_A12TH_C38 INV_X0P8B_A12TH_C38 INV_X11B_A12TH_C38 INV_X13B_A12TH_C38 INV_X16B_A12TH_C38 INV_X1B_A12TH_C38 INV_X1P2B_A12TH_C38 INV_X1P4B_A12TH_C38 INV_X1P7B_A12TH_C38 INV_X2B_A12TH_C38 INV_X2P5B_A12TH_C38 INV_X3B_A12TH_C38 INV_X3P5B_A12TH_C38 INV_X4B_A12TH_C38 INV_X5B_A12TH_C38 INV_X6B_A12TH_C38 INV_X7P5B_A12TH_C38 INV_X9B_A12TH_C38 }

set_ccopt_property clock_gating_cells {    PREICG_X0P5B_A12TR_C38    PREICG_X0P7B_A12TR_C38    PREICG_X0P8B_A12TR_C38    PREICG_X11B_A12TR_C38    PREICG_X13B_A12TR_C38    PREICG_X16B_A12TR_C38    PREICG_X1B_A12TR_C38    PREICG_X1P2B_A12TR_C38    PREICG_X1P4B_A12TR_C38    PREICG_X1P7B_A12TR_C38    PREICG_X2B_A12TR_C38    PREICG_X2P5B_A12TR_C38    PREICG_X3B_A12TR_C38    PREICG_X3P5B_A12TR_C38    PREICG_X4B_A12TR_C38    PREICG_X5B_A12TR_C38    PREICG_X6B_A12TR_C38    PREICG_X7P5B_A12TR_C38    PREICG_X9B_A12TR_C38 PREICG_X0P5B_A12TH_C38 PREICG_X0P7B_A12TH_C38 PREICG_X0P8B_A12TH_C38 PREICG_X11B_A12TH_C38 PREICG_X13B_A12TH_C38 PREICG_X16B_A12TH_C38 PREICG_X1B_A12TH_C38 PREICG_X1P2B_A12TH_C38 PREICG_X1P4B_A12TH_C38 PREICG_X1P7B_A12TH_C38 PREICG_X2B_A12TH_C38 PREICG_X2P5B_A12TH_C38 PREICG_X3B_A12TH_C38 PREICG_X3P5B_A12TH_C38 PREICG_X4B_A12TH_C38 PREICG_X5B_A12TH_C38 PREICG_X6B_A12TH_C38 PREICG_X7P5B_A12TH_C38 PREICG_X9B_A12TH_C38 }


# Source base constraint to get T_CLK variable values
source ../../constraints/fe_base.sdc 

#### Clock definitions #######################
# Clocks present at pin clk
#   clk in timing_config functional (period 1.960ns)
#   clk_sclk_shift in timing_config scan_shift (period 100.000ns)
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property source_driver -clock_tree clk {BUF_X4B_A12TH_C34/A BUF_X4B_A12TH_C34/Y}
set_ccopt_property source_max_capacitance -clock_tree clk 0.080
# Clock period setting for source pin of clk
set_ccopt_property clock_period -pin clk ${T_CLK}

# Clock period setting for source pin of clk
#set_ccopt_property clock_period -pin clk ${T_CLK}
#set_ccopt_property source_driver -clock_tree clk {BUF_X4B_A12TH_C34/A BUF_X4B_A12TH_C34/Y}
#set_ccopt_property source_max_capacitance -clock_tree clk 0.080

# Duty factor (DF) is the maximum percentage of time the net transitions within a clock cycle.
# The ARM guideline is 10% for clock nets and 20% for data nets.

set_ccopt_property -net_type trunk target_max_trans [expr  ${T_CLK} * 0.1 ]
set_ccopt_property -net_type leaf  target_max_trans [expr  ${T_CLK} * 0.1 ]
set_ccopt_property -net_type top   target_max_trans [expr  ${T_CLK} * 0.1 ]


#set_ccopt_property -net_type trunk target_max_trans 0.15
#set_ccopt_property -net_type leaf  target_max_trans 0.15
#set_ccopt_property -net_type top   target_max_trans 0.15

# Set the target skew. CCopt is quite accurate in reaching these
#set_ccopt_property target_skew -early 0.1
#set_ccopt_property target_skew -late  0.1

set_ccopt_property target_skew -early [expr  ${T_CLK} * 0.2 ]
set_ccopt_property target_skew -late  [expr  ${T_CLK} * 0.2 ]


set_ccopt_property use_inverters -clock_tree clk true


# Skew group to balance non generated clock:clk in timing_config:functional (sdc /net/proj/dspgreen/workarea/jacqueline.mertes/build/adc_adapt/backend/db/edi/adc_adapt_place_db.enc.dat/mmmc/modes/functional/functional.sdc)
create_ccopt_skew_group -name clk/functional -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/functional true
set_ccopt_property extracted_from_clock_name -skew_group clk/functional clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/functional functional
set_ccopt_property extracted_from_delay_corners -skew_group clk/functional {ssa_0p81v_m40c_libset_FuncRCmax ssa_0p81v_125c_libset_FuncRCmax ffa_0p945v_125c_libset_FuncRCmin ffa_0p945v_0c_libset_FuncRCmin}


# turn on multi-corner CTS
set_ccopt_property -skew_group * -delay_corner * -late target_skew auto
set_ccopt_property -skew_group * -delay_corner * -early target_skew auto


# Clock routing definition
#create_route_type -name shieldRoute -shield_net VSS ...
#set_ccopt_property route_type shieldRoute -net_type trunk
#set_ccopt_property route_type shieldRoute -net_type leaf

# Define NDR for clock tree routing
#set_ccopt_mode -route_top_bottom_preferred_layer M2
#set_ccopt_mode -route_top_top_preferred_layer    B2
set_ccopt_mode -route_top_bottom_preferred_layer M2
set_ccopt_mode -route_top_top_preferred_layer    B2

# Create NDR only if it not already exists
#if {[lsearch [ dbGet head.rules.name ] default_2x_width_2x_space] < 0} {
   add_ndr -name default_2x_width_2x_space -width { M2:M6 0.134 } -spacing {M2:M6 0.1 B1:B2 0.2} -min_cut {V2:W1 2} -generate_via
#}

generateVias -enclosure { \
{{V2} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V3} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V4} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V5} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
} -ndr_only

modify_ndr -name default_2x_width_2x_space -via [dbGet head.rules.vias.name default_2x_width_2x_space_VXBAR_ENCL*]
   
create_route_type -name leaf_routing  -top_preferred_layer M5 -bottom_preferred_layer M4 -shield_net VSS -bottom_shield_layer M4 -non_default_rule default_2x_width_2x_space
create_route_type -name trunk_routing -top_preferred_layer B2 -bottom_preferred_layer B1 -shield_net VSS -bottom_shield_layer M4 -non_default_rule default_2x_width_2x_space
create_route_type -name top_routing   -top_preferred_layer B2 -bottom_preferred_layer B1 -shield_net VSS -bottom_shield_layer M4 -non_default_rule default_2x_width_2x_space

set_ccopt_property -net_type leaf  route_type leaf_routing 
set_ccopt_property -net_type trunk route_type trunk_routing 
set_ccopt_property -net_type top   route_type top_routing 

check_ccopt_clock_tree_convergence

generateVias -enclosure { \
{{V2} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V3} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V4} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
{{V5} {ndr default_2x_width_2x_space} {num_cuts 2} {0.025 0.025 0.025 0.025} {cut_class VXBAR}} \
} -ndr_only

modify_ndr -name default_2x_width_2x_space -via [dbGet head.rules.vias.name default_2x_width_2x_space_VXBAR_ENCL*]
 
