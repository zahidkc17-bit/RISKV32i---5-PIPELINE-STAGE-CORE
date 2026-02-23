module hazard_unit(rst,Rs1D,Rs2D,RdE,MemReadE,Stall);
	input  [4:0] Rs1D, Rs2D;  
    input  [4:0] RdE;         
    input  [1:0]MemReadE;
	input rst;     
    output Stall;  

    wire lwStall;
    
    assign lwStall = (MemReadE==2'b01) & ((RdE == Rs1D) | (RdE == Rs2D));
    assign Stall = (!rst)?1'b0: lwStall; 

endmodule
