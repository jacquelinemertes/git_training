#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : floorplan.tcl                                                  #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : DHD                                                            #
# PROJECT      : DSP28                                                          #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Encounter script for floorplannning                            #
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        fe       ;# Specify the top module of the Design
set inputExt         mapped.dft
set outputExt        floorplan

source ../../script/innovus/globals.tcl

#----------------------------------------------------------------------------------------------
# Set pointers to input and output files
#----------------------------------------------------------------------------------------------
set I_VerilogNetlist     ../../../design/structural/rc/${topmodule}.${inputExt}.v.gz
#set I_VerilogNetlist     ../../../design/structural/dc/${topmodule}.mapped.v
set I_MMMCFile           ../../script/innovus/mmmc.tcl
set I_DefNetlist         ../../physical/innovus/${topmodule}.def.gz
set I_ScanDefNetlist     ../../../design/structural/rc/${topmodule}.scan.def.gz

set O_DefNetlist         ../../physical/innovus/${topmodule}_${outputExt}.def.gz
set O_VerilogNetlist     ../../structural/innovus/${topmodule}_${outputExt}.v.gz
set O_DataBase           ../../db/innovus/${topmodule}_${outputExt}.enc

set O_LefModel           ../../physical/innovus/${topmodule}_${outputExt}.lef
set O_TimingModelDir     ../../timing/innovus


#-------------------------------------------------------------------------------
# Initialize the design
#-------------------------------------------------------------------------------
set init_verilog   ${I_VerilogNetlist}
set init_top_cell  ${topmodule}
set init_pwr_net   { VDD VNW }
set init_gnd_net   { VSS VPW}
set init_mmmc_file ${I_MMMCFile}

#-------------------------------------------------------------------------------
# Define the analysis views. For floorplanning, these can be simple
# Then initialize the design
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

init_design -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_power_analysis_mode -analysis_view ${power_analysis_view}
#createBasicPathGroups -expanded

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
# Load Scan-Def defining the scanchains.
#-------------------------------------------------------------------------------
defIn ${I_ScanDefNetlist}

#-------------------------------------------------------------------------------
# Load DEF from Toplevel partioning
#-------------------------------------------------------------------------------
#defIn ${I_DefNetlist} 
defIn ../../physical/edi/${topmodule}.def.gz
generateTracks -honorPitch

suspend


#-------------------------------------------------------------------------------
# Modify the floorplan we get from top
#-------------------------------------------------------------------------------
# Delete LB wires on net VDD and VSS
dbDeleteObj [dbGet -p2 [dbGet -p  top.physNets.name VDD].sWires.layer.name LB    ]
dbDeleteObj [dbGet -p2 [dbGet -p  top.physNets.name VSS].sWires.layer.name LB    ]

# Delete obstructions in LB
dbDeleteObj [dbGet -p2 top.fPlan.rBlkgs.layer.name  LB ]

# Delete M2 wires on VDD and VSS
#dbDeleteObj [dbGet -p2 [dbGet -p  top.physNets.name VDD].sWires.layer.name M2    ]
#dbDeleteObj [dbGet -p2 [dbGet -p  top.physNets.name VSS].sWires.layer.name M2    ]

# Delete all bumps
deleteBumps -all
#Delete DVDD and DVSS
deleteNet DVDD
deleteNet DVSS


# Delete the blockages that are on/outside the boundary
foreach blockagePointer [dbGet top.fPlan.rBlkgs {.boxes > 0 }] {
    if { [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 0]] < [dbGet top.fPlan.box_llx]} {
        dbDeleteObj ${blockagePointer}
   }
}
foreach blockagePointer [dbGet top.fPlan.rBlkgs {.boxes > 0 }] {
    if { [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 1]] < [dbGet top.fPlan.box_lly]} {
        dbDeleteObj ${blockagePointer}
   }
}
foreach blockagePointer [dbGet top.fPlan.rBlkgs {.boxes > 0 }] {
    if { [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 2]] > [dbGet top.fPlan.box_urx]} {
        dbDeleteObj ${blockagePointer}
   }
}
foreach blockagePointer [dbGet top.fPlan.rBlkgs {.boxes > 0 }] {
    if { [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 3]] > [dbGet top.fPlan.box_ury]} {
        dbDeleteObj ${blockagePointer}
   }
}

clearDrc



#-------------------------------------------------------------------------------
# Adding ESD cells
#-------------------------------------------------------------------------------


