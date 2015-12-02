module burst_test   (input Clk, VGA_Clk, Reset, wait_req, valid,
							input [24:0] address_in,
							input [31:0] data_from_mem,
							output write_out, read_out,
							output [3:0] byte_enable,
							output [24:0] address_out,
							output [31:0] data_to_sdram, data_to_fpga,
							output [8:0] counter
							);
/*							
							logic [31:0] data;
							logic fifo_read, fifo_write, rdempty, wrfull, master_ready;
									
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(sdram_read), .write_req(1'b0), .valid(valid), .wait_req(wait_req),
								  .address_in(counter), .write_data(32'b1), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(master_ready), .byte_enable(byte_enable), .address_out(address_out), 
								  .data_to_sdram(data_to_sdram), .data_to_fpga(data_to_fpga));
								  
		enum logic [2:0] {RESET, READ} state, next_state;
		
		assign red [3:0] = data[7:4];
		assign red [7:4] = data[3:0];
		assign green [3:0] = data[15:12];
		assign green [7:4] = data[11:8];
		assign blue [3:0] = data[23:20];
		assign blue [7:4] = data[19:16];
		
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						state <= RESET;
						counter <= 9'b0;
				end 
				else begin
						state <= next_state;
						unique case(state)
						RESET:
						READ: begin
								if(master_ready) begin
								data <= data_to_fpga;
								counter <= counter + 1'b1;
								end 
						end 
						endcase
				end 
		end 
		
		always_comb 
		begin
				fifo_write = 1'b0;
				unique case(state)
				RESET: begin
						next_state = READ;
				end 
				READ: begin
						fifo_write = 1'b1;
						next_state = READ;
				end 
				endcase
		end 
		
	*/	
endmodule