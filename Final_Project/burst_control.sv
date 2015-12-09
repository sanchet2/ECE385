module burst_control(input Clk, VGA_Clk, Reset, wait_req, valid,
							input [24:0] address_in,
							input [31:0] data_from_mem,
							output write_out, read_out,
							output [3:0] byte_enable,
							output [24:0] address_out,
							output [31:0] data_to_sdram,
							output [7:0] red, green, blue,
							input [9:0] x_pos, y_pos,
							
							input blitter_read, blitter_write,
							input [31:0] data_from_blitter,
							input [24:0] address_from_blitter,
							output blitter_finished, blitter_valid,
							output [31:0] data_to_blitter
							);
							
		
		logic fifo_empty, fifo_full, fifo_read, fifo_write, sdram_read, sdram_write, sdram_ready,
				burst_req, burst_finished;	
		logic [24:0] sdram_address, frame_address;
		logic [31:0] read_data, fifo_data, blitter_data;
		logic [9:0] num_words;
		
		
		enum logic [2:0] {FIFO_INPUT, WAIT, BLITTER_READ, BLITTER_WRITE} state, next_state;
		enum logic [2:0] {VGA_READ,VGA_WAIT} v_state, v_next_state;
		
		assign red [7:0] = fifo_data[7:0];
		assign green [7:0] = fifo_data[15:8];
		assign blue [7:0] = fifo_data[23:16];
		
		FIFO fifo(.data(read_data), .wrclk(Clk), .wrfull(fifo_full), .wrreq(fifo_write), .aclr(Reset), 
					 .q(fifo_data), .rdreq(fifo_read), .rdclk(VGA_Clk), .rdempty(fifo_empty), .wrusedw(num_words));
		
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(sdram_read), .write_req(sdram_write), .valid(valid), .wait_req(wait_req),
								  .address_in(sdram_address), .write_data(data_from_blitter), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(sdram_ready), .byte_enable(byte_enable), .address_out(address_out), .blitter_read(blitter_read),
								  .data_to_sdram(data_to_sdram), .data_out(read_data), .burst_req(burst_req), .burst_finished(burst_finished));
		
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						state   <= FIFO_INPUT;
						v_state <= VGA_WAIT;
						frame_address<=25'd218;
				end
				else
				begin	
						state <= next_state;
						v_state <= v_next_state;
						unique case (state)
							WAIT:begin
							if( x_pos >= 25'b0 && y_pos >= 25'd479)
								frame_address <= 25'd218;
							end
							FIFO_INPUT:begin
								if(burst_finished == 1'b1)
								begin
									frame_address<=(frame_address+25'd640)%25'd307200;
								end
							end 
							BLITTER_READ: ;
							BLITTER_WRITE:;
						endcase
				end
		end 
		
		
		always_comb
		begin
			fifo_read   = 1'b0;
			fifo_write  = 1'b0;
			sdram_read  = 1'b0;
			sdram_write = 1'b0;
			burst_req = 1'b0;
			sdram_address = 25'd0;
			
			blitter_finished = 1'b0;
			blitter_valid = 1'b0;
			data_to_blitter = read_data;
			
			unique case(state)
			WAIT: begin
			if( (x_pos == 1'b0) && (y_pos < 10'd480))
				next_state = FIFO_INPUT;
			else if(y_pos >= 10'd480 && y_pos < 10'd524)
				begin
						if(blitter_read == 1'b1)
							next_state = BLITTER_READ;
						else if(blitter_write == 1'b1)
							next_state = BLITTER_WRITE;
						else	
							next_state = WAIT;
				end
			else 
					next_state = WAIT;
			end
			FIFO_INPUT: begin
					burst_req = 1'b1;
					sdram_address = frame_address;
					if(sdram_ready)
					begin
						fifo_write=1'b1;
						if(burst_finished)
							next_state=WAIT;
						else
							next_state=FIFO_INPUT;
					end
					else
						next_state=FIFO_INPUT;
				end
			BLITTER_READ: begin
					sdram_address = address_from_blitter;
					burst_req = 1'b1;
					blitter_valid = sdram_ready;
					if(burst_finished == 1'b1)
					begin
						blitter_finished = 1'b1;
						next_state = WAIT;
					end 
					else begin
						next_state = BLITTER_READ;
					end 
			end 
			BLITTER_WRITE: begin
					sdram_address = address_from_blitter;
					sdram_write = 1'b1;
					if(sdram_ready == 1'b1)
					begin
						blitter_valid = 1'b1;
						next_state = WAIT;
					end 
					else begin
						next_state = BLITTER_WRITE;
					end 
			end 
			endcase
			
			
			unique case(v_state)
			VGA_WAIT: begin
					if(y_pos == 10'd0 && x_pos == 10'd640)
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
				
		
		
		
		
		
		/*
		 logic master_ready, sdram_read, sdram_write;
		logic [31:0] data;
		logic [24:0] address, vga_address;
		
		assign vga_address = x_pos + (y_pos * 10'd640);
		
		assign address_test = address;
				
		assign red [7:0] = data[7:0];
		assign green [7:0] = data[15:8];
		assign blue [7:0] = data[23:16];
		
		sdram_master master(.Clk(Clk), .Reset(Reset), .read_req(sdram_read), .write_req(sdram_write), .valid(valid), .wait_req(wait_req),
								  .address_in(address), .write_data(data_from_blitter), .data_from_mem(data_from_mem), .write_out(write_out),
								  .read_out(read_out), .ready(master_ready), .byte_enable(byte_enable), .address_out(address_out), 
								  .data_to_sdram(data_to_sdram), .data_to_fpga(data));		
		
		always_comb
		begin
				data_to_fpga = data;
				address = vga_address;
				sdram_read = 1'b0;
				sdram_write = 1'b0;
				data_to_blitter = data;
				blitter_finished = 1'b0;
		
				if(((x_pos >= 10'd640) || (y_pos >= 10'd480)))
				begin 
						address = address_from_blitter;
						blitter_finished = master_ready;
						if(x_pos < 10'd780 || y_pos < 10'd523)
						begin
							if(blitter_read == 1'b0)
							begin
								sdram_read = 1'b0;
								sdram_write = blitter_write;								
							end 
							else begin
								sdram_read = 1'b1;
							end 
						end
						else begin
								sdram_read = 1'b0;
								sdram_write = 1'b0;
						end 
				end 
				else begin 
						sdram_read = 1'b1;
						address = vga_address;
				end 
				
				
		end 
		
		*/
endmodule 