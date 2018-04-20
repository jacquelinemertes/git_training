//-----------------------------------------------------------
//Copyright(c) lincensed to BrPhotonics.
//This version of the IP model is proprietary information of BrPhotonics.
//All Right Reserved.
//-----------------------------------------------------------
//SVN information:
//$Rev: 807 $
//$Author: ltomazine_brp $
//$Date: 2016-08-04 19:51:29 -0300 (Thu, 04 Aug 2016) $
//$URL: http://svn.cpqd.com.br/DRT/asic_100g/hardware/blocks/trunk/bcd/design/rtl/bcd.v $
//-----------------------------------------------------------
//Commentary:
//-----------------------------------------------------------

module fe #(
    parameter NBW_IN    = 9,
    parameter NBI_IN    = 2,
    parameter NBW_FFT   = NBW_IN+2,
    parameter NBI_FFT   = NBI_IN+9,
    parameter FE_NS_IN    = 64,
    parameter FE_NS_FFT = 512,
    parameter FE_NB_MAX = 8,
    parameter FE_NS_FIR = 5
)
(
    input  logic clk,
    input  logic rst_async_n,  

    input  logic i_valid,
    input  logic i_subsampling,
    input  logic i_enable,

    input  logic [9:0] i_static_pipe_lat, 
    input  logic signed [FE_NS_FIR*NBW_IN-1:0] i_static_coef,

    input  logic signed [FE_NS_IN*NBW_IN-1:0] i_data_i,
    input  logic signed [FE_NS_IN*NBW_IN-1:0] i_data_q,

    output logic o_fo_valid,    
    
    output logic signed [NBW_IN-1+6:0] o_fo_value   // 15 bits

);


localparam I = 1'd0;
localparam Q = 1'd1;

logic signed [NBW_IN-1:0] reg_data_i [FE_NS_IN-1:0];    //data reg in
logic signed [NBW_IN-1:0] reg_data_q [FE_NS_IN-1:0];  //data reg in

logic signed [NBW_IN-1:0] data_i [FE_NS_IN-1:0]; // data input subsampling fft
logic signed [NBW_IN-1:0] data_q [FE_NS_IN-1:0]; // data input subsampling fft

logic signed [NBW_IN-1:0] pow_out_i [FE_NS_IN-1:0]; // power 4th output
logic signed [NBW_IN-1:0] pow_out_q [FE_NS_IN-1:0]; // power 4th output

logic signed [2*NBW_IN+2:0] aux_filter_i [4-1:0]; // filter
logic signed [2*NBW_IN+2:0] aux_filter_q [4-1:0]; // filter

logic signed [NBW_IN-1:0] fft_in_i [FE_NS_IN-1:0]; //fft input
logic signed [NBW_IN-1:0] fft_in_q [FE_NS_IN-1:0]; //fft input

logic signed [NBW_FFT-1:0] fft_out_i [FE_NS_IN-1:0]; //fft output
logic signed [NBW_FFT-1:0] fft_out_q [FE_NS_IN-1:0]; //fft output

logic signed [2*NBW_IN:0] abs_in [FE_NS_IN-1:0]; //abs input wire
logic signed [FE_NB_MAX-1:0] abs_out [FE_NS_IN-1:0]; //abs output reg

logic signed [FE_NB_MAX*FE_NS_IN-1:0] max; //abs output

logic reg_valid, reg_enable, reg_subsampling;
logic gen_enable;
logic [9:0] pipe_lat_cont;
logic pipe_lat_flag;
logic ready;
logic op_enable;        //enable operations
logic [6:0] op_count;      //count operations 
logic [3:0] cont_sub;   //64 samples saved
logic start_flag;        //acumulator full signal
logic pow_vld_in;
logic pow_vld_out;
logic fft_vld_in;
logic fft_vld_out;
logic abs_vld;
logic max_tree_vld;

genvar i,g;

//=============================1D to 2D ==========================
logic signed[NBW_IN-1:0] w_i_static_coef [FE_NS_FIR-1:0];

