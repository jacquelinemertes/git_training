#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : post_route_opt_iqrc.tcl                                        #
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
set topmodule        fe       ;# Specify the top module of the Design
set inputExt         post_route_opt
set outputExt        post_route_opt_iqrc

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

setMultiCpuUsage -localCpu 8 -keepLicense false -threadInfo 2 \
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
                             "

set hold_analysis_views     "ffa_0p945v_125c_libset_FuncRCmin_125c_functional    \
                             ffa_0p945v_125c_libset_FuncRCmin_125c_scan_shift    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_functional    \
                             ffa_0p945v_0c_libset_FuncRCmin_0c_scan_shift  \
                             ffa_0p945v_125c_libset_FuncCmin_125c_functional    \
                             ffa_0p945v_125c_libset_FuncCmin_125c_scan_shift    \
                             ffa_0p945v_0c_libset_FuncCmin_0c_functional    \
                             ffa_0p945v_0c_libset_FuncCmin_0c_scan_shift  \
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

# Read activity file
#read_activity_file  ../../../design/timing/tcf/fe.tcf -format TCF -scope uu_fe -block fe

setOptMode -addInstancePrefix   			FE_POST_ROUTE_IQRC_
setOptMode -addNetPrefix        			FE_POST_ROUTE_IQRC_NET_
setOptMode -allEndPoints 			 	true 
setOptMode -fixFanoutLoad  				true
setOptMode -postRouteAreaReclaim  			setupAware

# Use QRC standalone for signoff parasitic extraction. Restrict to 4 PU (2 QRC GXL licenses available)
#setExtractRCMode -reset
setExtractRCMode -engine postRoute

setExtractRCMode -effortLevel medium 
#setExtractRCMode -effortLevel high
#setExtractRCMode -effortLevel signoff

setExtractRCMode -lefTechFileMap ../../script/innovus/lefTechFileMap.map
setExtractRCMode -qrcCmdFile ../../script/innovus/qrc_command.tcl -qrcCmdType partial

# as this is the final step, we must know where we extrapolate outside the timing tables
setDelayCalMode -SIAware true -reportOutBound true 

# This option is default, just to remember that it can be changed.
setSIMode -analysisType aae 


getReport { getAnalysisMode } 	> ${REPORTS_PATH}/analysisMode.rpt
getReport { getExtractRCMode } 	> ${REPORTS_PATH}/extractRCMode.rpt
getReport { getOptMode } 	> ${REPORTS_PATH}/optMode.rpt
getReport { getDelayCalMode } 	> ${REPORTS_PATH}/delayCalMode.rpt
getReport { getNanoRouteMode } 	> ${REPORTS_PATH}/nanoRouteMode.rpt
get_global timing_apply_default_primary_input_assertion


suspend
#-----------------------------------------------------------------------------
# Post route optimization for setup
#-----------------------------------------------------------------------------
optDesign -postRoute       -outDir $REPORTS_PATH/setup -expandedViews

#-------------------------------------------------------------------------------
# Output setup optmized design
#-------------------------------------------------------------------------------
saveDesign  $O_DataBase.setup -def -tcon

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
timeDesign -postRoute       -outDir ${REPORTS_PATH}/setup -expandedViews -timingDebugReport
timeDesign -postRoute -hold -outDir ${REPORTS_PATH}/setup -expandedViews  -timingDebugReport

#suspend

#-----------------------------------------------------------------------------
# Post route optimization for hold
#-----------------------------------------------------------------------------
setOptMode -postRouteAreaReclaim holdAndSetupAware

setOptMode -fixHoldAllowSetupTnsDegrade true

optDesign -postRoute -hold -outDir $REPORTS_PATH 
 
saveDesign  $O_DataBase.hold -def -tcon
#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
clearDrc       

verifyConnectivity   -type all       -error 1000 -report ${REPORTS_PATH}/$topmodule.verifyconnectivity.rpt.route_pre_drc
verify_drc       -check_only regular -limit 10000 -report ${REPORTS_PATH}/$topmodule.verifydrc.rpt.route_pre_drc
verifyProcessAntenna                 -error 1000 -report ${REPORTS_PATH}/$topmodule.verifyantenna.rpt.route_pre_drc

#----------------------------------------------------------------------------- 
# Route Design: Repair viaEnclosure violations
#----------------------------------------------------------------------------- 
# Clear all DRC markers
clearDrc

