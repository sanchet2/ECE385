module sdram_master(input 				Clk, Reset, read_req, write_req, valid, wait_req, burst_req,blitter_read,
						  input [24:0] 	address_in,
						  input [31:0] 	write_data, data_from_mem,
						  output 			write_out, read_out, ready, burst_finished,
						  output [3:0] 	byte_enable,
						  output [24:0] 	address_out,
						  output [31:0] 	data_to_sdram, data_out);
						  
		
		enum logic [2:0] {WAIT, READ, WRITE, BURST_READ, BURST_WAIT} state, next_state;
		
		logic [24:0] burst_address;
		logic [9:0] data_counter;
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset == 1'b1)
				begin
						state <= WAIT;
						burst_address <= 25'b0;
						data_counter <= 10'b0;
				end 
				else begin
						state <= next_state;
						unique case(state)
						WAIT: begin
								burst_address <= address_in;
								data_counter <= 9'b0;
						end 
						READ: ;
						WRITE: ;
						BURST_READ: begin
								if(wait_req == 1'b0)
									burst_address <= burst_address + 1'b1;
								if(valid == 1'b1)
									data_counter <= data_counter + 1'b1;
						end 
						BURST_WAIT: begin
								if(valid == 1'b1)
									data_counter <= data_counter + 1'b1;
						end 
						endcase
				end 
		end 
		
		always_comb 
		begin
				write_out = 1'b1;
				read_out = 1'b1;
				ready = 1'b0;
				burst_finished = 1'b0;
				byte_enable = 4'b0000;
				data_out = data_from_mem;
				data_to_sdram = write_data;
				address_out = address_in;
				next_state = state;
				
				unique case(state)
				WAIT: begin
						if(burst_req == 1'b1)
						begin
								next_state = BURST_READ;
						end	
						else if(read_req == 1'b1)
						begin
							next_state = READ;
						end
						else if(write_req == 1'b1)
							next_state = WRITE;
						else
							next_state = WAIT;
				end 
				READ: begin
						read_out = 1'b0;
						if(valid == 1'b1 && wait_req == 1'b0)
						begin
								ready = 1'b1;
								next_state = WAIT;
						end 
						else begin
								next_state = READ;
						end 
				end 
				WRITE: begin
						write_out = 1'b0;
						if(wait_req == 1'b0)
						begin
								ready = 1'b1;
								next_state = WAIT;
						end 
						else begin
								next_state = WRITE;
						end 
				end 
				BURST_READ: begin
						if(blitter_read)
							address_out=burst_address;
						else
							address_out = burst_address%25'd307200;
						read_out =1'b0;
						if(burst_address - address_in >= 25'd641)
						begin
								next_state = BURST_WAIT;
						end 
						else begin
								next_state = BURST_READ;
						end 
						if(valid) 
						begin
								ready = 1'b1;
						end 
				end 
				BURST_WAIT: begin
						if(valid == 1'b1)
						begin
								ready = 1'b1;
								if(data_counter == 10'd639)
								begin
										burst_finished = 1'b1;
										next_state = WAIT;
								end 
								else begin
										next_state = BURST_WAIT;
								end 
						end 
						else
							next_state = BURST_WAIT;
				end 
				endcase
				
		end 
						  
						  
endmodule 