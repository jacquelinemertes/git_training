//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//email: dsp_brphotonics@brphotonics.com
//SVN information:
//$Rev: 9411 $
//$Date: 2017-05-07 13:51:13 -0300 (Dom, 07 Mai 2017) $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe
(
    input clk,
    input rst_async_n,

    input i_valid,
    input i_subsampling,
    input i_enable,

    input [9:0] i_static_pipe_lat,
    input [44:0] i_static_coef,

    input [575:0] i_data_i,
    input [575:0] i_data_q,

    output o_fo_valid,

    `ifdef _NO_DFT_
    output [14:0] o_fo_value
    `else
    output [14:0] o_fo_value,
    input sc_cpren,
    input sc_spren,
    input sc_sen,
    input sc_di0,
    input sc_di1,
    input sc_di2,
    input sc_di3,
    input sc_di4,
    output sc_do0,
    output sc_do1,
    output sc_do2,
    output sc_do3,
    output sc_do4
    `endif
);

    //Switch to avoid undriven ports in hal
    `ifdef _HAL_
    assign o_fo_valid = 1'b0;
    assign o_fo_value = {15{1'b0}};
       `ifndef _NO_DFT_
        assign sc_do0 = 1'b0;
        assign sc_do1 = 1'b0;
        assign sc_do2 = 1'b0;
        assign sc_do3 = 1'b0;
        assign sc_do4 = 1'b0;
        `endif
    `endif
  
endmodule
