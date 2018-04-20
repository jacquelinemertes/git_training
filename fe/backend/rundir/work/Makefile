# Variables
timestamp=`date "+%d_%b_%Y_%H.%M.%S"`

# CREATE AREA
create_area:
	mkdir ../../reports/
	mkdir ../../log/

# CLEAN AREA
clean:
	@echo "Cleaning Area"	
	rm -rf ../../reports/ ../../log/ *.cmd *.log *.logv

# FLOORPLANNING
fp: 
	innovus -log ../../log/floorplan_${timestamp}.log -init ../../script/edi/floorplan_fe.tcl

# PLACEMENT
place:
	innovus -log ../../log/place_${timestamp}.log -init ../../script/edi/place.tcl

# CLOCK TREE SYNTHESIS
cts:
	innovus -log ../../log/cts_${timestamp}.log -init ../../script/edi/cts.tcl

# ROUTE
route: 
	innovus -log ../../log/route_${timestamp}.log -init ../../script/edi/route.tcl

# Route Optimization
route_opt:
	innovus -log ../../log/route_opt_${timestamp}.log -init ../../script/edi/route_opt.tcl