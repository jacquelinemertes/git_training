

### pt_setup.tcl file              ###




puts "RM-Info: Running script [info script]\n"
### Start of PrimeTime Runtime Variables ###

##########################################################################################
# PrimeTime Variables PrimeTime Reference Methodology script
# Script: pt_setup.tcl
# Version: K-2015.06 (July 13, 2015)
# Copyright (C) 2008-2015 Synopsys All rights reserved.
##########################################################################################


######################################
# Report and Results Directories
######################################

set REPORTS_DIR "reports0"
set RESULTS_DIR "results0"


######################################
# Library and Design Setup
######################################

### Mode : Generic

set search_path ". $ADDITIONAL_SEARCH_PATH $search_path"
set target_library $TARGET_LIBRARY_FILES
set link_path "* $target_library $ADDITIONAL_LINK_LIB_FILES"

# Provide list of Verilog netlist files. It can be compressed --- example "A.v B.v C.v"
set NETLIST_FILES "../../structural/dc/fe.mapped.v"
# DESIGN_NAME is checked for existence from common_setup.tcl
if {[string length $DESIGN_NAME] > 0} {
} else {
set DESIGN_NAME "fe"  ;#  The name of the top-level design
}




#######################################
# Non-DMSA Power Analysis Setup Section
#######################################

# switching activity (VCD/SAIF) file 
set ACTIVITY_FILE ../../../modeling/testbench/script/fe.vcd
# strip_path setting for the activity file
set STRIP_PATH "sc_main/dut_rtl/rtl/fe/fe_uu"

## name map file
set NAME_MAP_FILE ""





######################################
# Back Annotation File Section
######################################
# The recommended order is to put the block spefs first then the top so that block spefs are read 1st then top
# For example 
# PARASITIC_FILES "blk1.sbpf blk2.sbpf ... top.sbpf"
# PARASITIC_PATHS "u_blk1 u_blk2 ... top"
# If you are loading the node coordinates by setting read_parasitics_load_locations true, it is more efficient
# to read the top first so that block coordinates can be transformed as they are read in
# Each PARASITIC_PATH entry corresponds to the related PARASITIC_FILE for the specific block"  
# For toplevel PARASITIC file please use the toplevel design name in PARASITIC_PATHS variable."   
set PARASITIC_FILES	 "../../physical/dc/fe.mapped.spef"
set PARASITIC_PATHS	 "" 

######################################
# Constraint Section Setup
######################################
set CONSTRAINT_FILES "../../constraints/fe.tcl"  








######################################
# End
######################################

### End of PrimeTime Runtime Variables ###
puts "RM-Info: Completed script [info script]\n"