logic signed [NBW_IN-1:0] w_i_data_i [FE_NS_IN-1:0];
logic signed [NBW_IN-1:0] w_i_data_q [FE_NS_IN-1:0];

 generate
    for(i=0; i<FE_NS_IN; i=i+1) begin : in
        assign w_i_data_i[i] = $signed(i_data_i[(i+1)*NBW_IN-1:i*NBW_IN]); 
        assign w_i_data_q[i] = $signed(i_data_q[(i+1)*NBW_IN-1:i*NBW_IN]);            
    end

    for(g=0; g<FE_NS_FIR; g=g+1) begin : coef
        assign w_i_static_coef[g] = $signed(i_static_coef[(g+1)*NBW_IN-1:g*NBW_IN]); 
    end
endgenerate

//=============================1D to 2D ==========================

integer k,l,j;

assign gen_enable = op_enable&reg_valid&reg_enable;

always_ff@(posedge clk, negedge rst_async_n) begin    :reg_valid_method
    if(!rst_async_n) begin
        reg_valid <= 0;
        reg_enable <= 0;
        reg_subsampling <= 0 ;
    end
    else begin 
        reg_valid <= (pipe_lat_flag)?0:i_valid;
        reg_enable <= i_enable;
        reg_subsampling <= (ready)?i_subsampling:reg_subsampling;
    end
end

