puts "RM-Info: Running script [info script]\n"

# The following variables are used by scripts in the rm_dc_scripts folder to direct 
# the location of the output files.

set REPORTS_DIR "../../reports"
set CONSTRAINTS_DIR "../../constraints"
set RESULTS_DIR "../../structural"
set LOGS_DIR "../../logs"
set PHYSICAL_DIR "../../physical"
set POWER_DIR "../../power"
set PARASITICS_DIR "../../parasitics"
set TIMING_DIR "../../timing"

file mkdir ${REPORTS_DIR}
file mkdir ${CONSTRAINTS_DIR}
file mkdir ${RESULTS_DIR}
file mkdir ${LOGS_DIR}
file mkdir ${PHYSICAL_DIR}
file mkdir ${POWER_DIR}
file mkdir ${PARASITICS_DIR}
file mkdir ${TIMING_DIR}

file mkdir ${REPORTS_DIR}/dc
file mkdir ${REPORTS_DIR}/fm
file mkdir ${CONSTRAINTS_DIR}/dc
file mkdir ${RESULTS_DIR}/dc
file mkdir ${RESULTS_DIR}/fm
file mkdir ${LOGS_DIR}/dc
file mkdir ${LOGS_DIR}/fm
file mkdir ${PHYSICAL_DIR}/dc
file mkdir ${POWER_DIR}/dc
file mkdir ${PARASITICS_DIR}/dc
file mkdir ${TIMING_DIR}/dc

#################################################################################
# Design Compiler Reference Methodology Filenames Setup
# Script: dc_setup_filenames.tcl
# Version: L-2016.03-SP2 (July 25, 2016)
# Copyright (C) 2010-2016 Synopsys, Inc. All rights reserved.
#################################################################################

#################################################################################
# Use this file to customize the filenames used in the Design Compiler
# Reference Methodology scripts.  This file is designed to be sourced at the
# beginning of the dc_setup.tcl file after sourcing the common_setup.tcl file.
#
# Note that the variables presented in this file depend on the type of flow
# selected when generating the reference methodology files.
#
# Example.
#    If you set DFT flow as FALSE, you will not see DFT related filename
#    variables in this file.
#
# When reusing this file for different flows or newer release, ensure that
# all the required filename variables are defined.  One way to do this is
# to source the default dc_setup_filenames.tcl file and then override the
# default settings as needed for your design.
#
# The default values are backwards compatible with older
# Design Compiler Reference Methodology releases.
#
# Note: Care should be taken when modifying the names of output files
#       that are used in other scripts or tools.
#################################################################################

#################################################################################
# General Flow Files
#################################################################################

##########################
# Milkyway Library Names #
##########################

set DCRM_MW_LIBRARY_NAME                                ${DESIGN_NAME}_LIB
set DCRM_FINAL_MW_CEL_NAME                              ${DESIGN_NAME}_DCT

###############
# Input Files #
###############

set DCRM_SDC_INPUT_FILE                                 ${CONSTRAINTS_DIR}/${DESIGN_NAME}.sdc
set DCRM_CONSTRAINTS_INPUT_FILE                         ${CONSTRAINTS_DIR}/${DESIGN_NAME}.tcl

###########
# Reports #
###########

set DCRM_CHECK_LIBRARY_REPORT                           ${REPORTS_DIR}/dc/${DESIGN_NAME}.check_library.rpt

set DCRM_CONSISTENCY_CHECK_ENV_FILE                     ${REPORTS_DIR}/dc/${DESIGN_NAME}.compile_ultra.env
set DCRM_CHECK_DESIGN_REPORT                            ${REPORTS_DIR}/dc/${DESIGN_NAME}.check_design.rpt
set DCRM_CHECK_DESIGN_FINAL_REPORT                      ${REPORTS_DIR}/dc/${DESIGN_NAME}.check_design.final.rpt
set DCRM_ANALYZE_DATAPATH_EXTRACTION_REPORT             ${REPORTS_DIR}/dc/${DESIGN_NAME}.analyze_datapath_extraction.rpt

