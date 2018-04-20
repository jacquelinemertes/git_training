#******************************************************************************#
# PURPOSE : Script to include basic timing constraints.                        #
#******************************************************************************#

#################################################################################
# OVERCLOCK FOR SYNTHESIS
#################################################################################
#No overclock for signoff
set OVERCLOCK 1

################################################################################
# CLOCK DEFINITIONS
################################################################################

# CLOCK FREQUENCY (MHz)
set F_CLK	  [ expr 465.0 * $OVERCLOCK  ]
set F_SCLK_LAUNCH 465.0
set F_SCLK_SHIFT  10.0

# CLOCK PERIOD
#Period in nano seconds (ns)
set T_CLK	    [ expr (1000 / $F_CLK)           ]
set T_CLK           [ format "%.2f" ${T_CLK}         ]
set T_SCLK_LAUNCH   [ expr (1000 / $F_SCLK_LAUNCH)   ]
set T_SCLK_LAUNCH   [ format "%.2f" ${T_SCLK_LAUNCH} ]
set T_SCLK_SHIFT    [ expr (1000 / $F_SCLK_SHIFT)    ]
set T_SCLK_SHIFT    [ format "%.2f" ${T_SCLK_SHIFT}  ]

# CLOCK WAVE
set W_CLK         [list 0 [ expr $T_CLK / 2 ] ]
set W_SCLK_LAUNCH [list 0 [ expr $T_SCLK_LAUNCH / 2 ] ]
set W_SCLK_SHIFT  [list 0 [ expr $T_SCLK_SHIFT / 2 ] ]

# CLOCK UNCERTAINTY
set CLK_UNC_SETUP             [expr (${T_CLK}*0.15) ]
set CLK_UNC_HOLD              [expr (${T_CLK}*0.02) ]
set CLK_UNC_SETUP_SCLK_LAUNCH [expr (${T_SCLK_LAUNCH}*0.15) ]
set CLK_UNC_HOLD_SCLK_LAUNCH  [expr (${T_SCLK_LAUNCH}*0.02) ]
set CLK_UNC_SETUP_SCLK_SHIFT  [expr (${T_SCLK_SHIFT}*0.15) ]
set CLK_UNC_HOLD_SCLK_SHIFT   [expr (${T_SCLK_SHIFT}*0.02) ]

set CLK_UNC_SETUP              0.000
set CLK_UNC_HOLD               0.050
set CLK_UNC_SETUP_SCLK_LAUNCH  [expr (${T_SCLK_LAUNCH}*0.05) + 0.050 ]
set CLK_UNC_HOLD_SCLK_LAUNCH   0.050
set CLK_UNC_SETUP_SCLK_SHIFT   0.000
set CLK_UNC_HOLD_SCLK_SHIFT    0.050

# CLOCK TRANSITION
set CLK_TRANSITION             0.10
# 1/2 cycle clock
set CLK_TRANSITION_SCLK_LAUNCH [expr (${T_SCLK_LAUNCH}*0.50) ] 
#1/2 cycle clock
set CLK_TRANSITION_SCLK_SHIFT  [expr (${T_SCLK_SHIFT}*0.50) ]  

# CLOCK LATENCY : SHOULD BE DEFINED BY TOP DESIGNER
set CLK_LATENCY             0.006
set CLK_LATENCY_SCLK_LAUNCH 0.006  
set CLK_LATENCY_SCLK_SHIFT  0.006 

################################################################################
# INPUT DEFINITIONS
################################################################################

# INPUT DELAY: 60% of clock cycle to functional mode
set INPUT_DELAY_PERC            60.0
set MAX_INPUT_DELAY             [expr $T_CLK         * ($INPUT_DELAY_PERC/100)]
set INPUT_DELAY_PERC2           50.0
set MAX_INPUT_DELAY2            [expr $T_CLK         * ($INPUT_DELAY_PERC2/100)]

# INPUT DELAY: 50% of clock cycle to scan modes
set SCAN_INPUT_DELAY_PERC        50.0
set MAX_INPUT_DELAY_SCLK_SHIFT  [expr $T_SCLK_SHIFT  * ($SCAN_INPUT_DELAY_PERC/100)]

# MAX INPUT TRANSITION : 20% of clock cycle or smaller
set INPUT_TRANS_PERC            20.0
set MAX_INPUT_TRANS             [expr $T_CLK         * ($INPUT_TRANS_PERC/100)]
set MAX_INPUT_TRANS_SCLK_LAUNCH [expr $T_SCLK_LAUNCH * ($INPUT_TRANS_PERC/100)]
set MAX_INPUT_TRANS_SCLK_SHIFT  [expr $T_SCLK_SHIFT  * ($INPUT_TRANS_PERC/100)]

# MIN INPUT TRANSITION
set MIN_INPUT_TRANS             0.005
set MIN_INPUT_TRANS_SCLK_LAUNCH 0.005
set MIN_INPUT_TRANS_SCLK_SHIFT  0.005

# MAX CAPACITANCE : SHOULD BE DEFINED BY TOP DESIGNER
set MAX_INPUT_CAP             0.3
set MAX_INPUT_CAP_SCLK_LAUNCH 0.3
set MAX_INPUT_CAP_SCLK_SHIFT  0.3

################################################################################
# OUTPUT DEFINITIONS
################################################################################

# OUTPUT DELAY: 70% of clock cycle to functional mode
set OUTPUT_DELAY_PERC            70.0
set MAX_OUTPUT_DELAY             [expr $T_CLK         * ($OUTPUT_DELAY_PERC/100)]
# OUTPUT DELAY: 40% of clock cycle to scan modes
set SCAN_OUTPUT_DELAY_PERC       40.0
set MAX_OUTPUT_DELAY_SCLK_SHIFT  [expr $T_SCLK_SHIFT  * ($SCAN_OUTPUT_DELAY_PERC/100)]

# MAX TRANSITION : 20% of clock cycle to functional mode
set OUTPUT_TRANS_PERC            20.0
set MAX_OUTPUT_TRANS             [expr $T_CLK         * ($OUTPUT_TRANS_PERC/100)]
set MAX_OUTPUT_TRANS_SCLK_LAUNCH [expr $T_SCLK_LAUNCH * ($OUTPUT_TRANS_PERC/100)]
set MAX_OUTPUT_TRANS_SCLK_SHIFT  [expr $T_SCLK_SHIFT  * ($OUTPUT_TRANS_PERC/100)]

# OUTPUT LOAD : SHOULD BE DEFINED BY TOP DESIGNER
set OUTPUT_LOAD             0.2
set OUTPUT_LOAD_SCLK_LAUNCH 0.2
set OUTPUT_LOAD_SCLK_SHIFT  0.2

# MAX CAPACITANCE : SHOULD BE DEFINED BY TOP DESIGNER
set MAX_OUTPUT_CAP             0.3
set MAX_OUTPUT_CAP_SCLK_LAUNCH 0.3
set MAX_OUTPUT_CAP_SCLK_SHIFT  0.3

