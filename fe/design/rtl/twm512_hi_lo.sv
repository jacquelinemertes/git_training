module twm512_hi_lo #(
    parameter NBW_IN   = 'd9,
    parameter NBI_IN   = 'd2,
    parameter NBW_OUT  = NBW_IN,
    parameter NBI_OUT  = NBI_IN,
    parameter NS_IN    = 'd64,
    parameter INV      = 'd0,
    parameter RND_INF  = 'd0
)
(   
    input  logic clk,
    input  logic rst_async_n,

    input  logic i_valid,
	input  logic hi_lo_flag,
    input  logic signed [NBW_IN -1:0] i_data[NS_IN-1:0][1:0],

    output logic o_valid,
    output logic signed [NBW_OUT-1:0] o_data[NS_IN-1:0][1:0] 
);
    localparam NS_COEF = 512;
    localparam N_TWF = 'd4;

    localparam I = 1'd0;
    localparam Q = 1'd1;

    localparam NBW_ADDR = $clog2(N_TWF);
    localparam NBW_CS   = 'd9;
    localparam NBI_CS   = 'd2;

    function [N_TWF-1:0][1:0][NBW_CS-1:0] load_twf(input integer idx);
        logic signed [1:0][NBW_CS-1:0] tw [NS_COEF-1:0];
 tw[0]={9'sd128, 9'sd0}; 	 tw[64]={9'sd128, 9'sd0}; 	 	tw[128]={9'sd128, 9'sd0}; 		 tw[192]={9'sd128, 9'sd0}; 	 tw[256]={9'sd128, 9'sd0}; 	 tw[320]={9'sd128, 9'sd0}; 	 tw[384]={9'sd128, 9'sd0}; 	 tw[448]={9'sd128, 9'sd0}; 		
 tw[1]={9'sd128, 9'sd0}; 	 tw[65]={9'sd128, 9'sd6}; 	 	tw[129]={9'sd128, 9'sd3}; 		 tw[193]={9'sd128, 9'sd9}; 	 tw[257]={9'sd128, 9'sd2}; 	 tw[321]={9'sd128, 9'sd8}; 	 tw[385]={9'sd128, 9'sd5}; 	 tw[449]={9'sd128, 9'sd11}; 		
 tw[2]={9'sd128, 9'sd0}; 	 tw[66]={9'sd127, 9'sd13}; 	 tw[130]={9'sd128, 9'sd6}; 	 tw[194]={9'sd127, 9'sd19}; 	 tw[258]={9'sd128, 9'sd3}; 	 tw[322]={9'sd127, 9'sd16}; 	 tw[386]={9'sd128, 9'sd9}; 	 tw[450]={9'sd126, 9'sd22}; 		
 tw[3]={9'sd128, 9'sd0}; 	 tw[67]={9'sd127, 9'sd19}; 	 tw[131]={9'sd128, 9'sd9}; 	 tw[195]={9'sd125, 9'sd28}; 	 tw[259]={9'sd128, 9'sd5}; 	 tw[323]={9'sd126, 9'sd23}; 	 tw[387]={9'sd127, 9'sd14}; 	 tw[451]={9'sd124, 9'sd33}; 		
 tw[4]={9'sd128, 9'sd0}; 	 tw[68]={9'sd126, 9'sd25}; 	 tw[132]={9'sd127, 9'sd13}; 	 tw[196]={9'sd122, 9'sd37}; 	 tw[260]={9'sd128, 9'sd6}; 	 tw[324]={9'sd124, 9'sd31}; 	 tw[388]={9'sd127, 9'sd19}; 	 tw[452]={9'sd121, 9'sd43}; 		
 tw[5]={9'sd128, 9'sd0}; 	 tw[69]={9'sd124, 9'sd31}; 	 tw[133]={9'sd127, 9'sd16}; 	 tw[197]={9'sd119, 9'sd46}; 	 tw[261]={9'sd128, 9'sd8}; 	 tw[325]={9'sd122, 9'sd39}; 	 tw[389]={9'sd126, 9'sd23}; 	 tw[453]={9'sd116, 9'sd53}; 		
 tw[6]={9'sd128, 9'sd0}; 	 tw[70]={9'sd122, 9'sd37}; 	 tw[134]={9'sd127, 9'sd19}; 	 tw[198]={9'sd116, 9'sd55}; 	 tw[262]={9'sd128, 9'sd9}; 	 tw[326]={9'sd119, 9'sd46}; 	 tw[390]={9'sd125, 9'sd28}; 	 tw[454]={9'sd111, 9'sd63}; 		
 tw[7]={9'sd128, 9'sd0}; 	 tw[71]={9'sd121, 9'sd43}; 	 tw[135]={9'sd126, 9'sd22}; 	 tw[199]={9'sd111, 9'sd63}; 	 tw[263]={9'sd128, 9'sd11}; 	 tw[327]={9'sd116, 9'sd53}; 	 tw[391]={9'sd124, 9'sd33}; 	 tw[455]={9'sd106, 9'sd72}; 		
 tw[8]={9'sd128, 9'sd0}; 	 tw[72]={9'sd118, 9'sd49}; 	 tw[136]={9'sd126, 9'sd25}; 	 tw[200]={9'sd106, 9'sd71}; 	 tw[264]={9'sd127, 9'sd13}; 	 tw[328]={9'sd113, 9'sd60}; 	 tw[392]={9'sd122, 9'sd37}; 	 tw[456]={9'sd99, 9'sd81}; 		
 tw[9]={9'sd128, 9'sd0}; 	 tw[73]={9'sd116, 9'sd55}; 	 tw[137]={9'sd125, 9'sd28}; 	 tw[201]={9'sd101, 9'sd79}; 	 tw[265]={9'sd127, 9'sd14}; 	 tw[329]={9'sd109, 9'sd67}; 	 tw[393]={9'sd121, 9'sd42}; 	 tw[457]={9'sd92, 9'sd89}; 		
 tw[10]={9'sd128, 9'sd0}; 	 tw[74]={9'sd113, 9'sd60}; 	 tw[138]={9'sd124, 9'sd31}; 	 tw[202]={9'sd95, 9'sd86}; 	 tw[266]={9'sd127, 9'sd16}; 	 tw[330]={9'sd105, 9'sd74}; 	 tw[394]={9'sd119, 9'sd46}; 	 tw[458]={9'sd84, 9'sd97}; 		
 tw[11]={9'sd128, 9'sd0}; 	 tw[75]={9'sd110, 9'sd66}; 	 tw[139]={9'sd123, 9'sd34}; 	 tw[203]={9'sd88, 9'sd93}; 	 tw[267]={9'sd127, 9'sd17}; 	 tw[331]={9'sd100, 9'sd80}; 	 tw[395]={9'sd118, 9'sd50}; 	 tw[459]={9'sd75, 9'sd104}; 		
 tw[12]={9'sd128, 9'sd0}; 	 tw[76]={9'sd106, 9'sd71}; 	 tw[140]={9'sd122, 9'sd37}; 	 tw[204]={9'sd81, 9'sd99}; 	 tw[268]={9'sd127, 9'sd19}; 	 tw[332]={9'sd95, 9'sd86}; 	 tw[396]={9'sd116, 9'sd55}; 	 tw[460]={9'sd66, 9'sd110}; 		
 tw[13]={9'sd128, 9'sd0}; 	 tw[77]={9'sd103, 9'sd76}; 	 tw[141]={9'sd122, 9'sd40}; 	 tw[205]={9'sd74, 9'sd105}; 	 tw[269]={9'sd126, 9'sd20}; 	 tw[333]={9'sd89, 9'sd92}; 	 tw[397]={9'sd114, 9'sd59}; 	 tw[461]={9'sd56, 9'sd115}; 		
 tw[14]={9'sd128, 9'sd0}; 	 tw[78]={9'sd99, 9'sd81}; 		 tw[142]={9'sd121, 9'sd43}; 	 tw[206]={9'sd66, 9'sd110}; 	 tw[270]={9'sd126, 9'sd22}; 	 tw[334]={9'sd84, 9'sd97}; 	 tw[398]={9'sd111, 9'sd63}; 	 tw[462]={9'sd46, 9'sd119}; 		
 tw[15]={9'sd128, 9'sd0}; 	 tw[79]={9'sd95, 9'sd86}; 		 tw[143]={9'sd119, 9'sd46}; 	 tw[207]={9'sd58, 9'sd114}; 	 tw[271]={9'sd126, 9'sd23}; 	 tw[335]={9'sd78, 9'sd102}; 	 tw[399]={9'sd109, 9'sd67}; 	 tw[463]={9'sd36, 9'sd123}; 		
 tw[16]={9'sd128, 9'sd0}; 	 tw[80]={9'sd91, 9'sd91}; 		 tw[144]={9'sd118, 9'sd49}; 	 tw[208]={9'sd49, 9'sd118}; 	 tw[272]={9'sd126, 9'sd25}; 	 tw[336]={9'sd71, 9'sd106}; 	 tw[400]={9'sd106, 9'sd71}; 	 tw[464]={9'sd25, 9'sd126}; 		
 tw[17]={9'sd128, 9'sd0}; 	 tw[81]={9'sd86, 9'sd95}; 	 	 tw[145]={9'sd117, 9'sd52}; 	 tw[209]={9'sd40, 9'sd122}; 	 tw[273]={9'sd125, 9'sd27}; 	 tw[337]={9'sd64, 9'sd111}; 	 tw[401]={9'sd104, 9'sd75}; 	 tw[465]={9'sd14, 9'sd127}; 		
 tw[18]={9'sd128, 9'sd0}; 	 tw[82]={9'sd81, 9'sd99}; 	 	 tw[146]={9'sd116, 9'sd55}; 	 tw[210]={9'sd31, 9'sd124}; 	 tw[274]={9'sd125, 9'sd28}; 	 tw[338]={9'sd58, 9'sd114}; 	 tw[402]={9'sd101, 9'sd79}; 	 tw[466]={9'sd3, 9'sd128}; 		
 tw[19]={9'sd128, 9'sd0}; 	 tw[83]={9'sd76, 9'sd103}; 	 tw[147]={9'sd114, 9'sd58}; 	 tw[211]={9'sd22, 9'sd126}; 	 tw[275]={9'sd125, 9'sd30}; 	 tw[339]={9'sd50, 9'sd118}; 	 tw[403]={9'sd98, 9'sd82}; 	 tw[467]={-9'sd8, 9'sd128}; 		
 tw[20]={9'sd128, 9'sd0}; 	 tw[84]={9'sd71, 9'sd106}; 	 tw[148]={9'sd113, 9'sd60}; 	 tw[212]={9'sd13, 9'sd127}; 	 tw[276]={9'sd124, 9'sd31}; 	 tw[340]={9'sd43, 9'sd121}; 	 tw[404]={9'sd95, 9'sd86}; 	 tw[468]={-9'sd19, 9'sd127}; 		
 tw[21]={9'sd128, 9'sd0}; 	 tw[85]={9'sd66, 9'sd110}; 	 tw[149]={9'sd111, 9'sd63}; 	 tw[213]={9'sd3, 9'sd128}; 	 tw[277]={9'sd124, 9'sd33}; 	 tw[341]={9'sd36, 9'sd123}; 	 tw[405]={9'sd92, 9'sd89}; 	 tw[469]={-9'sd30, 9'sd125}; 		
 tw[22]={9'sd128, 9'sd0}; 	 tw[86]={9'sd60, 9'sd113}; 	 tw[150]={9'sd110, 9'sd66}; 	 tw[214]={-9'sd6, 9'sd128}; 	 tw[278]={9'sd123, 9'sd34}; 	 tw[342]={9'sd28, 9'sd125}; 	 tw[406]={9'sd88, 9'sd93}; 	 tw[470]={-9'sd40, 9'sd122}; 		
 tw[23]={9'sd128, 9'sd0}; 	 tw[87]={9'sd55, 9'sd116}; 	 tw[151]={9'sd108, 9'sd68}; 	 tw[215]={-9'sd16, 9'sd127}; 	 tw[279]={9'sd123, 9'sd36}; 	 tw[343]={9'sd20, 9'sd126}; 	 tw[407]={9'sd85, 9'sd96}; 	 tw[471]={-9'sd50, 9'sd118}; 		
 tw[24]={9'sd128, 9'sd0}; 	 tw[88]={9'sd49, 9'sd118}; 	 tw[152]={9'sd106, 9'sd71}; 	 tw[216]={-9'sd25, 9'sd126}; 	 tw[280]={9'sd122, 9'sd37}; 	 tw[344]={9'sd13, 9'sd127}; 	 tw[408]={9'sd81, 9'sd99}; 	 tw[472]={-9'sd60, 9'sd113}; 		
 tw[25]={9'sd128, 9'sd0}; 	 tw[89]={9'sd43, 9'sd121}; 	 tw[153]={9'sd105, 9'sd74}; 	 tw[217]={-9'sd34, 9'sd123}; 	 tw[281]={9'sd122, 9'sd39}; 	 tw[345]={9'sd5, 9'sd128}; 	 tw[409]={9'sd78, 9'sd102}; 	 tw[473]={-9'sd70, 9'sd107}; 		
 tw[26]={9'sd128, 9'sd0}; 	 tw[90]={9'sd37, 9'sd122}; 	 tw[154]={9'sd103, 9'sd76}; 	 tw[218]={-9'sd43, 9'sd121}; 	 tw[282]={9'sd122, 9'sd40}; 	 tw[346]={-9'sd3, 9'sd128}; 	 tw[410]={9'sd74, 9'sd105}; 	 tw[474]={-9'sd79, 9'sd101}; 		
 tw[27]={9'sd128, 9'sd0}; 	 tw[91]={9'sd31, 9'sd124}; 	 tw[155]={9'sd101, 9'sd79}; 	 tw[219]={-9'sd52, 9'sd117}; 	 tw[283]={9'sd121, 9'sd42}; 	 tw[347]={-9'sd11, 9'sd128}; 	 tw[411]={9'sd70, 9'sd107}; 	 tw[475]={-9'sd87, 9'sd94}; 		
 tw[28]={9'sd128, 9'sd0}; 	 tw[92]={9'sd25, 9'sd126}; 	 tw[156]={9'sd99, 9'sd81}; 	 tw[220]={-9'sd60, 9'sd113}; 	 tw[284]={9'sd121, 9'sd43}; 	 tw[348]={-9'sd19, 9'sd127}; 	 tw[412]={9'sd66, 9'sd110}; 	 tw[476]={-9'sd95, 9'sd86}; 		
 tw[29]={9'sd128, 9'sd0}; 	 tw[93]={9'sd19, 9'sd127}; 	 tw[157]={9'sd97, 9'sd84}; 	 tw[221]={-9'sd68, 9'sd108}; 	 tw[285]={9'sd120, 9'sd45}; 	 tw[349]={-9'sd27, 9'sd125}; 	 tw[413]={9'sd62, 9'sd112}; 	 tw[477]={-9'sd102, 9'sd78}; 		
 tw[30]={9'sd128, 9'sd0}; 	 tw[94]={9'sd13, 9'sd127}; 	 tw[158]={9'sd95, 9'sd86}; 	 tw[222]={-9'sd76, 9'sd103}; 	 tw[286]={9'sd119, 9'sd46}; 	 tw[350]={-9'sd34, 9'sd123}; 	 tw[414]={9'sd58, 9'sd114}; 	 tw[478]={-9'sd108, 9'sd68}; 		
 tw[31]={9'sd128, 9'sd0}; 	 tw[95]={9'sd6, 9'sd128}; 		 tw[159]={9'sd93, 9'sd88}; 	 tw[223]={-9'sd84, 9'sd97}; 	 tw[287]={9'sd119, 9'sd48}; 	 tw[351]={-9'sd42, 9'sd121}; 	 tw[415]={9'sd53, 9'sd116}; 	 tw[479]={-9'sd114, 9'sd59}; 		
 tw[32]={9'sd128, 9'sd0}; 	 tw[96]={9'sd0, 9'sd128}; 		 tw[160]={9'sd91, 9'sd91}; 	 tw[224]={-9'sd91, 9'sd91}; 	 tw[288]={9'sd118, 9'sd49}; 	 tw[352]={-9'sd49, 9'sd118}; 	 tw[416]={9'sd49, 9'sd118}; 	 tw[480]={-9'sd118, 9'sd49}; 		
 tw[33]={9'sd128, 9'sd0}; 	 tw[97]={-9'sd6, 9'sd128}; 	 tw[161]={9'sd88, 9'sd93}; 	 tw[225]={-9'sd97, 9'sd84}; 	 tw[289]={9'sd118, 9'sd50}; 	 tw[353]={-9'sd56, 9'sd115}; 	 tw[417]={9'sd45, 9'sd120}; 	 tw[481]={-9'sd122, 9'sd39}; 		
 tw[34]={9'sd128, 9'sd0}; 	 tw[98]={-9'sd13, 9'sd127}; 	 tw[162]={9'sd86, 9'sd95}; 	 tw[226]={-9'sd103, 9'sd76}; 	 tw[290]={9'sd117, 9'sd52}; 	 tw[354]={-9'sd63, 9'sd111}; 	 tw[418]={9'sd40, 9'sd122}; 	 tw[482]={-9'sd125, 9'sd28}; 		
 tw[35]={9'sd128, 9'sd0}; 	 tw[99]={-9'sd19, 9'sd127}; 	 tw[163]={9'sd84, 9'sd97}; 	 tw[227]={-9'sd108, 9'sd68}; 	 tw[291]={9'sd116, 9'sd53}; 	 tw[355]={-9'sd70, 9'sd107}; 	 tw[419]={9'sd36, 9'sd123}; 	 tw[483]={-9'sd127, 9'sd17}; 		
 tw[36]={9'sd128, 9'sd0}; 	 tw[100]={-9'sd25, 9'sd126}; 	 tw[164]={9'sd81, 9'sd99}; 	 tw[228]={-9'sd113, 9'sd60}; 	 tw[292]={9'sd116, 9'sd55}; 	 tw[356]={-9'sd76, 9'sd103}; 	 tw[420]={9'sd31, 9'sd124}; 	 tw[484]={-9'sd128, 9'sd6}; 		
 tw[37]={9'sd128, 9'sd0}; 	 tw[101]={-9'sd31, 9'sd124}; 	 tw[165]={9'sd79, 9'sd101}; 	 tw[229]={-9'sd117, 9'sd52}; 	 tw[293]={9'sd115, 9'sd56}; 	 tw[357]={-9'sd82, 9'sd98}; 	 tw[421]={9'sd27, 9'sd125}; 	 tw[485]={-9'sd128, -9'sd5}; 		
 tw[38]={9'sd128, 9'sd0}; 	 tw[102]={-9'sd37, 9'sd122}; 	 tw[166]={9'sd76, 9'sd103}; 	 tw[230]={-9'sd121, 9'sd43}; 	 tw[294]={9'sd114, 9'sd58}; 	 tw[358]={-9'sd88, 9'sd93}; 	 tw[422]={9'sd22, 9'sd126}; 	 tw[486]={-9'sd127, -9'sd16}; 		
 tw[39]={9'sd128, 9'sd0}; 	 tw[103]={-9'sd43, 9'sd121}; 	 tw[167]={9'sd74, 9'sd105}; 	 tw[231]={-9'sd123, 9'sd34}; 	 tw[295]={9'sd114, 9'sd59}; 	 tw[359]={-9'sd94, 9'sd87}; 	 tw[423]={9'sd17, 9'sd127}; 	 tw[487]={-9'sd125, -9'sd27}; 		
 tw[40]={9'sd128, 9'sd0}; 	 tw[104]={-9'sd49, 9'sd118}; 	 tw[168]={9'sd71, 9'sd106}; 	 tw[232]={-9'sd126, 9'sd25}; 	 tw[296]={9'sd113, 9'sd60}; 	 tw[360]={-9'sd99, 9'sd81}; 	 tw[424]={9'sd13, 9'sd127}; 	 tw[488]={-9'sd122, -9'sd37}; 		
 tw[41]={9'sd128, 9'sd0}; 	 tw[105]={-9'sd55, 9'sd116}; 	 tw[169]={9'sd68, 9'sd108}; 	 tw[233]={-9'sd127, 9'sd16}; 	 tw[297]={9'sd112, 9'sd62}; 	 tw[361]={-9'sd104, 9'sd75}; 	 tw[425]={9'sd8, 9'sd128}; 	 tw[489]={-9'sd119, -9'sd48}; 		
 tw[42]={9'sd128, 9'sd0}; 	 tw[106]={-9'sd60, 9'sd113}; 	 tw[170]={9'sd66, 9'sd110}; 	 tw[234]={-9'sd128, 9'sd6}; 	 tw[298]={9'sd111, 9'sd63}; 	 tw[362]={-9'sd108, 9'sd68}; 	 tw[426]={9'sd3, 9'sd128}; 	 tw[490]={-9'sd114, -9'sd58}; 		
 tw[43]={9'sd128, 9'sd0}; 	 tw[107]={-9'sd66, 9'sd110}; 	 tw[171]={9'sd63, 9'sd111}; 	 tw[235]={-9'sd128, -9'sd3}; 	 tw[299]={9'sd111, 9'sd64}; 	 tw[363]={-9'sd112, 9'sd62}; 	 tw[427]={-9'sd2, 9'sd128}; 	 tw[491]={-9'sd109, -9'sd67}; 		
 tw[44]={9'sd128, 9'sd0}; 	 tw[108]={-9'sd71, 9'sd106}; 	 tw[172]={9'sd60, 9'sd113}; 	 tw[236]={-9'sd127, -9'sd13};   tw[300]={9'sd110, 9'sd66}; 	 tw[364]={-9'sd116, 9'sd55}; 	 tw[428]={-9'sd6, 9'sd128}; 	 tw[492]={-9'sd103, -9'sd76}; 		
 tw[45]={9'sd128, 9'sd0}; 	 tw[109]={-9'sd76, 9'sd103}; 	 tw[173]={9'sd58, 9'sd114}; 	 tw[237]={-9'sd126, -9'sd22};   tw[301]={9'sd109, 9'sd67}; 	 tw[365]={-9'sd119, 9'sd48}; 	 tw[429]={-9'sd11, 9'sd128}; 	 tw[493]={-9'sd96, -9'sd85}; 		
 tw[46]={9'sd128, 9'sd0}; 	 tw[110]={-9'sd81, 9'sd99}; 	 tw[174]={9'sd55, 9'sd116}; 	 tw[238]={-9'sd124, -9'sd31};   tw[302]={9'sd108, 9'sd68}; 	 tw[366]={-9'sd122, 9'sd40}; 	 tw[430]={-9'sd16, 9'sd127}; 	 tw[494]={-9'sd88, -9'sd93}; 		
 tw[47]={9'sd128, 9'sd0}; 	 tw[111]={-9'sd86, 9'sd95}; 	 tw[175]={9'sd52, 9'sd117}; 	 tw[239]={-9'sd122, -9'sd40};   tw[303]={9'sd107, 9'sd70}; 	 tw[367]={-9'sd124, 9'sd33}; 	 tw[431]={-9'sd20, 9'sd126}; 	 tw[495]={-9'sd80, -9'sd100}; 		
 tw[48]={9'sd128, 9'sd0}; 	 tw[112]={-9'sd91, 9'sd91}; 	 tw[176]={9'sd49, 9'sd118}; 	 tw[240]={-9'sd118, -9'sd49};   tw[304]={9'sd106, 9'sd71}; 	 tw[368]={-9'sd126, 9'sd25}; 	 tw[432]={-9'sd25, 9'sd126}; 	 tw[496]={-9'sd71, -9'sd106}; 		
 tw[49]={9'sd128, 9'sd0}; 	 tw[113]={-9'sd95, 9'sd86}; 	 tw[177]={9'sd46, 9'sd119}; 	 tw[241]={-9'sd114, -9'sd58};   tw[305]={9'sd106, 9'sd72}; 	 tw[369]={-9'sd127, 9'sd17}; 	 tw[433]={-9'sd30, 9'sd125}; 	 tw[497]={-9'sd62, -9'sd112}; 		
 tw[50]={9'sd128, 9'sd0}; 	 tw[114]={-9'sd99, 9'sd81}; 	 tw[178]={9'sd43, 9'sd121}; 	 tw[242]={-9'sd110, -9'sd66};   tw[306]={9'sd105, 9'sd74}; 	 tw[370]={-9'sd128, 9'sd9}; 	 tw[434]={-9'sd34, 9'sd123}; 	 tw[498]={-9'sd52, -9'sd117}; 		
 tw[51]={9'sd128, 9'sd0}; 	 tw[115]={-9'sd103, 9'sd76}; 	 tw[179]={9'sd40, 9'sd122}; 	 tw[243]={-9'sd105, -9'sd74};   tw[307]={9'sd104, 9'sd75}; 	 tw[371]={-9'sd128, 9'sd2}; 	 tw[435]={-9'sd39, 9'sd122}; 	 tw[499]={-9'sd42, -9'sd121}; 		
 tw[52]={9'sd128, 9'sd0}; 	 tw[116]={-9'sd106, 9'sd71}; 	 tw[180]={9'sd37, 9'sd122}; 	 tw[244]={-9'sd99, -9'sd81}; 	 tw[308]={9'sd103, 9'sd76}; 	 tw[372]={-9'sd128, -9'sd6}; 	 tw[436]={-9'sd43, 9'sd121}; 	 tw[500]={-9'sd31, -9'sd124}; 		
 tw[53]={9'sd128, 9'sd0}; 	 tw[117]={-9'sd110, 9'sd66}; 	 tw[181]={9'sd34, 9'sd123}; 	 tw[245]={-9'sd93, -9'sd88}; 	 tw[309]={9'sd102, 9'sd78}; 	 tw[373]={-9'sd127, -9'sd14};   tw[437]={-9'sd48, 9'sd119}; 	 tw[501]={-9'sd20, -9'sd126}; 		
 tw[54]={9'sd128, 9'sd0}; 	 tw[118]={-9'sd113, 9'sd60}; 	 tw[182]={9'sd31, 9'sd124}; 	 tw[246]={-9'sd86, -9'sd95}; 	 tw[310]={9'sd101, 9'sd79}; 	 tw[374]={-9'sd126, -9'sd22};   tw[438]={-9'sd52, 9'sd117}; 	 tw[502]={-9'sd9, -9'sd128}; 		
 tw[55]={9'sd128, 9'sd0}; 	 tw[119]={-9'sd116, 9'sd55}; 	 tw[183]={9'sd28, 9'sd125}; 	 tw[247]={-9'sd79, -9'sd101};   tw[311]={9'sd100, 9'sd80}; 	 tw[375]={-9'sd125, -9'sd30};   tw[439]={-9'sd56, 9'sd115}; 	 tw[503]={9'sd2, -9'sd128}; 		
 tw[56]={9'sd128, 9'sd0}; 	 tw[120]={-9'sd118, 9'sd49}; 	 tw[184]={9'sd25, 9'sd126}; 	 tw[248]={-9'sd71, -9'sd106};   tw[312]={9'sd99, 9'sd81}; 	 tw[376]={-9'sd122, -9'sd37};   tw[440]={-9'sd60, 9'sd113}; 	 tw[504]={9'sd13, -9'sd127}; 		
 tw[57]={9'sd128, 9'sd0}; 	 tw[121]={-9'sd121, 9'sd43}; 	 tw[185]={9'sd22, 9'sd126}; 	 tw[249]={-9'sd63, -9'sd111};   tw[313]={9'sd98, 9'sd82}; 	 tw[377]={-9'sd120, -9'sd45};   tw[441]={-9'sd64, 9'sd111}; 	 tw[505]={9'sd23, -9'sd126}; 		
 tw[58]={9'sd128, 9'sd0}; 	 tw[122]={-9'sd122, 9'sd37}; 	 tw[186]={9'sd19, 9'sd127}; 	 tw[250]={-9'sd55, -9'sd116};   tw[314]={9'sd97, 9'sd84}; 	 tw[378]={-9'sd117, -9'sd52};   tw[442]={-9'sd68, 9'sd108}; 	 tw[506]={9'sd34, -9'sd123}; 		
 tw[59]={9'sd128, 9'sd0}; 	 tw[123]={-9'sd124, 9'sd31}; 	 tw[187]={9'sd16, 9'sd127}; 	 tw[251]={-9'sd46, -9'sd119};   tw[315]={9'sd96, 9'sd85}; 	 tw[379]={-9'sd114, -9'sd59};   tw[443]={-9'sd72, 9'sd106}; 	 tw[507]={9'sd45, -9'sd120}; 		
 tw[60]={9'sd128, 9'sd0}; 	 tw[124]={-9'sd126, 9'sd25}; 	 tw[188]={9'sd13, 9'sd127}; 	 tw[252]={-9'sd37, -9'sd122};   tw[316]={9'sd95, 9'sd86}; 	 tw[380]={-9'sd110, -9'sd66};   tw[444]={-9'sd76, 9'sd103}; 	 tw[508]={9'sd55, -9'sd116}; 		
 tw[61]={9'sd128, 9'sd0}; 	 tw[125]={-9'sd127, 9'sd19}; 	 tw[189]={9'sd9, 9'sd128}; 	 tw[253]={-9'sd28, -9'sd125};   tw[317]={9'sd94, 9'sd87}; 	 tw[381]={-9'sd106, -9'sd72};   tw[445]={-9'sd80, 9'sd100}; 	 tw[509]={9'sd64, -9'sd111}; 		
 tw[62]={9'sd128, 9'sd0}; 	 tw[126]={-9'sd127, 9'sd13}; 	 tw[190]={9'sd6, 9'sd128}; 	 tw[254]={-9'sd19, -9'sd127};   tw[318]={9'sd93, 9'sd88}; 	 tw[382]={-9'sd101, -9'sd79};   tw[446]={-9'sd84, 9'sd97}; 	 tw[510]={9'sd74, -9'sd105}; 		
 tw[63]={9'sd128, 9'sd0}; 	 tw[127]={-9'sd128, 9'sd6}; 	 tw[191]={9'sd3, 9'sd128}; 	 tw[255]={-9'sd9, -9'sd128}; 	 tw[319]={9'sd92, 9'sd89}; 	 tw[383]={-9'sd96, -9'sd85}; 	 tw[447]={-9'sd87, 9'sd94}; 	 tw[511]={9'sd82, -9'sd98}; 		
        return {tw[idx+3*128], tw[idx+2*128], tw[idx+1*128], tw[idx+0*128]};  //inverted due endian change...
    endfunction


    logic [NBW_ADDR-1:0]       addr;
    logic signed [NBW_OUT-1:0] result[NS_IN-1:0][Q:I];

    always_ff @(posedge clk, negedge rst_async_n) begin : outreg
        if (!rst_async_n) begin
            addr <= '{default:'0};
        end else begin
            if (i_valid) begin
                addr   <= addr + 1;
                o_data <= result;
            end
        end
    end
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    genvar i;
    generate
        for (i=0; i<NS_IN; i++) begin : mult
            localparam logic signed [N_TWF-1:0][Q:I][NBW_CS-1:0] TWIDDLE_LO  = load_twf(i);     //you'll need to create a flag to control
            localparam logic signed [N_TWF-1:0][Q:I][NBW_CS-1:0] TWIDDLE_HI  = load_twf(i+64);
        
            logic signed [NBW_IN+NBW_CS:0] mult[Q:I];

            logic signed [NBW_CS-1:0] tw [Q:I];

            assign tw[Q] = (hi_lo_flag)?TWIDDLE_HI[addr][I]:TWIDDLE_LO[addr][I];            //twiddle depends on hi lo flag
            assign tw[I] = (hi_lo_flag)?TWIDDLE_HI[addr][Q]:TWIDDLE_LO[addr][Q];			//inverted (Q <= I) due endian change...
          
            if (INV == 0) begin : direct
                assign mult[I] = (i_data[i][I]*tw[I]) + (i_data[i][Q]*tw[Q]);
                assign mult[Q] = (i_data[i][Q]*tw[I]) - (i_data[i][I]*tw[Q]);               
            end else begin
                assign mult[I] = (i_data[i][I]*tw[I]) - (i_data[i][Q]*tw[Q]);
                assign mult[Q] = (i_data[i][Q]*tw[I]) + (i_data[i][I]*tw[Q]);               
            end
            
            rnd_sat #(.NBW_IN(NBW_IN+NBW_CS+1),.NBI_IN(NBI_IN+NBI_CS+1),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF))uu_rnd_sat_i(.i_data(mult[I]),.o_data(result[i][I]));
            rnd_sat #(.NBW_IN(NBW_IN+NBW_CS+1),.NBI_IN(NBI_IN+NBI_CS+1),.NBW_OUT(NBW_OUT),.NBI_OUT(NBI_OUT),.RND_INF(RND_INF))uu_rnd_sat_q(.i_data(mult[Q]),.o_data(result[i][Q]));            
         end
     endgenerate

     always_ff @(posedge clk, negedge rst_async_n) begin : outv
         if (!rst_async_n) begin
             o_valid <= 0;
         end else begin
             o_valid <= i_valid;
         end
     end

endmodule

