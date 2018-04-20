#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : globals.tcl                                                    #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jeroen vermeeren                                               #
# AUTHOR EMAIL : jeroen.vermeeren@team.eldorado.org.br                          # 
#*******************************************************************************#
# PURPOSE :      Variable definitions and global settings to load before        #
#                design initialization.                                         #
#*******************************************************************************#

set DESIGN_REF_DATA_PATH  "/net/tdk/arm/gf/cmos28hpp"
#set MEM_LEFS_DATA_PATH    "/net/proj/dsp_pd/workarea/tsuzuki/memorias"
#set MEM_LIBS_DATA_PATH    "/net/proj/dsp_pd/workarea/tsuzuki/memorias"
set CAPTABLE_PATH         "${DESIGN_REF_DATA_PATH}/arm_tech/r5p0/cadence_captable/6U1x_2U2x_2T8x_LB"
set QX_TECH_PATH          "${DESIGN_REF_DATA_PATH}/pdk-28HPP_V1.1_2.0/QRC/6U1x_2U2x_2T8x_LB"

setUserDataValue defHierChar {/}

set init_import_mode          { \
 -syncRelativePath true \
 -bufferTieAssign true \
 -bufferFeedThruAssign false \
 -verticalRow false \
 -treatUndefinedCellAsBbox false \
 -minDbuPerMicron 0 \
 -keepEmptyModule true \
 }

set init_design_settop { 1 }
set init_assign_buffer {  1  -buffer  BUFH_X4M_A12TH_C38  }
set init_design_netlisttype { Verilog }
set init_design_settop       { 1 }

set init_assign_buffer       {  1  -buffer  BUFH_X4M_A12TH_C38  }

set init_io_file             { }


set init_portable_path_vars  { 0 }

set init_abstract_view       { }
set init_cpf_file            { }
set init_layout_view         { }

set init_oa_design_cell      { }
set init_oa_design_lib       { }
set init_oa_design_view      { }
set init_oa_ref_lib          { }
set init_oa_search_lib       { }

