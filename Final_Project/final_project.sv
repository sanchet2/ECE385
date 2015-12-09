
module  Final_Project ( input logic         CLOCK_50,
                       input logic [3:0]    KEY, //bit 0 is set up as Reset
							  output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,						
							  // VGA Interface 
							  output [8:0] LEDG,
							  output [17:0] LEDR,
							//  input [17:0] SW,
                       output [7:0]  VGA_R,					//VGA Red
							                VGA_G,					//VGA Green
												 VGA_B,					//VGA Blue
							  output        VGA_CLK,				//VGA Clock
							                VGA_SYNC_N,			//VGA Sync signal
												 VGA_BLANK_N,			//VGA Blank signal
												 VGA_VS,					//VGA virtical sync signal	
												 VGA_HS,					//VGA horizontal sync signal
							  // CY7C67200 Interface 
							  inout [15:0]  OTG_DATA,						//	CY7C67200 Data bus 16 Bits
							  output [1:0]  OTG_ADDR,						//	CY7C67200 Address 2 Bits
							  output        OTG_CS_N,						//	CY7C67200 Chip Select
												 OTG_RD_N,						//	CY7C67200 Write
												 OTG_WR_N,						//	CY7C67200 Read
												 OTG_RST_N,						//	CY7C67200 Reset
							  input			 OTG_INT,						//	CY7C67200 Interrupt
							  // SDRAM Interface for Nios II Software
							  output logic [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout logic [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output logic [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output logic [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output	logic 		 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output	logic 		 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output	logic 		 DRAM_CKE,				// SDRAM Clock Enable
							  output	logic 		 DRAM_WE_N,				// SDRAM Write Enable
							  output	logic 		 DRAM_CS_N,				// SDRAM Chip Select
							  output	logic 		 DRAM_CLK				// SDRAM Clock
											);
    
    logic sdram_cs, sdram_r, sdram_w;
	 logic sdram_rvalid, sdram_wait;
	 logic [24:0] sdram_address, address;
	 logic [31:0] sdram_datain;
	 logic [31:0] sdram_dataout;
	 logic [3:0] sdram_byteen;
	 
	 logic ready, read_ok;
			logic [24:0] a;
			logic [31:0] data, write_data;
	 
	 logic [9:0] drawxsig, drawysig;
	 
	 logic Reset_h, vssig, Clk, valid;

	 assign sdram_cs = 1'b1;
	 assign Clk = CLOCK_50;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	 
	 vga_controller vgasync_instance( .Clk(Clk), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .pixel_clk(VGA_CLK), .blank(VGA_BLANK_N),
													.sync(VGA_SYNC_N), .DrawX(drawxsig), .DrawY(drawysig)); 
		
//	frame_control test1(.x_pos(drawxsig), .y_pos(drawysig), .read_ok(read_ok));


	 logic blitter_finished, sprite_received, sprite_finished, new_sprite, sprite_ack, sprite_incoming, is_shadow;
	 logic [5:0] sprite_num;
		logic [25:0] sprite_address;
		logic [9:0] x_size, y_size, sprite_x_pos, sprite_y_pos;
		
		wire [1:0] hpi_addr;
	 wire [15:0] hpi_data_in, hpi_data_out, keycode;
	 wire hpi_r, hpi_w,hpi_cs;
	 
	 //The connections for nios_system might be named different depending on how you set up Qsys
	 nios_system nios_system(
										 .clk_clk(Clk),         
										 .reset_reset_n(KEY[0]),   
										 .sdram_wire_addr(DRAM_ADDR), 
										 .sdram_wire_ba(DRAM_BA),   
										 .sdram_wire_cas_n(DRAM_CAS_N),
										 .sdram_wire_cke(DRAM_CKE),  
										 .sdram_wire_cs_n(DRAM_CS_N), 
										 .sdram_wire_dq(DRAM_DQ),   
										 .sdram_wire_dqm(DRAM_DQM),  
										 .sdram_wire_ras_n(DRAM_RAS_N),
										 .sdram_wire_we_n(DRAM_WE_N), 
										 .sdram_clk_clk(DRAM_CLK),
										 .sdram_mm_address(sdram_address),            
	                            .sdram_mm_byteenable_n(sdram_byteen),       
                               .sdram_mm_chipselect(sdram_cs),         
                               .sdram_mm_writedata(sdram_datain),          
                               .sdram_mm_read_n(sdram_r),             
                               .sdram_mm_write_n(sdram_w),            
										 .sdram_mm_readdata(sdram_dataout),           
                               .sdram_mm_readdatavalid(sdram_rvalid),      
                               .sdram_mm_waitrequest(sdram_wait),
										 
										 .hw_to_sw_export({sprite_received, sprite_finished}),
										 .sprite_num_export(sprite_num),
										 .sw_to_hw_export({is_shadow, sprite_incoming, sprite_ack}),
										 .xy_pos_export({sprite_x_pos, sprite_y_pos}),
										 
										 .keycode_export(keycode),  
										 .otg_hpi_address_export(hpi_addr),
										 .otg_hpi_data_in_port(hpi_data_in),
										 .otg_hpi_data_out_port(hpi_data_out),
										 .otg_hpi_cs_export(hpi_cs),
										 .otg_hpi_r_export(hpi_r),
										 .otg_hpi_w_export(hpi_w)
										 ); 
									 
		logic [31:0]  data_from_blitter, data_to_blitter;
		logic [24:0] address_from_blitter;
		logic blitter_read, blitter_valid, blitter_write, burst_finished;
		
		
		
		communicator com(.Clk(Clk), .Reset(Reset_h), .sprite_incoming(sprite_incoming), .acknowledge_finished_sprite(sprite_ack),
						 .blitter_finished(blitter_finished), .sprite_num(sprite_num), 
						 .sprite_received(sprite_received), .sprite_finished(sprite_finished), .blitter_start(new_sprite),
						 .sprite_address(sprite_address), .x_size(x_size), .y_size(y_size));
									  
		burst_control burst(.Clk(Clk), .Reset(Reset_h), .VGA_Clk(VGA_CLK), .blitter_valid(blitter_valid),
									  .valid(sdram_rvalid), .wait_req(sdram_wait), .red(VGA_R), .green(VGA_G), .blue(VGA_B),
									  .address_in(a), .data_from_mem(sdram_dataout), .write_out(sdram_w),
									  .read_out(sdram_r), .byte_enable(sdram_byteen), .address_out(sdram_address), .address_test(address),
									  .data_to_sdram(sdram_datain), .data_to_fpga(data2), .x_pos(drawxsig), .y_pos(drawysig),
									  .blitter_read(blitter_read), .blitter_write(blitter_write), .data_from_blitter(data_from_blitter),
									  .address_from_blitter(address_from_blitter), .blitter_finished(burst_finished), .data_to_blitter(data_to_blitter)); 
							
		blittera blittera(.Clk(Clk), .Reset(Reset_h), .new_sprite(new_sprite), .valid(blitter_valid), .is_shadow(is_shadow),
							 .sprite_x_pos(sprite_x_pos), .sprite_y_pos(sprite_y_pos),.sprite_address(sprite_address),
							 .data_from_sdram(data_to_blitter), .wrote_sprite(blitter_finished), .read_req(blitter_read), 
							 .write_req(blitter_write), .data_out(data_from_blitter), .address_to_sdram(address_from_blitter),
							 .sprite_dimx(x_size), .sprite_dimy(y_size), .burst_finished(burst_finished));
							 
		
	 
	 hpi_io_intf hpi_io_inst(   .from_sw_address(hpi_addr),
										 .from_sw_data_in(hpi_data_in),
										 .from_sw_data_out(hpi_data_out),
										 .from_sw_r(hpi_r),
										 .from_sw_w(hpi_w),
										 .from_sw_cs(hpi_cs),
		 								 .OTG_DATA(OTG_DATA),    
										 .OTG_ADDR(OTG_ADDR),    
										 .OTG_RD_N(OTG_RD_N),    
										 .OTG_WR_N(OTG_WR_N),    
										 .OTG_CS_N(OTG_CS_N),    
										 .OTG_RST_N(OTG_RST_N),   
										 .OTG_INT(OTG_INT),
										 .Clk(Clk),
										 .Reset(Reset_h)
	 );
									  
		
			assign data = data_from_blitter;
			
			assign LEDR = 	sdram_address[17:0];						 
			HexDriver Hexd0( .In0(data[3:0]), .Out0(HEX0));
			HexDriver Hexd1( .In0(data[7:4]), .Out0(HEX1));
			HexDriver Hexd2( .In0(data[11:8]), .Out0(HEX2));
			HexDriver Hexd3( .In0(data[15:12]), .Out0(HEX3));
			HexDriver Hexd4( .In0(data[19:16]), .Out0(HEX4));
			HexDriver Hexd5( .In0(data[23:20]), .Out0(HEX5));
			HexDriver Hexd6( .In0(data[27:24]), .Out0(HEX6));
			HexDriver Hexd7( .In0(data[31:28]), .Out0(HEX7));
endmodule 