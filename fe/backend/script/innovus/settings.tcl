#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2017                       #
#*******************************************************************************#
# FILE NAME    : settings.tcl                                                   #
# TYPE         : TCL command script                                             #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP28                                                          #
# AUTHOR       : Jacqueline G. Mertes                                           #
# AUTHOR EMAIL : jacqueline.mertes@eldorado.org.br                              #
#*******************************************************************************#
# PURPOSE :      Default Encounter settings		   		        #
#*******************************************************************************#

setDesignMode -process 28 -flowEffort high

set REPORTS_PATH       ../../reports/innovus/${outputExt}
file mkdir ${REPORTS_PATH}


# Define global variable controlling fields in timing reports
set_global report_timing_format {instance arc cell net load slew fanin fanout aocv_derate delay arrival}

setAnalysisMode -analysisType onChipVariation -clockPropagation sdcControl \
   -cppr both -skew true -usefulSkew true -aocv true

set_global timing_report_timing_header_detail_info extended


set_default_switching_activity -input_activity 0.5

#set_table_style -name report_timing -max_widths {90,,80,}
set_global timing_report_group_based_mode true

setDelayCalMode -reportOutBound true

# Our design needs this, because there is a scanchain compressor
setScanReorderMode -compLogic true

# Optimisation settings
setOptMode -drcMargin 0.15
setOptMode -fixFanoutLoad true
#setOptMode -clkGateAware force
#setOptMode -reclaimArea true
#setOptMode -allEndPoints true
#setOptMode -postRouteAllowOverlap false
#setOptMode -fixHoldAllowSetupTnsDegrade false
setOptMode -verbose true 
#setOptMode -effort high
#setOptMode -postRouteAreaReclaim holdAndSetupAware
#setOptMode -resizeShifterAndIsoInsts true
setOptMode -fixGlitch           true       

# Skip the async @ clock. Un-constrainted inputs and outputs are async and have no relations
set_global timing_apply_default_primary_input_assertion false

setMessageLimit 10000
#-------------------------------------------------------------------------------
# Low power settings, both static and dynamic
#-------------------------------------------------------------------------------
# This option will use a lot of CPU time.
#setOptMode -leakagePowerEffort high

# Before dynamic optimization is performed, it is vital that the correct dynamic power view is 
# specified. Dynamic optimization needs to target the view that is most important to the design
# and then use it when optimizing based on switching activity.
#set_power_analysis_mode -analysis_view ${power_optimisation_view}

# This option will use a lot of CPU time.
#setOptMode -dynamicPowerEffort high

# Add Encounter routing option commands in this file
# Setting defined by Foundry in 
# /net/tdk/arm/gf/cmos28hpp/arm_tech/r5p1/lef/6U1x_2U2x_2T8x_LB/encounter_route_options.tcl

setNanoRouteMode -routeBottomRoutingLayer 2
setNanoRouteMode -routeWithViaInPin "1:1"
setNanoRouteMode -routeWithViaOnlyForStandardCellPin "1:1"

#Customer is required to source the following placement options in EDI prior to placement 
    setPlaceMode -checkImplantWidth true
    setPlaceMode -honorImplantSpacing true
    setPlaceMode -checkImplantMinArea true

# In the chiplets we will use routing on layers until B2
setTrialRouteMode -maxRouteLayer 10

# This variable will let the tool add the clock insertion delay to the input and output constraints.
set_global timing_io_use_clock_network_latency always

# Setup parasitic extraction with QRC
setExtractRCMode -lefTechFileMap ../../script/innovus/lefTechFileMap.map

# 


setFillerMode \
   -core {{"FILLECOCAP48_A12TR_C30" "FILLECOCAP24_A12TR_C30" "FILLECOCAP12_A12TR_C30" "FILLECOCAP6_A12TR_C30" } \
          {"FILL128_A12TH_C38" "FILL128_A12TR_C38" "FILL128_A12TH_C34" "FILL128_A12TR_C34" "FILL128_A12TL_C34" "FILL128_A12TH_C30" "FILL128_A12TR_C30" "FILL128_A12TL_C30"} \
          {"FILL64_A12TH_C38" "FILL64_A12TR_C38" "FILL64_A12TH_C34" "FILL64_A12TR_C34" "FILL64_A12TL_C34" "FILL64_A12TH_C30" "FILL64_A12TR_C30" "FILL64_A12TL_C30"} \
          {"FILL32_A12TH_C38" "FILL32_A12TR_C38" "FILL32_A12TH_C34" "FILL32_A12TR_C34" "FILL32_A12TL_C34" "FILL32_A12TH_C30" "FILL32_A12TR_C30" "FILL32_A12TL_C30"} \
          {"FILL16_A12TH_C38" "FILL16_A12TR_C38" "FILL16_A12TH_C34" "FILL16_A12TR_C34" "FILL16_A12TL_C34" "FILL16_A12TH_C30" "FILL16_A12TR_C30" "FILL16_A12TL_C30"} \
          {"FILL8_A12TH_C38" "FILL8_A12TR_C38" "FILL8_A12TH_C34" "FILL8_A12TR_C34" "FILL8_A12TL_C34" "FILL8_A12TH_C30" "FILL8_A12TR_C30" "FILL8_A12TL_C30"} \
          {"FILL4_A12TH_C38" "FILL4_A12TR_C38" "FILL4_A12TH_C34" "FILL4_A12TR_C34" "FILL4_A12TL_C34" "FILL4_A12TH_C30" "FILL4_A12TR_C30" "FILL4_A12TL_C30"} \
          {"FILL3_A12TH_C38" "FILL3_A12TR_C38" "FILL3_A12TH_C34" "FILL3_A12TR_C34" "FILL3_A12TL_C34" "FILL3_A12TH_C30" "FILL3_A12TR_C30" "FILL3_A12TL_C30"} \
          {"FILL2_A12TH_C38" "FILL2_A12TR_C38" "FILL2_A12TH_C34" "FILL2_A12TR_C34" "FILL2_A12TL_C34" "FILL2_A12TH_C30" "FILL2_A12TR_C30" "FILL2_A12TL_C30"} \
          {"FILL1_A12TH_C38" "FILL1_A12TR_C38" "FILL1_A12TH_C34" "FILL1_A12TR_C34" "FILL1_A12TL_C34" "FILL1_A12TH_C30" "FILL1_A12TR_C30" "FILL1_A12TL_C30"}} -corePrefix DECAP_FILLER \
   -preserveUserOrder true \
   -scheme cellFirst 



