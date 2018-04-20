#*******************************************************************************#
#                       INSTITUTO DE PESQUISA ELDORADO 2016                     #
#*******************************************************************************#
# FILE NAME   : Makefile                                                        #
# TYPE        : -                                                               #
# DEPARTMENT  : DHD                                                             #
# PROJECT     : DSP28                                                           #
# AUTHOR      : Jacqueline G. Mertes                                            #
# AUTHOR EMAIL: jacqueline.mertes@eldorado.org.br                               #
#*******************************************************************************#
# PURPOSE: Makefile for starting Innovus with different options.                #
#*******************************************************************************#
# Standard variables
REPORT_DIR=../../reports/innovus
LOG_DIR=../../log/innovus
TIMESTAMP=`date "+%d_%b_%Y_%H.%M.%S"`

# Executable as variable to be able to add commandline options quickly
#encounter=/net/edatools/cadence/edi/14.27.000-ISR7/bin/encounter -64
encounter=/apps/cadence/EDI_14_28_s033_1/bin/encounter -edsxl -64
#cdnshelp=/net/edatools/cadence/edi/14.27.000-ISR7/bin/cdnshelp -hierarchy /net/edatools/cadence/edi/14.27.000-ISR7/doc/xmlreg/library.lbr

innovus=innovus

help:
	@echo "---------------------------------------------------"
	@echo "make clean                # Remove all links and log files"
	@echo "make clean_rundir         # Delete all temp files in rundir, keeping Makefile"
	@echo "make setup                # Create directories, clean first"
	@echo "---------------------------------------------------"
	@echo "make gui                  # Start Encounter with GUI"
	@echo "make nogui                # Start Encounter without GUI"
	@echo "make floorplan            # Define floorplan"
	@echo "make place                # Place standard cells"
	@echo "make pre_cts_opt          # Post place timing optimization"
	@echo "make cts_ccopt            # Clock tree insertion and concurent timing optimization with CCOpt"
	@echo "make post_cts_opt         # Post clock tree optimization for power and timing using GigaOpt"
	@echo "make route                # Route the design"
	@echo "make post_route_opt       # Post route signoff timing and power optimization with GigaOpt"
	@echo "make flow                 # Start Encounter and run complete flow"

setup:  clean clean_rundir
	@echo "### Creating directory structure"
	@mkdir -p  ${REPORT_DIR} ${LOG_DIR}

clean:
	@echo "### Removing old log files, libraries and designs"
	@rm -rf ${REPORT_DIR} ${LOG_DIR}

clean_rundir:
	@echo "### Cleaning rundir"
	@mv Makefile ..;rm -rf * .*;mv ../Makefile .

#*******************************************************************************#

gui:	
	${innovus} -log ${LOG_DIR}/interactive_${TIMESTAMP}.log

nogui:	
	${innovus} -log ${LOG_DIR}/interactive_${TIMESTAMP}.log -nowin

flow:
	${innovus} -log ${LOG_DIR}/make_flow.log   -overwrite -init ../../script/innovus/flow.tcl  

floorplan:
	${innovus} -log ${LOG_DIR}/floorplan.log   -overwrite -init ../../script/innovus/floorplan.tcl  

quick_pr:
	${innovus} -log ${LOG_DIR}/quick_pr.log    -overwrite  -init ../../script/innovus/quick_pr.tcl  

place:
	${innovus} -log ${LOG_DIR}/place.log    -overwrite  -init ../../script/innovus/place.tcl  

pre_cts_opt:
	${innovus} -log ${LOG_DIR}/pre_cts_opt.log -overwrite -init ../../script/innovus/pre_cts_opt.tcl  

cts_ccopt:
	${innovus} -log ${LOG_DIR}/cts_ccopt.log  -overwrite -init ../../script/innovus/cts_ccopt.tcl 
 

post_cts_opt:
	${innovus} -log ${LOG_DIR}/post_cts_opt.log -overwrite -init ../../script/innovus/post_cts_opt.tcl  

route:
	${innovus} -log ${LOG_DIR}/route.log   -overwrite -init ../../script/innovus/route.tcl  

post_route_opt:
	export TMPDIR=. && \
	${innovus} -log ${LOG_DIR}/post_route_opt.log -overwrite -init ../../script/innovus/post_route_opt.tcl  

post_route_opt_iqrc:
	export TMPDIR=. && \
	${innovus} -log ${LOG_DIR}/post_route_opt_iqrc.log -overwrite -init ../../script/innovus/post_route_opt_iqrc.tcl  

post_route_opt_signoff:
	export TMPDIR=. && \
	${innovus} -log ${LOG_DIR}/post_route_opt_signoff.log -overwrite -init ../../script/innovus/post_route_opt_signoff.tcl  

eco1:
	@echo "# Executing ECO Timing Closure scripts"
	${innovus} -log  ../../log/innovus/timingclosure_1a.log -overwrite -init ../../script/innovus/timingclosure_1.tcl  

rpthelp:
	@echo "make rptfp    		# De-compacting Floorplan Reports"
	@echo "make rplpc	 	# De-compacting Placement Reports"
	@echo "make rptcts		# De-compacting Clock Tree Synthesis Reports"
	@echo "make rptrt		# De-compacting Route Reports"
	@echo "make rptprt		# De-compacting Post Route Optimization Reports"
	@echo "make rpteco		# De-compacting ECO Timing Closure Reports"
	@echo "make rptexp		# De-compacting Export Design Reports"
	@echo "make openrptfp    	# Opening Floorplan Reports"
	@echo "make openrplpc	 	# Opening Placement Reports"
	@echo "make openrptcts		# Opening Clock Tree Synthesis Reports"
	@echo "make openrptrt		# Opening Route Reports"
	@echo "make openrptprt		# Opening Post Route Optimization Reports"
	@echo "make openrpteco		# Opening ECO Timing Closure Reports"
	@echo "make openrptexp		# Opening Export Design Reports"

