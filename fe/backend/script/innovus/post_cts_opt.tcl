#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : post_cts_opt.tcl                                               #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                              		#
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for post cts optimization                     #
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        fe       ;# Specify the top module of the Design
set inputExt         cts_ccopt
set outputExt        post_cts_opt

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

#----------------------------------------------------------------------------------------------
# Script control variables
#----------------------------------------------------------------------------------------------
set dynamic_static_power_optimisation false         ;# true or false

#-------------------------------------------------------------------------------
# Initialize the design
#-------------------------------------------------------------------------------
set init_verilog   ${I_VerilogNetlist}
set init_top_cell  ${topmodule}
set init_pwr_net   { VDD VNW }
set init_gnd_net   { VSS VPW}
set init_mmmc_file ${I_MMMCFile}

#-------------------------------------------------------------------------------
# Load DB
#-------------------------------------------------------------------------------

#Must be loaded using all information from ccopt, i.e. using .db  
#Otherwise the optimization will result worse than previous step results !
source ${I_DataBase}



#-------------------------------------------------------------------------------
# Define the analysis views. Not sure if we need al 4 views yet
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

suspend


#-------------------------------------------------------------------------------
# Global net connect rules needed for newly created instances.
#-------------------------------------------------------------------------------

#When read the .db doesn need global connect again, 
#these connections are already done in the previous step

clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VDD -type pgpin -pin VNW -inst * -verbose
globalNetConnect VDD -type tiehi -verbose

globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
globalNetConnect VSS -type pgpin -pin VPW -inst * -verbose
globalNetConnect VSS -type tielo -verbose


#suspend


#-----------------------------------------------------------------------------
# Timing analysis before post CTS optimization
#----------------------------------------------------------------------------- 

#timeDesign -postCTS       -outDir ${REPORTS_PATH}/pre_opt -expandedViews -timingDebugReport -numPaths 1000
#timeDesign -postCTS -hold -outDir ${REPORTS_PATH}/pre_opt -expandedViews -numPaths 1000

# Remove trial route wires
#dbDeleteTrialRoute

#suspend
#-----------------------------------------------------------------------------
# Post CTS optimization for SETUP
#----------------------------------------------------------------------------- 
setPlaceMode -powerDriven false
setOptMode -dynamicPowerEffort none -leakagePowerEffort none

setPlaceMode -reorderScan true -timingEffort medium
setPlaceMode -doRPlace true -swapEEQ true -wireLenOptEffort high

setOptMode -addInstancePrefix  FE_POST_CTS_
setOptMode -addNetPrefix       FE_POST_CTS_NET_
setOptMode -allEndPoints true -fixFanoutLoad true
setOptMode -reclaimArea true -optimizeFF true

optDesign -postCTS -outDir $REPORTS_PATH -expandedViews

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow  $O_DefNetlist
saveDesign  $O_DataBase -def -tcon


#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------

timeDesign -postCTS       -outDir $REPORTS_PATH -expandedViews -numPaths 10000
timeDesign -postCTS -hold -outDir $REPORTS_PATH -expandedViews -numPaths 10000


getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc

verify_drc       -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 10000
verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt


#report_power  -hierarchy  1 -outfile  $REPORTS_PATH/power_post_opt.rpt

# Remove trial route wires
#dbDeleteTrialRoute


suspend
#-------------------------------------------------------------------------------
#2nd  Round of optimization: DRV optimization 
#-------------------------------------------------------------------------------
# Remove trial route wires
dbDeleteTrialRoute

set STEP opt_drv

setOptMode -addInstancePrefix  FE_POST_CTS_DRV_
setOptMode -addNetPrefix       FE_POST_CTS_DRV_NET_
setOptMode -allEndPoints true -fixFanoutLoad true

optDesign -postCTS -drv -outDir $REPORTS_PATH/${STEP} -expandedViews

timeDesign -postCTS       -outDir $REPORTS_PATH/${STEP} -expandedViews -numPaths 1000
timeDesign -postCTS -hold -outDir $REPORTS_PATH/${STEP} -expandedViews -numPaths 1000

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc

verifyGeometry      -report ${REPORTS_PATH}/verifyGeometry.rpt     -error 1000000
verify_drc       -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 1000
#verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt


suspend

#-------------------------------------------------------------------------------
# Output the design for DRV
#-------------------------------------------------------------------------------
saveNetlist ${O_VerilogNetlist}_${STEP} 
defOut -netlist -floorplan -cutRow -ioRow  ${O_DefNetlist}_${STEP}
saveDesign  ${O_DataBase}_${STEP} -def -tcon -rc

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow  $O_DefNetlist
saveDesign  $O_DataBase -def -tcon


#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } >> ${REPORTS_PATH}/GetMetric.runtime.rpt

#exit
