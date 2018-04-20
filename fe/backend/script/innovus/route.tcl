#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : route.tcl                                                      #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for signal routing with Nanoroute             #
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        fe       
set inputExt         post_cts_opt
#set inputExt         cts_ccopt
set outputExt        route

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

#Must be loaded using all information from ccopt, i.e. using .db  
#Otherwise the optimization will result worse than previous step results !
source ${I_DataBase}

#suspend

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

set_interactive_constraint_modes [all_constraint_modes -active]
set_analysis_view -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_propagated_clock [all_clocks]

set_power_analysis_mode -analysis_view ${power_analysis_view}
createBasicPathGroups -expanded
#suspend

#-------------------------------------------------------------------------------
# Default settings
#-------------------------------------------------------------------------------
source ../../script/innovus/settings.tcl

# Standard procedures, always useful
source ../../script/innovus/util_stdProcedures.tcl
source ../../script/innovus/util_genGDS.tcl


setMultiCpuUsage -localCpu 8 -keepLicense false -threadInfo 2 \
   -verbose -autoPageFaultMonitor 3

setPreference CmdLogMode 2
#suspend
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




#----------------------------------------------------------------------------- 
# Place decoupling and fillers
#----------------------------------------------------------------------------- 
deleteFiller -prefix DECAP_FILLER

addFiller -minHole true -doDRC true -viaEnclosure true
checkPlace
#Check geometry
verify_drc      -report ${REPORTS_PATH}/verify_drc_preroute.rpt     -limit 1000000

suspend

#If needed add more fillers, run these commands
#checkPlace

#addFiller -doDRC true -ecoMode true -fixDRC -cell  {FILL2_A12TH_C38 FILL2_A12TH_C34 FILL2_A12TH_C30 FILL1_A12TH_C38 FILL1_A12TH_C34 FILL1_A12TH_C30 FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

#addFiller -diffCellViol true -minHoleCheck -doDRC true -cell {FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

#checkPlace

#addFiller -doDRC true -ecoMode true -fixDRC -cell  {FILL2_A12TH_C38 FILL2_A12TH_C34 FILL2_A12TH_C30 FILL1_A12TH_C38 FILL1_A12TH_C34 FILL1_A12TH_C30 FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 FILL2_A12TL_C34  FILL2_A12TL_C30  FILL1_A12TL_C34  FILL1_A12TL_C30}

#checkPlace
#addFiller -diffCellViol true -minHoleCheck -doDRC true -cell {FILL2_A12TR_C38  FILL2_A12TR_C34  FILL2_A12TR_C30  FILL1_A12TR_C38  FILL1_A12TR_C34  FILL1_A12TR_C30 }


checkPlace



#-----------------------------------------------------------------------------
# Route Design: Settings
#----------------------------------------------------------------------------- 

#antenna cell defined into info  file
setNanoRouteMode -routeAntennaCellName  {ANTENNA3_A12TH_C30 ANTENNA3_A12TH_C34 ANTENNA3_A12TH_C38 \
					ANTENNA3_A12TL_C30 ANTENNA3_A12TL_C34 \
					ANTENNA3_A12TR_C30 ANTENNA3_A12TR_C34 ANTENNA3_A12TR_C38 }
# Nanoroute Settings
setNanoRouteMode -routeStrictlyHonorNonDefaultRule true
setNanoRouteMode -routeInsertAntennaDiode		true
setNanoRouteMode -routeInsertDiodeForClockNets		true
setNanoRouteMode -routeReserveSpaceForMultiCut		true
#setNanoRouteMode -routeDesignFixClockNets 		true
setNanoRouteMode -routeWithTimingDriven 		true
setNanoRouteMode -routeWithSiDriven                     true
setNanoRouteMode -routeWithLithoDriven                  true

setNanoRouteMode -routeConcurrentMinimizeViaCountEffort medium

# Wire optimisation
setNanoRouteMode -droutePostRouteSpreadWire    true

# Restrict the signal routing to these layers, the upper ones are to course to be useful.
setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -routeTopRoutingLayer    8


#-----------------------------------------------------------------------------
#  Route Design: Signal routing
#-----------------------------------------------------------------------------
getAnalysisMode -aocv
setAnalysisMode -aocv true

# Cleanup the design first
dbDeleteTrialRoute

## Placement Check
routeDesign -placementcheck

#Verify if the clock routing is still correct
routeDesign -clockEco

## Global routing
routeDesign -globalDetail