rptfp:
	@echo "# De-compacting Floorplan Reports" && \
        echo ../../reports/innovus/floorplan/*.tarpt.gz | xargs -n 1 gunzip -f 

rptpc:
	@echo "# De-compacting Place Reports" && \
        echo ../../reports/innovus/place/*.tarpt.gz | xargs -n 1 gunzip -f && \
        echo ../../reports/innovus/place/*.summary.gz | xargs -n 1 gunzip -f

rptcts:
	@echo "# De-compacting CTS Reports" && \
        echo ../../reports/innovus/cts_ccopt/*.tarpt.gz | xargs -n 1 gunzip -f && \
        echo ../../reports/innovus/place/*.summary.gz | xargs -n 1 gunzip -f

rptrt:
	@echo "# De-compacting Route Reports" && \
        echo ../../reports/innovus/route/*.tarpt.gz | xargs -n 1 gunzip -f && \
        echo ../../reports/innovus/place/*.summary.gz | xargs -n 1 gunzip -f

rptprt:
	@echo "# De-compacting Post-route Reports" && \
        echo ../../reports/innovus/post_route_opt/*.tarpt.gz | xargs -n 1 gunzip -f && \
        echo ../../reports/innovus/place/*.summary.gz | xargs -n 1 gunzip -f

openrptpc:
	@echo "	# Opening Placement Reports"
	@${edit} ../../reports/innovus/*place*
	@${edit} ../../reports/innovus/*place*/*preplace*
	@${edit} ../../reports/innovus/*place*/*place_pre*
	@${edit} ../../reports/innovus/*place*/*place_opt*



openrptcts:
	@echo "	# Opening Clock Tree Synthesis Reports"
	@${edit} ../../reports/innovus/clockDesign/*
	@${edit} ../../reports/innovus/*cts_pre*
	@${edit} ../../reports/innovus/*cts_opt*
	@${edit} ../../reports/innovus/*cts_pre*/*cts_pre*
	@${edit} ../../reports/innovus/*cts_opt*/*cts_opt*

openrptrt:
	@echo "	# Opening Route Reports"
	#Summaries
	@${edit} ../../reports/innovus/$top_name.design_summary.rpt.route_pre_drc \
	../../reports/innovus/$top_name.design_summary.rpt.route
	#Verify
	@${edit} ../../reports/innovus/$top_name.verifyconnectivity.rpt.route_pre_drc \
	../../reports/innovus/$top_name.verifygeometry.rpt.route_pre_drc \
	../../reports/innovus/$top_name.verifyantenna.rpt.route_pre_drc \
	../../reports/innovus/$top_name.verifygeometry.rpt.route
	#STA Setup
	@${edit} ../../reports/innovus/sta_route/*summ* \
	../../reports/innovus/sta_route/*tarpt
	#Shield
	@${edit} ../../reports/innovus/$top_name.clock_shield.rpt.route
	#DRV
	@${edit} ../../reports/innovus/$top_name.max_fanout.rpt.route \
	../../reports/innovus/$top_name.max_transition.rpt.route \
	../../reports/innovus/$top_name.max_capacitance.rpt.route \
	../../reports/innovus/$top_name.wirelength.rpt.route
	#cts report
	@${edit} ../../reports/innovus/$top_name.ss_0p81v_0p81v_m40c_Cmax_func_impl.func.clock_latency.rpt

openrptprt:
	@echo "	# Opening Post Route Optimization Reports"
	#optDesign  -postRoute  -prefix sta_route_opt1  -outDir ../../reports/innovus/sta_route_opt1 -expandedViews
	@${edit} \
	../../reports/innovus/sta_route_opt1/*summ* \
	../../reports/innovus/sta_route_opt1/*tarpt
	#Verify
	@${edit} \
	../../reports/innovus/$top_name.verifyconnectivity.rpt.route_opt1 \
	../../reports/innovus/$top_name.verifygeometry.rpt.route_opt1 \
	../../reports/innovus/$top_name.verifyantenna.rpt.route_opt1 \
	#summaryReport -noHtml     -outfile  ../../reports/innovus/$top_name.design_summary.rpt.route_opt1
	@${edit} \
	../../reports/innovus/$top_name.design_summary.rpt.route_opt1
	#timeDesign
	@${edit} \
	../../reports/innovus/sta_route_opt1/*summ* \
	../../reports/innovus/sta_route_opt1/*tarpt
	#reportShield
	@${edit} \
	../../reports/innovus/$top_name.clock_shield.rpt.route_opt1 
	#DRV
	@${edit} \
	../../reports/innovus/$top_name.max_fanout.rpt.route_opt1 \
	../../reports/innovus/$top_name.max_transition.rpt.route_opt1 \
	../../reports/innovus/$top_name.max_capacitance.rpt.route_opt1 \
	../../reports/innovus/$top_name.wirelength.rpt.route_opt1 

openrpteco:
	@echo "	# Opening ECO Timing Closure Reports"

openrptexp:
	@echo "	# Opening Export Design Reports"


scripthelp:
	@echo "make opentcl    		# Open TCL Scripts"
	@echo "make chmodtcl	 	# Change permintion to innovust the TCL Scripts (764)"

opentcl:
	@echo "	# Opening TCL Scripts"
	@${edit} ../../script/innovus/*.tcl ../../script/innovus/Makefile &

chmodtcl:
	@echo "	# Changing permition to innovust the TCL Scripts (764)"
	@chmod 764 ../../script/innovus -R


