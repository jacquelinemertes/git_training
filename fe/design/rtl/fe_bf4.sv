//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf4.sv $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe_bf4 #(
    parameter NBW_IN  = 'd9,
    parameter NBI_IN  = 'd9,
    parameter NBW_OUT = NBW_IN+2,
    parameter NBI_OUT = NBI_IN+2,
    parameter INV     = 'd0,
    parameter RND_INF = 'd0
)
(  
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
    input  logic signed [NBW_IN -1:0] i_data[3:0][1:0],

    output logic signed [NBW_OUT-1:0] o_data[3:0][1:0]
);
    localparam NS_IN = 4;
    localparam I     = 1'd0;
    localparam Q     = 1'd1;

    localparam NBF_IN  = NBW_IN  - NBI_IN;
    localparam NBF_OUT = NBW_OUT - NBI_OUT;

    logic signed [NBW_IN:0] bf2[NS_IN-1:0][Q:I];

    assign bf2[0][I] = i_data[0][I] + i_data[2][I];
    assign bf2[0][Q] = i_data[0][Q] + i_data[2][Q];
    assign bf2[2][I] = i_data[0][I] - i_data[2][I];
    assign bf2[2][Q] = i_data[0][Q] - i_data[2][Q];
    assign bf2[1][I] = i_data[1][I] + i_data[3][I];
    assign bf2[1][Q] = i_data[1][Q] + i_data[3][Q];

    generate
        if (INV == 0) begin : direct
            assign bf2[3][Q] = -(i_data[1][I] - i_data[3][I]);
            assign bf2[3][I] =   i_data[1][Q] - i_data[3][Q] ;
        end else if (INV == 1) begin : inverse
            assign bf2[3][Q] =   i_data[1][I] - i_data[3][I] ;
            assign bf2[3][I] = -(i_data[1][Q] - i_data[3][Q]);
        end
    endgenerate

    logic signed [NBW_OUT-1:0] result[NS_IN-1:0][Q:I];

    generate
        if ((NBF_OUT == NBF_IN) && (NBW_OUT == NBW_IN+2)) begin : dres
            assign result[0][I] = bf2[0][I] + bf2[1][I]; 
            assign result[0][Q] = bf2[0][Q] + bf2[1][Q];
            assign result[1][I] = bf2[0][I] - bf2[1][I];
            assign result[1][Q] = bf2[0][Q] - bf2[1][Q];
            assign result[2][I] = bf2[2][I] + bf2[3][I];
            assign result[2][Q] = bf2[2][Q] + bf2[3][Q];
            assign result[3][I] = bf2[2][I] - bf2[3][I];
            assign result[3][Q] = bf2[2][Q] - bf2[3][Q];
        end else begin : daux
            logic signed [NBW_IN+1:0] aux[NS_IN-1:0][Q:I];

            assign aux[0][I] = bf2[0][I] + bf2[1][I]; 
            assign aux[0][Q] = bf2[0][Q] + bf2[1][Q];
            assign aux[1][I] = bf2[0][I] - bf2[1][I];
            assign aux[1][Q] = bf2[0][Q] - bf2[1][Q];
            assign aux[2][I] = bf2[2][I] + bf2[3][I];
            assign aux[2][Q] = bf2[2][Q] + bf2[3][Q];
            assign aux[3][I] = bf2[2][I] - bf2[3][I];
            assign aux[3][Q] = bf2[2][Q] - bf2[3][Q];

            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_0_i (.i_data(aux[0][I]), .o_data(result[0][I]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_0_q (.i_data(aux[0][Q]), .o_data(result[0][Q]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_1_i (.i_data(aux[1][I]), .o_data(result[1][I]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_1_q (.i_data(aux[1][Q]), .o_data(result[1][Q]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_2_i (.i_data(aux[2][I]), .o_data(result[2][I]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_2_q (.i_data(aux[2][Q]), .o_data(result[2][Q]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_3_i (.i_data(aux[3][I]), .o_data(result[3][I]));
            rnd_sat #(.NBW_IN(NBW_IN+2),.NBI_IN(NBI_IN+2),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF)) uu_sat_3_q (.i_data(aux[3][Q]), .o_data(result[3][Q]));
        end
    endgenerate

    always_ff @(posedge clk) begin : outreg
       
            if (i_valid) begin
                o_data <= result;
            end
        
    end

endmodule