always_ff@(posedge clk, negedge rst_async_n) begin    :op_ctrl //operation control
    if(!rst_async_n) begin
        pipe_lat_cont <= 0;
        pipe_lat_flag <= 0;  
        op_enable <= 1;
        op_count <= 0;
    end
    else begin
        if(ready)    begin                                    //starts delay
            pipe_lat_cont <= 0;
            pipe_lat_flag <= 1;
        end
        else    begin
            if(pipe_lat_flag)
                if(pipe_lat_cont==i_static_pipe_lat)    begin
                    pipe_lat_cont <= 0;
                    pipe_lat_flag <= 0;    
                    op_enable <= 1;        
                    op_count <= 0;    
                end
                else begin        
                    pipe_lat_cont <= pipe_lat_cont+1;
                    pipe_lat_flag <= 1;
                end
            else begin
                pipe_lat_cont <= 0;
                pipe_lat_flag <= 0;    
                op_count <= (gen_enable)?(op_count+1'b1):op_count;
                if(reg_subsampling)
                    op_enable <= (op_count==7'd127&gen_enable)?0:op_enable;
                else    
                    op_enable <= (op_count==7'd7&gen_enable)?0:op_enable;        
            end
        end
    end
end

always_ff@(posedge clk, negedge rst_async_n) begin    :vld_ctrl //valids control
    if(!rst_async_n) begin
        pow_vld_in  <= 0;
        pow_vld_out <= 0;
    end
    else begin
        pow_vld_in  <= gen_enable; //i_valid = 1, enable = 1, op_enable = 1
        pow_vld_out <= pow_vld_in;
    end
end

always_ff@(posedge clk) begin :reg_fill    //reg fill control
   
       if(op_enable) begin
           if(reg_subsampling)begin
                for(j=0; j<FE_NS_IN; j=j+1) begin                                                         //power to 4th the input samples
                    if(j<5||(j>15&&j<21)||(j>31&&j<37)||(j>47&&j<53)) begin
                        reg_data_i[j] <= w_i_data_i[j];
                        reg_data_q[j] <= w_i_data_q[j];
                    end
                    else begin
                        reg_data_i[j] <= reg_data_i[j];
                        reg_data_q[j] <= reg_data_q[j];
                    end
                end
            end
            else begin
                reg_data_i <= w_i_data_i;
                reg_data_q <= w_i_data_q;
            end
        end
        else begin  
            reg_data_i <= reg_data_i;
            reg_data_q <= reg_data_q;
        end  
    
end

generate 
    for(i=0; i<FE_NS_IN; i=i+1) begin             :pwd4                                            //power to 4th the input samples        
        pow_4 #( .NBW_IN(NBW_IN), 
                 .NBI_IN(NBI_IN)) 
        pow_41(    .clk(clk), 
                .i_valid(pow_vld_in|pow_vld_out|op_enable),
                .i_data_i(reg_data_i[i]), 
                .i_data_q(reg_data_q[i]), 
                .o_data_i(pow_out_i[i]), 
                .o_data_q(pow_out_q[i]));     
    end
endgenerate
                                                                            //fir filter 
assign     aux_filter_i[0] = (pow_vld_out&&reg_subsampling)?pow_out_i[0] *w_i_static_coef[0] +pow_out_i[1]*w_i_static_coef[1] +pow_out_i[2]*w_i_static_coef[2] +pow_out_i[3]*w_i_static_coef[3] +pow_out_i[4]*w_i_static_coef[4]:0;
assign     aux_filter_i[1] = (pow_vld_out&&reg_subsampling)?pow_out_i[16]*w_i_static_coef[0]+pow_out_i[17]*w_i_static_coef[1]+pow_out_i[18]*w_i_static_coef[2]+pow_out_i[19]*w_i_static_coef[3]+pow_out_i[20]*w_i_static_coef[4]:0;
assign     aux_filter_i[2] = (pow_vld_out&&reg_subsampling)?pow_out_i[32]*w_i_static_coef[0]+pow_out_i[33]*w_i_static_coef[1]+pow_out_i[34]*w_i_static_coef[2]+pow_out_i[35]*w_i_static_coef[3]+pow_out_i[36]*w_i_static_coef[4]:0;
assign     aux_filter_i[3] = (pow_vld_out&&reg_subsampling)?pow_out_i[48]*w_i_static_coef[0]+pow_out_i[49]*w_i_static_coef[1]+pow_out_i[50]*w_i_static_coef[2]+pow_out_i[51]*w_i_static_coef[3]+pow_out_i[52]*w_i_static_coef[4]:0;
assign     aux_filter_q[0] = (pow_vld_out&&reg_subsampling)?pow_out_q[0] *w_i_static_coef[0] +pow_out_q[1]*w_i_static_coef[1] +pow_out_q[2]*w_i_static_coef[2] +pow_out_q[3]*w_i_static_coef[3] +pow_out_q[4]*w_i_static_coef[4]:0;
assign     aux_filter_q[1] = (pow_vld_out&&reg_subsampling)?pow_out_q[16]*w_i_static_coef[0]+pow_out_q[17]*w_i_static_coef[1]+pow_out_q[18]*w_i_static_coef[2]+pow_out_q[19]*w_i_static_coef[3]+pow_out_q[20]*w_i_static_coef[4]:0;
assign     aux_filter_q[2] = (pow_vld_out&&reg_subsampling)?pow_out_q[32]*w_i_static_coef[0]+pow_out_q[33]*w_i_static_coef[1]+pow_out_q[34]*w_i_static_coef[2]+pow_out_q[35]*w_i_static_coef[3]+pow_out_q[36]*w_i_static_coef[4]:0;
assign     aux_filter_q[3] = (pow_vld_out&&reg_subsampling)?pow_out_q[48]*w_i_static_coef[0]+pow_out_q[49]*w_i_static_coef[1]+pow_out_q[50]*w_i_static_coef[2]+pow_out_q[51]*w_i_static_coef[3]+pow_out_q[52]*w_i_static_coef[4]:0;
            

always_ff@(posedge clk, negedge rst_async_n) begin    :sub_acc //subsampling acumulator
    if(!rst_async_n) begin
        cont_sub <= 0;
        start_flag <= 0;
    end
    else begin
        if(pow_vld_out&&reg_subsampling) begin
            data_i[cont_sub*4+0] <= aux_filter_i[0][15:7];
            data_i[cont_sub*4+1] <= aux_filter_i[1][15:7];
            data_i[cont_sub*4+2] <= aux_filter_i[2][15:7];
            data_i[cont_sub*4+3] <= aux_filter_i[3][15:7];
            data_q[cont_sub*4+0] <= aux_filter_q[0][15:7];
            data_q[cont_sub*4+1] <= aux_filter_q[1][15:7];
            data_q[cont_sub*4+2] <= aux_filter_q[2][15:7];
            data_q[cont_sub*4+3] <= aux_filter_q[3][15:7];
            cont_sub <= cont_sub + 1'b1;        
        end
        else    begin
            data_i <= data_i;
            data_q <= data_q;      
            cont_sub <= cont_sub;   //avoid two start_flags in a row
        end    
        
        start_flag <= (cont_sub==15&pow_vld_out)?1:0;        
    end
end

generate 
    for(i=0; i<FE_NS_IN; i=i+1) begin                 :fft_in                                        //power to 4th the input samples
        assign fft_in_i[i] = (reg_subsampling)?data_i[i]:pow_out_i[i];
        assign fft_in_q[i] = (reg_subsampling)?data_q[i]:pow_out_q[i];
    end
endgenerate

assign fft_vld_in = (reg_subsampling)?start_flag:pow_vld_out;

fft512_hi_lo #(                                                            //fft 512 instance
        .NBW_IN (NBW_IN ),
        .NBI_IN (NBI_IN ),
        .NBW_OUT(NBW_FFT),
        .NBI_OUT(NBI_FFT)
    ) uu_fft512_hi_lo
    (   
        .clk        (clk        ),
        .rst_async_n(rst_async_n),
        .i_overlap  (3'd4  ),             
        .i_valid    (fft_vld_in),
        .i_data_i   (fft_in_i    ),
        .i_data_q   (fft_in_q    ),
        .o_valid (fft_vld_out ),
        .o_data_i(fft_out_i),
        .o_data_q(fft_out_q)
        
    );

generate 
    for(i=0; i<FE_NS_IN; i=i+1) begin                         :abs_input                                //fft abs
        assign abs_in[i] = fft_out_i[i]**2 + fft_out_q[i]**2;
    end
endgenerate

always_ff@(posedge clk, negedge rst_async_n) begin :abs_ctrl    //control flow between fft 512 and absolute value
    if(!rst_async_n) begin
        abs_vld <= 0;
    end
    else     begin

        if    (fft_vld_out) begin
            for(k=0; k<FE_NS_IN; k=k+1) begin
                abs_out [k] <= abs_in[k][15:16-FE_NB_MAX];
            end
            abs_vld <= 1'b1;
        end
        else begin            
            abs_vld <= 0;
        end        
    end
end

generate 
    for(i=0; i<FE_NS_IN; i=i+1) begin                         :max_in                                    //send the upper bits to find the maximum
        assign max[FE_NB_MAX*i+FE_NB_MAX-1:FE_NB_MAX*i] = abs_out[i];
    end
endgenerate

logic [6-1:0] max_pos; //max output
logic [FE_NB_MAX-1:0] max_val; //max output

fe_max_tree#(                                                                        //max tree instance
            .NB_IN    (FE_NB_MAX),
            .NS_IN    ('d64),
            .N_LEVELS ('d6),
            .REGS     (7'b100100_0)
) uu_max_tree
(           .clk(clk),
            .arst_n(rst_async_n),
            .vld_in(abs_vld),
            .i_data(max),
            .vld_out(max_tree_vld),
            .o_data_pos(max_pos),
            .o_data_val(max_val)             
);

logic [FE_NB_MAX-1:0]     result; //max now
logic [8:0]     position; //max now
logic [2:0]     cont;

always_ff@(posedge clk, negedge rst_async_n) begin    :out_flow //control flow output
    if(!rst_async_n) begin
        result <= 0;
        position <= 0;    
        cont <= 0;            
    end
    else
        if(max_tree_vld) begin
            if(max_val>result)begin
                result <= max_val;
                case(cont)
                    1:             position <= max_pos*8 +2;
                    2:             position <= max_pos*8 +1;
                    5:             position <= max_pos*8 +6;
                    6:             position <= max_pos*8 +5;                
                    default:       position <= max_pos*8 +cont;
                endcase            
            end
            else begin
                result <= result;
                position <= position;
            end                
            cont <= cont +1'b1;
        end
        else begin
            result <=   (ready)?0:result;
            position <= (ready)?0:position;
            cont <=     (ready)?0:cont;
        end
end

always_ff@(posedge clk, negedge rst_async_n) begin        :out_ctrl            //output control
    if(!rst_async_n) begin
        o_fo_valid <= 0;    
        o_fo_value <= 0;
        ready <= 0;
    end

    else begin
        if(ready) begin
            o_fo_valid <= 1'b1;
            if(reg_subsampling)
                o_fo_value <= ((position[8])?(position-512):position) + o_fo_value;
            else
                o_fo_value <= ((position[8])?((position-512)<<4):(position<<4)) + o_fo_value; //abs position
        end
        else    begin
            o_fo_valid <= 0;
            o_fo_value <= o_fo_value;
        end
        ready <= (cont==7)?1:0;
    end
end

endmodule
