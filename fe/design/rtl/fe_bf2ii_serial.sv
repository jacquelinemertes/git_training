//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf2ii_serial.sv $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe_bf2ii_serial #(
    parameter NBW_IN  = 'd8,
    parameter NBI_IN  = 'd1,
    parameter NBW_OUT = NBW_IN+1,
    parameter NBI_OUT = NBI_IN+1,
    parameter INV     = 'd0,
    parameter NBW_C   = 'd2,
    parameter BSEL    = 'd1,
    parameter RND_INF = 'd0
)
(   
    input  logic clk,
    input  logic rst_async_n,
	
    input  logic i_valid,
    input  logic signed [NBW_IN-1 :0] i_data[1:0][1:0],
    output logic o_valid,
    output logic signed [NBW_OUT-1:0] o_data[1:0][1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    localparam NBI_CS_45 = 'd1;
    localparam NBW_CS_45 = 'd9;
    localparam COS_SIN_45 = 9'sd181;

    logic [NBW_C-1:0] count;
    logic [1:0] sel;

    always_ff @(posedge clk, negedge rst_async_n) begin : outreg
        if (!rst_async_n) begin
            count <= '{default:'0};
        end else begin			
	        if (i_valid) begin
	            count <= count + 1;
	        end
        end
    end

    assign sel = count[BSEL:BSEL-1];

    logic signed [NBW_IN+NBW_CS_45:0] mult[Q:I]; 
    logic signed [NBW_IN-1:0] result[Q:I];

    rnd_sat #(
        .NBW_IN (NBW_IN+1+NBW_CS_45),
        .NBI_IN (NBI_IN+1+NBI_CS_45),
        .NBW_OUT(NBW_IN),
        .NBI_OUT(NBI_IN),
        .RND_INF(1)
    ) 
    uu_rsat_i (
        .i_data(mult[I]),
        .o_data(result[I])
    );

    rnd_sat #(
        .NBW_IN (NBW_IN+1+NBW_CS_45),
        .NBI_IN (NBI_IN+1+NBI_CS_45),
        .NBW_OUT(NBW_IN),
        .NBI_OUT(NBI_IN),
        .RND_INF(1)
    )
    uu_rsat_q (
        .i_data(mult[Q]),
        .o_data(result[Q])
    );

    logic signed [NBW_IN:0] data[1:0][1:0];

    generate
        if (INV == 0) begin : direct

            assign mult[I] = ( i_data[1][I] + i_data[1][Q]) * COS_SIN_45;
            assign mult[Q] = ( i_data[1][Q] - i_data[1][I]) * COS_SIN_45;

            always_comb begin : ang
                case(sel)
                    2'd1 : begin
                        data[0][I] = i_data[0][I] + i_data[1][Q];
                        data[0][Q] = i_data[0][Q] - i_data[1][I];
                        data[1][I] = i_data[0][I] - i_data[1][Q];
                        data[1][Q] = i_data[0][Q] + i_data[1][I];
                    end
                    2'd2 : begin
                        data[0][I] = i_data[0][I] + result[I];
                        data[0][Q] = i_data[0][Q] + result[Q];
                        data[1][I] = i_data[0][I] - result[I];
                        data[1][Q] = i_data[0][Q] - result[Q];
                    end
                    2'd3 : begin
                        data[0][I] = i_data[0][I] + result[Q];
                        data[0][Q] = i_data[0][Q] - result[I];
                        data[1][I] = i_data[0][I] - result[Q];
                        data[1][Q] = i_data[0][Q] + result[I];
                    end
                    default : begin
                        data[0][I] = i_data[0][I] + i_data[1][I];
                        data[0][Q] = i_data[0][Q] + i_data[1][Q];
                        data[1][I] = i_data[0][I] - i_data[1][I];
                        data[1][Q] = i_data[0][Q] - i_data[1][Q];
                    end
                endcase
            end
        end else if (INV == 1) begin : inverse

            assign mult[I] = ( i_data[1][I] - i_data[1][Q]) * COS_SIN_45;
            assign mult[Q] = ( i_data[1][Q] + i_data[1][I]) * COS_SIN_45;

            always_comb begin : ang
                case(sel)
                    2'd2 : begin
                        data[0][I] = i_data[0][I] - i_data[1][Q];
                        data[0][Q] = i_data[0][Q] + i_data[1][I];
                        data[1][I] = i_data[0][I] + i_data[1][Q];
                        data[1][Q] = i_data[0][Q] - i_data[1][I];
                    end
                    2'd1 : begin
                        data[0][I] = i_data[0][I] + result[I];
                        data[0][Q] = i_data[0][Q] + result[Q];
                        data[1][I] = i_data[0][I] - result[I];
                        data[1][Q] = i_data[0][Q] - result[Q];
                    end
                    2'd3 : begin
                        data[0][I] = i_data[0][I] - result[Q];
                        data[0][Q] = i_data[0][Q] + result[I];
                        data[1][I] = i_data[0][I] + result[Q];
                        data[1][Q] = i_data[0][Q] - result[I];
                    end
                    default : begin
                        data[0][I] = i_data[0][I] + i_data[1][I];
                        data[0][Q] = i_data[0][Q] + i_data[1][Q];
                        data[1][I] = i_data[0][I] - i_data[1][I];
                        data[1][Q] = i_data[0][Q] - i_data[1][Q];
                    end
                endcase
            end
        end
    endgenerate

    generate
        if ( (NBW_IN+1 == NBW_OUT) && (NBI_IN+1 == NBI_OUT) ) begin : grow
            always_ff @(posedge clk, negedge rst_async_n) begin : outreg
                if (!rst_async_n) begin
                    o_valid <= 1'b0;
                end else begin
                    o_valid <= i_valid;
                    if (i_valid) begin
                        o_data <= data;
                    end
                end
            end

        end else begin : trim
            logic signed [NBW_OUT-1:0] data_rnd_sat[1:0][Q:I];
            rnd_sat #(
                .NBW_IN (NBW_IN+1),
                .NBI_IN (NBI_IN+1),
                .NBW_OUT(NBW_OUT),
                .NBI_OUT(NBI_OUT),
                .RND_INF(RND_INF)
            ) 
            uu_rsat0_i (
                .i_data(data[0][I]),
                .o_data(data_rnd_sat[0][I])
            );
            rnd_sat #(
                .NBW_IN (NBW_IN+1),
                .NBI_IN (NBI_IN+1),
                .NBW_OUT(NBW_OUT),
                .NBI_OUT(NBI_OUT),
                .RND_INF(RND_INF)
            )
            uu_rsat0_q (
                .i_data(data[0][Q]),
                .o_data(data_rnd_sat[0][Q])
            );
            rnd_sat #(
                .NBW_IN (NBW_IN+1),
                .NBI_IN (NBI_IN+1),
                .NBW_OUT(NBW_OUT),
                .NBI_OUT(NBI_OUT),
                .RND_INF(RND_INF)
            ) 
            uu_rsat1_i (
                .i_data(data[1][I]),
                .o_data(data_rnd_sat[1][I])
            );
            rnd_sat #(
                .NBW_IN (NBW_IN+1),
                .NBI_IN (NBI_IN+1),
                .NBW_OUT(NBW_OUT),
                .NBI_OUT(NBI_OUT),
                .RND_INF(RND_INF)
            )
            uu_rsat1_q (
                .i_data(data[1][Q]),
                .o_data(data_rnd_sat[1][Q])
            );
            always_ff @(posedge clk, negedge rst_async_n) begin : outreg
                if (!rst_async_n) begin
                    o_valid <= 1'b0;
                end else begin
                    o_valid <= i_valid;
                    if (i_valid) begin
                        o_data <= data_rnd_sat;
                    end
                end
            end
         end
     endgenerate

endmodule

