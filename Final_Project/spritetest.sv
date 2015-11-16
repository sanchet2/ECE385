module spritetest( input [9:0] x_pos, y_pos,
						 input [31:0] data,
						 input Clk, Reset, ready, 
						 output [7:0] red, green, blue,
						 output [24:0] address,
						 output read_req );
	
		logic [13:0] a_counter;
		
		assign address = a_counter;
		
		enum logic [1:0] {RESET, READ, INC, WAIT} state, next_state;
		
		always_ff @ (posedge Clk)
		begin
				if(Reset) begin 
					a_counter <= 14'b0;
					state <= RESET;
					red <= 8'd255;
					green <= 8'd0;
					blue <= 8'd0;
				end 
				else
				state <= next_state;
				unique case(state)
				RESET: ;
				READ: ;
				INC: begin
					a_counter <= a_counter + 1'b1;
					red [3:0] <= data[7:4];
					red [7:4] <= data[3:0];
					green [3:0] <= data[15:12];
					green [7:4] <= data[11:8];
					blue [3:0] <= data[23:20];
					blue [7:4] <= data[19:16];
				end 
				WAIT: begin
						red <= 8'd255;
					green <= 8'd0;
					blue <= 8'd0;
				end
				endcase
		end 	
		
		always_comb begin
				read_req = 1'b0;
				unique case(state)
				RESET: begin
				if(x_pos <= 10'd127 && y_pos <= 10'd127)
					next_state = READ;
				else 
					next_state = WAIT;
				end
				READ: begin
					read_req = 1'b1;
					if(ready == 1'b1)
						next_state = INC;
					else
						next_state = READ;
				end 
				INC: begin
					
					if(x_pos <= 10'd127 && y_pos <= 10'd127)
						next_state = READ;
					else
						next_state = WAIT;
				end 
				WAIT:
					if(x_pos <= 10'd127 && y_pos <= 10'd127)
						next_state = READ;
					else
						next_state = WAIT;
				endcase
		end 
	
	
	
endmodule
	