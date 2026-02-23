module comparator(a,b,zero,neg);
	input [31:0]a,b;
	output zero,neg;

	wire [31:0]result;

	assign result = (a + ((~b)+1));

	assign zero = &(~result);
    assign neg = result[31];
	
endmodule
