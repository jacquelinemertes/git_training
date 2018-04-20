source -echo -verbose ../../script/dc/rm_setup/common_setup.tcl
source -echo -verbose ../../script/dc/rm_setup/dc_setup_filenames.tcl

puts "RM-Info: Running script [info script]\n"

#################################################################################
# Design Compiler Reference Methodology Setup for Hierarchical Flow
# Script: dc_setup.tcl
# Version: L-2016.03-SP2 (July 25, 2016)
# Copyright (C) 2007-2016 Synopsys, Inc. All rights reserved.
#################################################################################

##########################################################################################
# Hierarchical Flow Blocks
#
# If you are performing a hierarchical flow, define the hierarchical designs here.
# List the reference names of the hierarchical blocks.  Cell instance names will
# be automatically derived from the design names provided.
#
# Note: These designs are expected to be unique. There should not be multiple
#       instantiations of physical hierarchical blocks.
#
##########################################################################################

# Each of the hierarchical designs specified in ${HIERARCHICAL_DESIGNS} in the common_setup.tcl file
# should be added to only one of the lists below:

set synth_dft false

set DDC_HIER_DESIGNS                    ""  ;# List of Design Compiler hierarchical design names (.ddc will be read)
set DC_BLOCK_ABSTRACTION_DESIGNS        ""  ;# List of Design Compiler block abstraction hierarchical designs (.ddc will be read)
                                             # without transparent interface optimization
set DC_BLOCK_ABSTRACTION_DESIGNS_TIO    ""  ;# List of Design Compiler block abstraction hierarchical designs
                                             # with transparent interface optimization
set ICC_BLOCK_ABSTRACTION_DESIGNS       ""  ;# List of IC Compiler block abstraction hierarchical design names (Milkyway will be read)


#################################################################################
# Setup Variables
#
# Modify settings in this section to customize your Design Compiler Reference 
# Methodology run.
# Portions of dc_setup.tcl may be used by other tools so program name checks
# are performed where necessary.
#################################################################################

  # The following setting removes new variable info messages from the end of the log file
  set_app_var sh_new_variable_message false

if {$synopsys_program_name == "dc_shell"}  {

  #################################################################################
  # Design Compiler Setup Variables
  #################################################################################

  # Use the set_host_options command to enable multicore optimization to improve runtime.
  # This feature has special usage and license requirements.  Refer to the 
  # "Support for Multicore Technology" section in the Design Compiler User Guide
  # for multicore usage guidelines.
  # Note: This is a DC Ultra feature and is not supported in DC Expert.

  set_host_options -max_cores 4

  # Change alib_library_analysis_path to point to a central cache of analyzed libraries
  # to save runtime and disk space.  The following setting only reflects the
  # default value and should be changed to a central location for best results.

  set_app_var alib_library_analysis_path .

  # Add any additional Design Compiler variables needed here

}

# Note: When autoread is used ${RTL_SOURCE_FILES} can include a list of
#       both directories and files.


set RTL_SOURCE_FILES  "\
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/sat.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/rnd.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/rnd_sat.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf2_fifo.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf2ii_serial.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf2i_serial.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf8_serial.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/fft_serial_hi_lo.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/twm64.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/twm16.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf16.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/bf4.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/fft_64.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/twm512_hi_lo.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/fft512_hi_lo.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/max_tree.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/pow_4.sv \
/net/proj/dspgreen/workarea/ltomazine_brp/build/fe/design/rtl/fe.sv"      ; # Enter the list of source RTL files if reading from RTL

#################################################################################
# Search Path Setup
#
# Set up the search path to find the libraries and design files.
#################################################################################

  set_app_var search_path ". ${ADDITIONAL_SEARCH_PATH} $search_path"

  # For a hierarchical flow, add the block-level results directories to the
  # search path to find the block-level design files.

#  set HIER_DESIGNS "${DDC_HIER_DESIGNS} ${DC_BLOCK_ABSTRACTION_DESIGNS} ${DC_BLOCK_ABSTRACTION_DESIGNS_TIO}"
#  foreach design $HIER_DESIGNS {
    lappend search_path ../../structural/dc
#  }

#################################################################################
# Library Setup
#
# This section is designed to work with the settings from common_setup.tcl
# without any additional modification.
#################################################################################

  # Milkyway variable settings

  # Make sure to define the Milkyway library variable
  # mw_design_library, it is needed by write_milkyway command

  set mw_reference_library ${MW_REFERENCE_LIB_DIRS}
  set mw_design_library ${DCRM_MW_LIBRARY_NAME}

  set mw_site_name_mapping { {CORE unit} {Core unit} {core unit} }

# The remainder of the setup below should only be performed in Design Compiler
if {$synopsys_program_name == "dc_shell"}  {

  set_app_var target_library ${TARGET_LIBRARY_FILES}
  set_app_var synthetic_library dw_foundation.sldb
  set_app_var link_library "* $target_library $ADDITIONAL_LINK_LIB_FILES $synthetic_library"

  # Set min libraries if they exist
  foreach {max_library min_library} $MIN_LIBRARY_FILES {
    set_min_library $max_library -min_version $min_library
  }

  # Set the variable to use Verilog libraries for Test Design Rule Checking
  # (See dc.tcl for details)

  # set_app_var test_simulation_library <list of Verilog library files>

  if {[shell_is_in_topographical_mode]} {

    # To activate the extended layer mode to support 4095 layers uncomment the extend_mw_layers command 
    # before creating the Milkyway library. The extended layer mode is permanent and cannot be reverted 
    # back to the 255 layer mode once activated.

    extend_mw_layers

    # Only create new Milkyway design library if it doesn't already exist
    if {![file isdirectory $mw_design_library ]} {
      create_mw_lib   -technology $TECH_FILE \
                      -mw_reference_library $mw_reference_library \
                      $mw_design_library
    } else {
      # If Milkyway design library already exists, ensure that it is consistent with specified Milkyway reference libraries
      set_mw_lib_reference $mw_design_library -mw_reference_library $mw_reference_library
    }

    open_mw_lib     $mw_design_library

    check_library > ${DCRM_CHECK_LIBRARY_REPORT}

    set_tlu_plus_files -max_tluplus $TLUPLUS_MAX_FILE \
                       -min_tluplus $TLUPLUS_MIN_FILE \
                       -tech2itf_map $MAP_FILE

    check_tlu_plus_files
  }

  #################################################################################
  # Library Modifications
  #
  # Apply library modifications after the libraries are loaded.
  #################################################################################

  if {[file exists [which ${LIBRARY_DONT_USE_FILE}]]} {
    puts "RM-Info: Sourcing script file [which ${LIBRARY_DONT_USE_FILE}]\n"
    source -echo -verbose ${LIBRARY_DONT_USE_FILE}
  }
}

puts "RM-Info: Completed script [info script]\n"

