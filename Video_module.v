module Video_module(
	clk,
	uart_clk,
	rst_n,
	resetsig,
	display_code_in,
	resolution,
	runstop,
	Vertical_Fre,
	Horizon_Fre,
	tmds_clk_p,
	tmds_clk_n,
	key_count_code_m0,
	key_count_code_m1,
	key_count_code_m2,
	key_count_code_m3,
	vsync,
	hsync,
	hdmi_clk,
	R,
	G,
	B,
	tmds_data_n,
	tmds_data_p,
	sys_hw_rst_n
);

	input wire	clk;
	input wire	uart_clk;
	input wire	rst_n;
	input wire	[7:0] resetsig;
	input wire	[7:0] display_code_in;
	input wire	[7:0] resolution;
	input wire	[7:0] runstop;
		
	output wire	[7:0] Vertical_Fre;
	output wire	[23:0] Horizon_Fre;
	
	output wire	tmds_clk_p;
	output wire	tmds_clk_n;
	output wire	key_count_code_m0;
	output wire	key_count_code_m1;
	output wire	key_count_code_m2;
	output wire	key_count_code_m3;
	output wire	vsync;
	output wire	hsync;
	output wire	hdmi_clk;
	output wire	R;
	output wire	G;
	output wire	B;
	output wire	sys_hw_rst_n;
	output wire	[2:0] tmds_data_n;
	output wire	[2:0] tmds_data_p;

	wire	[3:0] display_code_out_m0;
	wire	[7:0] rgb_b;
	wire	[7:0] rgb_g;
	wire	[7:0] rgb_r;
	wire	[2:0] tmds_data_n_m0;
	wire	[2:0] tmds_data_p_m0;
	
	wire	hdmi_clk_m0;
	wire	pixelclk5x_m0;
	wire	rstin_m0;
	wire	hsync_m0;
	wire	vsync_m0;
	wire	de_m0;
	wire	sys_rst_n_m0;
	wire	[16:0] pixel_xpos_m0;
	wire	[16:0] pixel_ypos_m0;
	wire	[23:0] pixel_data_0_m0;
	wire	[23:0] pixel_data_1_m0;
	wire	[23:0] pixel_data_2_m0;
	wire	[23:0] pixel_data_3_m0;
	wire	[23:0] pixel_data_out;
	wire	locked_m0;
	wire	[15:0] cnt_h_m0;
	wire	[15:0] cnt_v_m0;
	wire	[23:0] vsync_m07;
	wire	clk2_m0;
	wire	clk0_m0;
	wire	outclk_m0;

	assign	vsync = vsync_m0;
	assign	hsync = hsync_m0;
	assign	hdmi_clk = hdmi_clk_m0;