# Add pad_power1 cells on top of placement blockages and delete placement blockages
## I will consider adding T3 over pad_power.
## X-Spacing = 0.25 (NW Std Cell) + 1um (Ring de NW) + 0.4 (overlap NW->T3) + 3.5 (spacing T3 -> T3) + 0.4 (overlap NW->T3) = 5.55
## Y-Spacing = 0.2 (NW Std Cell) + 0.4 (overlap NW->T3) + 3.5 (spacing T3 -> T3) + 0.4 (overlap NW->T3) = 4.5 -> rounded to 4.8
foreach blockagePointer [dbGet  top.fPlan.pBlkgs { .area == 6532.22892 }] {
   set llxCoor [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 0]]
   set llyCoor [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 1]]
   set urxCoor [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 2]]
   set uryCoor [lindex [lindex [lindex [lindex  [dbGet ${blockagePointer}.boxes] 0] 0 ] 3]]
   
   set instanceName  pad_power_[expr int($llxCoor)][expr int($llyCoor)]

#  if { ($instanceName == pad_power_447639) | ($instanceName == pad_power_858639) | ($instanceName == pad_power_2091639) | ($instanceName == pad_power_2502639) }
   addInst  -inst $instanceName -cell pad_power1 -physical -status fixed 
   placeInstance $instanceName ${llxCoor} ${llyCoor} -fixed
   #addHaloToBlock 5 5 5 5 $instanceName
   createPlaceBlockage -type hard -name pad_power_placeblockage -box \
       [expr ${llxCoor} - 5.0 ] [expr  ${llyCoor} - 5.0 ] [expr ${urxCoor} + 5.0 ] [expr ${uryCoor} + 5.0 ]
   dbDeleteObstruct [dbGet top.fPlan] ${blockagePointer}

   # We add a blcokage in M3 for power routing so we will not get a fine M3 dynamic power grid on to of the instance
   # and leave space for signal routing
   createRouteBlk -layer M3 -name powerRouteBlk -pgnetonly -box \
        [expr ${llxCoor} - 0.582 ] [expr  ${llyCoor} - 4 ] [expr ${urxCoor} + 0.582 ] [expr ${uryCoor} + 3.606 ]
   #Create pins on top of the pad so we can connect it on toplevel
   createPGPin VDD -net VDD -geom \
   M11 [expr ${llxCoor} +15 ] [expr ${llyCoor} -0.5 ] [expr ${llxCoor} +15 + 35.5] [expr ${llyCoor}  -0.5 + 12.5]
   createPGPin VDD -net VDD -geom \
   M11 [expr ${llxCoor} +95 ] [expr ${llyCoor} -0.5 ] [expr ${llxCoor} +95 + 35.5] [expr ${llyCoor}  -0.5 + 12.5]
   createPGPin VSS -net VSS -geom \
   M11 [expr ${llxCoor} +15 ] [expr ${llyCoor} +22 ] [expr ${llxCoor} +15 + 35.5] [expr ${llyCoor}  +22 + 13]
   createPGPin VSS -net VSS -geom \
   M11 [expr ${llxCoor} +95 ] [expr ${llyCoor} +22 ] [expr ${llxCoor} +95 + 35.5] [expr ${llyCoor}  +22 + 13]
}



# Delete routing blockages that are on the place of the pad_power1
deselectAll
foreach blockagePointer [dbGet  top.fPlan.rBlkgs ] {
   # Dont use this, it crashes Encounter
   # dbDeleteObstruct [dbGet top.fPlan] ${blockagePointer}
    select_obj  ${blockagePointer}
}
deleteSelectedFromFPlan

#-------------------------------------------------------------------------------
# Set all pins to be fixed
#-------------------------------------------------------------------------------
fixAllIos -pinOnly


#suspend

#-------------------------------------------------------------------------------
# Connecting Power nets
#-------------------------------------------------------------------------------
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -verbose
globalNetConnect VDD -type pgpin -pin VNW -inst * -verbose
globalNetConnect VDD -type tiehi -verbose

globalNetConnect VSS -type pgpin -pin VSS -inst * -verbose
globalNetConnect VSS -type pgpin -pin VPW -inst * -verbose
globalNetConnect VSS -type tielo -verbose

#suspend
#-------------------------------------------------------------------------------
#Floorplan
#-------------------------------------------------------------------------------

#######################################################
# REMOVE EXTRA NETS OF M2 FROM TOP AND BOTTOM  #

# top area
deselectAll
selectWire 0.0000 639.5330 1704.3000 639.6670 2 VSS
selectWire 0.0000 640.7330 1704.3000 640.8670 2 VDD
deleteSelectedFromFPlan
deselectAll

# bottom area
deselectAll
selectWire 0.0000 1.1330 1704.3000 1.2670 2 VSS
selectMarker 0.0000 -0.0670 1704.3000 0.0000 2 1 6
selectWire 0.0000 -0.0670 1704.3000 0.0670 2 VDD
deleteSelectedFromFPlan
deselectAll

