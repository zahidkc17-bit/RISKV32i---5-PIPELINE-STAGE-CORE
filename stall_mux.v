module stall_mux(a,b,c,controllD);
	input [10:0]a,b;
	input c;
	output [10:0]controllD;

	assign controllD = c?a:b;
endmodule
