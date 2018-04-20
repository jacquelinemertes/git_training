module twm64 #(
    parameter NBW_IN  = 'd9,
    parameter NBI_IN  = 'd2,
    parameter NBW_OUT = NBW_IN,
    parameter NBI_OUT = NBI_IN,
    parameter IDX     = 'd0,
    parameter INV     = 'd0,
    parameter RND_INF = 'd0
)
(   
    input  logic clk,
    input  logic i_valid,

    input  logic signed [NBW_IN -1:0] i_data[1:0],    // INPUT:    XX.XXXXX 
    output logic signed [NBW_OUT-1:0] o_data[1:0]     // OUTPUT: X XX.XXX 
);
    localparam I = 1'd0;
    localparam Q = 1'd1;

    localparam NS     ='d64;
    localparam NBW_CS = 'd9;
    localparam NBI_CS = 'd2;

    localparam logic [0:NS-1][I:Q][NBW_CS-1:0] TW  = '{
   	 '{9'sd128, 9'sd0},
	 '{9'sd128, 9'sd0},
	 '{9'sd128, 9'sd0},
	 '{9'sd128, 9'sd0},
	 '{9'sd128, 9'sd0},
	 '{9'sd91, 9'sd91},
	 '{9'sd0, 9'sd128},
	 '{-9'sd91, 9'sd91},
	 '{9'sd128, 9'sd0},
	 '{9'sd118, 9'sd49},
	 '{9'sd91, 9'sd91},
	 '{9'sd49, 9'sd118},
	 '{9'sd128, 9'sd0},
	 '{9'sd49, 9'sd118},
	 '{-9'sd91, 9'sd91},
	 '{-9'sd118, -9'sd49},
	 '{9'sd128, 9'sd0},
	 '{9'sd126, 9'sd25},
	 '{9'sd118, 9'sd49},
	 '{9'sd106, 9'sd71},
	 '{9'sd128, 9'sd0},
	 '{9'sd71, 9'sd106},
	 '{-9'sd49, 9'sd118},
	 '{-9'sd126, 9'sd25},
	 '{9'sd128, 9'sd0},
	 '{9'sd106, 9'sd71},
	 '{9'sd49, 9'sd118},
	 '{-9'sd25, 9'sd126},
	 '{9'sd128, 9'sd0},
	 '{9'sd25, 9'sd126},
	 '{-9'sd118, 9'sd49},
	 '{-9'sd71, -9'sd106},
	 '{9'sd128, 9'sd0},
	 '{9'sd127, 9'sd13},
	 '{9'sd126, 9'sd25},
	 '{9'sd122, 9'sd37},
	 '{9'sd128, 9'sd0},
	 '{9'sd81, 9'sd99},
	 '{-9'sd25, 9'sd126},
	 '{-9'sd113, 9'sd60},
	 '{9'sd128, 9'sd0},
	 '{9'sd113, 9'sd60},
	 '{9'sd71, 9'sd106},
	 '{9'sd13, 9'sd127},
	 '{9'sd128, 9'sd0},
	 '{9'sd37, 9'sd122},
	 '{-9'sd106, 9'sd71},
	 '{-9'sd99, -9'sd81},
	 '{9'sd128, 9'sd0},
	 '{9'sd122, 9'sd37},
	 '{9'sd106, 9'sd71},
	 '{9'sd81, 9'sd99},
	 '{9'sd128, 9'sd0},
	 '{9'sd60, 9'sd113},
	 '{-9'sd71, 9'sd106},
	 '{-9'sd127, -9'sd13},
	 '{9'sd128, 9'sd0},
	 '{9'sd99, 9'sd81},
	 '{9'sd25, 9'sd126},
	 '{-9'sd60, 9'sd113},
	 '{9'sd128, 9'sd0},
	 '{9'sd13, 9'sd127},
	 '{-9'sd126, 9'sd25},
	 '{-9'sd37, -9'sd122}
    };

    generate
        if ((TW[IDX][I] == 9'sd64) && (TW[IDX][Q] == 9'sd0)) begin : byp_0
            always_ff @(posedge clk) begin : outreg
                
                    if (i_valid) begin
                        o_data <= i_data;
                    end
                
            end

        end else if ((TW[IDX][I] == -9'sd64) && (TW[IDX][Q] == 9'sd0)) begin : byp_180
            always_ff @(posedge clk) begin : outreg
                
                    if (i_valid) begin
                        o_data[I] <= -i_data[I];
                        o_data[Q] <=  i_data[Q];
                    end
                
            end

        end else if ( ((TW[IDX][I] == 9'sd0) && (TW[IDX][Q] ==  9'sd64) && INV == 0) ||
                      ((TW[IDX][I] == 9'sd0) && (TW[IDX][Q] == -9'sd64) && INV == 1) ) begin : byp_90
            always_ff @(posedge clk) begin : outreg
                
                    if (i_valid) begin
                        o_data[I] <=  i_data[Q];
                        o_data[Q] <= -i_data[I];
                    end
                
            end

        end else if ( ((TW[IDX][I] == 9'sd0) && (TW[IDX][Q] == -9'sd64) && INV == 0) ||
                      ((TW[IDX][I] == 9'sd0) && (TW[IDX][Q] ==  9'sd64) && INV == 1) ) begin : byp_m90
            always_ff @(posedge clk) begin : outreg
                
                    if (i_valid) begin
                        o_data[I] <= -i_data[Q];
                        o_data[Q] <=  i_data[I];
                    end
                
            end


        end else begin : mult
            logic signed [NBW_IN+NBW_CS:0] mult[Q:I];
            logic signed [NBW_OUT-1:0]     result[Q:I];

            if (INV == 0) begin : direct
                assign mult[I] = (i_data[I]*$signed(TW[IDX][I])) + (i_data[Q]*$signed(TW[IDX][Q]));
                assign mult[Q] = (i_data[Q]*$signed(TW[IDX][I])) - (i_data[I]*$signed(TW[IDX][Q]));
            end else begin
                assign mult[I] = (i_data[I]*$signed(TW[IDX][I])) - (i_data[Q]*$signed(TW[IDX][Q]));
                assign mult[Q] = (i_data[Q]*$signed(TW[IDX][I])) + (i_data[I]*$signed(TW[IDX][Q]));
            end

            rnd_sat #(
                .NBW_IN  (NBW_IN+NBW_CS+1),
                .NBI_IN  (NBI_IN+NBI_CS+1),
                .NBW_OUT (NBW_OUT),
                .NBI_OUT (NBI_OUT),
                .RND_INF (RND_INF)
            ) uu_rnd_sat_i
            (   
                .i_data(mult[I]),
                .o_data(result[I]) 
            );

            rnd_sat #(
                .NBW_IN  (NBW_IN+NBW_CS+1),
                .NBI_IN  (NBI_IN+NBI_CS+1),
                .NBW_OUT (NBW_OUT),
                .NBI_OUT (NBI_OUT),
                .RND_INF (RND_INF) 
            ) uu_rnd_sat_q
            (   
                .i_data(mult[Q]),
                .o_data(result[Q]) 
            );

            always_ff @(posedge clk) begin : outreg
                
                    if (i_valid) begin
                        o_data <= result;
                    end
                
            end
        end
    endgenerate

endmodule

