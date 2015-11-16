module frame_reader(input Clk, Reset, ready,
						  input [31:0] data_in,
						  input [9:0] x_pos, y_pos,
						  output read_req,
						  output [24:0] address,
						  output [7:0] red, green, blue);
			
		enum logic [1:0] {RESET, READ, INC, WAIT} state, next_state;
			
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						state <= RESET;
						address <= 25'b0;
				end 
				else begin
						state <= next_state;
						unique case(state)
						RESET:
						READ: begin
								
						end 
						INC:begin
								if(address == 25'd307199)
									address <= 25'b0;
								else
									address <= address + 1'b1;
						end 
						WAIT: ;
						endcase
				end 
		end 

		always_comb 
		begin
				read_req = 1'b0;
				next_state = state;
				red = 8'b0;
				green = 8'd255;
				blue = 8'b0;
				unique case(state)
				RESET: begin
						if((x_pos < 10'd639) || x_pos == 10'd799 || (y_pos < 10'd479) || y_pos == 10'd524)
						begin
							next_state = READ;
							read_req = 1'b1;
						end
						else	
							next_state = WAIT;
				end 
				READ: begin
						read_req = 1'b1;
						red [3:0] = data_in[7:4];
						red [7:4] = data_in[3:0];
						green [3:0] = data_in[15:12];
						green [7:4] = data_in[11:8];
						blue [3:0] = data_in[23:20];
						blue [7:4] = data_in[19:16];
						if(ready)
							next_state = INC;
						else
							next_state = READ;
				end 
				INC: begin
						red [3:0] = data_in[7:4];
						red [7:4] = data_in[3:0];
						green [3:0] = data_in[15:12];
						green [7:4] = data_in[11:8];
						blue [3:0] = data_in[23:20];
						blue [7:4] = data_in[19:16];
						if((x_pos < 10'd639) || x_pos == 10'd799 || (y_pos < 10'd479) || y_pos == 10'd524)
						begin
							next_state = READ;
							read_req = 1'b1;
						end
						else
							next_state = WAIT;
				end 
				WAIT: begin
						if((x_pos < 10'd639) || x_pos == 10'd799 || (y_pos < 10'd479) || y_pos == 10'd524)
						begin
							next_state = READ;
							read_req = 1'b1;
						end
						else
							next_state = WAIT;
				end 
				endcase
		end 
			
endmodule
						  