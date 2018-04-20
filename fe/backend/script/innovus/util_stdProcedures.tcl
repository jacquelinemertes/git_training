#*******************************************************************************#
#                       INSTITUTO DE PESQUISA ELDORADO 2016                     #
#*******************************************************************************#
# FILE NAME   : util_stdProcedures.tcl                                          #
# TYPE        : Tool Command Language                                           #
# DEPARTMENT  : DHW                                                             #
# PROJECT     : DSP28                                                           #
# AUTHOR      : Jeroen Vermeeren                                                #
# AUTHOR EMAIL: Jeroen.Vermeeren@team.eldorado.org.br                           #
#*******************************************************************************#
# PURPOSE : Script with Standard prodecures for Encounter Digital               #
#           Implementation                                                      #
#*******************************************************************************#

# 
proc getobjectinfo {objectName var} {
    global ${var}
    if { [ set obj  [ dbGetInstByName ${objectName} ]] } {
       set obj                     [ dbGetInstByName ${objectName} ]
       # preplace the instance, sometimes we get wrong info back
       if  { ! [ dbIsInstPlaced $obj ] } {dbPlaceInst $obj -2000000 0 R0}
       array unset ${var}       
       set ${var}(obj)             ${obj}
       set ${var}(x1)                   [ dbDBUToMicrons [ dbBoxLLX [ dbInstBox ${obj}]  ] ]
       set ${var}(y1)                   [ dbDBUToMicrons [ dbBoxLLY [ dbInstBox ${obj}]  ] ]
       set ${var}(x2)                   [ dbDBUToMicrons [ dbBoxURX [ dbInstBox ${obj}]  ] ]
       set ${var}(y2)                   [ dbDBUToMicrons [ dbBoxURY [ dbInstBox ${obj}]  ] ]
       set ${var}(ori)             [ dbInstOrient ${obj} ]
       set ${var}(name)            ${objectName}
       set ${var}(inst_width)           [ dbDBUToMicrons [expr [ dbBoxURX [ dbInstBox ${obj} ] ] - [ dbBoxLLX [ dbInstBox ${obj} ] ] ] ]
       set ${var}(inst_height)     [ dbDBUToMicrons [expr [ dbBoxURY [ dbInstBox ${obj} ] ] - [ dbBoxLLY [ dbInstBox ${obj} ] ] ] ]
       set ${var}(inst_len)           ${var}(inst_width)
       set ${var}(cell_type)           [ dbInstCellName ${obj} ]
       set ${var}(nr_term)           [ dbInstNrTerm  ${obj} ]
        #puts "Load info for instance ${objectName}"
    } else {
        puts "Error : Instance ${objectName} not found."
    }
}

# Draw wires on multiple layer. Layers will be connected with contacts.
# dont use intermediate layers, make layer stack ascending
proc addWireMultipleLayers {netName x1 y1 x2 y2 layers} {
   #set netName VDD
   #set x1 220
   #set y1 1000
   #set x2 230
   #set y2 2000
   #set layers [ list M2 M3 LB]
  setAddStripeMode -remove_floating_stripe_over_block 0
   if { [expr $x2 -$x1 ] < [ expr $y2 - $y1 ] } {
      set direction "vertical"
      set wireWidth [expr $x2 -$x1]
   } else {
      set direction "horizontal"
      set wireWidth [expr $y2 -$y1]
   }

   foreach layer ${layers} {
      addStripe -number_of_sets 1 -nets "$netName"  -layer ${layer} -width $wireWidth -spacing 2 \
            -direction ${direction}         -area "$x1 $y1 $x2 $y2" -skip_via_on_wire_shape {Padring Ring Blockring Noshape} -orthogonal_only 0
   }
}


