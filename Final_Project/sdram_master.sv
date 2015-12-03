module sdram_master(input 				Clk, Reset, read_req, write_req, valid, wait_req,
						  input [24:0] 	address_in,
						  input [31:0] 	write_data, data_from_mem,
						  output 			write_out, read_out, ready,
						  output [3:0] 	byte_enable,
						  output [24:0] 	address_out,
						  output [31:0] 	data_to_sdram, data_to_fpga);
						  
		logic [31:0] data;
		logic [24:0] address;
		
		enum logic [4:0] {RESET, WAIT, READ, READ_LOOP, WRITE, WRITE_LOOP} state, next_state;
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset == 1'b1)
				begin
						data <= 32'b0;
						address <= 25'b0;
						state <= RESET;
				end 
				else begin
						state <= next_state;
						unique case(state)
						RESET: begin
								
						end 
						WAIT: begin
								address <= address_in;
						end 
						READ: begin
								data <= data_from_mem;
						end 
						READ_LOOP: begin
								data <= data_from_mem;
						end 
						WRITE: ;
						WRITE_LOOP: ;
						endcase
				end 
		end 
		
		always_comb 
		begin
				write_out = 1'b1;
				read_out = 1'b1;
				ready = 1'b0;
				byte_enable = 4'b0000;
				data_to_fpga = data_from_mem;
				data_to_sdram = write_data;
				address_out = address_in;
				next_state = state;
				
				unique case(state)
				RESET: begin
						next_state = WAIT;
				end 
				WAIT: begin
						if(read_req == 1'b1)
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
								next_state = READ_LOOP;
						end 
				end 
				READ_LOOP: begin
						read_out = 1'b0;
						if(valid == 1'b1 && wait_req == 1'b0)
						begin
								ready = 1'b1;
								next_state = WAIT;
						end 
						else begin
								next_state = READ_LOOP;
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
								next_state = WRITE_LOOP;
						end 
				end 
				WRITE_LOOP: begin
						write_out = 1'b0;
						if(wait_req == 1'b0)
						begin
								ready = 1'b1;
								next_state = WAIT;
						end 
						else begin
								next_state = WRITE_LOOP;
						end
				end 
				endcase
				
		end 
						  
						  
endmodule 