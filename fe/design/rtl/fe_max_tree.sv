module fe_max_tree #(
    parameter NB_IN    =  'd16,
    parameter NS_IN    =  'd64,
    parameter N_LEVELS =  'd6,
    parameter REGS     = 8'b1001000_0
)
(
		input  clk,
		input  arst_n,
		input  vld_in,
		input  [NB_IN*NS_IN-1:0] i_data,
		output reg vld_out,
		output [N_LEVELS-1:0] o_data_pos,
		output [NB_IN-1:0] o_data_val
);

	logic [2:0]cont;
	logic enable;

	always_ff@(posedge clk, negedge arst_n) begin	:main
		if(!arst_n) begin
			cont <= 0;
			vld_out <= 0;
			enable <= 0;
		end
		else begin		
			if(vld_in)
				enable <= 1;
			else 	
				if(cont == 7)
					enable <= 0;
				else
					enable <= enable;	
			if(enable) begin
				cont <= cont+1;
				vld_out <= 1;
			end
			else begin
				cont <= 0;
				vld_out <= 0;
			end
		end
			
			
	end
    function integer func_nadd (input integer level);
        integer i;
        integer nadd;
    begin
        nadd = NS_IN;
        for (i=0; i<level; i=i+1) begin
            nadd = (nadd+1)/2;
        end
        func_nadd = nadd;
    end
    endfunction

    genvar i,j;
    generate
        for (i=0; i<=N_LEVELS; i=i+1) begin : levels

            for (j=0; j<func_nadd(i); j=j+1 ) begin : nodes
                
                reg [NB_IN-1:0] result;
                reg [N_LEVELS-1:0] position;

                if (i == 0) begin	:maxif1

                    always @ (*) begin : in_split
                        result   = i_data[(j+1)*NB_IN-1:j*NB_IN];
                        position = j;
                    end

                end else if (2*j+1 == func_nadd(i-1)) begin

                    if (REGS[i]) begin
                        always @ (posedge clk, negedge arst_n) begin : odd_reg
                            if (!arst_n) begin
                                result   <= {NB_IN{1'b0}};
                                position <= {N_LEVELS{1'b0}};
                            end else begin
                                result   <= levels[i-1].nodes[2*j+0].result;
                                position <= levels[i-1].nodes[2*j+0].position;
                            end
                        end
                    end else begin
                        always @ (*) begin : odd
                            result   = levels[i-1].nodes[2*j+0].result;
                            position = levels[i-1].nodes[2*j+0].position;
                        end
                    
                    end

                end else begin		:maxelse1

                    if (REGS[i]) begin	:maxif2
                        always @ (posedge clk, negedge arst_n) begin : add_reg
                            if (!arst_n) begin
                                result   <= {NB_IN{1'b0}};
                                position <= {N_LEVELS{1'b0}};
                            end else begin
                                if (levels[i-1].nodes[2*j+0].result > levels[i-1].nodes[2*j+1].result) begin
                                    result   <= levels[i-1].nodes[2*j+0].result;
                                    position <= levels[i-1].nodes[2*j+0].position;
                                end else begin
                                    result   <= levels[i-1].nodes[2*j+1].result;
                                    position <= levels[i-1].nodes[2*j+1].position;
                                end
                            end
                        end
                    end else begin		:maxelse2
                        always @ (*) begin : add
                            if (levels[i-1].nodes[2*j+0].result > levels[i-1].nodes[2*j+1].result) begin
                                result   = levels[i-1].nodes[2*j+0].result;
                                position = levels[i-1].nodes[2*j+0].position;
                            end else begin
                                result   = levels[i-1].nodes[2*j+1].result;
                                position = levels[i-1].nodes[2*j+1].position;
                            end
                        end
                    end

                end
            end
        end
    endgenerate

    assign o_data_pos = levels[N_LEVELS].nodes[0].position; 
	assign o_data_val = levels[N_LEVELS].nodes[0].result; 

endmodule