proc cellCount { } {

   # to print all timing libraries:
   # dbForEachHeadTimeLib [dbgHead] libPtr { print [dbTimeLibName $libPtr] }
   set cellCount 0
   set hvtCellCount 0
   set rvtCellCount 0
   set totalCellCount 0
   set cellNameList {}
   set ignoreCellNameList {}
   set totalCellCount [llength [dbFindInstsByName *]]
   foreach instName [dbFindInstsByName *] {
      set instPtr [dbGetInstByName $instName]
      set cellPtr [dbInstCell $instPtr]
      set cellName [dbCellName $cellPtr]
      set timingLibContext [dbInstLibraryContext $instPtr]
      set timingLibPtr [dbCellTimeLib $cellPtr $instPtr]
      if {$timingLibPtr != "0x0"} {
         set timingLib [dbTimeLibName $timingLibPtr]
         if {[string match "*hvt*"   $timingLib] == 1 ||
             [string match "*rvt*" $timingLib] == 1} {
             incr cellCount
             if {[lsearch $cellNameList $cellName] == -1} {
                set cellNameList [lappend cellNameList $cellName]
             }
         } \
         else {
             if {[lsearch $ignoreCellNameList $cellName] == -1} {
                set ignoreCellNameList [lappend ignoreCellNameList $cellName]
             }
         }
      } \
      else {
          if {[lsearch $ignoreCellNameList $cellName] == -1} {
             set ignoreCellNameList [lappend ignoreCellNameList $cellName]
          }
      }
      if {[string match "*_A8TH" $cellName] == 1} {
         incr hvtCellCount
      }
      if {[string match "*_A8TR" $cellName] == 1} {
         incr rvtCellCount
      }
   }
   
   print "Placeable cell types:"
   foreach cellName [lsort $cellNameList] { print "   $cellName" }
   print "Nonplaceable cell types:"
   foreach cellName [lsort $ignoreCellNameList] { print "   $cellName" }
   
   print "Number of hvt instances: $hvtCellCount"
   print "Number of rvt instances: $rvtCellCount"
   print "Number of all placeable instances: $cellCount"
   print "Number of all instances: $totalCellCount"
   
   set percentHvt [expr (int(($hvtCellCount*1.0/$cellCount*100.0)*100.0))/100.0]
   print "Percent hvt cells out of total placeable cell: $percentHvt\%"
   set percentRvt [expr (int(($rvtCellCount*1.0/$cellCount*100.0)*100.0))/100.0]
   print "Percent rvt cells out of total placeable cell: $percentRvt\%"
}   

proc padCells { { cells "SDFF*" } { padding 2 } } {
   foreach_in_collection c [get_lib_cells $cells] {
      specifyCellPad [get_property $c name] $padding
   }
}   

proc addcellToInputPin {netBaseName instBaseName instPin cellName x y } {
    
     set i 1
     set newInstName ${instBaseName}${i}
     while {   [ dbFindInstsByName ${newInstName} ] != "" }  {
       incr i 1
       set newInstName ${instBaseName}${i}
     }
     set i 1
        
     set newNetName ${netBaseName}${i}
     while {   [ dbFindNetsByName ${newNetName} ] != "" }  {
       incr i 1
       set newNetName ${netBaseName}${i}
     }
     set inst          [dbTermInstName [dbGetObjByName ${instPin}]]
     set term          [dbObjName [dbTermFTerm [dbGetObjByName ${instPin}]]]
     set ptr          [dbGetTermByName ${inst} ${term}]
     set oldNetName   [dbObjName [dbTermNet ${ptr}]]

     detachTerm ${inst} ${term}
     addNet ${newNetName}
     addInst -loc ${x} ${y} -cell ${cellName} -inst ${newInstName}
     dbSetIsCellDontTouch [dbGetObjByName ${cellName} ] 1
     attachTerm    ${newInstName} X     ${newNetName}
     attachTerm    ${newInstName} A     ${oldNetName}
     attachTerm    ${inst}  ${term}         ${newNetName}
}


proc addcellToOutputPin {netBaseName instBaseName instPin cellName x y } {
    
     set i 1
     set newInstName ${instBaseName}${i}
     while {   [ dbFindInstsByName ${newInstName} ] != "" }  {
       incr i 1
       set newInstName ${instBaseName}${i}
     }
     set i 1
        
     set newNetName ${netBaseName}${i}
     while {   [ dbFindNetsByName ${newNetName} ] != "" }  {
       incr i 1
       set newNetName ${netBaseName}${i}
     }
     set inst          [dbTermInstName [dbGetObjByName ${instPin}]]
     set term          [dbObjName [dbTermFTerm [dbGetObjByName ${instPin}]]]
     set ptr          [dbGetTermByName ${inst} ${term}]
     set oldNetName   [dbObjName [dbTermNet ${ptr}]]

     detachTerm ${inst} ${term}
     addNet ${newNetName}
     addInst -loc ${x} ${y} -cell ${cellName} -inst ${newInstName}
     dbSetIsCellDontTouch [dbGetObjByName ${cellName} ] 1
     attachTerm    ${newInstName} A     ${newNetName}
     attachTerm    ${newInstName} X     ${oldNetName}
     attachTerm    ${inst}  ${term}         ${newNetName}
}

