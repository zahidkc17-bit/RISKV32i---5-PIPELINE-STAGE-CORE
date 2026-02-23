module alu(a,b,result,alucontrol);

    input [31:0]a,b;
    input [3:0]alucontrol;
    //output carry,zero,neg;
    output [31:0]result;

    wire Cout;
    wire [31:0]Sum;

    assign {Cout,Sum} = (alucontrol[2] == 1'b0) ? a + b :
                                          (a + ((~b)+1)) ;
    assign result = (alucontrol == 4'b0010) ? Sum :
                    (alucontrol == 4'b0110) ? Sum :
                    (alucontrol == 4'b0000) ? a & b :
                    (alucontrol == 4'b0001) ? a | b :
                    (alucontrol == 4'b0111) ? {{31{1'b0}},(Sum[31])} : {32{1'b0}};
    
    /*assign OverFlow = ((Sum[31] ^ a[31]) & 
                      (~(alucontrol[2] ^ b[31] ^ a[31])) &
                      (~alucontrol[1]));
    assign Carry = Cout;
    assign Zero = &(~Result);
  	assign Negative = Result[31];*/

endmodule
