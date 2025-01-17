	component nios_system is
		port (
			clk_clk                : in    std_logic                     := 'X';             -- clk
			hw_to_sw_export        : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- export
			keycode_export         : out   std_logic_vector(15 downto 0);                    -- export
			otg_hpi_address_export : out   std_logic_vector(1 downto 0);                     -- export
			otg_hpi_cs_export      : out   std_logic;                                        -- export
			otg_hpi_data_in_port   : in    std_logic_vector(15 downto 0) := (others => 'X'); -- in_port
			otg_hpi_data_out_port  : out   std_logic_vector(15 downto 0);                    -- out_port
			otg_hpi_r_export       : out   std_logic;                                        -- export
			otg_hpi_w_export       : out   std_logic;                                        -- export
			reset_reset_n          : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk          : out   std_logic;                                        -- clk
			sdram_mm_address       : in    std_logic_vector(24 downto 0) := (others => 'X'); -- address
			sdram_mm_byteenable_n  : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable_n
			sdram_mm_chipselect    : in    std_logic                     := 'X';             -- chipselect
			sdram_mm_writedata     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			sdram_mm_read_n        : in    std_logic                     := 'X';             -- read_n
			sdram_mm_write_n       : in    std_logic                     := 'X';             -- write_n
			sdram_mm_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
			sdram_mm_readdatavalid : out   std_logic;                                        -- readdatavalid
			sdram_mm_waitrequest   : out   std_logic;                                        -- waitrequest
			sdram_wire_addr        : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba          : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n       : out   std_logic;                                        -- cas_n
			sdram_wire_cke         : out   std_logic;                                        -- cke
			sdram_wire_cs_n        : out   std_logic;                                        -- cs_n
			sdram_wire_dq          : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm         : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n       : out   std_logic;                                        -- ras_n
			sdram_wire_we_n        : out   std_logic;                                        -- we_n
			sprite_num_export      : out   std_logic_vector(5 downto 0);                     -- export
			sw_to_hw_export        : out   std_logic_vector(2 downto 0);                     -- export
			xy_pos_export          : out   std_logic_vector(19 downto 0)                     -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --             clk.clk
			hw_to_sw_export        => CONNECTED_TO_hw_to_sw_export,        --        hw_to_sw.export
			keycode_export         => CONNECTED_TO_keycode_export,         --         keycode.export
			otg_hpi_address_export => CONNECTED_TO_otg_hpi_address_export, -- otg_hpi_address.export
			otg_hpi_cs_export      => CONNECTED_TO_otg_hpi_cs_export,      --      otg_hpi_cs.export
			otg_hpi_data_in_port   => CONNECTED_TO_otg_hpi_data_in_port,   --    otg_hpi_data.in_port
			otg_hpi_data_out_port  => CONNECTED_TO_otg_hpi_data_out_port,  --                .out_port
			otg_hpi_r_export       => CONNECTED_TO_otg_hpi_r_export,       --       otg_hpi_r.export
			otg_hpi_w_export       => CONNECTED_TO_otg_hpi_w_export,       --       otg_hpi_w.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --           reset.reset_n
			sdram_clk_clk          => CONNECTED_TO_sdram_clk_clk,          --       sdram_clk.clk
			sdram_mm_address       => CONNECTED_TO_sdram_mm_address,       --        sdram_mm.address
			sdram_mm_byteenable_n  => CONNECTED_TO_sdram_mm_byteenable_n,  --                .byteenable_n
			sdram_mm_chipselect    => CONNECTED_TO_sdram_mm_chipselect,    --                .chipselect
			sdram_mm_writedata     => CONNECTED_TO_sdram_mm_writedata,     --                .writedata
			sdram_mm_read_n        => CONNECTED_TO_sdram_mm_read_n,        --                .read_n
			sdram_mm_write_n       => CONNECTED_TO_sdram_mm_write_n,       --                .write_n
			sdram_mm_readdata      => CONNECTED_TO_sdram_mm_readdata,      --                .readdata
			sdram_mm_readdatavalid => CONNECTED_TO_sdram_mm_readdatavalid, --                .readdatavalid
			sdram_mm_waitrequest   => CONNECTED_TO_sdram_mm_waitrequest,   --                .waitrequest
			sdram_wire_addr        => CONNECTED_TO_sdram_wire_addr,        --      sdram_wire.addr
			sdram_wire_ba          => CONNECTED_TO_sdram_wire_ba,          --                .ba
			sdram_wire_cas_n       => CONNECTED_TO_sdram_wire_cas_n,       --                .cas_n
			sdram_wire_cke         => CONNECTED_TO_sdram_wire_cke,         --                .cke
			sdram_wire_cs_n        => CONNECTED_TO_sdram_wire_cs_n,        --                .cs_n
			sdram_wire_dq          => CONNECTED_TO_sdram_wire_dq,          --                .dq
			sdram_wire_dqm         => CONNECTED_TO_sdram_wire_dqm,         --                .dqm
			sdram_wire_ras_n       => CONNECTED_TO_sdram_wire_ras_n,       --                .ras_n
			sdram_wire_we_n        => CONNECTED_TO_sdram_wire_we_n,        --                .we_n
			sprite_num_export      => CONNECTED_TO_sprite_num_export,      --      sprite_num.export
			sw_to_hw_export        => CONNECTED_TO_sw_to_hw_export,        --        sw_to_hw.export
			xy_pos_export          => CONNECTED_TO_xy_pos_export           --          xy_pos.export
		);