//	dvi_encoder	b2v_dvi_encoder_m0(
//		.pixelclk(hdmi_clk_m0),
//		.pixelclk5x(pixelclk5x_m0),
//		.rstin(rstin_m0),
//		.hsync(hsync_m0),
//		.vsync(vsync_m0),
//		.de(de_m0),
//		.blue_din(rgb_b),
//		.green_din(rgb_g),
//		.red_din(rgb_r),
//		.tmds_clk_p(tmds_clk_p),
//		.tmds_clk_n(tmds_clk_n),
//		.tmds_data_n(tmds_data_n_m0),
//		.tmds_data_p(tmds_data_p_m0));
	
	rgb2hdmi	b2v_rgb2hdmi_m0(
		.clock(pixelclk5x_m0),
		.clk_en(hdmi_clk_m0),
		.vsync(vsync_m0),
		.hsync(hsync_m0),
		.de(de_m0),
		.red(rgb_r),
		.green(rgb_g),
		.blue(rgb_b),
		.hdmi_clk_p(tmds_clk_p),
		.hdmi_d2_p(tmds_data_p_m0[2]),
		.hdmi_d1_p(tmds_data_p_m0[1]),
		.hdmi_d0_p(tmds_data_p_m0[0]),
		.hdmi_clk_n(tmds_clk_n),
		.hdmi_d2_n(tmds_data_n_m0[2]),
		.hdmi_d1_n(tmds_data_n_m0[1]),
		.hdmi_d0_n(tmds_data_n_m0[0]));


	hdmi_singlecolor_cs	b2v_inst(
		.clk(hdmi_clk_m0),
		.sys_rst_n(sys_rst_n_m0),
		.cs(display_code_out_m0),
		.pixel_xpos(pixel_xpos_m0),
		.pixel_ypos(pixel_ypos_m0),
		.Resolution_code(resolution[1:0]),
		.pixel_data(pixel_data_0_m0));


	mux4	b2v_inst1(
		.clk(hdmi_clk_m0),
		.sys_rst_n(sys_rst_n_m0),
		.cs(display_code_out_m0),
		.pixel_data_0(pixel_data_0_m0),
		.pixel_data_1(pixel_data_1_m0),
		.pixel_data_2(pixel_data_2_m0),
		.pixel_data_3(pixel_data_3_m0),
		.pixel_data_out(pixel_data_out));

	assign	sys_rst_n_m0 = rst_n & runstop[0] & locked_m0;


	hdmi_char	b2v_inst14(
		.clk(hdmi_clk_m0),
		.rst(sys_rst_n_m0),
		.cs(display_code_out_m0),
		.pixel_xpos(pixel_xpos_m0),
		.pixel_ypos(pixel_ypos_m0),
		.Resolution_code(resolution[1:0]),
		.pixel_color_data(pixel_data_2_m0));


	hdmi_blockmove	b2v_inst15(
		.clk(hdmi_clk_m0),
		.rst(sys_rst_n_m0),
		.cs(display_code_out_m0),
		.pixel_xpos(pixel_xpos_m0),
		.pixel_ypos(pixel_ypos_m0),
		.Resolution_code(resolution[1:0]),
		.pixel_color_data(pixel_data_3_m0));


	hdmi_colorbar	b2v_inst17(
		.clk(hdmi_clk_m0),
		.sys_rst_n(sys_rst_n_m0),
		.cs(display_code_out_m0),
		.pixel_xpos(pixel_xpos_m0),
		.pixel_ypos(pixel_ypos_m0),
		.Resolution_code(resolution[1:0]),
		.pixel_data(pixel_data_1_m0));


	datasend_calc	b2v_inst19(
		.clk(uart_clk),
		.sys_rst_n(sys_rst_n_m0),
		.Resolution_code(resolution[1:0]),
		.Horizon_Fre(Horizon_Fre),
		.Vertical_Fre(Vertical_Fre));
		

	video_pll_2	b2v_inst20(
		.inclk0(clk),
		.c0(clk0_m0),
		.c2(clk2_m0),
		.locked(locked_m0));


	 display_code_cache	b2v_inst22(
		.sys_clk(uart_clk),
		.sys_rst_n(sys_rst_n_m0),
		.cnt_h(cnt_h_m0),
		.cnt_v(cnt_v_m0),
		.display_code_in(display_code_in[3:0]),
		.resetsig(resetsig),
		.Resolution_code(resolution[1:0]),
		.display_code_out(display_code_out_m0));

	hdmi_driver	b2v_inst23(
		.clk(hdmi_clk_m0),
		.rst(sys_rst_n_m0),
		.pixel_color_data(pixel_data_out),
		.Resolution_code(resolution[1:0]),
		.hdmi_hs(hsync_m0),
		.hdmi_vs(vsync_m0),
		.hdmi_en(de_m0),
		.cnt_h(cnt_h_m0),
		.cnt_v(cnt_v_m0),
		.pixel_xpos(pixel_xpos_m0),
		.pixel_ypos(pixel_ypos_m0),
		.rgb_b(rgb_b),
		.rgb_g(rgb_g),
		.rgb_r(rgb_r));


	clk5x_ctrl	b2v_inst4(
		.inclk1x(clk2_m0),
		.inclk0x(clk0_m0),
		.clkselect(resolution[0]),
		.outclk(outclk_m0));

	assign	sys_hw_rst_n = rst_n & locked_m0;


	clk_div	b2v_inst9(
		.clock(outclk_m0),
		.rst_n(sys_rst_n_m0),
		.clk_out(pixelclk5x_m0),
		.clk_div_five(hdmi_clk_m0));

	assign	key_count_code_m3 =  ~resetsig[0];

	assign	key_count_code_m2 =  ~display_code_out_m0[2];

	assign	key_count_code_m1 =  ~display_code_out_m0[1];

	assign	key_count_code_m0 =  ~display_code_out_m0[0];

	assign	rstin_m0 =  ~sys_rst_n_m0;

	assign	R = rgb_r[0];
	assign	G = rgb_g[0];
	assign	B = rgb_b[0];
	assign	tmds_data_n = tmds_data_n_m0;
	assign	tmds_data_p = tmds_data_p_m0;

endmodule
