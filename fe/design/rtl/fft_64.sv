//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 807 $
//$Author: tvilela_brp $
//$Date: 2016-08-04 19:51:29 -0300 (Thu, 04 Aug 2016) $
//$URL: http://svn.cpqd.com.br/DRT/asic_100g/hardware/blocks/trunk/bcd/design/rtl/bf8.v $
//-----------------------------------------------------------
//Commentary: ATTENTION: THE OUTPUT MUST BE AT MOST ONE BIT WIDER THAN THE
//            INPUT, IF NOT, THERE WILL BE COMPILATION ISSUES!!!
//            INV = 0 -> OUTPUT IS ROUNDED
//            INV = 1 -> OUTPUT IS SATURATED
//-----------------------------------------------------------

module fft_64 #(
    parameter NBW_IN    = 'd9,
    parameter NBI_IN    = 'd2,
    parameter NBW_BF16 =  NBW_IN,
    parameter NBI_BF16  = NBI_IN,
	parameter NBW_BF4   = NBW_IN+2,
    parameter NBI_BF4   = NBI_IN+2,   
    parameter NBW_OUT   = NBW_IN+4,
    parameter NBI_OUT   = NBI_IN+4,
    parameter BF4_R_INF = 0,
    parameter INV       = 0
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
    input  logic signed [NBW_IN -1:0] i_data[63:0][1:0],

    output logic o_valid,
    output logic signed [NBW_OUT-1:0] o_data[63:0][1:0]
);
    function integer bitrevorder (input integer x);
        integer rev;
        integer i;
        integer inp;
    begin
        inp = x;
        rev = 0;
        for (i=0; i<6; i=i+1) begin
            rev = rev * 2;
            rev = rev | (inp & 1);
            inp = inp / 2;
        end
        bitrevorder =  rev; 
    end
    endfunction

    localparam I     = 1'd0;
    localparam Q     = 1'd1;

    localparam BF1S  = 'd16;
    localparam BF2S  = 'd4;
    localparam NS_IN = BF1S*BF2S;

    logic bf16_bf4_i;
    logic bf16_twm16;
    logic bf16_bf4_ii;
    logic bf64_twm64;
  //  logic bf8_bf4;            no need for this pipeline stage in the 64 version

    always_ff @(posedge clk, negedge rst_async_n) begin : pipetrack
        if (!rst_async_n) begin
            bf16_bf4_i   <= 1'b0;
            bf16_twm16   <= 1'b0;
            bf16_bf4_ii  <= 1'b0;
            bf64_twm64 <= 1'b0;
          //  bf8_bf4      <= 1'b0;
            o_valid      <= 1'b0;
        end else begin
            bf16_bf4_i   <= i_valid     ;
            bf16_twm16   <= bf16_bf4_i  ;
            bf16_bf4_ii  <= bf16_twm16  ;
            bf64_twm64 <= bf16_bf4_ii ;
           // bf8_bf4      <= bf64_twm64	;    //////////reduce one stage to 
           // o_valid      <= bf8_bf4     ;
		  	o_valid <= bf64_twm64	;
        end
    end

    logic signed [NBW_BF16-1:0] bf16_data   [NS_IN-1:0][Q:I];
    logic signed [NBW_BF16-1:0] twm64_data  [NS_IN-1:0][Q:I];

    genvar i,j;
    generate
        for(i=0; i<BF2S; i=i+1) begin : bf16_inst
            logic signed [NBW_IN -1:0]  i_resh[BF1S-1:0][Q:I];
            logic signed [NBW_BF16-1:0] o_resh[BF1S-1:0][Q:I];

            // Reshape of input
            for (j=0; j<BF1S; j=j+1) begin : reshape 
                assign i_resh[j] = i_data[i+j*BF2S];
                assign bf16_data[i+j*BF2S] = o_resh[j];
            end

            // First butterflies
            fe_bf16 #(
                .NBW_IN  (NBW_IN  ),
                .NBI_IN  (NBI_IN  ),
                .NBW_BFI (NBW_BF4 ),
                .NBI_BFI (NBI_BF4 ),
                .NBW_OUT (NBW_BF16),
                .NBI_OUT (NBI_BF16),
                .INV     (INV     ),
                .RND_INF (0       )
            ) uu_bf16
            (  
                .clk        (clk         ),
                .rst_async_n(rst_async_n ),
                .i_valid    (i_valid     ),
                .i_data     (i_resh      ),
                .o_data     (o_resh      )
            );
        end
    endgenerate

    genvar m;
    generate
        for (m=0; m<NS_IN; m=m+1) begin : twmult
            logic signed [NBW_BF16-1:0] result [Q:I];
            twm64 #(
                .NBW_IN(NBW_BF16),
                .NBI_IN(NBI_BF16),
                .IDX(m),
                .INV(INV)
            ) 
            uu_twm64 (
               .clk        (clk         ),
               .i_valid    (bf16_bf4_ii ),
               .i_data     (bf16_data[m]),
               .o_data     (result      )
            );
            assign twm64_data[m] = result;
        end
    endgenerate

    genvar k,l;
    generate
        // Second butterflies
        for(k=0; k<BF1S; k=k+1) begin : bf4_inst
            logic signed [NBW_BF16-1:0] bf4_input[3:0][1:0];
            logic signed [NBW_OUT-1:0]  result   [3:0][1:0];

			localparam a = k*BF2S + BF2S -1;
			localparam b = k*BF2S;

            assign bf4_input = twm64_data[a:b];

            fe_bf4 #(
                .NBW_IN  (NBW_BF16 ),
                .NBI_IN  (NBI_BF16 ),
                .NBW_OUT (NBW_OUT  ),
                .NBI_OUT (NBI_OUT  ),
                .INV     (INV      ),
                .RND_INF (BF4_R_INF)
            ) uu_bf4
            (  
                .clk        (clk         ),
                .rst_async_n(rst_async_n ),
                .i_valid    (bf64_twm64),
                .i_data     (bf4_input   ),
                .o_data     (result      )
            );

            for (l=0; l<BF2S; l=l+1) begin : genbf8ro
                localparam IDX = bitrevorder(k*BF2S+l);
                assign o_data[IDX] = result[l];
            end

        end
    endgenerate

endmodule
