set O_TimingModelDir     ../../timing/edi
#set view_name tt_0p85v_25c_libset_nominal_25c_functional



###########################################################################
# io_latency in other views
###########################################################################

set setup_analysis_views  "ssa_0p81v_125c_libset_FuncRCmax_125c_functional \
                           ssa_0p81v_125c_libset_FuncRCmax_125c_scan_shift \
                           tt_0p85v_25c_libset_nominal_25c_functional      \
                           tt_0p85v_25c_libset_nominal_25c_scan_shift      \
                          "
set hold_analysis_views   "ffa_0p945v_0c_libset_FuncCmin_0c_functional     \
                           ffa_0p945v_0c_libset_FuncCmin_0c_scan_shift     \
                           "
set_interactive_constraint_modes [all_constraint_modes -active]
set_analysis_view -setup ${setup_analysis_views} -hold  ${hold_analysis_views}

set_global timing_enable_simultaneous_setup_hold_mode true

reset_propagated_clock [ get_clocks clk ]
reset_propagated_clock [ get_clocks cko]
reset_propagated_clock [ get_clocks sys_clk ]
reset_propagated_clock [ get_clocks jtag_clk ]
reset_propagated_clock [ get_clocks clk_sclk_shift ]
report_clocks

# Reset Ideal Clock Latency and Propagated Clock Latency
reset_clock_latency    [get_ports {clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {clk} ] -clock [all_clocks]

reset_clock_latency    [get_ports {clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {clk} ] -clock [all_clocks]

reset_clock_latency    [get_ports {Sys_clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {Sys_clk} ] -clock [all_clocks]

reset_clock_latency    [get_ports {CKO} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {CKO} ] -clock [all_clocks]

reset_clock_latency    [get_ports {jtag_tck} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {jtag_tck} ] -clock [all_clocks]

update_io_latency -source -verbose

#update_clock_latencies

set_global timing_enable_simultaneous_setup_hold_mode false

###########################################################################


set setup_analysis_views  "ssa_0p81v_m40c_libset_FuncRCmax_0c_functional   \
                           ssa_0p81v_m40c_libset_FuncRCmax_0c_scan_shift   \
                           ssa_0p81v_125c_libset_FuncRCmax_125c_functional \
                           ssa_0p81v_125c_libset_FuncRCmax_125c_scan_shift \
                           tt_0p85v_25c_libset_nominal_25c_functional      \
                           tt_0p85v_25c_libset_nominal_25c_scan_shift      \
                          "
set hold_analysis_views   "ffa_0p945v_125c_libset_FuncCmin_125c_functional \
                           ffa_0p945v_125c_libset_FuncCmin_125c_scan_shift \
                           ffa_0p945v_0c_libset_FuncCmin_0c_functional     \
                           ffa_0p945v_0c_libset_FuncCmin_0c_scan_shift     \
                           "

set_analysis_view -setup $setup_analysis_views -hold $hold_analysis_views

set_propagated_clock clk

set_propagated_clock cko

set_propagated_clock sys_clk

set_propagated_clock jtag_clk

set_propagated_clock clk_sclk_shift

report_clocks

createBasicPathGroups -expanded


setExtractRCMode -effortLevel medium 
setDelayCalMode -SIAware true 



foreach view_name [concat ${setup_analysis_views} ${hold_analysis_views} ] {
   set_analysis_view -setup $view_name -hold $view_name
   # Generate a liberty model. Not not use gz extension, this will stall the tool
   # Use gzip after model generation to compress
   do_extract_model -lib_name ${topmodule}_${outputExt}_lib -cell_name ${topmodule} -view ${view_name}\
        -include_aocv_weights -greybox ../../timing/edi/${topmodule}_${outputExt}_${view_name}.lib
   # you can get the clock latencies from the timing constraints
   #writeTimingCon -view ${view_name} ../../constraints/${topmodule}_${view_name}_${outputExt}.sdc.gz
} 
  
system mkdir -p  ../../models/${outputExt}
setIlmMode -async true
# This will make ILM models of all defined analysis views
createInterfaceLogic -dir ../../models/${outputExt} \
   -modelType timing -useType ilm -writeSDC
lefOut ${O_LefModel} -5.8 -specifyTopLayer 11 -stripePin -PGpinLayers 2 9 10 11 -extractBlockPGPinLayers 2 9 10 11



