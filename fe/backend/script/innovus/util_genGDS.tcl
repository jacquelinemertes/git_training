#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : util_genGDS.tcl                                                #
# TYPE         : Tool Command Language                                          #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP28                                                          #
# AUTHOR       : Jeroen vermeeren                                               #
# AUTHOR EMAIL : Jeroen.Vermeeren@team.eldorado.org.br                          # 
#*******************************************************************************#
# PURPOSE : Script with GDS generate Procedures                                 #
#*******************************************************************************#

proc gds_write_full {structureName outputExtention outputDirectory } {

  global dbgLefDefOutVersion
  puts "Usage: gds_write_full <cell name> <output extention> <output directory>"
  puts "       Merge with ALL gds2 files "

  setStreamOutMode -SEvianames        true
  setStreamOutMode -virtualConnection false

  streamOut ${outputDirectory}/${structureName}_${outputExtention}.gds.gz \
    -mapFile              ../../script/innovus/cmos28hp_soc.stream.map   \
    -libName DesignLib \
    -structureName ${structureName} \
    -outputMacros \
    -uniquifyCellNames \
    -attachInstanceName 102 \
    -attachNetName 103 \
    -dieAreaAsBoundary \
    -stripes 1 \
    -units 1000 \
    -mode ALL \
    -offset 0 0 \
    -merge \
    { \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_lvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_lvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/gds2/sc12mc_cmos28hpp_pmk_hvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/gds2/sc12mc_cmos28hpp_pmk_hvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_eco_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/gds2/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_6U1x_2U2x_2T8x_LB.gds2 \
    	../../../../dsp28/backend/physical/gds/pad_power1.gds.gz \
    }
   # This takes too long for big designs
   # summaryReport -noHtml -outfile ${outputDirectory}/${structureName}_${outputExtention}.summary.rpt
}


proc gds_write_tiling {structureName outputExtention outputDirectory } {

  global dbgLefDefOutVersion
  puts "Usage: gds_write_tiling <cell name> <output extention> <output directory>"
  puts "       Create gds2 file of tiling structures only. "

  setStreamOutMode -SEvianames        true
  setStreamOutMode -virtualConnection false
  
  streamOut ${outputDirectory}/${structureName}_${outputExtention}.gds.gz \
    -mapFile              ../../script/edi/cmos28hp_soc.stream.map   \
    -libName DesignLib \
    -structureName ${structureName} \
    -outputMacros \
    -uniquifyCellNames \
    -attachInstanceName 102 \
    -attachNetName 103 \
    -dieAreaAsBoundary \
    -stripes 1 \
    -units 1000 \
    -mode FILLONLY \
    -offset 0 0 \
    -merge \
    { \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_lvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_lvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/gds2/sc12mc_cmos28hpp_base_rvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/gds2/sc12mc_cmos28hpp_base_hvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/gds2/sc12mc_cmos28hpp_pmk_rvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/gds2/sc12mc_cmos28hpp_pmk_hvt_c34.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/gds2/sc12mc_cmos28hpp_pmk_hvt_c38.gds2 \
        /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/gds2/sc12mc_cmos28hpp_eco_rvt_c30.gds2 \
        /net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/gds2/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_6U1x_2U2x_2T8x_LB.gds2 \
	    ../../../../dsp28/backend/physical/gds/pad_power1.gds.gz \
    }
}

