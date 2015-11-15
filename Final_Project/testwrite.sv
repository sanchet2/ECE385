module testwrite (input clk, reset, valid, waitsig, cont,
						output [31:0] dataout,
						input [31:0] datain,
						output r, w);
		
		enum logic [1:0] {start, write1, write2, read} state, next_state; 
		logic [31:0] data;
	
	assign dataout = data;
	
	always_comb
	begin
		case(state)
				start: begin
						if(cont == 1'b0)
							next_state = write1;
						else
							next_state = start;
						r = 1'b1;
						w = 1'b1;
						end 
				write1: begin
					r = 1'b1;
					w = 1'b0;
					next_state = write2;
				end 
				write2: begin
					 w = 1'b0;
					 r = 1'b1;
					 if(waitsig)
						next_state = write2;
					else
						next_state = read;
				end 
				read: begin
					w = 1'b1;
					r = 1'b0;
					if(valid == 1'b0 || waitsig == 1'b1)
						next_state = read;
					else
						next_state = start;
				end 
		endcase
	end
	
	always_ff @ (posedge clk or posedge reset)
	begin
			if(reset) begin
				state <= start;
				data <= 32'b0;
			end 
			else begin 
			state <= next_state;
			if(valid == 1'b1)
				data <= datain;
			end 
	end 
endmodule