proc addLsToOutputPin {netBaseName instBaseName instPin cellName x y } {
    
     set i 1
     set newInstName ${instBaseName}${i}
     while {   [ dbFindInstsByName ${newInstName} ] != "" }  {
       incr i 1
       set newInstName ${instBaseName}${i}
     }
     set i 1
        
     set newNetName ${netBaseName}${i}
     while {   [ dbFindNetsByName ${newNetName} ] != "" }  {
       incr i 1
       set newNetName ${netBaseName}${i}
     }
     set inst          [dbTermInstName [dbGetObjByName ${instPin}]]
     set term          [dbObjName [dbTermFTerm [dbGetObjByName ${instPin}]]]
     set ptr          [dbGetTermByName ${inst} ${term}]
     set oldNetName   [dbObjName [dbTermNet ${ptr}]]

     detachTerm ${inst} ${term}
     addNet ${newNetName}
     addInst -loc ${x} ${y} -cell ${cellName} -inst ${newInstName}
     dbSetIsCellDontTouch [dbGetObjByName ${cellName} ] 1
     attachTerm    ${newInstName} A     ${newNetName}
     attachTerm    ${newInstName} Q     ${oldNetName}
     attachTerm    ${inst}  ${term}         ${newNetName}
}

proc createInstNetsFile {inst  fileName } {
    set listNetsName ""
    set instPtr [dbGetInstByName ${inst} ]
        foreach termPtr [dbGet $instPtr.instTerms] {
              set netPtr [ dbTermNet $termPtr ]
              set pinName [ dbTermName $termPtr ]
              set netName [ dbNetName $netPtr]
              lappend listNetsName $netName
        }
      exec echo " $listNetsName " > ${fileName}

}

proc createInstPinsFile {inst  fileName } {

    set listPinsName ""
    set instPtr [dbGetInstByName ${inst} ]
        foreach termPtr [dbGet $instPtr.instTerms] {
              set pinName [ dbTermName $termPtr ]
              puts $pinName
              lappend listPinsName $pinName
        }
    echo " $listPinsName " > ${fileName}

}

proc jvAddcellToInputPin {instPin cellName x y} {
     
     set instBaseName manAddInst_
     set i 1
     set newInstName ${instBaseName}${i}
     while {   [ dbFindInstsByName ${newInstName} ] != "" }  {
       incr i 1
       set newInstName ${instBaseName}${i}
     }
     set netBaseName manAddNet_
     set i 1
        
     set newNetName ${netBaseName}${i}
     while {   [ dbFindNetsByName ${newNetName} ] != "" }  {
       incr i 1
       set newNetName ${netBaseName}${i}
     }
     puts "1"
     set inst         [dbTermInstName [dbGetObjByName ${instPin}]]
     set term         [dbObjName [dbTermFTerm [dbGetObjByName ${instPin}]]]
     set ptr          [dbGetTermByName ${inst} ${term}]
     set oldNetName   [dbObjName [dbTermNet ${ptr}]]
     puts "2"
     detachTerm ${inst} ${term}
     addNet ${newNetName}
     addInst -loc ${x} ${y} -cell ${cellName} -inst ${newInstName}
     dbSetIsCellDontTouch [dbGetObjByName ${cellName} ] 1
     attachTerm    ${newInstName} X     ${newNetName}
     attachTerm    ${newInstName} A     ${oldNetName}
     attachTerm    ${inst}  ${term}      ${newNetName}
     puts "3"
} 


##=====================================================================================================================================
## floorplan sanity check for unfixed macros
##=====================================================================================================================================
proc macroPlacementCheck {} {
   puts "Checking placement..."
   dbForEachCellInst [dbgTopCell] instPtr {
     if { $instPtr != "0x0" } {
       set obj_type [dbObjType $instPtr]
       if { $obj_type == "dbcObjInst" } {
   	 set instName [dbObjName $instPtr]
   	 set cellName [dbInstCellName $instPtr]
   	 set cellPtr [dbInstCell $instPtr]
   	 set placement [dbInstPlacementStatus $instPtr ]
   	 if { [dbIsCellBlock $cellPtr ] == 1 } {
   	   if { $placement != "dbcFixed" } {
   	     puts "ERROR: $instName is a non-fixed macro!"
   	   }
   	 }
       }
     }
   }
   puts "Finished checking placement"
}

##=====================================================================================================================================
## floorplan sanity check for unassigned/unfixed pins
##=====================================================================================================================================
proc pinPlacementCheck {} {
    puts "Checking for unassigned/unfixed pins..."
    set all_pins  [dbFindFTermsByName [dbGet top] * ]
    foreach pin $all_pins {
      if { ![dbIsFTermAssigned $pin] } {
    	puts "ERROR: $pin not assigned!"
      }
      set pin_ptr [ dbGetFTermByName $pin ]
      if { [dbObjType $pin_ptr] == "dbcObjFTerm" } {
    	if { [dbFTermPlacementStatus $pin_ptr] != "dbcFixed" } {
    	  puts "ERROR: $pin not fixed!!"
    	}
      }
    }
   puts "Finished checking pins"
}

# Math functions
proc tcl::mathfunc::roundto {value decimalplaces} {expr {round(10**$decimalplaces*$value)/10.0**$decimalplaces}}

# Boolean Functions
proc isEven                 {value} {expr {($value % 2) == 0}}
proc isOdd                  {value} {expr {($value % 2) != 0}}
