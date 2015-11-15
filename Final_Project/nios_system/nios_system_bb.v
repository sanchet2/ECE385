
module nios_system (
	clk_clk,
	reset_reset_n,
	sdram_clk_clk,
	sdram_mm_address,
	sdram_mm_byteenable_n,
	sdram_mm_chipselect,
	sdram_mm_writedata,
	sdram_mm_read_n,
	sdram_mm_write_n,
	sdram_mm_readdata,
	sdram_mm_readdatavalid,
	sdram_mm_waitrequest,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n);	

	input		clk_clk;
	input		reset_reset_n;
	output		sdram_clk_clk;
	input	[24:0]	sdram_mm_address;
	input	[3:0]	sdram_mm_byteenable_n;
	input		sdram_mm_chipselect;
	input	[31:0]	sdram_mm_writedata;
	input		sdram_mm_read_n;
	input		sdram_mm_write_n;
	output	[31:0]	sdram_mm_readdata;
	output		sdram_mm_readdatavalid;
	output		sdram_mm_waitrequest;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
endmodule
