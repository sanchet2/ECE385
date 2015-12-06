module burst_read_test(input 				Clk, Reset, valid, wait_req,
						  input [31:0] 	data_from_mem,
						  output 			write_out, read_out,
						  output [3:0] 	byte_enable,
						  output [24:0] 	address_out,
						  output [31:0] 	data_to_sdram, data_to_fpga);
						  
		
		
		always_ff @ (posedge Clk or posedge Reset)
		begin
				if(Reset)
				begin
						data_to_fpga <= 32'b0;
						address_out <= 25'b0;
				end 
				else begin
						if(valid)
						begin
								data_to_fpga <= data_from_mem;
						end 
						if(wait_req == 1'b0)
						begin
								address_out <= (address_out + 1'b1)%25'd307200;
						end 
				end 
		end 
		
		always_comb 
		begin
				write_out = 1'b1;
				read_out = 1'b0;
				byte_enable = 4'b0000;
				data_to_sdram = 32'b0;;
		end 
						  
						  
endmodule 