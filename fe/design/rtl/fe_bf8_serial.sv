//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf8_serial.sv $
//-----------------------------------------------------------
//Commentary: This BF64 is composed by BF8 -> TWM -> BF8 performed serially
//            Each BF8 is composed by BF2i -> BF2 -> BF2ii
//            BF2i  can perform an extra multiplication on result1 by -j for
//            FFT (or j for IFFT)
//            BF2ii can perform an extra multiplication on input1 by -j or
//            -1j*2*pi/64 or -3j*2*pi/64 for FFT (or j or 1j*2*pi/64 or -3j*2*pi/64
//            for IFFT)
//-----------------------------------------------------------

module fe_bf8_serial #(
    parameter NBW_IN    =  'd8,
    parameter NBI_IN    =  'd1,
    parameter NBW_BFI   =  NBW_IN+1,
    parameter NBI_BFI   =  NBI_IN+1,
    parameter NBW_BF2   =  NBW_IN+2,
    parameter NBI_BF2   =  NBI_IN+2,
    parameter NBW_OUT   =  NBW_IN+3,
    parameter NBI_OUT   =  NBI_IN+3,
    parameter INV       = 'd0,
    parameter BSELI     = 'd0,
    parameter BSELII    = 'd1,
    parameter LENGTH_I  = 'd2,
    parameter LENGTH_2  = 'd1,
    parameter NBW_C     = 'd2
)
(   
    input  logic clk,
    input  logic rst_async_n,
	
    input  logic i_valid,
    input  logic signed [NBW_IN-1:0] i_data[1:0][1:0],

    output logic o_valid,
    output logic signed [NBW_OUT-1:0] o_data[1:0][1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    // Perform buterflie calculation and, depending on counter,
    // perform an extra -j or j (FFT or IFFT) multiplication on result

    logic signed [NBW_BFI-1:0] bf2i_data[1:0][Q:I];

    fe_bf2i_serial #(
        .NBW_IN (NBW_IN),
        .NBW_OUT(NBW_BFI),
        .INV    (INV),
        .NBW_C  (NBW_C),
        .BSEL   (BSELI)
    )
    uu_fe_bf2i (
        .clk(clk),
        .rst_async_n(rst_async_n),
        .i_valid(i_valid  ),
        .i_data (i_data   ),
        .o_data (bf2i_data)
    );

    logic                      fifoi_valid;
    logic signed [NBW_BFI-1:0] fifoi_data[1:0][Q:I];

    // Rearange data, using fifos, to the next stage
    fe_bf2_fifo #(
        .NBW_IN   (NBW_BFI),
        .NS_FIFO  (LENGTH_I)
    )
    uu_fe_bf2_fifoi(
        .clk(clk),
        .rst_async_n(rst_async_n),
        .i_valid  (i_valid      ),
        .i_data   (bf2i_data    ),
        .o_valid  (fifoi_valid  ),
        .o_data   (fifoi_data   )
    );

//-------------------------------------------------------------//
//
    // BF2, stage 4, result
    logic                      bf2_valid;
    logic signed [NBW_BF2-1:0] bf2_data[1:0][Q:I];

    always_ff @(posedge clk, negedge rst_async_n) begin : bf2calc
        if (!rst_async_n) begin
            bf2_valid <= 1'b0;
        end else begin
            bf2_valid <= fifoi_valid;
            if (fifoi_valid) begin
                // BF2 calculus,  
                bf2_data[0][I] <= fifoi_data[0][I] + fifoi_data[1][I];
                bf2_data[0][Q] <= fifoi_data[0][Q] + fifoi_data[1][Q];
                bf2_data[1][I] <= fifoi_data[0][I] - fifoi_data[1][I];
                bf2_data[1][Q] <= fifoi_data[0][Q] - fifoi_data[1][Q];
            end
        end
    end

    logic                      fifoii_valid;
    logic signed [NBW_BF2-1:0] fifoii_data[1:0][Q:I];
    // Rearange data, using fifos, to the next stage
    fe_bf2_fifo #(
        .NBW_IN   (NBW_BF2),
        .NS_FIFO  (LENGTH_2)
    )
    uu_fe_bf2_fifoii(
        .clk(clk),
        .rst_async_n(rst_async_n ),
        .i_valid (bf2_valid ),
        .i_data  (bf2_data    ),
        .o_valid (fifoii_valid),
        .o_data  (fifoii_data )
    );

//-------------------------------------------------------------//

    // Perform buterflie calculation and, depending on counter,
    // perform an extra -j or j, -1j*2*pi/64 or 1j*2*pi/64 and 
    // -3j*2*pi/64 or 3j*2*pi/64 (FFT or IFFT) multiplication on result1
    // This is the last calculus of the first BF8

    logic signed [NBW_OUT-1:0] bf2ii_data[1:0][Q:I];

    fe_bf2ii_serial #(
        .NBW_IN (NBW_BF2),
        .NBI_IN (NBI_BF2),
        .NBW_OUT(NBW_OUT),
        .NBI_OUT(NBI_OUT),
        .INV    (INV),
        .NBW_C  (NBW_C),
        .BSEL   (BSELII),
        .RND_INF(0)
    )
    uu_fe_bf2ii (
        .clk(clk),
        .rst_async_n(rst_async_n ),
        .i_valid(fifoii_valid),
        .i_data (fifoii_data ),
        .o_valid(o_valid ),
        .o_data (o_data  )
    );



endmodule

