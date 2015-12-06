module memory_manager(input 			VGA_Clk, Clk, Reset, read_req, write_req, read_data_valid, wait_req,
							 input [24:0] 	address_in,
						    input [31:0] 	write_data, data_from_mem,
						    output 			write_out, read_out,
						    output [3:0] 	byte_enable,
						    output [24:0] 	address_out,
						    output [31:0] 	data_to_sdram, data_out
							 
							 output [7:0] red, green, blue);
							 
		logic fifo_empty, fifo_full, fifo_read, fifo_write;	
		logic [24:0] frame_address;
		logic [31:0] fifo_data;
		logic [9:0] num_words, num_data_transferred;
		
		assign red [7:0] = fifo_data[7:0];
		assign green [7:0] = fifo_data[15:8];
		assign blue [7:0] = fifo_data[23:16];
		
		FIFO fifo(.data(data_from_mem), .wrclk(Clk), .wrfull(fifo_full), .wrreq(fifo_write), .aclr(Reset), 
					 .wrusedw(num_words), .q(fifo_data), .rdreq(fifo_read), .rdclk(VGA_Clk), .rdempty(fifo_empty));
endmodule
					 
					 