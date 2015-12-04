module communicator(input Clk, Reset, sprite_incoming, acknowledge_finished_sprite, blitter_finished,
							input [1:0] sprite_num,
							output sprite_received, sprite_finished, blitter_start,
							output [25:0] sprite_address,
							output [9:0] x_size, y_size
							);
							
							
			sprite_table table1(.Clk(Clk), .in(sprite_num), .out({sprite_address, x_size, y_size}));				
			
			enum logic [2:0] {WAIT, READ_SPRITE, WRITE_SPRITE, FINISHED_SPRITE} state, next_state;
			
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
					sprite_received = 1'b0;
					sprite_finished = 1'b0;
					blitter_start = 1'b0;
					
					unique case(state)
					WAIT: begin
							if(sprite_incoming)
							begin
									next_state = READ_SPRITE;
							end 
							else begin
									next_state = WAIT;
							end 
					end 
					READ_SPRITE: begin
							blitter_start = 1'b1;
							sprite_received=1'b1;
							if(sprite_incoming == 1'b0)
								next_state= WRITE_SPRITE;
							else
								next_state = READ_SPRITE;
					end 
					WRITE_SPRITE:begin
							if(blitter_finished)
								next_state=FINISHED_SPRITE;
							else	
								begin	
								next_state=WRITE_SPRITE;
								end
					end
					FINISHED_SPRITE:begin
							sprite_finished=1'b1;
							if(acknowledge_finished_sprite)
								next_state=WAIT;
							else
								next_state = FINISHED_SPRITE;
					
					end
					endcase
			end 

endmodule 