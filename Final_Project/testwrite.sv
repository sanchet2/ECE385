module testwrite (input clk, reset,
						output r, w);
		
		enum logic [1:0] {start, write1, write2, read} state, next_state; 
	
	always_comb
	begin
		case(state)
				start: begin
						next_state = write1;
						r = 1'b1;
						w = 1'b1;
						end 
				write1: begin
					 next_state = write2;
					 r = 1'b1;
					 w = 1'b0;
				end 
				write2: begin
					 next_state = read;
					 r = 1'b1;
					 w = 1'b0;
				end 
				read: begin
					 next_state = read;
					 r = 1'b0;
					 w = 1'b1;
				end 
		endcase
	end
	
	always_ff @ (posedge clk or posedge reset)
	begin
			if(reset)
				state <= start;
			else
			state <= next_state;
	end 
endmodule