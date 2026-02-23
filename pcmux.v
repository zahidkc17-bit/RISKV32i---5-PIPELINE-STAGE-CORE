module pcmux(pcPlus4,targetaddr,pcsrc,pcnext);
	input [31:0]pcPlus4;
	input [31:0]targetaddr;
	input pcsrc;
	output [31:0]pcnext;

	assign pcnext = (pcsrc==1'b0)?pcPlus4:targetaddr; 
	
endmodule

