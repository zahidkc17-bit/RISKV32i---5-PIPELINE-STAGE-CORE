module instructionmem(rst,pc,instrf);
	input [31:0]pc;
	input rst;
	output [31:0]instrf;
	reg [31:0]instr_mem[1023:0];
	
	assign instrf=(!rst)?32'h00000000:instr_mem[pc[31:2]];
	initial begin
    	$readmemh("intruction.hex",instr_mem);
  	end

endmodule
