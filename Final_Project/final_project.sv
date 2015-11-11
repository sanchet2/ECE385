
module  Final_Project ( input         CLOCK_50,
                       input[3:0]    KEY, //bit 0 is set up as Reset
							  output [6:0]  HEX0, HEX1, HEX2, HEX3, //, HEX4, HEX5, HEX6, HEX7,						
							  // VGA Interface 
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
							  output [12:0] DRAM_ADDR,				// SDRAM Address 13 Bits
							  inout [31:0]  DRAM_DQ,				// SDRAM Data 32 Bits
							  output [1:0]  DRAM_BA,				// SDRAM Bank Address 2 Bits
							  output [3:0]  DRAM_DQM,				// SDRAM Data Mast 4 Bits
							  output			 DRAM_RAS_N,			// SDRAM Row Address Strobe
							  output			 DRAM_CAS_N,			// SDRAM Column Address Strobe
							  output			 DRAM_CKE,				// SDRAM Clock Enable
							  output			 DRAM_WE_N,				// SDRAM Write Enable
							  output			 DRAM_CS_N,				// SDRAM Chip Select
							  output			 DRAM_CLK				// SDRAM Clock
											);
    
    logic Reset_h, vssig, Clk, sdram_byteen, sdram_cs, sdram_r, sdram_w, sdram_rvalid, sdram_wait;
	 logic [24:0] sdram_address;
	 logic [31:0] sdram_datain, sdram_dataout, junk;
	 
	 assign sdram_address = 25'd1;
	 assign sdram_datain = 32'd45;
	 assign sdram_cs = 1'b1;
	 assign Clk = CLOCK_50;
	// assign sdram_r = 1'b0;
	// assign sdram_w = 1'b1;
    assign {Reset_h}=~ (KEY[0]);  // The push buttons are active low
	 
	 testwrite test (.clk(CLOCK_50), .reset(reset_h), .w(sdram_w), .r(sdram_r));
	 
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
                               .sdram_pll_pll_slave_read(sdram_r),    
                               .sdram_pll_pll_slave_write(sdram_w),   
                               .sdram_pll_pll_slave_address(sdram_address), 
                               .sdram_pll_pll_slave_readdata(junk),
                               .sdram_pll_pll_slave_writedata(sdram_datain));
										 
										 
			HexDriver Hexd0( .In0(sdram_dataout[3:0]), .Out0(HEX0));
			HexDriver Hexd1( .In0(sdram_dataout[7:4]), .Out0(HEX1));
			HexDriver Hexd2( .In0(sdram_dataout[11:8]), .Out0(HEX2));
			HexDriver Hexd3( .In0(sdram_dataout[15:12]), .Out0(HEX3));
endmodule 