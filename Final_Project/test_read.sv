module test_read(input Clk, Reset, cont, complete,
					  output read_req, 
					  output [24:0] address);
					  
					  
		enum logic [1:0]{RESET, READ, INC, WAIT} state, next_state;
					  
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						address <= 25'b0;
						state <= RESET;
				end 
				else
				begin
						state <= next_state;
						case(state)
						RESET: address <= 25'b0;
						READ: begin
								
						end 
						INC: address <= address + 1'b1;
						WAIT: ;
						endcase
				end 
		end 
					  
		always_comb
		begin
				next_state = state;
				read_req = 1'b0;
				case(state)
				RESET: begin
						next_state = READ;
				end 
				READ: begin
						read_req = 1'b1;
						if(cont == 1'b0 && complete == 1'b1)
							next_state = INC;
				end 
				INC: begin
						next_state = WAIT;
						end 
				WAIT: begin
						read_req = 1'b1;
						if(cont == 1'b1)
							next_state = READ;
						else
							next_state = WAIT;
				end 
				endcase
		end 
		
endmodule 