module fifo_test(input 	Clk, Reset, load, read_sig,
					  input 	[17:0] write_data,
					  output [31:0] read_data,
					  output [8:0] num_words,
					  output empty
					  );

				logic write, read, wrfull;

		FIFO fifio(.data(write_data), .aclr(Reset), .wrreq(write), .wrclk(Clk), .rdreq(read), 
					  .rdclk(Clk), .wrfull(wrfull), .q(read_data), .rdempty(empty), .wrusedw(num_words));

		enum logic [3:0] {WAIT, WRITE, READ, HOLD_READ, HOLD_WRITE} state, next_state;
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						state <= WAIT;
				end 
				else begin
						state <= next_state;
				end 
		end 
			
		always_comb 
		begin
				write = 1'b0;
				read = 1'b0;
				unique case(state)
				WAIT: begin
						if(load == 1'b0)
							next_state = WRITE;
						else if(read_sig == 1'b0)
							next_state = READ;
						else
							next_state = WAIT;
				end 
				WRITE: begin
						write = 1'b1;
						next_state = HOLD_WRITE;
				end 
				HOLD_WRITE: begin
						if(load == 1'b0)
							next_state = HOLD_WRITE;
						else
							next_state = WAIT;
				end 
				READ: begin
						read = 1'b1;
						next_state = HOLD_READ;
				end 
				HOLD_READ: begin
						if(read_sig == 1'b0)
							next_state = HOLD_READ;
						else
							next_state = WAIT;
				end
				endcase
		end 
			
endmodule 