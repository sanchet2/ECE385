module frame_control(input [9:0] x_pos, y_pos,
						  output read_ok);
	
			always_comb
			begin
					if((x_pos >= 10'd640) || (y_pos >= 10'd480))
						read_ok = 1'b0;
					else
						read_ok = 1'b1;
			end 
			
endmodule
						  