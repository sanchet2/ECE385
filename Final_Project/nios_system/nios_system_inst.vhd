	component nios_system is
		port (
			clk_clk                : in    std_logic                     := 'X';             -- clk
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
			sdram_wire_we_n        : out   std_logic                                         -- we_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --        clk.clk
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --      reset.reset_n
			sdram_clk_clk          => CONNECTED_TO_sdram_clk_clk,          --  sdram_clk.clk
			sdram_mm_address       => CONNECTED_TO_sdram_mm_address,       --   sdram_mm.address
			sdram_mm_byteenable_n  => CONNECTED_TO_sdram_mm_byteenable_n,  --           .byteenable_n
			sdram_mm_chipselect    => CONNECTED_TO_sdram_mm_chipselect,    --           .chipselect
			sdram_mm_writedata     => CONNECTED_TO_sdram_mm_writedata,     --           .writedata
			sdram_mm_read_n        => CONNECTED_TO_sdram_mm_read_n,        --           .read_n
			sdram_mm_write_n       => CONNECTED_TO_sdram_mm_write_n,       --           .write_n
			sdram_mm_readdata      => CONNECTED_TO_sdram_mm_readdata,      --           .readdata
			sdram_mm_readdatavalid => CONNECTED_TO_sdram_mm_readdatavalid, --           .readdatavalid
			sdram_mm_waitrequest   => CONNECTED_TO_sdram_mm_waitrequest,   --           .waitrequest
			sdram_wire_addr        => CONNECTED_TO_sdram_wire_addr,        -- sdram_wire.addr
			sdram_wire_ba          => CONNECTED_TO_sdram_wire_ba,          --           .ba
			sdram_wire_cas_n       => CONNECTED_TO_sdram_wire_cas_n,       --           .cas_n
			sdram_wire_cke         => CONNECTED_TO_sdram_wire_cke,         --           .cke
			sdram_wire_cs_n        => CONNECTED_TO_sdram_wire_cs_n,        --           .cs_n
			sdram_wire_dq          => CONNECTED_TO_sdram_wire_dq,          --           .dq
			sdram_wire_dqm         => CONNECTED_TO_sdram_wire_dqm,         --           .dqm
			sdram_wire_ras_n       => CONNECTED_TO_sdram_wire_ras_n,       --           .ras_n
			sdram_wire_we_n        => CONNECTED_TO_sdram_wire_we_n         --           .we_n
		);

