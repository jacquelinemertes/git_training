module rnd #(
    parameter NBW_IN  = 'd7,
    parameter NBW_OUT = 'd6,
    parameter RND_INF = 0
)
(   
    input  logic signed [NBW_IN-1:0] i_data,    // INPUT:    XX.XXXXX 
    output logic signed [NBW_OUT :0] o_data     // OUTPUT: X XX.XXX 
);
    localparam NB_TRIM = NBW_IN - NBW_OUT;

    generate
        if (RND_INF == 0) begin : rnd
            assign o_data = $signed(i_data[NBW_IN-1:NB_TRIM]) + $signed({1'b0,i_data[NB_TRIM-1]});

        end else begin : rnd_inf
            if (NB_TRIM == 1) begin : onebit
                always_comb begin : trim
                    if (!i_data[NBW_IN-1] && i_data[0]) begin //Add just when the number is positive
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+1;
                    end else begin
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+0;
                    end
                end
            end else if (NB_TRIM == 2) begin : twobits
                always_comb begin : trim
                    if (i_data[1] && (!i_data[NBW_IN-1] || i_data[0])) begin
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+1;
                    end else begin
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+0;
                    end
                end
            end else if (NB_TRIM > 2) begin : nbits 
                always_comb begin : trim
                    if (i_data[NB_TRIM-1] && (!i_data[NBW_IN-1] || i_data[NB_TRIM-2:0] != {NB_TRIM-1{1'b0}})) begin
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+1;
                    end else begin
                        o_data = $signed(i_data[NBW_IN-1:NB_TRIM])+0;
                    end
                end
            end 
        end
    endgenerate
endmodule


