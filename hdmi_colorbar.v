/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
Author				:		Mars
Email Address		: 		pengfeiwang88@163.com
Filename				:		hdmi_colorbar.v
Date					:		2020-06-20
Description			:		                                                                                       
							          Oooo								
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/

module hdmi_colorbar(
	input				clk,							//驱动时钟
	input				sys_rst_n,						//复位信号
	input	[3:0]	cs,								//片选信号
    
	input	[16:0]	pixel_xpos,						//像素点横坐标
	input	[16:0]	pixel_ypos,						//像素点纵坐标  
	input	[1:0]		Resolution_code, 	
	
	output reg	[23:0]	pixel_data						//像素点数据
	);    
    
	reg	[16:0]	H_DISP;
	reg	[16:0]	V_DISP;	

	localparam WHITE	= 24'b11111111_11111111_11111111;    //RGB888 白色
	localparam YELLOW	= 24'b11111111_11111111_00000000;    //RGB888 黄色
	localparam CYAN	= 24'b00000000_11111111_11111111;    //RGB888 青色
	localparam GREEN	= 24'b00000000_11111111_00000000;    //RGB888 绿色
	localparam MAGENTA= 24'b11111111_00000000_11111111;    //RGB888 紫色
	localparam RED		= 24'b11111111_00000000_00000000;    //RGB888 红色
	localparam BLUE	= 24'b00000000_00000000_11111111;    //RGB888 蓝色
	localparam BLACK	= 24'b00000000_00000000_00000000;    //RGB888 黑色

//	always @(*) begin   
	always @(posedge clk or negedge sys_rst_n) begin        
		if (!sys_rst_n) begin
			H_DISP <= 'd640;
			V_DISP <= 'd480;
		end
		else begin
	 		if (Resolution_code == 'b00)begin
				H_DISP <= 'd640;
				V_DISP <= 'd480;			
			end
			else if (Resolution_code == 'b01)begin
				H_DISP <= 'd1024;
				V_DISP <= 'd768;									
			end
			else if (Resolution_code == 'b10)begin
				H_DISP <= 'd800;
				V_DISP <= 'd600;	
			end
			else begin
				H_DISP <= 'd640;
				V_DISP <= 'd480;			
			end			
		end
	end
	
	//根据当前像素点坐标指定当前像素点颜色数据，在屏幕上显示彩条
	always @(posedge clk or negedge sys_rst_n) begin         
		if (!sys_rst_n)
			pixel_data <= 24'd0;
		else begin
			if(cs !== 'h09)	pixel_data <= BLACK;
			else begin
				if((pixel_xpos >= 0) && (pixel_xpos <= (H_DISP/8)*1))
					pixel_data <= WHITE;
				else if((pixel_xpos >= (H_DISP/8)*1) && (pixel_xpos <	(H_DISP/8)*2))
					pixel_data <= YELLOW;
				else if((pixel_xpos >= (H_DISP/8)*2) && (pixel_xpos <	(H_DISP/8)*3))
					pixel_data <= CYAN;
				else if((pixel_xpos >= (H_DISP/8)*3) && (pixel_xpos <	(H_DISP/8)*4))
					pixel_data <= GREEN;
				else if((pixel_xpos >= (H_DISP/8)*4) && (pixel_xpos <	(H_DISP/8)*5))
					pixel_data <= MAGENTA;
				else if((pixel_xpos >= (H_DISP/8)*5) && (pixel_xpos <	(H_DISP/8)*6))
					pixel_data <= RED;
				else if((pixel_xpos >= (H_DISP/8)*6) && (pixel_xpos <	(H_DISP/8)*7))
					pixel_data <= BLUE;
				else if((pixel_xpos >= (H_DISP/8)*7) && (pixel_xpos < (H_DISP/8)*8))
					pixel_data <= BLACK;
				else
					pixel_data <= WHITE;
			end
		end
	end

endmodule 