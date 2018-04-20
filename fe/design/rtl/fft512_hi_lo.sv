//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 807 $
//$Author: tvilela_brp $
//$Date: 2016-08-04 19:51:29 -0300 (Thu, 04 Aug 2016) $
//$URL: http://svn.cpqd.com.br/DRT/asic_100g/hardware/blocks/trunk/bcd/design/rtl/fft8192.v $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fft512_hi_lo #(
    parameter NBW_IN    = 'd9,
    parameter NBI_IN    = 'd2,
    parameter NBW_OUT   = NBW_IN+2, 
    parameter NBI_OUT   = NBI_IN+9, 
    parameter NS_IN     = 'd64,
    parameter NBW_FS    = 'd3
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic [NBW_FS-1:0] i_overlap,

    input  logic i_valid,

    input  logic signed [NBW_IN-1:0] i_data_i[NS_IN-1:0],
    input  logic signed [NBW_IN-1:0] i_data_q[NS_IN-1:0],

    output logic                      o_valid,
    output logic signed [NBW_OUT-1:0] o_data_i[NS_IN-1:0],
    output logic signed [NBW_OUT-1:0] o_data_q[NS_IN-1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    localparam NBW_SER = NBW_IN;						// serial output +1 bit
    localparam NBI_SER = NBI_IN+3;

    logic          [NS_IN-1:0] fs_valid;
	logic		   [NS_IN-1:0] hi_lo_flag;
    logic signed [NBW_SER-1:0] fs_data[NS_IN-1:0][Q:I];

    logic signed          twm512_valid;
    logic signed [NBW_SER-1:0] twm512_data[NS_IN-1:0][Q:I];

    logic signed [NBW_OUT-1:0] fft64_data[NS_IN-1:0][Q:I];


    genvar i;
    generate														//generate 64 serial 8 points FFT's
        for (i=0; i<NS_IN; i=i+1) begin : gen_serial
            logic signed [NBW_IN-1 :0] data     [Q:I];
            logic signed [NBW_SER-1:0] result	[Q:I];
         
            assign data[I] = i_data_i[i];
            assign data[Q] = i_data_q[i];

            fft_serial_hi_lo #(
                .NBW_IN (NBW_IN),
                .NBI_IN (NBI_IN),
				.NBW_OUT (NBW_SER),
                .NBI_OUT (NBI_SER)
            ) uu_fft_serial_hi_lo
            (   
                .clk(clk),
                .rst_async_n(rst_async_n),
                .i_overlap  (i_overlap  ),
                .i_valid    (i_valid    ),
                .i_data     (data       ),
                .o_valid    (fs_valid[i]),
				.hi_lo_flag (hi_lo_flag[i]),
                .o_data  	(result  )
            );

            assign fs_data[i] = result;

            assign o_data_i[i] = fft64_data[i][I];
            assign o_data_q[i] = fft64_data[i][Q];
        end
    endgenerate

    twm512_hi_lo #(
        .NBW_IN  (NBW_SER),
        .NBI_IN  (NBI_SER),
        .INV     (0),
        .RND_INF (0)
    ) uu_twm512
    (   
        .clk        (clk          ),
        .rst_async_n(rst_async_n  ),
        .i_valid    (fs_valid[0]),  // high and low valid signals
		.hi_lo_flag (hi_lo_flag[0]),
        .i_data 	 (fs_data   ), 
        .o_valid    (twm512_valid  ),
        .o_data  	(twm512_data   ) 
    );



    fft_64 #(
        .NBW_IN   (NBW_SER  ),
        .NBI_IN   (NBI_SER  ),
        .NBW_BF4  (NBW_SER+2),
        .NBI_BF4  (NBI_SER+2),
        .NBW_BF16 (NBW_SER  ),
        .NBI_BF16 (NBI_SER+4),
        .NBW_OUT  (NBW_OUT  ),
        .NBI_OUT  (NBI_OUT  ),
        .BF4_R_INF(0        ),
        .INV      (0        )
    ) uu_fft64
    (
        .clk(clk),
        .rst_async_n(rst_async_n),
        .i_valid(twm512_valid ),    
        .i_data (twm512_data  ),
        .o_valid(o_valid     ),
        .o_data (fft64_data )
    );

endmodule
