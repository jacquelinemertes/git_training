module rnd_sat #(
    parameter NBW_IN  = 'd9,
    parameter NBI_IN  = 'd2,
    parameter NBW_OUT = 'd8,
    parameter NBI_OUT = 'd1,
    parameter RND_INF = 0
)
(   
    input  logic signed [NBW_IN -1:0] i_data,
    output logic signed [NBW_OUT-1:0] o_data 
);
    localparam NBF_IN  = NBW_IN  - NBI_IN;
    localparam NBF_OUT = NBW_OUT - NBI_OUT;

    generate
        if (NBF_OUT == NBF_IN) begin: nornd
            sat #(
                .NBW_IN (NBW_IN ),
                .NBW_OUT(NBW_OUT)
            )
            uu_sat (
               .i_data(i_data),
               .o_data(o_data)
            );

        end else if( (NBF_OUT < NBF_IN) && (NBI_OUT < NBI_IN+1) ) begin : rndsat
            logic signed [NBI_IN+NBF_OUT:0] rounded;
            rnd #(
                .NBW_IN (NBW_IN),
                .NBW_OUT(NBI_IN+NBF_OUT),
                .RND_INF(RND_INF)
            )
            uu_rnd (
                .i_data(i_data),
                .o_data(rounded)
            );
            sat #(
                .NBW_IN (NBI_IN+NBF_OUT+1),
                .NBW_OUT(NBW_OUT)
            )
            uu_sat (
                .i_data(rounded),
                .o_data(o_data)
            );
        end
    endgenerate

endmodule


