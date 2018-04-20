#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : quick_pr.tcl                                                   #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jeroen vermeeren                                               #
# AUTHOR EMAIL : jeroen.vermeeren@team.eldorado.org.br                          # 
#*******************************************************************************#
# PURPOSE :      Encounter script for quick-place and route, to prepare         #
#                for the setup of physical verification.          		#
#                No optimization (timming, power, etc ) will be done.		#  
#*******************************************************************************#

#-------------------------------------------------------------------------------
# File and Paths                                                        
#-------------------------------------------------------------------------------
set topmodule        adc_adapt       ;# Specify the top module of the Design
set inputExt         floorplan
set outputExt        quick_pr

source ../../script/edi/globals.tcl

#----------------------------------------------------------------------------------------------
# Set pointers to input and output files
#----------------------------------------------------------------------------------------------
set I_VerilogNetlist     ../../structural/edi/${topmodule}_${inputExt}.v.gz
set I_MMMCFile           ../../script/edi/mmmc.tcl
set I_DefNetlist         ../../physical/edi/${topmodule}_${inputExt}.def.gz
set I_ScanDef            ../../../design/structural/rc/${topmodule}.scan.def.gz
set I_DataBase           ../../db/edi/${topmodule}_${inputExt}.enc

set O_DefNetlist         ../../physical/edi/${topmodule}_${outputExt}.def.gz
set O_VerilogNetlist     ../../structural/edi/${topmodule}_${outputExt}.v.gz
set O_DataBase           ../../db/edi/${topmodule}_${outputExt}.enc

#-------------------------------------------------------------------------------
# Initialize the design
#-------------------------------------------------------------------------------
set init_verilog   ${I_VerilogNetlist}
set init_top_cell  ${topmodule}
set init_mmmc_file ${I_MMMCFile}

#-------------------------------------------------------------------------------
# Define the analysis views.Selective set only
#-------------------------------------------------------------------------------
set setup_analysis_views  "tt_0p85v_25c_libset_nominal_25c_functional"
set hold_analysis_views   "tt_0p85v_25c_libset_nominal_25c_functional"
set power_analysis_view   "tt_0p85v_25c_libset_nominal_25c_functional"

init_design -setup ${setup_analysis_views} -hold ${hold_analysis_views}
set_power_analysis_mode -analysis_view ${power_analysis_view}
createBasicPathGroups -expanded


#-------------------------------------------------------------------------------
# Default settings
#-------------------------------------------------------------------------------
source ../../script/edi/settings.tcl

# In quick mode, we only need DRC and LVS clean design
setDesignMode -process 28 -flowEffort none

# Standard procedures, always useful
source ../../../../globals/backend/script/edi/util_stdProcedures.tcl
source ../../../../globals/backend/script/edi/util_genGDS.tcl

setMultiCpuUsage -localCpu 16 -keepLicense false -threadInfo 2 \
   -verbose -autoPageFaultMonitor 3


#-------------------------------------------------------------------------------
# Load DEF from previous stage
#-------------------------------------------------------------------------------
defIn $I_DefNetlist



#-----------------------------------------------------------------------------
# Place Standard Cells
#----------------------------------------------------------------------------- 
setPlaceMode -powerDriven false -reorderScan false -timingDriven false
setPlaceMode -wireLenOptEffort none -timingEffort low -placeIoPins false -coreEngineEffort medium

placeDesign -noPrePlaceOpt

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt

#----------------------------------------------------------------------------- 
# Place Tie Cells
#----------------------------------------------------------------------------- 
setTieHiLoMode                                      \
   -cell "TIELO_X1M_A12TH_C38  TIEHI_X1M_A12TH_C38" \
   -createHierPort true                             \
   -reportHierPort true                             \
   -maxFanOut 20 		                    \
   -maxDistance 200

getReport { addTieHiLo -powerDomain ALWAYS_ON -prefix TIE_ALWAYS_ON } > ${REPORTS_PATH}/tiehilo_always_on.rpt
getReport { addTieHiLo -powerDomain SWITCHED  -prefix TIE_SWITCHED  } > ${REPORTS_PATH}/tiehilo_switched.rpt

#----------------------------------------------------------------------------- 
# Place decoupling and fillers
#----------------------------------------------------------------------------- 
addFiller -minHoleCheck true

