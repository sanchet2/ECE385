module sdram_master_test   (input 				Clk, Reset, wait_req, valid, read,
								    input [31:0] 		data_from_mem,
								    output 				write_out, read_out, waiting, ready,
								    output [3:0] 		byte_enable,
								    output [24:0] 	address_out, current_address,
								    output [31:0] 	data_to_sdram, data                    
								    );
									 
		logic read_sig;
									 
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(read_sig), .write_req(1'b0), .valid(valid), .wait_req(wait_req),
								  .address_in(current_address), .write_data(32'b1), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(ready), .byte_enable(byte_enable), .address_out(address_out), 
								  .data_to_sdram(data_to_sdram), .data_to_fpga(data));
								  
		enum logic [2:0] {WAIT, READ, INC, HOLD} state, next_state;
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						current_address <= 25'b0;
						state <= WAIT;
				end 
				else begin
						state <= next_state;
						unique case(state)
						WAIT:
						READ: begin
								
						end 
						INC: begin
								current_address <= current_address + 1'b1;
						end 
						HOLD: ;
						endcase
				end 
		end 
		
		always_comb 
		begin
				read_sig = 1'b0;
				waiting = 1'b0;
				unique case(state)
				WAIT: begin
						waiting = 1'b1;
						if(read == 1'b0)
							next_state = READ;
						else
							next_state = WAIT;
				end 
				READ: begin
						read_sig = 1'b1;
						if(ready)
							next_state = INC;
						else 
							next_state = READ;
				end 
				INC: next_state = HOLD;
				HOLD: begin
						if(read == 1'b1)
							next_state = WAIT;
						else
							next_state = HOLD;
				end 
				endcase
		end 
		
endmodule 