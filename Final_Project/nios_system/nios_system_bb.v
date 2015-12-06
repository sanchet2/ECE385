
module nios_system (
	clk_clk,
	hw_to_sw_export,
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
	sdram_wire_we_n,
	sprite_num_export,
	sw_to_hw_export,
	xy_pos_export,
	keycode_export,
	otg_hpi_cs_export,
	otg_hpi_address_export,
	otg_hpi_data_in_port,
	otg_hpi_data_out_port,
	otg_hpi_r_export,
	otg_hpi_w_export,
	reset_reset_n);	

	input		clk_clk;
	input	[1:0]	hw_to_sw_export;
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
	output	[1:0]	sprite_num_export;
	output	[2:0]	sw_to_hw_export;
	output	[19:0]	xy_pos_export;
	output	[15:0]	keycode_export;
	output		otg_hpi_cs_export;
	output	[1:0]	otg_hpi_address_export;
	input	[15:0]	otg_hpi_data_in_port;
	output	[15:0]	otg_hpi_data_out_port;
	output		otg_hpi_r_export;
	output		otg_hpi_w_export;
	input		reset_reset_n;
endmodule
