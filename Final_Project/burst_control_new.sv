module burst_control_new(input Clk, VGA_Clk, Reset, wait_req, valid,
								 input [24:0] address_in,
								 input [31:0] data_from_mem,
								 output write_out, read_out,
								 output [3:0] byte_enable,
								 output [24:0] address_out, address_test,
								 output [31:0] data_to_sdram, data_to_fpga,
								 output [7:0] red, green, blue,
								 input [9:0] x_pos, y_pos,
								 
								 input blitter_read, blitter_write,
								 input [31:0] data_from_blitter,
								 input [24:0] address_from_blitter,
								 output blitter_finished,
								 output [31:0] data_to_blitter
								 );
							
		
		logic fifo_empty, fifo_full, fifo_read, fifo_write, sdram_read, sdram_write, sdram_ready;	
		logic [24:0] sdram_address, frame_address;
		logic [31:0] read_data, fifo_data, blitter_data;
		
		enum logic [2:0] {WAIT,FIFO_INPUT} state, next_state;
		enum logic [2:0] {VGA_READ,VGA_WAIT} v_state, v_next_state;
		
		assign red [7:0] = data_to_fpga[7:0];
		assign green [7:0] = data_to_fpga[15:8];
		assign blue [7:0] = data_to_fpga[23:16];
		
		FIFO fifo(.data(data_from_mem), .wrclk(Clk), .wrfull(fifo_full), .wrreq(fifo_write), .aclr(Reset), 
					 .wrusedw(num_words), .q(data_to_fpga), .rdreq(fifo_read), .rdclk(VGA_Clk), .rdempty(fifo_empty));
		
		
		
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						state   <= FIFO_INPUT;
						v_state <= VGA_WAIT;
						frame_address<=25'd640;
				end
				else
				begin	
						state <= next_state;
						v_state <= v_next_state;
						case (state)
							WAIT:begin
							if( x_pos == 25'b0 && y_pos== 25'd479)
								frame_address <= 25'd0;
							end
							FIFO_INPUT:begin
								if(sdram_ready)
								begin
									frame_address<=frame_address+1'b1;
								end
							end
						endcase
				end
		end 
		
		
		always_comb
		begin
			fifo_read   = 1'b0;
			fifo_write  = 1'b0;
			sdram_read  = 1'b0;
			sdram_write = 1'b0;
			sdram_address = 25'd0;
			unique case(state)
			WAIT: begin
			if( (x_pos == 1'b0))
				next_state = FIFO_INPUT;
			else
				next_state = WAIT;
			
			end
			FIFO_INPUT: begin
					sdram_read = 1'b1;
					sdram_address = frame_address;
					if(sdram_ready)
					begin
						fifo_write=1'b1;
						if(( frame_address+ 1'b1 )% 25'd640==1'b0)
							next_state=WAIT;
						else
							next_state=FIFO_INPUT;
					end
					else
						next_state=FIFO_INPUT;
				end
			endcase
			
			
			unique case(v_state)
			VGA_WAIT: begin
					if(y_pos == 10'b0 && x_pos == 10'd640)
						v_next_state = VGA_READ;
					else
						v_next_state = VGA_WAIT;
			end 
			VGA_READ: begin
					v_next_state = VGA_READ;
					if(y_pos < 10'd480 && x_pos < 10'd640)
							fifo_read = 1'b1;
					else
							fifo_read = 1'b0;
			end 
			endcase
			
			
		end
endmodule 