#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : post_route_opt_signoff.tcl                                     #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for placement and post place optimization     #
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        adc_adapt       ;# Specify the top module of the Design
set inputExt         post_route_opt_iqrc
set outputExt        post_route_opt_signoff

source ../../script/innovus/globals.tcl

#----------------------------------------------------------------------------------------------
# Set pointers to input and output files
#----------------------------------------------------------------------------------------------
set I_VerilogNetlist     ../../structural/innovus/${topmodule}_${inputExt}.v.gz
set I_MMMCFile           ../../script/innovus/mmmc.tcl
set I_DefNetlist         ../../physical/innovus/${topmodule}_${inputExt}.def.gz
set I_ScanDef            ../../../design/structural/rc/${topmodule}.scan.def.gz
set I_DataBase           ../../db/innovus/${topmodule}_${inputExt}.enc

set O_DefNetlist         ../../physical/innovus/${topmodule}_${outputExt}.def.gz
set O_LefModel           ../../physical/innovus/${topmodule}_${outputExt}.lef.gz
set O_VerilogNetlist     ../../structural/innovus/${topmodule}_${outputExt}.v.gz
set O_VerilogNetlistPhysical     ../../structural/innovus/${topmodule}_${outputExt}_phys.v.gz
set O_DataBase           ../../db/innovus/${topmodule}_${outputExt}.enc


#-------------------------------------------------------------------------------
# Load DB
#-------------------------------------------------------------------------------
#Must be loaded using all information from ccopt, i.e. using .enc  
#Otherwise the optimization will result worse than previous step results !
source ${I_DataBase}


#suspend

#-------------------------------------------------------------------------------
# Default settings
#-------------------------------------------------------------------------------
source ../../script/innovus/settings.tcl

# Standard procedures, always useful
source ../../script/innovus/util_stdProcedures.tcl
source ../../script/innovus/util_genGDS.tcl

setMultiCpuUsage -localCpu 16 -keepLicense false -threadInfo 2 \
   -verbose -autoPageFaultMonitor 3

setPreference CmdLogMode 2

#-------------------------------------------------------------------------------
# Define the analysis views
#-------------------------------------------------------------------------------

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

set_interactive_constraint_modes [all_constraint_modes -active]
set_analysis_view -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_propagated_clock [all_clocks]

set_power_analysis_mode -analysis_view ${power_analysis_view}
createBasicPathGroups -expanded

#suspend


#-----------------------------------------------------------------------------
# Post route optimization, settings
#-----------------------------------------------------------------------------

setNanoRouteMode -routeConcurrentMinimizeViaCountEffort low
setOptMode -ignorePathGroupsForHold { reg2out in2reg in2out }
setOptMode -timeDesignCompressReports false

# Read activity file
#read_activity_file  ../../../design/timing/tcf/adc_adapt.tcf -format TCF -scope uu_adc_adapt -block adc_adapt

setOptMode -addInstancePrefix   			FE_POST_ROUTE_
setOptMode -addNetPrefix        			FE_POST_ROUTE_NET_
setOptMode -allEndPoints 			 	true 
setOptMode -fixFanoutLoad  				true
setOptMode -postRouteAreaReclaim  			setupAware
setOptMode -reclaimArea true -optimizeFF true

# Use QRC standalone for signoff parasitic extraction. Restrict to 6 CPU (7 QRC GXL licenses available)
#setExtractRCMode -reset
setExtractRCMode -engine postRoute

#setExtractRCMode -effortLevel medium 
#setExtractRCMode -effortLevel high
setExtractRCMode -effortLevel signoff

setExtractRCMode -lefTechFileMap ../../script/innovus/lefTechFileMap.map
setExtractRCMode -qrcCmdFile ../../script/innovus/qrc_command.tcl -qrcCmdType partial

# as this is the final step, we must know where we extrapolate outside the timing tables
setDelayCalMode -SIAware true -reportOutBound true 

# This option is default, just to remember that it can be changed.
setSIMode -analysisType aae 

setOptMode -ignorePathGroupsForHold { reg2out in2reg in2out }

getReport { getAnalysisMode } 	> ${REPORTS_PATH}/analysisMode.rpt
getReport { getExtractRCMode } 	> ${REPORTS_PATH}/extractRCMode.rpt
getReport { getOptMode } 	> ${REPORTS_PATH}/optMode.rpt
getReport { getDelayCalMode } 	> ${REPORTS_PATH}/delayCalMode.rpt
getReport { getNanoRouteMode } 	> ${REPORTS_PATH}/nanoRouteMode.rpt
get_global timing_apply_default_primary_input_assertion

#suspend

#-------------------------------------------------------------------------------
# Update IO Latency for all Corners listed above
#-------------------------------------------------------------------------------
#reset propagated clock to update IO latency
set_global timing_enable_simultaneous_setup_hold_mode true
set_interactive_constraint_modes [all_constraint_modes -active]

reset_propagated_clock [all_clocks]
reset_propagated_clock [get_ports clk ]

# Reset Idela Clock Latency and propagated clock latency
reset_clock_latency    [get_ports {clk} ] -clock [all_clocks]
reset_clock_latency  -source  [get_ports {clk} ] -clock [all_clocks]

