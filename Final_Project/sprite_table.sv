module sprite_table(input Clk,
							input [5:0] in,
							output [44:0] out);
							
always @ (posedge Clk)
	case(in)
	2'd0: out <= {25'd307200, 10'd64, 10'd48}; // Player sprites
	2'd1: out <= {25'd310272, 10'd60, 10'd64};
	
	2'd3: out <= {25'd320646, 10'd64, 10'd64}; // Enemy sprites //TODO: fix dimensions
	2'd4: out <= {25'd351834, 10'd64, 10'd64};
	2'd5: out <= {25'd357834, 10'd64, 10'd64};
	2'd6: out <= {25'd365952, 10'd64, 10'd64};
	2'd7: out <= {25'd373806, 10'd64, 10'd64};
	2'd8: out <= {25'd380176, 10'd64, 10'd64};
	2'd9: out <= {25'd386308, 10'd64, 10'd64};
	2'd10: out <= {25'd402200, 10'd64, 10'd64};
	2'd11: out <= {25'd408815, 10'd64, 10'd64};
	2'd12: out <= {25'd415490, 10'd64, 10'd64};

	endcase 
	
endmodule 