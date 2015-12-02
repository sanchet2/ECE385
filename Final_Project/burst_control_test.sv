module burst_control_test(input Clk, VGA_Clk, Reset, VGA_read, wait_req, valid,
							input [24:0] address_in,
							input [31:0] data_from_mem,
							output write_out, read_out,
							output [3:0] byte_enable,
							output [24:0] address_out, address_test,
							output [31:0] data_to_sdram, data_to_fpga,
							output [7:0] red, green, blue,
							input [9:0] x_pos, y_pos);
							
		logic master_ready;
		logic [31:0] data;
		logic [24:0] address;
		
		assign address = x_pos + (y_pos * 10'd640);
		
		assign address_test = address;
				
		assign red [7:0] = data[7:0];
		assign green [7:0] = data[15:8];
		assign blue [7:0] = data[23:16];
		
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(VGA_read), .write_req(1'b0), .valid(valid), .wait_req(wait_req),
								  .address_in(address), .write_data(32'b1), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(master_ready), .byte_enable(byte_enable), .address_out(address_out), 
								  .data_to_sdram(data_to_sdram), .data_to_fpga(data));		
		
		
		
		
endmodule 