# Run verifyGeometry and see if we have viaEncosure violations
setVerifyGeometryMode -area { 0 0 0 0 } -minWidth false -minSpacing false -minArea false \
    -sameNet false -short false -overlap false -offRGrid false -offMGrid false \
    -mergedMGridCheck false -minHole false -implantCheck false -minimumCut false \
    -minStep false -viaEnclosure true -antenna false -insuffMetalOverlap false \
    -pinInBlkg false -diffCellViol true -sameCellViol false -padFillerCellsOverlap true \
    -routingBlkgPinOverlap true -routingCellBlkgOverlap true -regRoutingOnly true \
    -stackedViasOnRegNet false -wireExt false -useNonDefaultSpacing true -maxWidth false \
    -maxNonPrefLength -1 -error 10000
verify_drc

# Get the boxes of the viaEnclosure markers on M1
set drcList [dbGet [dbGet -p2  [dbGet top.markers { .subType == "ViaEnclosure" }].layer.name M1].box ]

if { ${drcList} != 0x0 } {
   # add routing blockages for V1
   set name 0
   foreach m ${drcList} {
     set bbox_lx [lindex ${m} 0]
     set bbox_ly [lindex ${m} 1]
     set bbox_ux [lindex ${m} 2]
     set bbox_uy [lindex ${m} 3]
     createRouteBlk -name V1_viaEnclosure_blockage_${name} -box ${bbox_lx} ${bbox_ly} ${bbox_ux} ${bbox_uy} -layer V1
     incr ${name}
   }
   # Delete the wires on violating nets
   editDeleteViolations
   # Eco route will only route the nets we just deleted
   ecoRoute
   deleteRouteBlk -name V1_viaEnclosure_blockage_*
}


clearDrc

verify_drc       -report  ${REPORTS_PATH}/$topmodule.verifygeometry.viaEnclosure.rpt.route     -limit 10000

editDeleteViolations -keep_fixed
ecoRoute

clearDrc
verify_drc       -check_only regular -limit 10000 -report ${REPORTS_PATH}/$topmodule.verifydrc.ecoRt1.rpt.route

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow -routing -scanChain $O_DefNetlist
saveDesign  $O_DataBase -def -tcon 


# Save SDC files for each analysis view
foreach view_name [concat ${setup_analysis_views} ${hold_analysis_views} ] {
   writeTimingCon -view ${view_name} ../../constraints/${topmodule}_${view_name}_${outputExt}.sdc.gz
}

# Save models for possible use on toplevel
#system mkdir -p  ../../models/innovus/${outputExt}
#setIlmMode -keepAsync true

#saveModel -uniquifyCellNames -dir ../../models/innovus/${outputExt} -cts -sdf
#createInterfaceLogic -dir ../../models/innovus/${outputExt} \
#   -modelType timing -useType ilm -writeSDC



#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------
timeDesign -postRoute       -outDir ${REPORTS_PATH} -expandedViews -timingDebugReport
timeDesign -postRoute -hold -outDir ${REPORTS_PATH} -expandedViews  -timingDebugReport
#suspend


#setSIMode -enable_glitch_report true 
#timeDesign -signOff       -outDir $REPORTS_PATH -expandedViews -timingDebugReport -numPaths 5000
#timeDesign -signOff -hold -outDir $REPORTS_PATH -expandedViews -numPaths 5000

# Save noise reports for each analysis view
lappend view_list
foreach view_name [concat ${setup_analysis_views} ${hold_analysis_views} ${power_analysis_view} ] {
   if { ${view_name} ni ${view_list} } {
      lappend view_list ${view_name}
      report_noise -bumpy_waveform        -view ${view_name} -gzip > $REPORTS_PATH/report_noise_bumpy_waveform_${view_name}.rpt.gz
      report_noise -histogram             -view ${view_name}       > $REPORTS_PATH/report_noise_histogram_${view_name}.rpt
      report_noise -sort_by receiver_peak -view ${view_name}       > $REPORTS_PATH/report_noise_sort_by_receiver_peak_${view_name}.rpt
      report_noise -failure               -view ${view_name}       > $REPORTS_PATH/report_noise_failure_${view_name}.rpt
   }
}

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc

verify_drc       -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 10000
verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt

set_analysis_view -setup ${power_analysis_view} -hold ${power_analysis_view}
report_power  -hierarchy  2 -outfile  ${REPORTS_PATH}/report_power.rpt

#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } > ${REPORTS_PATH}/GetMetric.runtime.rpt


#exit
