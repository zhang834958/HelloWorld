module uart_module(clk50, rst_n,rx, tx,key_in,clk,led_out,resolution,display,resetsig,runstop,
					slaver,pw_flag,pulse_number_flag,loop_output,change_pulse_number_time,Vertical_Scan_Fre,Horizon_Scan_Fre);
					
	input			clk50;
	input			rst_n;
	input 	[1:0] 	key_in;
	input 			rx;
	input 	[7:0]	Vertical_Scan_Fre;
	input 	[23:0] 	Horizon_Scan_Fre;
	
	output 			tx,slaver,pw_flag,pulse_number_flag,loop_output,change_pulse_number_time;
	output 	[3:0]	led_out;
	output 	[7:0] 	resolution,display,resetsig,runstop; 


	output clk;       //clock for 9600 uart port
	wire [7:0] txdata,txdata1,txdata2,rxdata,store_test;
	wire [31:0] store1;
	wire [159:0] store2;  
	wire idle,wrsig_reg;
	wire dataerror;
	wire frameerror;
	wire k;

	wire [10:0] duty;
	wire [31:0] number_of_pulse;
	wire [24:0]fre;
	wire [9:0] time_output_pulse;
	wire [31:0] width_of_pulse;

	clkdiv u0 (
			.clk50                   (clk50),   
			.bps                     (bps),		
			.clkout                  (clk)                    
	 );

	uartrx u1 (
			.clk                     (clk),  
			.rx	                   	 (rx),  	
			.dataout                 (rxdata),                       
			.rdsig                   (rdsig),
			.dataerror               (dataerror),
			.frameerror              (frameerror)
			//.led_out                  (led_out)
	);

	uarttx u2 (
			.clk                     (clk),                           
			.datain                  (txdata),//txdata wrsig_reg//rxdata rdsig
			.wrsig                   (wrsig_reg),//(wrsig),//wrsig_reg //store_test  rdsig
			.idle                    (idle), 	
			.tx                      (tx)		
	 );

	uartbps u3 (
			.clk					(clk50),                           
			.key_in                 (key_in),  
			//.display_data                  (k), 
			.bps                    (bps)       
			//.clearsig                  (clearsig)    	
	 );

	select u4 (
			.clk                    (clk),                           
			.data_in                (rxdata),      
			.rdsig                  (rdsig), 
		    .store1                 (store1),  //视频
		    .store2                 (store2), 	//方波	
		    .clctsig                (clctsig),
			.store_test             (store_test),
			.led_out                (led_out),
			.store1_sig                  (store1_sig), 
			.store2_sig                  (store2_sig),
			.change_pulse_number_time    (change_pulse_number_time)
	 );
	 
	 data_div1 u5 (
			.clk                   (clk), 
//			.rst_n						(rst_n),
			.store1                  (store1),      
			.clctsig                  (clctsig), 
			.store1_sig                  (store1_sig), 
			.resolution                  (resolution), 
			.display                  (display),  	
			.resetsig                  (resetsig),  	
			.runstop                  (runstop)		
		 );
	 data_div2 u6 (
			.clk                            (clk),                           
			.store2                         (store2),      
			.clctsig                        (clctsig), 
			.store2_sig                     (store2_sig), 
			.slaver                         (slaver), 
			.pw_flag                        (pw_flag),  	
			.pulse_number_flag              (pulse_number_flag),  	
			.loop_output                    (loop_output),
			.duty                           (duty),
			.number_of_pulse                (number_of_pulse),
			.fre                            (fre),
			.time_output_pulse              (time_output_pulse),
			.width_of_pulse                 (width_of_pulse)	
	 );
	  
	data_send u7 (
			.clk                   (clk),                           
	//		.data_receive                  (data_receive),//待修改 
		  .data0                  (Vertical_Scan_Fre),   
		  .data1                  (Horizon_Scan_Fre),  
		  //.data2                  (resetsig),    		
			.wrsig_reg                  (wrsig_reg), 
			.dataout_reg                  (txdata)	
	 );     

endmodule

