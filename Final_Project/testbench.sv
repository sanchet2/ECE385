 module testbench();
 
 timeunit 10ns;
 
 timeprecision 1ns;
 
logic   CLOCK_50;
logic [3:0] KEY;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

logic [12:0] DRAM_ADDR;			
logic [31:0] DRAM_DQ;			
logic [1:0] DRAM_BA;			
logic [3:0] DRAM_DQM;			
logic  DRAM_RAS_N;		
logic  DRAM_CAS_N;		
logic  DRAM_CKE;			
logic  DRAM_WE_N;			
logic  DRAM_CS_N;			
logic  DRAM_CLK;

logic sdram_cs, sdram_r, sdram_w; 
logic sdram_rvalid, sdram_wait;
logic [24:0] sdram_address;
logic [31:0] sdram_datain;
logic [31:0] sdram_dataout;
logic [3:0] sdram_byteen;

logic [31:0] a, b;

Final_Project test(.*);

always begin
	#1 CLOCK_50 = ~CLOCK_50;
end

initial begin
	CLOCK_50 = 0;
end

initial begin
KEY = 4'b0;
sdram_cs = 1'b1;
sdram_address = 25'b0;
sdram_datain = 32'b0;
sdram_byteen = 4'b1111;
sdram_r = 1'b1;
sdram_w = 1'b1;

#2 KEY[0] = 1'b1;

#2 sdram_datain = 32'hABCDEF00;

#2 sdram_w = 1'b0;

#100 sdram_w = 1'b1;

#2 sdram_r = 1'b0;

#100 sdram_r = 1'b1;

#2 sdram_address = sdram_address+1'b1;

#2 sdram_datain = 32'h00FEDCBA;

#2 sdram_w = 1'b0;

#100 sdram_w = 1'b1;

#2 sdram_r = 1'b0;

#100 sdram_r = 1'b1;
end
endmodule 