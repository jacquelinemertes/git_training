set setup_analysis_views    "ssa_0p81v_m40c_libset_FuncRCmax_0c_functional \
                             ssa_0p81v_m40c_libset_FuncRCmax_0c_scan_shift \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_functional \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_scan_shift \
                             ssa_0p81v_m40c_libset_FuncCmax_0c_functional \
                             ssa_0p81v_m40c_libset_FuncCmax_0c_scan_shift \
                             ssa_0p81v_125c_libset_FuncCmax_125c_functional \
                             ssa_0p81v_125c_libset_FuncCmax_125c_scan_shift \
                             ffa_0p945v_125c_libset_FuncRCmin_125c_functional \
                             ffa_0p945v_125c_libset_FuncRCmin_125c_scan_shift \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_functional \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_scan_shift \
                             ffa_0p945v_125c_libset_FuncCmin_125c_functional \
                             ffa_0p945v_125c_libset_FuncCmin_125c_scan_shift \
                             ffa_0p945v_0c_libset_FuncCmin_0c_functional \
                             ffa_0p945v_0c_libset_FuncCmin_0c_scan_shift \
                             tt_0p85v_25c_libset_nominal_25c_functional \
                             tt_0p85v_25c_libset_nominal_25c_scan_shift            \
                             "

set hold_analysis_views     "ffa_0p945v_125c_libset_FuncRCmin_125c_functional    \
                             ffa_0p945v_125c_libset_FuncRCmin_125c_scan_shift    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_functional    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_scan_shift  \
                             ffa_0p945v_125c_libset_FuncCmin_125c_functional    \
                             ffa_0p945v_125c_libset_FuncCmin_125c_scan_shift    \
                             ffa_0p945v_0c_libset_FuncCmin_0c_functional    \
                             ffa_0p945v_0c_libset_FuncCmin_0c_scan_shift  \
                             ssa_0p81v_m40c_libset_FuncRCmax_0c_functional \
                             ssa_0p81v_m40c_libset_FuncRCmax_0c_scan_shift \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_functional \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_scan_shift \
                             ssa_0p81v_m40c_libset_FuncCmax_0c_functional \
                             ssa_0p81v_m40c_libset_FuncCmax_0c_scan_shift \
                             ssa_0p81v_125c_libset_FuncCmax_125c_functional \
                             ssa_0p81v_125c_libset_FuncCmax_125c_scan_shift \
                             tt_0p85v_25c_libset_nominal_25c_functional   \
                             tt_0p85v_25c_libset_nominal_25c_scan_shift \
                             "

set power_analysis_view   "tt_0p85v_25c_libset_nominal_25c_functional"

set_analysis_view -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_interactive_constraint_modes [all_constraint_modes -active]  

update_constraint_mode -name functional_signoff   -sdc_files {  ../../constraints/adc_adapt_base_signoff.sdc  ../../constraints/adc_adapt_functional.sdc }
update_constraint_mode -name scan_shift_signoff   -sdc_files {  ../../constraints/adc_adapt_base_signoff.sdc  ../../constraints/adc_adapt_scan_shift.sdc }


set_analysis_view -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_interactive_constraint_modes [all_constraint_modes -active]  


set_interactive_constraint_modes [all_constraint_modes -active]  
set_global timing_enable_simultaneous_setup_hold_mode true

set_interactive_constraint_modes [all_constraint_modes -active]

reset_propagated_clock [all_clocks]
reset_propagated_clock [get_ports clk ]
reset_propagated_clock [get_ports Sys_clk ]
reset_propagated_clock [get_ports CKO ]
reset_propagated_clock [get_ports jtag_tck ]

# Reset Ideal Clock Latency and propagated clock latency
reset_clock_latency    [get_ports {clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {clk} ] -clock [all_clocks]

reset_clock_latency    [get_ports {Sys_clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {Sys_clk} ] -clock [all_clocks]

reset_clock_latency    [get_ports {CKO} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {CKO} ] -clock [all_clocks]

reset_clock_latency    [get_ports {jtag_tck} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {jtag_tck} ] -clock [all_clocks]

update_io_latency -source  -verbose

set_global timing_enable_simultaneous_setup_hold_mode false

