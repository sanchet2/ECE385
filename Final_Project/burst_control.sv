module burst_control(input Clk, VGA_Clk, Reset, wait_req, valid,
							input [24:0] address_in,
							input [31:0] data_from_mem,
							output write_out, read_out,
							output [3:0] byte_enable,
							output [24:0] address_out, address_test,
							output [31:0] data_to_sdram, data_to_fpga,
							output [7:0] red, green, blue,
							input [9:0] x_pos, y_pos,
							
							input blitter_read, blitter_write,
							input [31:0] data_from_blitter,
							input [24:0] address_from_blitter,
							output blitter_finished,
							output [31:0] data_to_blitter
							);
							
		logic master_ready, sdram_read, sdram_write;
		logic [31:0] data;
		logic [24:0] address, vga_address;
		
		assign vga_address = x_pos + (y_pos * 10'd640);
		
		assign address_test = address;
				
		assign red [7:0] = data[7:0];
		assign green [7:0] = data[15:8];
		assign blue [7:0] = data[23:16];
		
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(sdram_read), .write_req(sdram_write), .valid(valid), .wait_req(wait_req),
								  .address_in(address), .write_data(data_from_blitter), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(master_ready), .byte_enable(byte_enable), .address_out(address_out), 
								  .data_to_sdram(data_to_sdram), .data_to_fpga(data));		
		
		always_comb
		begin
				data_to_fpga = data;
				address = vga_address;
				sdram_read = 1'b0;
				sdram_write = 1'b0;
				data_to_blitter = data;
				blitter_finished = 1'b0;
		
				if(((x_pos >= 10'd640) || (y_pos >= 10'd480)))
				begin 
						address = address_from_blitter;
						blitter_finished = master_ready;
						if(x_pos < 10'd780 || y_pos < 10'd523)
						begin
							if(blitter_read == 1'b0)
							begin
								sdram_read = 1'b0;
								sdram_write = blitter_write;								
							end 
							else begin
								sdram_read = 1'b1;
							end 
						end
						else begin
								sdram_read = 1'b0;
								sdram_write = 1'b0;
						end 
				end 
				else begin 
						sdram_read = 1'b1;
						address = vga_address;
				end 
				
				
		end 
		
		
endmodule 