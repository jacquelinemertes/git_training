#*******************************************************************************#
#                     INSTITUTO DE PESQUISA ELDORADO 2016                       #
#*******************************************************************************#
# FILE NAME    : mmmc.tcl                                                       #
# TYPE         : tcl scripts                                                    #
# DEPARTMENT   : Design House Eldorado                                          #
# PROJECT      : DSP Green                                                      #
# AUTHOR       : Jeroen vermeeren                                               #
# AUTHOR EMAIL : jeroen.vermeeren@team.eldorado.org.br                          # 
#*******************************************************************************#
# PURPOSE :      Encounter technology definition and multi-mode                 #
#                multi-corner setup                                             #
#*******************************************************************************#

##################################################
## LEF file definition
##################################################

set init_lef_file  "\
  /net/tdk/arm/gf/cmos28hpp/arm_tech/r5p1/lef/6U1x_2U2x_2T8x_LB/sc12mc_tech.lef\
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lef/sc12mc_cmos28hpp_base_lvt_c30.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lef/sc12mc_cmos28hpp_base_lvt_c34.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lef/sc12mc_cmos28hpp_base_rvt_c30.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lef/sc12mc_cmos28hpp_base_rvt_c34.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lef/sc12mc_cmos28hpp_base_rvt_c38.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lef/sc12mc_cmos28hpp_base_hvt_c30.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lef/sc12mc_cmos28hpp_base_hvt_c34.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lef/sc12mc_cmos28hpp_base_hvt_c38.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lef/sc12mc_cmos28hpp_pmk_rvt_c30.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lef/sc12mc_cmos28hpp_pmk_rvt_c34.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lef/sc12mc_cmos28hpp_pmk_rvt_c38.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lef/sc12mc_cmos28hpp_pmk_hvt_c34.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lef/sc12mc_cmos28hpp_pmk_hvt_c38.lef \
  /net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lef/sc12mc_cmos28hpp_eco_rvt_c30.lef \
  /net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lef/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_6U1x_2U2x_2T8x_LB.lef \
  ../../../../dsp28/backend/physical/lef/pad_power1_mod.lef \
  ../../../../dsp28/backend/physical/lef/pad_wb60_91_v2IO.lef \
  ../../../../dsp28/backend/physical/lef/bump.lef \
  "
  
##################################################
## LIBRARY SETS
##################################################

create_library_set \
	-name   ssa_0p765v_0c_libset \
	-timing [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p765v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ss_nominal_0p765v_1p65v_0c.lib \ 
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p765v_0c_5pct.aocv3 \
	]

create_library_set \
	-name   ssa_0p765v_125c_libset \
	-timing [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p765v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ss_nominal_0p765v_1p65v_125c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p765v_125c_5pct.aocv3 \
	]

create_library_set \
	-name   ffa_0p945v_125c_libset \
	-timing [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ffa_nominal_min_0p945v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ff_nominal_0p945v_1p95v_125c.lib \
	] \
	-aocv   [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ffa_nominal_min_0p945v_125c_10pct.aocv3 \
	]

create_library_set \
	-name   ffa_0p945v_0c_libset \
	-timing [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ffa_nominal_min_0p945v_0c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ff_nominal_0p945v_1p95v_0c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ffa_nominal_min_0p945v_0c_10pct.aocv3 \
	]

create_library_set \
	-name   ssa_0p81v_m40c_libset \
	-timing [ list \
		 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p81v_m40c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ss_nominal_0p81v_1p65v_m40c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p81v_m40c_5pct.aocv3 \
	]

create_library_set \
	-name   ssa_0p81v_125c_libset \
	-timing [ list \
		 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p81v_125c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_ss_nominal_0p81v_1p65v_125c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_ssa_nominal_max_0p81v_125c_5pct.aocv3 \
	]

create_library_set \
	-name   tt_0p90v_25c_libset \
	-timing [ list \
		 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_tt_nominal_max_0p90v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_tt_nominal_0p90v_1p80v_25c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_tt_nominal_max_0p90v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_tt_nominal_max_0p90v_25c_7pct.aocv3 \
	]

create_library_set \
	-name   tt_0p85v_25c_libset \
	-timing [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c30_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_lvt_c34_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c30_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c34_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_rvt_c38_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c30_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c34_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_base_hvt_c38_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c30_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c34_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_rvt_c38_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c34_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_pmk_hvt_c38_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/lib-ecsm-t/sc12mc_cmos28hpp_eco_rvt_c30_tt_nominal_max_0p85v_25c.lib_ecsm_t \
		/net/tdk/arm/gf/cmos28hpp/io/io_gppr_t18_085_mv18_tl25_rvt_dr/r3p1/lib/io_gppr_cmos28hpp_t18_085_mv18_tl25_rvt_dr_tt_nominal_0p85v_1p80v_25c.lib \
	] \
	-aocv [ list \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c30_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_lvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_lvt_c34_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c30_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c34_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_rvt_c38_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c30/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c30_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c34_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_base_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_base_hvt_c38_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c30_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c34_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_rvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_rvt_c38_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c34/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c34_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_pmk_hvt_c38/r9p0/aocv/sc12mc_cmos28hpp_pmk_hvt_c38_tt_nominal_max_0p85v_25c_7pct.aocv3 \
		/net/tdk/arm/gf/cmos28hpp/logic_ip/sc12mc_eco_rvt_c30/r9p0/aocv/sc12mc_cmos28hpp_eco_rvt_c30_tt_nominal_max_0p85v_25c_7pct.aocv3 \
	]
		
