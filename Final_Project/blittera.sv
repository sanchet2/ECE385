module blittera(input Clk, Reset, new_sprite, valid, burst_finished, is_shadow,
					input [9:0] sprite_x_pos, sprite_y_pos,
					input [24:0] sprite_address,
					input [31:0] data_from_sdram,
					input [9:0] sprite_dimx, sprite_dimy,
					output wrote_sprite, read_req, write_req,
					output [31:0] data_out,
					output [24:0] address_to_sdram);
					
		enum logic [1:0] {WAIT, READ, INTER, WRITE} state, next_state;
		
		logic fifO_full, fifo_read, fifo_write, fifo_empty, fifo_reset;
		logic [18:0] counter;
		logic [9:0] x_dim, y_dim, num_words;
		logic [31:0] data,q;
		
		scfifo_blitter fifo(.clock(Clk), .data(data_from_sdram),.rdreq(fifo_read),.sclr(Reset || fifo_reset),.wrreq(fifo_write),
									.empty(fifo_empty),.full(fifO_full),.q(q),.usedw(num_words));
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						counter <= 19'b0;
						state <= WAIT;
						x_dim <= 10'b0;
						data <= 32'd0;
						y_dim <= 10'b0;
				end 
				else begin
						state <= next_state;
						unique case(state)
						WAIT: begin
								x_dim <= sprite_dimx;
								y_dim <= sprite_dimy;
								counter <= 19'd0;
						end 
						READ: begin
								
						end 
						INTER:begin
								data <= q;
						end
						WRITE: begin
								if(valid)
									counter <= (counter + 1'b1)%(x_dim*y_dim);
									
						end 
						endcase
				end 
		end 
		
		always_comb 
		begin
				wrote_sprite = 1'b0;
				read_req = 1'b0;
				write_req = 1'b0;
				data_out = data;
				address_to_sdram = 25'b0;
				fifo_read = 1'b0;
				fifo_write = 1'b0;
				fifo_reset = 1'b0;
				
				unique case(state)
				WAIT: begin
						if(new_sprite==1'b1)
						begin
							next_state=READ;
						end
						else
							next_state=WAIT;
				end 
				READ: begin
						read_req=1'b1;
						address_to_sdram=sprite_address+counter;
						if(valid)
						begin
							fifo_write=1'b1;
						end
						if(burst_finished==1'b1)
						begin
							next_state=INTER;
						end
						else
							next_state=READ;
				end	
				INTER:begin
					if(fifo_empty==1'b1)
						next_state=READ;
					else
					begin
						next_state=WRITE;
						fifo_read=1'b1;
					end
				end
				WRITE: begin
					write_req=1'b1;
					address_to_sdram=sprite_x_pos + counter%x_dim+((sprite_y_pos+counter/x_dim)*10'd640);
					if(valid)
					begin
						if(counter>=(x_dim*y_dim-1'b1))
						begin
							fifo_reset=1'b1;
							next_state=WAIT;
							wrote_sprite=1'b1;
						end
					else
						next_state=INTER;
					end
					else
						next_state=WRITE;
				end 
				endcase
			end	
endmodule 