# extra search and repair stages
setNanoRouteMode -drouteStartIteration 1 
setNanoRouteMode -drouteEndIteration 1 
detailRoute 

setNanoRouteMode -drouteStartIteration 2 
setNanoRouteMode -drouteEndIteration 20 
detailRoute 

verifyConnectivity   -type all       -error 10000 -report ${REPORTS_PATH}/$topmodule.verifyconnectivity.rpt.detailroute_pre_drc
verify_drc  -check_only regular    -report ${REPORTS_PATH}/$topmodule.verifygeometry.rpt.detailroute_pre_drc -limit 10000
verifyProcessAntenna                 -error 4000 -report ${REPORTS_PATH}/$topmodule.verifyantenna.rpt.detailroute_pre_drc

saveDesign $O_DataBase.detail

#-----------------------------------------------------------------------------
#  Route Design: Increase multi cut via count
#-----------------------------------------------------------------------------
setNanoRouteMode -drouteUseMultiCutViaEffort            medium
setNanoRouteMode -droutePostRouteSwapVia                multiCut 
setNanoRouteMode -droutePostRouteSwapViaPriority        allNets
setNanoRouteMode -droutePostRouteSpreadWire             false
setNanoRouteMode -routeWithTimingDriven false
setNanoRouteMode -routeConcurrentMinimizeViaCountEffort medium

routeDesign -detail -viaOpt
saveDesign  $O_DataBase.viaopt
clearDrc       

verifyConnectivity   -type all       -error 4000 -report ${REPORTS_PATH}/$topmodule.verifyconnectivity.rpt.vaiopt_route_pre_drc
verify_drc -check_only regular -limit 40000 -report ${REPORTS_PATH}/$topmodule.verifygeometry.rpt.vaiopt_route_pre_drc
verifyProcessAntenna  -error 4000 -report ${REPORTS_PATH}/$topmodule.verifyantenna.rpt.vaiopt_route_pre_drc

suspend

editDeleteViolations -keep_fixed
ecoRoute -fix_drc


#setNanoRouteMode -routeWithTimingDriven 		false
#setNanoRouteMode -routeConcurrentMinimizeViaCountEffort medium


#clearDrc
#verifyGeometry       -regRoutingOnly -error 10000 -report ${REPORTS_PATH}/$topmodule.verifygeometry.ecoRt1.rpt.route
#ecoRoute
#verifyGeometry       -regRoutingOnly -error 10000 -report ${REPORTS_PATH}/$topmodule.verifygeometry.ecoRt2.rpt.route

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow -routing -scanChain $O_DefNetlist
lefOut $O_LefModel
saveDesign  $O_DataBase -def -tcon


# Save SDC files and TWF for each analysis view
lappend view_list
foreach view_name [concat ${setup_analysis_views} ${hold_analysis_views} ${power_analysis_view} ] {
   if { ${view_name} ni ${view_list} } {
      lappend view_list ${view_name}
#      writeTimingCon -view ${view_name} ../../constraints/${topmodule}_${outputExt}_${view_name}.sdc.gz
   }
}

# Save models for possible use on toplevel
system mkdir -p  ../../models/innovus/${outputExt}
setIlmMode -keepAsync true

#saveModel -uniquifyCellNames -dir ../../models/${outputExt} -cts -sdf
#createInterfaceLogic -dir ../../models/innovus/${outputExt} \
#   -modelType timing -useType ilm -writeSDC

#Save gds to run physical verification
#gds_write_full ${topmodule} ${outputExt} ../../physical/innovus

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
timeDesign -postRoute       -outDir ${REPORTS_PATH} -expandedViews -timingDebugReport -numPaths 10000
timeDesign -postRoute -hold -outDir ${REPORTS_PATH} -expandedViews -timingDebugReport -numPaths 10000

report_ccopt_clock_trees -file ${REPORTS_PATH}/report_ccopt_clock_trees.rpt 
report_ccopt_skew_groups -file ${REPORTS_PATH}/report_ccopt_skew_groups.rpt
report_ccopt_worst_chain -file ${REPORTS_PATH}/report_ccopt_worst_chain.rpt

# Enable the power analysis view and calculate the power
set_analysis_view -setup ${power_analysis_view} -hold ${power_analysis_view}
report_power                -outfile  ${REPORTS_PATH}/report_power.rpt
report_power  -hierarchy  2 -outfile  ${REPORTS_PATH}/report_power_hier.rpt

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc

verify_drc       -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 100000
verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt



#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } > ${REPORTS_PATH}/GetMetric.runtime.rpt


#exit
