//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 5425 $
//$Author: ltomazine_brp $
//$Date: 2016-12-15 09:32:24 -0200 (Qui, 15 Dez 2016) $
//$URL: https://svn.cpqd.com.br/brp/projects/dsp28/hardware/blocks/trunk/fe/design/rtl/fe_bf2_fifo.sv $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe_bf2_fifo #(
    parameter NBW_IN    =  'd8,
    parameter NS_FIFO   =  'd2
)
(
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
    input  logic signed [NBW_IN-1:0] i_data[1:0][1:0],
    output logic o_valid,
    output logic signed [NBW_IN-1:0] o_data[1:0][1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    generate
        if (NS_FIFO == 1) begin : onesample
            logic signed [NBW_IN-1:0] fifo0[Q:I];
            logic signed [NBW_IN-1:0] fifo1[Q:I];

            logic count;
            logic valid;

            always_ff @ (posedge clk, negedge rst_async_n) begin : shreg
                if (!rst_async_n) begin                   
                    count <= 1'b0;
                    valid <= 1'b0;
                end else begin						
			            if (!count) begin
			                if (i_valid) begin
			                    fifo0 <= i_data[0];
			                    count <= 1'b1;
			                end
			                valid <= 1'b0;
			            end else begin
			                if (i_valid) begin
			                    fifo0 <= fifo1;
			                    count <= 1'b0;
			                    valid <= 1'b1;
			                end
			            end

			            if (i_valid) begin
			                fifo1 <= i_data[1];
			            end					
                end
            end

            assign o_data[0][I] = fifo0[I];
            assign o_data[0][Q] = fifo0[Q];

            assign o_data[1][I] = count ? i_data[0][I] : fifo1[I];
            assign o_data[1][Q] = count ? i_data[0][Q] : fifo1[Q];

            assign o_valid      = count ? i_valid        : valid;

        end else if (NS_FIFO > 1) begin : nsamples
            localparam NBW_COUNT = $clog2(NS_FIFO)+1;
            reg [NBW_COUNT-1:0] count;
            reg [NS_FIFO-1  :0] valid;

            logic signed [NBW_IN-1:0] fifo0[NS_FIFO-1:0][Q:I];
            logic signed [NBW_IN-1:0] fifo1[NS_FIFO-1:0][Q:I];

            always @ (posedge clk, negedge rst_async_n) begin : shreg
                if (!rst_async_n) begin
                    count <= '{default:'0};
                    valid <= '{default:'0};
                end 
				else begin					
		            if (count < NS_FIFO) begin
		                if (i_valid || valid[NS_FIFO-1]) begin
		                    fifo0[NS_FIFO-1:1] <= fifo0[NS_FIFO-2:0];
		                end
		                valid <= {valid[NS_FIFO-2:0],1'b0};

		                if (i_valid) begin
		                    fifo0[0] <= i_data[0];
		                    count    <= count + 1;
		                end
		            end else begin
		                if (i_valid) begin
		                    fifo0[NS_FIFO-1:1] <= fifo0[NS_FIFO-2:0];
		                    fifo0[0]           <= fifo1[NS_FIFO-1];
		                    count <= count + 1;

		                    if (count == (2*NS_FIFO-1) ) begin
		                        valid <= '{default:'1};
		                    end
		                end
		            end
		            if (i_valid || valid[NS_FIFO-1]) begin
		                fifo1[NS_FIFO-1:1] <= fifo1[NS_FIFO-2:0];
		            end
		            if (i_valid) begin
		                fifo1[0] <= i_data[1];
		            end					
                end 
            end

            assign o_data[0][I] = fifo0[NS_FIFO-1][I];
            assign o_data[0][Q] = fifo0[NS_FIFO-1][Q];

            assign o_data[1][I] = count >= NS_FIFO ? i_data[0][I] : fifo1[NS_FIFO-1][I];
            assign o_data[1][Q] = count >= NS_FIFO ? i_data[0][Q] : fifo1[NS_FIFO-1][Q];
            assign o_valid      = count >= NS_FIFO ? i_valid      : valid[NS_FIFO-1];
        end
    endgenerate
endmodule