##################################################
# RC CORNERS
##################################################
# Setup extraction corners
create_rc_corner \
	-name             FuncCmax_m40c \
	-T                -40 \
	-qx_tech_file     $QX_TECH_PATH/FuncCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncCmax_0c \
	-T                0 \
	-qx_tech_file     $QX_TECH_PATH/FuncCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncCmax_125c \
	-T                125 \
	-qx_tech_file     $QX_TECH_PATH/FuncCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncRCmax_m40c \
	-T                -40 \
	-qx_tech_file     $QX_TECH_PATH/FuncRCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncRCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncRCmax_0c \
	-T                0 \
	-qx_tech_file     $QX_TECH_PATH/FuncRCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncRCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncRCmax_125c \
	-T                125 \
	-qx_tech_file     $QX_TECH_PATH/FuncRCmax/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncRCmax.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 



# Hold extraction corners
create_rc_corner \
	-name             FuncCmin_0c \
	-T                0 \
	-qx_tech_file     $QX_TECH_PATH/FuncCmin/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncCmin.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncCmin_125c \
	-T                125 \
	-qx_tech_file     $QX_TECH_PATH/FuncCmin/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncCmin.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncRCmin_0c \
	-T                0 \
	-qx_tech_file     $QX_TECH_PATH/FuncRCmin/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncRCmin.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

create_rc_corner \
	-name             FuncRCmin_125c \
	-T                125 \
	-qx_tech_file     $QX_TECH_PATH/FuncRCmin/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/FuncRCmin.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 



# Typical extraction corners
create_rc_corner \
	-name             nominal_25c \
	-T                25 \
	-qx_tech_file     $QX_TECH_PATH/nominal/qrcTechFile \
	-cap_table        $CAPTABLE_PATH/nominal.captbl \
	-preRoute_res     1.00 \
	-preRoute_cap     1.00 \
	-preRoute_clkres  1.00 \
	-preRoute_clkcap  1.00 \
	-postRoute_res    1.00 \
	-postRoute_cap    1.00 \
	-postRoute_clkres 1.00 \
	-postRoute_clkcap 1.00 \
	-postRoute_xcap   1.00 

##################################################
## CONSTRAINT MODES
##################################################
create_constraint_mode \
    -name functional \
    -sdc_files " \
    ../../constraints/${topmodule}_base.sdc \
    ../../constraints/${topmodule}_functional.sdc \
"
create_constraint_mode \
    -name scan_launch \
    -sdc_files " \
    ../../constraints/${topmodule}_base.sdc \
    ../../constraints/${topmodule}_scan_launch.sdc \
"
create_constraint_mode \
    -name scan_shift \
    -sdc_files " \
    ../../constraints/${topmodule}_base.sdc \
    ../../constraints/${topmodule}_scan_shift.sdc \
"

create_constraint_mode \
    -name functional_signoff \
    -sdc_files " \
    ../../constraints/${topmodule}_base_signoff.sdc \
    ../../constraints/${topmodule}_functional.sdc \
"
create_constraint_mode \
    -name scan_launch_signoff \
    -sdc_files " \
    ../../constraints/${topmodule}_base_signoff.sdc \
    ../../constraints/${topmodule}_scan_launch.sdc \
"
create_constraint_mode \
    -name scan_shift_signoff \
    -sdc_files " \
    ../../constraints/${topmodule}_base_signoff.sdc \
    ../../constraints/${topmodule}_scan_shift.sdc \
"

##################################################
#  DELAY CORNERS
##################################################

foreach library_set [ all_library_sets ] {
   foreach rc_corner  [ all_rc_corners ] { 
       create_delay_corner \
	   -name        ${library_set}_${rc_corner} \
	   -library_set ${library_set} \
	   -rc_corner   ${rc_corner}
   }
}

##################################################
#  ANALYSIS VIEWS
##################################################

foreach delay_corner [all_delay_corners ] {
   foreach constraint_mode [ all_constraint_modes ] {    
       create_analysis_view -name ${delay_corner}_${constraint_mode} \
	 -delay_corner ${delay_corner} \
	 -constraint_mode ${constraint_mode}
   }
}
