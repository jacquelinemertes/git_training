#######################################################

# Group 1: Bottom-Left
createInstGroup -isPhyHier boxBottomLeftGroup
createSoftGuide boxBottomLeftGroup
foreach instanceName [ dbGet [dbGet -p [dbGet top.terms { .pt_x >= 0 && .pt_y > 160 && .pt_x < 9 && .pt_y < 184 }].net.allTerms.inst.cell { .isSequential == 1 }].name ] {
   if { ${instanceName} != 0x0 } {
      addInstToInstGroup boxBottomLeftGroup ${instanceName}
   }
}

# Group 2: Top
createInstGroup -isPhyHier boxTopGroup
createSoftGuide boxTopGroup
foreach instanceName [ dbGet [dbGet -p [dbGet top.terms { .pt_x >= 0 && .pt_y > 590.7 && .pt_x < 3567  }].net.allTerms.inst.cell { .isSequential == 1 }].name ] {
   if { ${instanceName} != 0x0 } {
      addInstToInstGroup boxTopGroup ${instanceName}
   }
}

# Group 3: Middle
createInstGroup -isPhyHier boxMiddleGroup
createSoftGuide boxMiddleGroup
foreach instanceName [ dbGet [dbGet -p [dbGet top.terms { .pt_x > 2345 && .pt_y >= 0 && .pt_x < 3309 && .pt_y < 5 }].net.allTerms.inst.cell { .isSequential == 1 }].name ] {
   if { ${instanceName} != 0x0 } {
      addInstToInstGroup boxMiddleGroup ${instanceName}
   }
}

# Group 4: Middle-Bottom-Right
#createInstGroup -isPhyHier boxMiddleBottomRightGroup
#createSoftGuide boxMiddleBottomRightGroup
#foreach instanceName [ dbGet [dbGet -p [dbGet top.terms { .pt_x > 4280 && .pt_y >= 0 && .pt_x < 4355 && .pt_y < 5 }].net.allTerms.inst.cell { .isSequential == 1 }].name ] {
#   if { ${instanceName} != 0x0 } {
#      addInstToInstGroup boxMiddleBottomRightGroup ${instanceName}
#   }
#}

# Group 5: Bottom-Right
#createInstGroup -isPhyHier boxBottomRightGroup
#createSoftGuide boxBottomRightGroup
#foreach instanceName [ dbGet [dbGet -p [dbGet top.terms { .pt_x >= 5340 && .pt_y >= 0 && .pt_x < 5345 && .pt_y < 5 }].net.allTerms.inst.cell { .isSequential == 1 }].name ] {
#   if { ${instanceName} != 0x0 } {
#      addInstToInstGroup boxBottomRightGroup ${instanceName}
#   }
#}

setPlaceMode -softGuideStrength low
#######################################################
