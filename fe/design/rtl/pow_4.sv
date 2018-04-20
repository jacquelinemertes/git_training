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

module pow_4 #(
    parameter NBW_IN    = 9,
    parameter NBI_IN    = 2,
    parameter NBW_OUT   = NBW_IN,
    parameter NBI_OUT   = NBI_IN
)
(	
	input  logic clk, i_valid,
    input  logic signed [NBW_IN-1:0] i_data_i,
    input  logic signed [NBW_IN-1:0] i_data_q,

    output logic signed [NBW_OUT-1:0] o_data_i,
    output logic signed [NBW_OUT-1:0] o_data_q

);
	logic signed [2*NBW_IN-1:0] data_i_2, data_q_2, data_i_q;
    logic signed [2*NBW_IN-1:0] reg_data_i_2, reg_data_q_2, reg_data_i_q;
	logic signed [4*NBW_IN:0] aux_i, aux_q;  //4 times bigger due power 4
    
	assign data_i_2 = i_data_i**2;
	assign data_q_2 = i_data_q**2;
	assign data_i_q = i_data_i*i_data_q;
	assign aux_i = (reg_data_i_2)*(reg_data_i_2) + (reg_data_q_2)*(reg_data_q_2) - 6*(reg_data_i_2)*(reg_data_q_2);
	assign aux_q = 4*((reg_data_i_2)*reg_data_i_q - (reg_data_q_2)*reg_data_i_q);   

always_ff@(posedge clk) begin	 :main		
    if(i_valid) begin
        reg_data_i_2 <= data_i_2;
        reg_data_q_2 <= data_q_2;
        reg_data_i_q <= data_i_q;
	    o_data_i <= aux_i[29:21];
	    o_data_q <= aux_q[29:21];
    end
    else begin
        reg_data_i_2 <= reg_data_i_2;
        reg_data_q_2 <= reg_data_q_2;
        reg_data_i_q <= reg_data_i_q;
	    o_data_i <= o_data_i;
	    o_data_q <= o_data_q;
    end	
end
endmodule
