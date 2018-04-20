//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf2i_serial.sv $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe_bf2i_serial #(
    parameter NBW_IN  = 'd8,
    parameter NBW_OUT = NBW_IN+1,
    parameter INV     = 'd0,
    parameter NBW_C   = 'd2,
    parameter BSEL    = 'd0
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
    input  logic signed [NBW_IN-1 :0] i_data[1:0][1:0],
    output logic signed [NBW_OUT-1:0] o_data[1:0][1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    logic [NBW_C-1:0] count;
    logic sel;

    always_ff @(posedge clk, negedge rst_async_n) begin : outreg
        if (!rst_async_n) begin
            count <= '{default:'0};
        end else begin			
			count <= count + i_valid;
        end
    end

    assign sel = count[BSEL];

    assign o_data[0][I] = i_data[0][I] + i_data[1][I];
    assign o_data[0][Q] = i_data[0][Q] + i_data[1][Q];

    generate
        if (INV == 0) begin : direct
            assign o_data[1][I] = sel == 1'b1 ?   i_data[0][Q] - i_data[1][Q]  : i_data[0][I] - i_data[1][I];
            assign o_data[1][Q] = sel == 1'b1 ? -(i_data[0][I] - i_data[1][I]) : i_data[0][Q] - i_data[1][Q];
        end else if (INV == 1) begin : inverse
            assign o_data[1][I] = sel == 1'b1 ? -(i_data[0][Q] - i_data[1][Q]) : i_data[0][I] - i_data[1][I];
            assign o_data[1][Q] = sel == 1'b1 ?   i_data[0][I] - i_data[1][I]  : i_data[0][Q] - i_data[1][Q];
        end
    endgenerate

endmodule

