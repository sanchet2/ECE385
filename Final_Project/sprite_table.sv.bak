module sprite_table(input Clk,
							input [1:0] in,
							output [44:0] out);
							
always @ (posedge Clk)
	case(in)
	2'd0: out <= {25'd307200, 10'd640, 10'd480};
	2'd1: out <= {25'd614400, 10'd64, 10'd64};
	2'd2: out <= {25'd618496, 10'd64, 10'd64};
	endcase 
	
endmodule 