#----------------------------------------------------------------------------- 
# Route Design: setup Nanoroute
#----------------------------------------------------------------------------- 
# Restrict the signal routing to these layers, the upper ones are to course to be useful.
setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -routeTopRoutingLayer    8

#antenna cell defined into info  file
#setNanoRouteMode -routeAntennaCellName $ANTENNA_DIODE_CELL 
# Nanoroute Settings
setNanoRouteMode -routeStrictlyHonorNonDefaultRule      true
setNanoRouteMode -routeInsertAntennaDiode		true
setNanoRouteMode -routeInsertDiodeForClockNets		true
setNanoRouteMode -routeReserveSpaceForMultiCut		true

setNanoRouteMode -routeWithTimingDriven 		false
setNanoRouteMode -routeWithSiDriven                     false
setNanoRouteMode -routeWithLithoDriven                  false

setNanoRouteMode -droutePostRouteSpreadWire             false
#setNanoRouteMode -routeConcurrentMinimizeViaCountEffort high

#-----------------------------------------------------------------------------
#  Route Design: First the secondary power pin of the always on buffers
#-----------------------------------------------------------------------------
# The secondary power pins have a current flowing, so we use a wider wire and 
# Only 1 pin connection per wire
add_ndr -name sec_power_pin  -width { M1:M6 0.072 } -min_cut {V2:XA 2} -generate_via
setPGPinUseSignalRoute GPG*:VDDG GPG*:VSSG
routePGPinUseSignalRoute -maxFanout 1 -nets {VDD VSS} -nonDefaultRule sec_power_pin

# This is the BIASNW pin of the endcaps to VDD
# As there is no current flowing, we can connect several at a time
setPGPinUseSignalRoute ENDCAPBIASNW3_A12TH_C38:BIASNW
routePGPinUseSignalRoute -maxFanout 10 -nets {VDD VSS}

#----------------------------------------------------------------------------- 
# Route Design: signal route
#----------------------------------------------------------------------------- 
# Cleanup the design first
#dbDeleteTrialRoute

#routeDesign -clockEco
routeDesign -globalDetail

#----------------------------------------------------------------------------- 
# Route Design: signal route search and repair
#----------------------------------------------------------------------------- 
setNanoRouteMode -drouteStartIteration 1 
setNanoRouteMode -drouteEndIteration 1 
detailRoute 
setNanoRouteMode -drouteStartIteration 2 
setNanoRouteMode -drouteEndIteration 19 
detailRoute 

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
verifyGeometry

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

#-------------------------------------------------------------------------------
# Output the design
#-------------------------------------------------------------------------------
saveNetlist $O_VerilogNetlist 
saveDesign  ${O_DataBase}_${STEP} -def -tcon -rc

saveNetlist -phys -includePowerGround -excludeLeafCell \
  -excludeCellInst " \
 	FILLTIE3_A12TH_C38 \
	ENDCAPTIE3_A12TH_C38 \
 	FILL1_A12TR_C38 \
 	FILL1_A12TL_C34 \
 	FILL1_A12TH_C38 \
 	FILL2_A12TH_C38 \
 	FILL3_A12TH_C38 \
 	FILL4_A12TH_C38 \
 	ENDCAPBIASNW3_A12TH_C38" \
  $O_VerilogNetlistPhysical 
defOut -netlist -floorplan -cutRow -ioRow -scanChain -routing -withShield $O_DefNetlist

gds_write_full ${topmodule} ${outputExt} ../../physical/edi

#-------------------------------------------------------------------------------
# Verification
#-------------------------------------------------------------------------------

# Verify DRC and connectivity
clearDrc
verifyGeometry      -report ${REPORTS_PATH}/verifyGeometry.rpt     -error 1000000
verifyConnectivity    -report  ${REPORTS_PATH}/verifyConnectivity.rpt -error 1000000 -noAntenna -noUnConnPin -noUnroutedNet
summaryReport -noHtml -outfile ${REPORTS_PATH}/summaryReport.rpt

macroPlacementCheck
pinPlacementCheck

getReport { checkPlace -noHalo } > ${REPORTS_PATH}/check_placement.rpt

#-------------------------------------------------------------------------------
# Save the runtime 
#-------------------------------------------------------------------------------
getReport { get_metric {*time} -history } >> ${REPORTS_PATH}/GetMetric.runtime.rpt



exit
