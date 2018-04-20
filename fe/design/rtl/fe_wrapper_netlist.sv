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
	input  logic [FE_NS_FIR*NBW_IN-1:0] i_static_coef,

    input  logic [575:0] i_data_i,
    input  logic [FE_NS_IN*NBW_IN-1:0] i_data_q,

	output logic o_fo_valid,	
	
    output logic [NBW_IN-1+6:0] o_fo_value   // 13 bits

);

	logic w_clk;
    logic w_rst_async_n;  
    logic w_i_valid;
	logic w_i_subsampling;
	logic w_i_enable;
	logic [9:0] w_i_static_pipe_lat; 
	logic [FE_NS_FIR*NBW_IN-1:0] w_i_static_coef;
    logic [575:0] w_i_data_i;
    logic [FE_NS_IN*NBW_IN-1:0] w_i_data_q;
	logic w_o_fo_valid;		
    logic [NBW_IN-1+6:0] w_o_fo_value;   // 13 bits


	assign w_clk = clk;

   /* always begin
	w_clk = #0.175 clk;
    end*/
    assign w_rst_async_n =  rst_async_n;
    assign w_i_valid = i_valid;
	assign w_i_subsampling = i_subsampling;
	assign w_i_enable = i_enable;
	assign w_i_static_pipe_lat =  i_static_pipe_lat;
	assign w_i_static_coef = i_static_coef;
    assign w_i_data_i = i_data_i;
    assign w_i_data_q = i_data_q;
	assign o_fo_valid = w_o_fo_valid;		
    assign o_fo_value = w_o_fo_value;  // 13 bits

/*    genvar i,j;
    generate
        for(i=0; i<FE_NS_IN; i=i+1) begin : in_out
            assign w_i_data_i[(FE_NS_IN-i)*NBW_IN-1 :(FE_NS_IN-1-i)*NBW_IN]= i_data_i[(i+1)*NBW_IN-1:i*NBW_IN]; 
            assign w_i_data_q[(FE_NS_IN-i)*NBW_IN-1 :(FE_NS_IN-1-i)*NBW_IN]= i_data_q[(i+1)*NBW_IN-1:i*NBW_IN];
        end

        for(j=0; j<NS_COEF; j=j+1) begin : coef
            assign w_i_coef_i[(NS_COEF-j)*NBW_COEF-1:(NS_COEF-1-j)*NBW_COEF] = i_coef_i[(j+1)*NBW_COEF-1:j*NBW_COEF]; 
            assign w_i_coef_q[(NS_COEF-j)*NBW_COEF-1:(NS_COEF-1-j)*NBW_COEF] = i_coef_q[(j+1)*NBW_COEF-1:j*NBW_COEF];
        end
    endgenerate*/


fe fe_uu( 	.clk(w_clk), 
		.rst_async_n(w_rst_async_n), 
		.i_subsampling(w_i_subsampling), 
		.i_valid(w_i_valid), 
		.o_fo_valid(w_o_fo_valid),
		.i_data_i(w_i_data_i), 
		.i_data_q(w_i_data_q), 
		.o_fo_value(w_o_fo_value), 
		.i_static_coef(w_i_static_coef), 
		.i_enable(w_i_enable), 
		.i_static_pipe_lat(w_i_static_pipe_lat)
        //.sc_sen(0),
        //.i_ss(1)
);

endmodule

