//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf16.sv $
//-----------------------------------------------------------
//Commentary: ATTENTION: THE OUTPUT MUST BE AT MOST ONE BIT WIDER THAN THE
//            INPUT, IF NOT, THERE WILL BE COMPILATION ISSUES!!!
//            INV = 0 -> OUTPUT IS ROUNDED
//            INV = 1 -> OUTPUT IS SATURATED
//-----------------------------------------------------------

module fe_bf16 #(
    parameter NBW_IN    = 'd8,
    parameter NBI_IN    = 'd1,
    parameter NBW_BFI   = NBW_IN+2,
    parameter NBI_BFI   = NBI_IN+2,
    parameter NBW_OUT   = NBW_IN+4,
    parameter NBI_OUT   = NBI_IN+4,
    parameter INV       = 'd0,
    parameter RND_INF   = 'd0
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
    input  logic signed [NBW_IN -1:0] i_data[15:0][1:0],
    output logic signed [NBW_OUT-1:0] o_data[15:0][1:0]
);
    localparam I     = 0;
    localparam Q     = 1;
    localparam BF1S  = 'd4;
    localparam BF2S  = 'd4;
    localparam NS_IN = BF1S*BF2S;

    logic signed [NBW_BFI-1:0] bf4_i_data[NS_IN-1:0][Q:I];
    logic signed [NBW_BFI-1:0] twm16_data[NS_IN-1:0][Q:I];

    genvar i,j;
    generate
        for(i=0; i<BF2S; i=i+1) begin : bf4i
            logic signed [NBW_IN -1:0] i_resh[BF1S-1:0][Q:I];
            logic signed [NBW_BFI-1:0] o_resh[BF1S-1:0][Q:I];

            // Reshape of input
            for (j=0; j<BF1S; j=j+1) begin : reshape 
                assign i_resh[j] = i_data[i+j*BF2S];
                assign bf4_i_data[i+j*BF2S] = o_resh[j];
            end

            // First butterflies
            fe_bf4 #(
                .NBW_IN  (NBW_IN  ),
                .NBI_IN  (NBI_IN  ),
                .NBW_OUT (NBW_BFI ),
                .NBI_OUT (NBI_BFI ),
                .INV     (INV     ),
                .RND_INF (RND_INF )
            ) uu_fe_bf4_i
            (  
                .clk        (clk        ),
                .rst_async_n(rst_async_n),
                .i_valid    (i_valid    ),
                .i_data     (i_resh     ),
                .o_data     (o_resh     )
            );
        end
    endgenerate

    logic bf4_i_valid;
    logic twm16_valid;

    always_ff @(posedge clk, negedge rst_async_n) begin : outreg
        if (!rst_async_n) begin
            bf4_i_valid <= 1'b0;
            twm16_valid <= 1'b0;
        end else begin
            bf4_i_valid <= i_valid;
            twm16_valid <= bf4_i_valid;
        end
    end

    genvar l;
    generate
        for (l=0; l<(BF1S*BF2S); l=l+1) begin : twmult
            logic signed [NBW_BFI-1:0] result [Q:I];
            fe_twm16 #(
                .NBW_IN(NBW_BFI),
                .NBI_IN(NBI_BFI),
                .IDX(l),
                .INV(INV)
            ) 
            uu_fe_twm16 (
               .clk        (clk          ),
               .i_valid    (bf4_i_valid  ),
               .i_data     (bf4_i_data[l]),
               .o_data     (result       )
            );
            assign twm16_data[l] = result;
        end
    endgenerate

    genvar k;
    generate
        // Second butterflies
        for(k=0; k<BF1S; k=k+1) begin : bf4ii
            logic signed [NBW_BFI-1:0] bf_input [BF2S-1:0][Q:I]; 
            logic signed [NBW_OUT-1:0] result_ii   [BF2S-1:0][Q:I];

			localparam a = k*BF2S+BF2S-1;
			localparam b = k*BF2S;

            assign bf_input = twm16_data[a:b];
            assign o_data[a:b] = result_ii;

            fe_bf4 #(
                .NBW_IN  (NBW_BFI),
                .NBI_IN  (NBI_BFI),
                .NBW_OUT (NBW_OUT),
                .NBI_OUT (NBI_OUT),
                .INV     (INV    ),
                .RND_INF (RND_INF)
            ) uu_fe_bf4_ii
            (  
                .clk        (clk        ),
                .rst_async_n(rst_async_n),
                .i_valid    (twm16_valid),
                .i_data     (bf_input   ),
                .o_data     (result_ii     )
            );
        end
    endgenerate

endmodule
