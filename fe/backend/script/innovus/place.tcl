#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2017                       #
#*******************************************************************************#
# FILE NAME    : place.tcl                                                      #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for placement                                 #
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        fe       ;# Specify the top module of the Design
set inputExt         floorplan
set outputExt        place

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
# Define the analysis views. Not sure if we need al 4 views yet
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

#-------------------------------------------------------------------------------
# Global net connect rules needed for newly created instances.
#-------------------------------------------------------------------------------
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VDD -type pgpin -pin VNW -inst * -verbose
globalNetConnect VDD -type tiehi -verbose

globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
globalNetConnect VSS -type pgpin -pin VPW -inst * -verbose
globalNetConnect VSS -type tielo -verbose

suspend

#----------------------------------------------------------------------------- 
# Set Tie Cells Mode
#----------------------------------------------------------------------------- 
setTieHiLoMode                                      \
   -cell "TIELO_X1M_A12TH_C38  TIEHI_X1M_A12TH_C38" \
   -createHierPort true                             \
   -reportHierPort true                             \
   -maxFanOut 10 		                    \
   -maxDistance 100

#-------------------------------------------------------------------------------
# Set all pins to be fixed
#-------------------------------------------------------------------------------

fixAllIos -pinOnly


#-----------------------------------------------------------------------------
# Place Standard Cells
#----------------------------------------------------------------------------- 
# Delete buffer tree before place
deleteBufferTree

# Set the net weight for all input pins to a high value to force placement
foreach terminal [dbGet top.terms] {
    if  [dbGet ${terminal}.isInput] {
      specifyNetWeight [lindex [dbGet ${terminal}.name ] 0 ] 50
    }
}

# Set the net weight for all output pins to a high value to force placement
foreach terminal [dbGet top.terms] {
    if  [dbGet ${terminal}.isOutput] {
      specifyNetWeight [lindex [dbGet ${terminal}.name ] 0 ] 50
    }
}

setPlaceMode -doRPlace true -swapEEQ true -wireLenOptEffort high -timingEffort low


#Enable even cell distribution for designs with less than 70% utilization
setPlaceMode -place_global_uniform_density true


setPlaceMode -place_global_cong_effort high

# Enables the FGC engine inside placement for DRC checking
#setPlaceMode -place_detail_use_check_drc true

# CTS NDR route config requires 5-tracks
#setRouteMode -earlyGlobalNumTracksPerClockWire 5

#-----------------------------------------------------------------------------
# Cell Padding options - EXAMPLE
#-----------------------------------------------------------------------------
# Extra site tracks for each DFF register cell
#specifyCellPad *DFF* 10

#Specifies whether the  refinePlace  command honors cell padding on FIXED  instances.
#setPlaceMode -place_detail_pad_fixed_insts true

# Module padding to avoid high congestion intra module
#setPlaceMode -place_global_module_padding uu_rb_adc_adapt 1.2
#setPlaceMode -place_global_module_padding uu_adapt_mem_uu_adapt_mem_ch_* 1.2
#setPlaceMode -place_global_module_padding uu_adc_map_fifo_uu_xdmnf_* 1.3

#-----------------------------------------------------------------------------
# Global fast CTS commands
#-----------------------------------------------------------------------------
#source ../../script/innovus/ccopt_configb.tcl
#commit_ccopt_clock_tree_route_attributes
#setPlaceMode -place_global_fast_cts true

#suspend

# To reduce post CTS hold violations in scan mode, we will optimize the scanchain only after CTS
setPlaceMode -ignoreScan true
setScanReorderMode -skipMode skipNone


#suspend


#Create groups for each pin: usefull to improve timing in2reg and reg2out - EXAMPLE
#source ../../script/innovus/createInstGroupsPins.tcl

#suspend



# Place and optimise design, one command only for improved PPA
place_opt_design -expanded_views -out_dir  ${REPORTS_PATH}


#----------------------------------------------------------------------------- 
# Place Tie Cells
#----------------------------------------------------------------------------- 
setTieHiLoMode                                      \
   -cell "TIELO_X1M_A12TH_C38  TIEHI_X1M_A12TH_C38" \
   -createHierPort true                             \
   -reportHierPort true                             \
   -maxFanOut 15 		                    \
   -maxDistance 100

addTieHiLo -prefix TIECELLS_



#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow -scanChain  $O_DefNetlist
lefOut ${O_LefModel} -5.8 -specifyTopLayer 11 -stripePin -PGpinLayers 2 9 10 11 -extractBlockPGPinLayers 2 9 10 11
saveDesign  $O_DataBase -def -tcon 

# Save models for possible use on toplevel
#system mkdir -p  ../../models/innovus/${outputExt}
#setIlmMode -keepAsync true

#saveModel -uniquifyCellNames -dir ../../models/${outputExt} -cts -sdf
#createInterfaceLogic -dir ../../models/innovus/${outputExt} \
#   -modelType timing -useType ilm -writeSDC


#-------------------------------------------------------------------------------
# Placement verification
#-------------------------------------------------------------------------------

timeDesign -preCTS -outDir $REPORTS_PATH -expandedViews -timingDebugReport -numPaths 1000

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Clear DRC violations
clearDrc
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt


reportCongestion -hotSpot

suspend
#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } >> ${REPORTS_PATH}/GetMetric.runtime.rpt


exit