#queryPlaceDensity
checkFPlan -reportUtil

#win
suspend


#-------------------------------------------------------------------------------
# Make a fine grid in M3 for dynamic current.
# This type of grid is defined in ARM documentation
#-------------------------------------------------------------------------------
setAddStripeMode -stacked_via_top_layer    M4
setAddStripeMode -stacked_via_bottom_layer M2
setAddStripeMode -optimize_stripe_for_routing_track shift


setAddStripeMode -extend_to_closest_target none 
setAddStripeMode -extend_to_first_ring false 

addStripe   -direction vertical \
   -set_to_set_distance 2.68 \
   -width 0.134 \
   -spacing 1.206 \
   -xleft_offset 0.547 \
   -layer M3 \
   -nets {VSS VDD} \
   -route_over_rows_only true \
   -block_ring_bottom_layer_limit M2 \
   -block_ring_top_layer_limit M4\
   -area_blockage {{ 1778 162.8 2055 268 } {1987.045 115 2055 161.651}}

clearDrc
verify_drc  -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 100000

# delete the routing blockage that represents the stripes on the top
deleteRouteBlk -layer LB -name defLayerBlkName
deleteRouteBlk -layer M10 -name defLayerBlkName
deleteRouteBlk -layer M9 -name defLayerBlkName



## Delete automatically stripes violating em M3
#source ../../script/innovus/DeleteM3Violations.tcl

setPreference CmdLogMode 0
foreach violations [dbGet top.markers] {
    if {[dbGet $violations.layer.name] == "M3"} {
        deselectAll
        windowSelect [expr [dbGet $violations.box_llx] - 0.1] [expr [dbGet $violations.box_lly] - 0.1] [expr [dbGet $violations.box_llx] + 0.1] [expr [dbGet $violations.box_lly] + 0.1]
        foreach selection [dbGet selected] {
            if {[dbGet $selection.shape] == "stripe" && [dbGet $selection.layer.name] == "M3"} {
                puts "Deletando stripe em [dbGet $selection.box] => $selection"
                dbDeleteObj $selection
            }
        }
    }
}



#-------------------------------------------------------------------------------
#Create density areas
#-------------------------------------------------------------------------------

deleteAllDensityAreas
deletePlaceBlockage -all

#createDensityArea 307 457 1132 699.599 5 -name HotSpot1
#createPlaceBlockage -box 307 457 1132 699.599 -type partial -density 5 -name HotSpot1

#createDensityArea 2005 508 2980 699.599 5 -name HotSpot2
#createPlaceBlockage -box 2005 508 2980 699.599 -type partial -density 5 -name HotSpot2

#-------------------------------------------------------------------------------
# Insert endcaps at well/row ends and welltaps
#-------------------------------------------------------------------------------

deleteFiller -prefix  ENDCAP
deleteFiller -prefix  WELLTAP


addEndCap \
  -preCap  ENDCAPTIE3_A12TH_C38 \
  -postCap ENDCAPTIE3_A12TH_C38 \
  -prefix  ENDCAP


#cellInterval 59.930: size of filler cell
addWellTap \
    -cell FILLTIE3_A12TH_C38 \
    -prefix WELLTAP \
    -cellInterval  59.930 \
    -pitch 0.0 \
    -checkerboard \
    -pitchOffset 0.65

#clearDrc
#verify_drc  -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 100000


#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
defOut -netlist -floorplan -cutRow -ioRow  $O_DefNetlist
lefOut ../../physical/innovus/${topmodule}_${outputExt}.lef.gz -stripePin -PGpinLayers 9 10 11 -extractBlockPGPinLayers 9 10 11
saveDesign  $O_DataBase -def -tcon

#-------------------------------------------------------------------------------
# Floorplan verification
#-------------------------------------------------------------------------------
getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt
getReport { macroPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt
getReport { pinPlacementCheck } >> ${REPORTS_PATH}/check_placement.rpt

# Verify DRC and connectivity
clearDrc
verify_drc  -report  ${REPORTS_PATH}/verify_drc.rpt     -limit 10000
verifyConnectivity  -report ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt

#reportPowerDomain -file ${REPORTS_PATH}/reportPowerDomain.rpt


#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } > ${REPORTS_PATH}/run_runtime.metrics.rpt
getReport { get_metric {*mem}  -history } > ${REPORTS_PATH}/run_mem.metrics.rpt
getReport { get_metric         -history } > ${REPORTS_PATH}/run.metrics.rpt


exit

