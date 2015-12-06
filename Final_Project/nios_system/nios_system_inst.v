	nios_system u0 (
		.clk_clk                (<connected-to-clk_clk>),                //        clk.clk
		.hw_to_sw_export        (<connected-to-hw_to_sw_export>),        //   hw_to_sw.export
		.reset_reset_n          (<connected-to-reset_reset_n>),          //      reset.reset_n
		.sdram_clk_clk          (<connected-to-sdram_clk_clk>),          //  sdram_clk.clk
		.sdram_wire_addr        (<connected-to-sdram_wire_addr>),        // sdram_wire.addr
		.sdram_wire_ba          (<connected-to-sdram_wire_ba>),          //           .ba
		.sdram_wire_cas_n       (<connected-to-sdram_wire_cas_n>),       //           .cas_n
		.sdram_wire_cke         (<connected-to-sdram_wire_cke>),         //           .cke
		.sdram_wire_cs_n        (<connected-to-sdram_wire_cs_n>),        //           .cs_n
		.sdram_wire_dq          (<connected-to-sdram_wire_dq>),          //           .dq
		.sdram_wire_dqm         (<connected-to-sdram_wire_dqm>),         //           .dqm
		.sdram_wire_ras_n       (<connected-to-sdram_wire_ras_n>),       //           .ras_n
		.sdram_wire_we_n        (<connected-to-sdram_wire_we_n>),        //           .we_n
		.sprite_num_export      (<connected-to-sprite_num_export>),      // sprite_num.export
		.sw_to_hw_export        (<connected-to-sw_to_hw_export>),        //   sw_to_hw.export
		.xy_pos_export          (<connected-to-xy_pos_export>),          //     xy_pos.export
		.sdram_mm_address       (<connected-to-sdram_mm_address>),       //   sdram_mm.address
		.sdram_mm_byteenable_n  (<connected-to-sdram_mm_byteenable_n>),  //           .byteenable_n
		.sdram_mm_chipselect    (<connected-to-sdram_mm_chipselect>),    //           .chipselect
		.sdram_mm_writedata     (<connected-to-sdram_mm_writedata>),     //           .writedata
		.sdram_mm_read_n        (<connected-to-sdram_mm_read_n>),        //           .read_n
		.sdram_mm_write_n       (<connected-to-sdram_mm_write_n>),       //           .write_n
		.sdram_mm_readdata      (<connected-to-sdram_mm_readdata>),      //           .readdata
		.sdram_mm_readdatavalid (<connected-to-sdram_mm_readdatavalid>), //           .readdatavalid
		.sdram_mm_waitrequest   (<connected-to-sdram_mm_waitrequest>)    //           .waitrequest
	);

