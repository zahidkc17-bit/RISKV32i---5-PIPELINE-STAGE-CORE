module aludecoder(fun7,fun3,aluop,op5,alucontrol);
	input fun7,op5;
	input [2:0]fun3;
	input [1:0]aluop;
	output [3:0]alucontrol;

	assign alucontrol = (aluop == 2'b00) ? 4'b0010 :
                        (aluop == 2'b01) ? 4'b0110 :
                        ((aluop == 2'b10) & (fun3 == 3'b000) & ({op5,fun7} == 2'b11)) ? 4'b0110 : 
                        ((aluop == 2'b10) & (fun3 == 3'b000) & ({op5,fun7} != 2'b11)) ? 4'b0010 : 
                        ((aluop == 2'b10) & (fun3 == 3'b010)) ? 4'b0111 : 
                        ((aluop == 2'b10) & (fun3 == 3'b110)) ? 4'b0001 : 
                        ((aluop == 2'b10) & (fun3 == 3'b111)) ? 4'b0000 : 
                                                                  4'b0000 ;
	
endmodule
/*	0000 = AND
	0001 = OR
	0010 = ADD
	0110 = SUB
	0111 = SLT
				*/
