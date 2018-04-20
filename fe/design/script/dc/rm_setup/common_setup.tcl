puts "RM-Info: Running script [info script]\n"

##########################################################################################
# Variables common to all reference methodology scripts
# Script: common_setup.tcl
# Version: L-2016.03-SP2 (July 25, 2016)
# Copyright (C) 2007-2016 Synopsys, Inc. All rights reserved.
##########################################################################################

set DESIGN_NAME                   "fe"; #The name of the top-level design

set LIB_DATA                      "/net/tdk/arm/gf/cmos28hpp"

set DESIGN_REF_DATA_PATH          "/net/proj/dspgreen/workarea/eschneider_brp/build_dsp28/dsp28/hardware/blocks/trunk/tcm_dec_top/design/"  ;#  Absolute path prefix variable for library/design data.
				                       #  Use this variable to prefix the common absolute path  
                                       #  to the common variables defined below.
                                       #  Absolute paths are mandatory for hierarchical 
                                       #  reference methodology flow.

##########################################################################################
# Hierarchical Flow Design Variables
##########################################################################################

set HIERARCHICAL_DESIGNS           "" ;# List of hierarchical block design names "DesignA DesignB" ...
set HIERARCHICAL_CELLS             "" ;# List of hierarchical block cell instance names "u_DesignA u_DesignB" ...

##########################################################################################
# Library Setup Variables
##########################################################################################

# For the following variables, use a blank space to separate multiple entries.
# Example: set TARGET_LIBRARY_FILES "lib1.db lib2.db lib3.db"

set ADDITIONAL_SEARCH_PATH        "${DESIGN_REF_DATA_PATH}/rtl";  #  Additional search path to be added to the default search path

set TARGET_LIBRARY_FILES           "$LIB_DATA/logic_ip/sc12mc_base_lvt_c30/r9p0/db/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_lvt_c34/r9p0/db/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c30/r9p0/db-ccs-tn/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p765v_0c.db_ccs_tn \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c34/r9p0/db/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c38/r9p0/db/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c30/r9p0/db/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c34/r9p0/db/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c38/r9p0/db/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c30/r9p0/db/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c34/r9p0/db/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c38/r9p0/db/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_pmk_hvt_c34/r9p0/db/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p765v_0c.db \
$LIB_DATA/logic_ip/sc12mc_pmk_hvt_c38/r9p0/db/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p765v_0c.db"  ;#  Target technology logical libraries

set ADDITIONAL_LINK_LIB_FILES     ""  ;#  Extra link logical libraries not included in TARGET_LIBRARY_FILES

set MIN_LIBRARY_FILES             ""  ;#  List of max min library pairs "max1 min1 max2 min2 max3 min3"...

set MW_REFERENCE_LIB_DIRS         "$LIB_DATA/logic_ip/sc12mc_base_lvt_c30/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_lvt_c30/ \
$LIB_DATA/logic_ip/sc12mc_base_lvt_c34/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_lvt_c34/ \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c30/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_rvt_c30/ \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c34/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_rvt_c34/ \
$LIB_DATA/logic_ip/sc12mc_base_rvt_c38/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_rvt_c38/ \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c30/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_hvt_c30/ \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c34/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_hvt_c34/ \
$LIB_DATA/logic_ip/sc12mc_base_hvt_c38/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_base_hvt_c38/ \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c30/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_pmk_rvt_c30/ \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c34/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_pmk_rvt_c34/ \
$LIB_DATA/logic_ip/sc12mc_pmk_rvt_c38/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_pmk_rvt_c38/ \
$LIB_DATA/logic_ip/sc12mc_pmk_hvt_c34/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_pmk_hvt_c34/ \
$LIB_DATA/logic_ip/sc12mc_pmk_hvt_c38/r9p0/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_cmos28hpp_pmk_hvt_c38/"  ;#  Milkyway reference libraries (include IC Compiler ILMs here)

set MW_REFERENCE_CONTROL_FILE     ""  ;#  Reference Control file to define the Milkyway reference libs

set TECH_FILE                     "${LIB_DATA}/arm_tech/r5p1/milkyway/6U1x_2U2x_2T8x_LB/sc12mc_tech.tf"  ;#  Milkyway technology file
set MAP_FILE                      "${LIB_DATA}/arm_tech/r5p1/synopsys_tluplus/6U1x_2U2x_2T8x_LB/tluplus.map"  ;	#  Mapping file for TLUplus
set TLUPLUS_MAX_FILE              "${LIB_DATA}/arm_tech/r5p1/synopsys_tluplus/6U1x_2U2x_2T8x_LB/FuncRCmax.tluplus"  ;#  Max TLUplus file
set TLUPLUS_MIN_FILE              "${LIB_DATA}/arm_tech/r5p1/synopsys_tluplus/6U1x_2U2x_2T8x_LB/FuncRCmin.tluplus"  ;#  Min TLUplus file

set MIN_ROUTING_LAYER            "M2"   ;	# Min routing layer
set MAX_ROUTING_LAYER            "B2"   ;	# Max routing layer

set LIBRARY_DONT_USE_FILE        ""   ;# Tcl file with library modifications for dont_use

##########################################################################################
# Multivoltage Common Variables
#
# Define the following multivoltage common variables for the reference methodology scripts 
# for multivoltage flows. 
# Use as few or as many of the following definitions as needed by your design.
##########################################################################################

set PD1                          ""           ;# Name of power domain/voltage area  1
set VA1_COORDINATES              {}           ;# Coordinates for voltage area 1
set MW_POWER_NET1                "VDD1"       ;# Power net for voltage area 1

set PD2                          ""           ;# Name of power domain/voltage area  2
set VA2_COORDINATES              {}           ;# Coordinates for voltage area 2
set MW_POWER_NET2                "VDD2"       ;# Power net for voltage area 2

set PD3                          ""           ;# Name of power domain/voltage area  3
set VA3_COORDINATES              {}           ;# Coordinates for voltage area 3
set MW_POWER_NET3                "VDD3"       ;# Power net for voltage area 3

set PD4                          ""           ;# Name of power domain/voltage area  4
set VA4_COORDINATES              {}           ;# Coordinates for voltage area 4
set MW_POWER_NET4                "VDD4"       ;# Power net for voltage area 4

puts "RM-Info: Completed script [info script]\n"

