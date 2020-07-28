/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
Author				:		Mars
Email Address 		: 		pengfeiwang88@163.com
Filename			:		Video_signal_generator_tb.v
Date				:		2020-06-30
Description			:		                                                                                   
							          Oooo								
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/
`timescale 1ns/1ns
module Video_signal_generator_tb;
	reg 			clk;
	reg				rst_n;
	reg 			key_content;
	reg				key_resolution;
	
	wire			hsync;
	wire			vsync;
	wire			hdmi_clk;
	wire         	tmds_clk_p;
	wire         	tmds_clk_n;
	wire	[2:0]   tmds_data_p;    //rgb
	wire	[2:0]   tmds_data_n;    //rgb
	wire			key_count_code_m3;
	wire			key_count_code_m2;		
	wire			key_count_code_m1;
	wire			key_count_code_m0;	
	
	Video_signal_generator	Video_signal_generator_m0(
	.clk(clk),
	.rst_n(rst_n),
	.key_resolution(key_resolution),
	.key_content(key_content),
	
	.tmds_clk_p(tmds_clk_p),
	.tmds_clk_n(tmds_clk_n),
	.key_count_code_m0(key_count_code_m0),
	.key_count_code_m1(key_count_code_m1),
	.key_count_code_m2(key_count_code_m2),
	.key_count_code_m3(key_count_code_m3),
	.vsync(vsync),
	.hsync(hsync),
	.hdmi_clk(hdmi_clk),
	.tmds_data_n(tmds_data_n),
	.tmds_data_p(tmds_data_p)
	);
	
	initial begin
	#0		clk = 0;
			rst_n = 0;	
			key_content	= 1;
	#100	rst_n = 1;
		
	#1000	key_resolution =1;
	#100	key_resolution =0;
	#100	key_resolution =1;

	end
	
	always #10 clk = ~clk;	//50MHz	
	
endmodule
