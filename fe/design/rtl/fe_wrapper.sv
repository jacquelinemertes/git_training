//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 807 $
//$Author: ltomazine_brp $
//$Date: 2016-08-04 19:51:29 -0300 (Thu, 04 Aug 2016) $
//$URL: http://svn.cpqd.com.br/DRT/asic_100g/hardware/blocks/trunk/bcd/design/rtl/bcd.v $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe_wrapper #(
    parameter NBW_IN    = 9,
    parameter NBI_IN    = 2,
  	parameter NBW_FFT   = NBW_IN+2,
    parameter NBI_FFT   = NBI_IN+9,
	parameter FE_NS_IN	= 64,
	parameter FE_NS_FFT = 512,
	parameter FE_NB_MAX = 8,
	parameter FE_NS_FIR = 5
)
(
	input  logic clk,
    input  logic rst_async_n,  

    input  logic i_valid,
	input  logic i_subsampling,
	input  logic i_enable,

	input  logic [9:0] i_static_pipe_lat, 
	input  logic signed[NBW_IN*FE_NS_FIR-1:0] i_static_coef,

    input  logic signed [NBW_IN*FE_NS_IN-1:0] i_data_i,
    input  logic signed [NBW_IN*FE_NS_IN-1:0] i_data_q,

	output logic o_fo_valid,	
	
    output logic signed [NBW_IN-1+6:0] o_fo_value   // 15 bits
);

/*logic signed[NBW_IN-1:0] w_i_static_coef [FE_NS_FIR-1:0];

logic signed [NBW_IN-1:0] w_i_data_i [FE_NS_IN-1:0];
logic signed [NBW_IN-1:0] w_i_data_q [FE_NS_IN-1:0];


genvar i,j;
    generate
        for(i=0; i<FE_NS_IN; i=i+1) begin : in
            assign w_i_data_i[i] = $signed(i_data_i[(i+1)*NBW_IN-1:i*NBW_IN]); 
            assign w_i_data_q[i] = $signed(i_data_q[(i+1)*NBW_IN-1:i*NBW_IN]);            
        end

        for(j=0; j<FE_NS_FIR; j=j+1) begin : coef
            assign w_i_static_coef[j] = $signed(i_static_coef[(j+1)*NBW_IN-1:j*NBW_IN]); 
        end
    endgenerate*/

fe #( 	.NBW_IN    	(NBW_IN),
		.NBI_IN   	(NBI_IN),
	  	.NBW_FFT  	(NBW_FFT),
		.NBI_FFT  	(NBI_FFT),
		.FE_NS_IN  	(FE_NS_IN),
		.FE_NS_FFT 	(FE_NS_FFT),
		.FE_NB_MAX	(FE_NB_MAX),
		.FE_NS_FIR 	(FE_NS_FIR)
)
fe1( 	.clk(clk), 
		.rst_async_n(rst_async_n), 
		.i_subsampling(i_subsampling), 
		.i_valid(i_valid), 
		.o_fo_valid(o_fo_valid),
		.i_data_i(i_data_i), 
		.i_data_q(i_data_q), 
		.o_fo_value(o_fo_value), 
		.i_static_coef(i_static_coef), 
		.i_enable(i_enable), 
		.i_static_pipe_lat(i_static_pipe_lat)
);


endmodule