set DCRM_FINAL_QOR_REPORT                               ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.qor.rpt
set DCRM_FINAL_TIMING_REPORT                            ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.timing.rpt
set DCRM_FINAL_AREA_REPORT                              ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.area.rpt
set DCRM_FINAL_AREA_HIERARCHY_REPORT                    ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.area_hier.rpt
set DCRM_FINAL_POWER_REPORT                             ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.power.rpt
set DCRM_FINAL_POWER_HIERARCHY_REPORT                   ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.power_hier.rpt
set DCRM_FINAL_CLOCK_GATING_REPORT                      ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.clock_gating.rpt
set DCRM_FINAL_SELF_GATING_REPORT                       ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.self_gating.rpt
set DCRM_THRESHOLD_VOLTAGE_GROUP_REPORT                 ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.threshold.voltage.group.rpt
set DCRM_INSTANTIATE_CLOCK_GATES_REPORT                 ${REPORTS_DIR}/dc/${DESIGN_NAME}.instatiate_clock_gates.rpt

set DCRM_MULTIBIT_COMPONENTS_REPORT                     ${REPORTS_DIR}/dc/${DESIGN_NAME}.multibit.components.rpt
set DCRM_MULTIBIT_BANKING_REPORT                        ${REPORTS_DIR}/dc/${DESIGN_NAME}.multibit.banking.rpt


set DCRM_FINAL_INTERFACE_TIMING_REPORT                  ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.interface_timing.rpt

################
# Output Files #
################

set DCRM_AUTOREAD_RTL_SCRIPT                            ${RESULTS_DIR}/dc/${DESIGN_NAME}.autoread_rtl.tcl
set DCRM_ELABORATED_DESIGN_DDC_OUTPUT_FILE              ${RESULTS_DIR}/dc/${DESIGN_NAME}.elab.ddc
set DCRM_ELABORATED_DESIGN_VERILOG_OUTPUT_FILE          ${RESULTS_DIR}/dc/${DESIGN_NAME}.elab.v
set DCRM_COMPILE_ULTRA_DDC_OUTPUT_FILE                  ${RESULTS_DIR}/dc/${DESIGN_NAME}.compile_ultra.ddc
set DCRM_FINAL_DDC_OUTPUT_FILE                          ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.ddc
set DCRM_FINAL_PG_VERILOG_OUTPUT_FILE                   ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.pg.v
set DCRM_FINAL_VERILOG_OUTPUT_FILE                      ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.v
set DCRM_FINAL_SDC_OUTPUT_FILE                          ${CONSTRAINTS_DIR}/dc/${DESIGN_NAME}.mapped.sdc
set DCRM_FINAL_DESIGN_ICC2                              ICC2_files


# The following procedures are used to control the naming of the updated blocks
# after transparent interface optimization.
# Modify this procedure if you want to use different names.

proc dcrm_compile_ultra_tio_filename { design } {
  return $design.compile_ultra.tio.ddc
}
proc dcrm_mapped_tio_filename { design } {
  return $design.mapped.tio.ddc
}

#################################################################################
# DCT Flow Files
#################################################################################

###################
# DCT Input Files #
###################

set DCRM_DCT_DEF_INPUT_FILE                             ${PHYSICAL_DIR}/${DESIGN_NAME}.def
set DCRM_DCT_FLOORPLAN_INPUT_FILE                       ${PHYSICAL_DIR}/${DESIGN_NAME}.fp
set DCRM_DCT_PHYSICAL_CONSTRAINTS_INPUT_FILE            ${PHYSICAL_DIR}/${DESIGN_NAME}.physical_constraints.tcl


###############
# DCT Reports #
###############

set DCRM_DCT_PHYSICAL_CONSTRAINTS_REPORT                ${REPORTS_DIR}/dc/${DESIGN_NAME}.physical_constraints.rpt

set DCRM_DCT_FINAL_CONGESTION_REPORT                    ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.congestion.rpt
set DCRM_DCT_FINAL_CONGESTION_MAP_OUTPUT_FILE           ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.congestion_map.png
set DCRM_DCT_FINAL_CONGESTION_MAP_WINDOW_OUTPUT_FILE    ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.congestion_map_window.png

set DCRM_DCT_FINAL_QOR_SNAPSHOT_FOLDER                  ${REPORTS_DIR}/dc/${DESIGN_NAME}.qor_snapshot
set DCRM_DCT_FINAL_QOR_SNAPSHOT_REPORT                  ${REPORTS_DIR}/dc/${DESIGN_NAME}.qor_snapshot.rpt

####################
# DCT Output Files #
####################

set DCRM_DCT_FLOORPLAN_OUTPUT_FILE                      ${PHYSICAL_DIR}/dc/${DESIGN_NAME}.initial.fp

set DCRM_DCT_FINAL_FLOORPLAN_OUTPUT_FILE                ${PHYSICAL_DIR}/dc/${DESIGN_NAME}.mapped.fp
set DCRM_DCT_FINAL_SPEF_OUTPUT_FILE                     ${PHYSICAL_DIR}/dc/${DESIGN_NAME}.mapped.spef
set DCRM_DCT_FINAL_SDF_OUTPUT_FILE                      ${PHYSICAL_DIR}/dc/${DESIGN_NAME}.mapped.sdf


