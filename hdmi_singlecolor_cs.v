/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
Author				:		Zhang Jiahua
Email Address 		: 		pengfeiwang88@163.com
Filename			:		hdmi_colorbar.v
Date				:		2020-06-20
Description			:		                                                                                       
							          Oooo								
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/

module hdmi_singlecolor_cs(
	input             	clk,			//VGA驱动时钟
	input				sys_rst_n,		//复位信号
    
	input		[16:0]	pixel_xpos,		//像素点横坐标
	input		[16:0]	pixel_ypos,		//像素点纵坐标
	input		[3:0] 	cs,				//片选信号
	input		[1:0]	Resolution_code, 
		
	output reg 	[23:0]	pixel_data		//像素点数据
    );    
    
	reg		[39:0]	GRAY_TEMP_0;		//RGB相等时表现灰度的单个R值
	reg		[39:0]	GRAY_TEMP_1;
	reg		[39:0]	GRAY_TEMP_2;
	reg		[39:0]	GRAY_TEMP_3;	
	reg		[39:0]	GRAY_TEMP_4;
	reg		[39:0]	GRAY_OUT;			//灰度的RGB值

	reg	[16:0]	H_DISP;
	reg	[16:0]	V_DISP;	
	
	localparam WHITE   = 24'b11111111_11111111_11111111;    //RGB888 白色
	localparam BLACK   = 24'b00000000_00000000_00000000;    //RGB888 黑色
	localparam GRAY    = 24'b01111111_01111111_01111111;    //RGB888 灰色
	localparam RED     = 24'b11111111_00000000_00000000;    //RGB888 红色
	localparam GREEN   = 24'b00000000_11111111_00000000;    //RGB888 绿色
	localparam BLUE    = 24'b00000000_00000000_11111111;    //RGB888 蓝色
 
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
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n) 
		begin
			pixel_data <= 24'd0;
		end
		else begin
			if(cs == 'h00) pixel_data <= WHITE;
			else if (cs == 'h01) pixel_data <= BLACK;
			else if (cs == 'h02) pixel_data <= RED;
			else if (cs == 'h03) pixel_data <= GREEN;
			else if (cs == 'h04) pixel_data <= BLUE;
			
			else if (cs == 'h05)
			begin
				pixel_data <= GRAY_TEMP_2;	
				// pixel_data <= {pixel_xpos[7:0],8'b0,8'b0};				
			end		
			
			else if (cs == 'h06)
			begin
				pixel_data <= GRAY_TEMP_3;	
				// pixel_data <= {8'b0,pixel_xpos[7:0],8'b0};					
			end	
			
			else if (cs == 'h07)
			begin
				pixel_data <= GRAY_TEMP_1;
				// pixel_data <= pixel_xpos[7:0];					
			end
			
			else if (cs == 'h08)
			begin
				pixel_data <= GRAY_TEMP_4;
			end			
			
			else	pixel_data <= WHITE;
		end
	end
	
	//坐标乘以255
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n) GRAY_TEMP_0 <= 'b0;
		else begin
			GRAY_TEMP_0 <= (pixel_xpos << 8) - pixel_xpos;
		end
	end
	
	//蓝阶图像
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n)	GRAY_TEMP_1<= 'b0;
		else begin
			GRAY_TEMP_1 <= GRAY_TEMP_0 / H_DISP;
		end
	end
	
	//红阶图像
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n)	GRAY_TEMP_2<= 'b0;
		else begin
			GRAY_TEMP_2 <= {GRAY_TEMP_1[7:0],8'b0,8'b0};
		end
	end

	//绿阶图像	
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n)	GRAY_TEMP_3<= 'b0;
		else begin
			GRAY_TEMP_3 <= {8'b0,GRAY_TEMP_1[7:0],8'b0};
		end
	end

	//灰阶图像	
	always @(posedge clk or negedge sys_rst_n)
	begin
		if (!sys_rst_n)	GRAY_TEMP_4 <= 'b0;
		else begin
			GRAY_TEMP_4 <= {GRAY_TEMP_1[7:0],GRAY_TEMP_1[7:0],GRAY_TEMP_1[7:0]};
		end
	end

endmodule