update_io_latency -source  -verbose

set_global timing_enable_simultaneous_setup_hold_mode false

#-----------------------------------------------------------------------------
# Post route optimization
#-----------------------------------------------------------------------------

setOptMode -postRouteAreaReclaim holdAndSetupAware

#Remove density block to open sapce to post route
timeDesign -postRoute             -outDir ${REPORTS_PATH}/before      -expandedViews    -timingDebugReport
timeDesign -postRoute -hold       -outDir ${REPORTS_PATH}/before      -expandedViews    -timingDebugReport
#suspend

optDesign -postRoute -hold -setup -outDir $REPORTS_PATH/setup_hold    -expandedViews    -holdVioData $REPORTS_PATH/setup_hold/holdunfixedvio

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
clearDrc       

verifyConnectivity   -type all       -error 1000 -report ${REPORTS_PATH}//$topmodule.verifyconnectivity.rpt.route_pre_drc
verify_drc       -check_only regular -error 10000 -report ${REPORTS_PATH}//$topmodule.verifydrc.rpt.route_pre_drc
verifyProcessAntenna                 -error 1000 -report ${REPORTS_PATH}/$topmodule.verifyantenna.rpt.route_pre_drc
#resume

timeDesign -postRoute       -outDir ${REPORTS_PATH}/final -expandedViews -timingDebugReport
timeDesign -postRoute -hold -outDir ${REPORTS_PATH}/final -expandedViews  -timingDebugReport

ecoRoute

verifyConnectivity   -type all       -error 1000 -report ${REPORTS_PATH}/$topmodule.verifyconnectivity.rpt.eco_route_1
verify_drc       -check_only regular -error 10000 -report ${REPORTS_PATH}/$topmodule.verifydrc.rpt.eco_route_1
verifyProcessAntenna                 -error 1000 -report ${REPORTS_PATH}/$topmodule.verifyantenna.rpt.eco_route_1

saveDesign  $O_DataBase.pre_metalFill -def -tcon
#suspend

#Update signoff constraints and io latency
source ../../script/innovus/activeSignoffViews.tcl

#metalFill
deleteMetalFill -shapes { FILLWIRE FILLWIREOPC } -mode all
addMetalFill -layer { M1 M2 M3 M4 M5 M6 B1 B2 IA IB LB } -squareShape -timingAware sta -slackThreshold 0.050

checkPlace

addFiller -doDRC true -ecoMode true -fixDRC -cell  {FILL2_A12TH_C38 FILL2_A12TH_C34 FILL2_A12TH_C30 FILL1_A12TH_C38 FILL1_A12TH_C34 FILL1_A12TH_C30 FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

addFiller -diffCellViol true -minHoleCheck -doDRC true -cell {FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

checkPlace

addFiller -doDRC true -ecoMode true -fixDRC -cell  {FILL2_A12TH_C38 FILL2_A12TH_C34 FILL2_A12TH_C30 FILL1_A12TH_C38 FILL1_A12TH_C34 FILL1_A12TH_C30 FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

checkPlace
addFiller -diffCellViol true -minHoleCheck -doDRC true -cell {FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 }

checkPlace


timeDesign -postRoute       -outDir ${REPORTS_PATH}/signoff -expandedViews -timingDebugReport
timeDesign -postRoute -hold -outDir ${REPORTS_PATH}/signoff -expandedViews  -timingDebugReport


#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
saveDesign  $O_DataBase -def -tcon 
defOut -netlist -floorplan -cutRow -ioRow -routing -scanChain $O_DefNetlist

gds_write_full ${topmodule} ${outputExt} ../../physical/innovus

#saveCPF ${O_CPF}

# Save SDC, SDF, and TWF for each unique analysis view
lappend view_list
foreach view_name [concat ${setup_analysis_views} ${hold_analysis_views} ${power_analysis_view} ] {
   if { ${view_name} ni ${view_list} } {
      lappend view_list ${view_name}
      writeTimingCon -view ${view_name} ../../constraints/${topmodule}_${outputExt}_${view_name}.sdc.gz
#      write_timing_windows -view ${view_name} -power_compatible ../../timing/${topmodule}_${outputExt}_${view_name}.twf.gz
#      write_sdf -recompute_parallel_arcs -version 3.0 -precision 4  -view ${view_name} ../../timing/${topmodule}_${outputExt}_${view_name}.sdf.gz
   }
}

# Save models for possible use on toplevel
#system mkdir -p  ../../models/innovus/${outputExt}
#setIlmMode -async true

#saveModel -uniquifyCellNames -dir ../../models/${outputExt} -cts -sdf
#createInterfaceLogic -dir ../../models/innovus/${outputExt} -useType ilm -writeSDC -modelType timing

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
setSIMode -enable_glitch_report true 
timeDesign -signOff       -outDir $REPORTS_PATH -expandedViews -timingDebugReport -numPaths 5000
timeDesign -signOff -hold -outDir $REPORTS_PATH -expandedViews -numPaths 5000

suspend

#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } > ${REPORTS_PATH}/GetMetric.runtime.rpt


#exit
