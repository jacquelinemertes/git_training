#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : cts_ccopt.tcl                                                  #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for Clock tree implementation and timing      #
#                optimization with CCOpt
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        fe
set inputExt         place
set outputExt        cts_ccopt

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
set O_DataBase           ../../db/innovus/${topmodule}_${outputExt}.enc


#-------------------------------------------------------------------------------
# Load DB
#-------------------------------------------------------------------------------

#Must be loaded using all information using .db  
#Otherwise the optimization will result worse than previous step results !
source ${I_DataBase}

#suspend
#lefOut ../../physical/innovus/${topmodule}_place.lef
#-------------------------------------------------------------------------------
# Define the analysis views
#-------------------------------------------------------------------------------
set setup_analysis_views    "ssa_0p81v_m40c_libset_FuncRCmax_0c_functional \
                             ssa_0p81v_m40c_libset_FuncRCmax_0c_scan_shift \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_functional \
                             ssa_0p81v_125c_libset_FuncRCmax_125c_scan_shift \
                             "

set hold_analysis_views     "ffa_0p945v_125c_libset_FuncRCmin_125c_functional    \
                             ffa_0p945v_125c_libset_FuncRCmin_125c_scan_shift    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_functional    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_scan_shift  \
                             "
set power_analysis_view   "tt_0p85v_25c_libset_nominal_25c_functional"

#Fixing the virtual clocks
setExtractRCMode -reset

set_interactive_constraint_modes [all_constraint_modes -active]
set_analysis_view -setup ${setup_analysis_views} -hold ${hold_analysis_views}

set_power_analysis_mode -analysis_view ${power_analysis_view}
createBasicPathGroups -expanded


#-------------------------------------------------------------------------------
# Default settings
#-------------------------------------------------------------------------------
source ../../script/innovus/settings.tcl


# Standard procedures, always useful
source ../../script/innovus/util_stdProcedures.tcl

setMultiCpuUsage -localCpu 8 -keepLicense false -threadInfo 2 \
   -verbose -autoPageFaultMonitor 3

setPreference CmdLogMode 2

#suspend

#-------------------------------------------------------------------------------
# Global net connect rules needed for newly created instances.
#-------------------------------------------------------------------------------
#When read the .db doesn't need global connect again, 
#these connections are already done in the previous step

clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VDD -type pgpin -pin VNW -inst * -verbose
globalNetConnect VDD -type tiehi -verbose

globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
globalNetConnect VSS -type pgpin -pin VPW -inst * -verbose
globalNetConnect VSS -type tielo -verbose


#suspend


#-------------------------------------------------------------------------------
# Do  pre-cts settings
#-------------------------------------------------------------------------------
##Remove trial route wires
dbDeleteTrialRoute

#suspend
#-----------------------------------------------------------------------------
# CCOPT optimization
#----------------------------------------------------------------------------- 

# Placement settings
setPlaceMode -timingEffort low
setPlaceMode -doRPlace true -swapEEQ true -wireLenOptEffort high

# To reduce post CTS hold violations in scan mode, we will optimize the scanchain only after CTS
setPlaceMode -ignoreScan true
setScanReorderMode -skipMode skipNone

# Nanoroute settings (CCOpt will route the clock signal)
setNanoRouteMode -routeBottomRoutingLayer               2
setNanoRouteMode -routeTopRoutingLayer                  8
setNanoRouteMode -routeStrictlyHonorNonDefaultRule      true
setNanoRouteMode -routeInsertAntennaDiode		true
setNanoRouteMode -routeInsertDiodeForClockNets		true
setNanoRouteMode -routeReserveSpaceForMultiCut		true
setNanoRouteMode -routeWithTimingDriven 		true
setNanoRouteMode -routeWithSiDriven                     true
setNanoRouteMode -routeWithLithoDriven                  true
setNanoRouteMode -routeConcurrentMinimizeViaCountEffort high

#antenna cell defined into info  file
setNanoRouteMode -routeAntennaCellName  {ANTENNA3_A12TH_C30 ANTENNA3_A12TH_C34 ANTENNA3_A12TH_C38 \
					ANTENNA3_A12TL_C30 ANTENNA3_A12TL_C34 \
					ANTENNA3_A12TR_C30 ANTENNA3_A12TR_C34 ANTENNA3_A12TR_C38 }
setNanoRouteMode -routeInsertAntennaDiode		true
setNanoRouteMode -routeInsertDiodeForClockNets		true

# Optimisation settings
setOptMode -addInstancePrefix  FE_CTS_CCOPT
setOptMode -addNetPrefix       FE_CTS_CCOP_NET_
setOptMode -allEndPoints true -fixFanoutLoad true
setOptMode -timeDesignExpandedView true

suspend

# Run this comand to create auto clock tree spec and auto ccopt config tcl
#create_ccopt_clock_tree_spec -file ../../script/innovus/ccopt_spec.tcl


#These script has some commands from ccopt_spec.tcl and another commands
#described in the manual, needed by ccopt to defined the clock-tree correctly
source ../../script/innovus/ccopt_config.tcl
getAnalysisMode -aocv


#Check the definitions set by ccopt_config.tcl
ccopt_design -check_prerequisites -outDir ${REPORTS_PATH}

#suspend
#Implements and optimizes the clock tree
ccopt_design -outDir ${REPORTS_PATH}

get_ccopt_property primary_delay_corner

# Optimize scanchain
setScanReorderMode -reset
setScanReorderMode -clkAware true -scanEffort high -compLogic true
scanReorder 

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow -routing -scanChain $O_DefNetlist
lefOut $O_LefModel
saveDesign  $O_DataBase -def -tcon -rc


# Save models for possible use on toplevel
#system mkdir -p  ../../models/innovus/${outputExt}
#setIlmMode -keepAsync true

#saveModel -uniquifyCellNames -dir ../../models/${outputExt} -cts -sdf
#createInterfaceLogic -dir ../../models/innovus/${outputExt} \
#   -modelType timing -useType ilm -writeSDC

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
timeDesign -postCTS       -outDir $REPORTS_PATH -expandedViews -timingDebugReport -numPaths 10000
timeDesign -postCTS -hold -outDir $REPORTS_PATH -expandedViews -numPaths 1000

report_ccopt_clock_trees -file ${REPORTS_PATH}/report_ccopt_clock_trees.rpt 
report_ccopt_skew_groups -file ${REPORTS_PATH}/report_ccopt_skew_groups.rpt
report_ccopt_worst_chain -file ${REPORTS_PATH}/report_ccopt_worst_chain.rpt

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc
verify_drc       -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 100000
verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt

#report_power  -hierarchy  1 -outfile $REPORTS_PATH/report_power.rpt

#report_timing -check_clocks -path_type full_clock -max_paths 1000 > ${REPORTS_PATH}/rpt_timing_check_clk.rpt

suspend
#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } > ${REPORTS_PATH}/GetMetric.runtime.rpt

#Create lib model using do_extract_model
#source ../../script/innovus/create_lib_model.tcl

exit
