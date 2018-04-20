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

module fft_serial_hi_lo #(
    parameter NBW_IN    = 'd9,
    parameter NBI_IN    = 'd2,
    parameter NBW_OUT   = NBW_IN,
    parameter NBI_OUT   = NBI_IN+3,
    parameter NBW_FS    = 'd3 //$clog2(FFT_SIZE)
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic [NBW_FS-1:0] i_overlap,

    input  logic i_valid,
    input  logic signed [NBW_IN-1:0] i_data[1:0],

    output logic o_valid,
	output logic hi_lo_flag,
    output logic signed [NBW_OUT-1:0] o_data[1:0]
);
    localparam I = 1'd0;
    localparam Q = 1'd1;
    localparam FFT_SIZE = 4'd8;
    logic [NBW_FS-1:0] r_overlap;
    logic r_valid;
    logic signed [NBW_IN-1:0] r_data[1:0];

	logic aux_valid;
	logic aux_out_valid;
	

    always_ff @ (posedge clk, negedge rst_async_n) begin : inreg
        if (!rst_async_n) begin
            r_valid   <= 1'b0;           
        end else begin
            r_overlap <= i_overlap;
            r_valid   <= i_valid;
            r_data    <= i_data;
        end
    end

    logic [NBW_FS-2:0] addr;
    logic [NBW_FS-1:0] count;
    logic [NBW_FS-1:0] count_lim;

    assign count_lim = (FFT_SIZE/2-1) + r_overlap;

	always_ff @ (posedge clk, negedge rst_async_n) begin :out_ctrl//proper outputvalue
		if(!rst_async_n)
			aux_valid <= 0;
		else
			if(i_valid)
				if(count==3)				
					aux_valid <= 1;
				else
					aux_valid <= aux_valid;
			else
				aux_valid <= 0;
	end

    always_ff @ (posedge clk, negedge rst_async_n) begin : icounter
        if (!rst_async_n) begin
            count <= 4;
            addr  <= '{default:'0};
        end else begin					
	        if (r_valid) begin
	            addr <= addr + 1;
	            if (count == count_lim) begin
	                count <= '{default:'0};
	            end else begin
	                count <= count + 1;
	            end
	        end			
        end
    end

    logic signed [NBW_IN-1:0] dmem [0:(FFT_SIZE/2)-1][Q:I];
    logic signed [NBW_IN-1:0] data [1:0][Q:I];
    logic valid;

    always @(posedge clk) begin : memory_attr
       
            if (count >= i_overlap && r_valid) begin
                dmem[addr] <= r_data;
            end
        
    end

    assign valid = (count < FFT_SIZE/2) ? r_valid : 1'b0;

    assign data[0] = dmem[addr];
    assign data[1] = r_data;

    logic signed [NBW_OUT-1:0] bf8_data[1:0][Q:I];

    fe_bf8_serial #(
        .NBW_IN   (NBW_IN),
        .NBI_IN   (NBI_IN),
        .NBW_OUT  (NBW_OUT),
        .NBI_OUT  (NBI_OUT),
        .INV      ('d0),
        .BSELI    ('d1),
        .BSELII   ('d1),
        .LENGTH_I ('d2),
        .LENGTH_2 ('d1)
    )
    uu_bf8_serial (
        .clk        (clk        ),
        .rst_async_n(rst_async_n),
        .i_valid    (valid      ),
        .i_data     (data       ),
        .o_valid    (aux_out_valid),
        .o_data     (bf8_data   )
    );

	logic [1:0] count_out;
	logic signed [NBW_OUT-1:0] bf8_buffer[3:0][1:0];
	logic enable_count;
	
	always @(posedge clk, negedge rst_async_n) begin	:out_buff
		if (!rst_async_n) begin
			count_out <=0;	
			enable_count <=0;			
		end
		else begin
			if(aux_out_valid) begin					
				bf8_buffer[count_out][I] <= bf8_data[1][I];
				bf8_buffer[count_out][Q] <= bf8_data[1][Q];
				enable_count <= 1;
			end
			else
				if(count_out==3&&!aux_out_valid) begin
					bf8_buffer[0][0] <=0;
					bf8_buffer[0][1] <=0;
					bf8_buffer[1][0] <=0;
					bf8_buffer[1][1] <=0;
					bf8_buffer[2][0] <=0;
					bf8_buffer[2][1] <=0;
					bf8_buffer[3][0] <=0;
					bf8_buffer[3][1] <=0;
					enable_count <= 0;
				end
				else begin
					bf8_buffer <= bf8_buffer;
					enable_count <= enable_count;
				end
			count_out <=(enable_count||aux_out_valid)?count_out +1:0;
		end
	end

    assign o_data[I] = (aux_out_valid)?bf8_data[0][I]:bf8_buffer[count_out][I];
    assign o_data[Q] = (aux_out_valid)?bf8_data[0][Q]:bf8_buffer[count_out][Q];

  	assign o_valid = enable_count||aux_out_valid;   
	assign hi_lo_flag = !aux_out_valid;

endmodule
