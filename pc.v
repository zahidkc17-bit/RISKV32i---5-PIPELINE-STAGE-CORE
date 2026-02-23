module pc(clk,rst,stall,pc,pcnext);
	input clk,rst,stall;
	input [31:0]pcnext;
	output reg [31:0]pc;

	always@(posedge clk)begin
	 	if(!rst) pc=32'h00000000;
	 	else begin
	 		 if(!stall) pc=pcnext;
		end
	end
endmodule