#################################################################################
# DFT Flow Files
#################################################################################

###################
# DFT Input Files #
###################

set DCRM_DFT_SIGNAL_SETUP_INPUT_FILE                    ${PHYSICAL_DIR}/${DESIGN_NAME}.dft_signal_defs.tcl
set DCRM_DFT_AUTOFIX_CONFIG_INPUT_FILE                  ${PHYSICAL_DIR}/${DESIGN_NAME}.dft_autofix_config.tcl

###############
# DFT Reports #
###############

set DCRM_DFT_DRC_CONFIGURED_VERBOSE_REPORT              ${REPORTS_DIR}/dc/${DESIGN_NAME}.dft_drc_configured.rpt
set DCRM_DFT_SCAN_CONFIGURATION_REPORT                  ${REPORTS_DIR}/dc/${DESIGN_NAME}.scan_config.rpt
set DCRM_DFT_COMPRESSION_CONFIGURATION_REPORT           ${REPORTS_DIR}/dc/${DESIGN_NAME}.compression_config.rpt
set DCRM_DFT_PREVIEW_CONFIGURATION_REPORT               ${REPORTS_DIR}/dc/${DESIGN_NAME}.report_dft_insertion_config.preview_dft.rpt
set DCRM_DFT_PREVIEW_DFT_SUMMARY_REPORT                 ${REPORTS_DIR}/dc/${DESIGN_NAME}.preview_dft_summary.rpt
set DCRM_DFT_PREVIEW_DFT_ALL_REPORT                     ${REPORTS_DIR}/dc/${DESIGN_NAME}.preview_dft.rpt

set DCRM_DFT_FINAL_SCAN_PATH_REPORT                     ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.scanpath.rpt
set DCRM_DFT_DRC_FINAL_REPORT                           ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.dft_drc_inserted.rpt
set DCRM_DFT_FINAL_SCAN_COMPR_SCAN_PATH_REPORT          ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.scanpath.scan_compression.rpt
set DCRM_DFT_DRC_FINAL_SCAN_COMPR_REPORT                ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.dft_drc_inserted.scan_compression.rpt
set DCRM_DFT_FINAL_CHECK_SCAN_DEF_REPORT                ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.check_scan_def.rpt
set DCRM_DFT_FINAL_DFT_SIGNALS_REPORT                   ${REPORTS_DIR}/dc/${DESIGN_NAME}.mapped.dft_signals.rpt

####################
# DFT Output Files #
####################

set DCRM_DFT_FINAL_SCANDEF_OUTPUT_FILE                  ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.scandef
set DCRM_DFT_FINAL_EXPANDED_SCANDEF_OUTPUT_FILE         ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.expanded.scandef
set DCRM_DFT_FINAL_CTL_OUTPUT_FILE                      ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.ctl
set DCRM_DFT_FINAL_PROTOCOL_OUTPUT_FILE                 ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.scan.spf
set DCRM_DFT_FINAL_SCAN_COMPR_PROTOCOL_OUTPUT_FILE      ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.scancompress.spf


set MVRCRM_RTL_READ_SCRIPT                              ${RESULTS_DIR}/dc/${DESIGN_NAME}.MVRC.read_design.tcl
set VCLPRM_RTL_READ_SCRIPT                              ${RESULTS_DIR}/dc/${DESIGN_NAME}.VCLP.read_design.tcl
#################################################################################
# Formality Flow Files
#################################################################################

set DCRM_SVF_OUTPUT_FILE                                ${RESULTS_DIR}/dc/${DESIGN_NAME}.mapped.svf

set FMRM_UNMATCHED_POINTS_REPORT                        ${REPORTS_DIR}/fm/${DESIGN_NAME}.fmv_unmatched_points.rpt

set FMRM_FAILING_SESSION_NAME                           ${DESIGN_NAME}
set FMRM_FAILING_POINTS_REPORT                          ${REPORTS_DIR}/fm/${DESIGN_NAME}.fmv_failing_points.rpt
set FMRM_ABORTED_POINTS_REPORT                          ${REPORTS_DIR}/fm/${DESIGN_NAME}.fmv_aborted_points.rpt
set FMRM_ANALYZE_POINTS_REPORT                          ${REPORTS_DIR}/fm/${DESIGN_NAME}.fmv_analyze_points.rpt

puts "RM-Info: Completed script [info script]\n"
