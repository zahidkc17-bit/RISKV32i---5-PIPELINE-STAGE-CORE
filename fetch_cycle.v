`timescale 1ns/1ns
module fetch_cycle(clk,rst,if_flush,stall,pc_target,instr_d,pc_d,pcplus4_d);
	input clk,rst,if_flush,stall;
	input [31:0]pc_target;
	output [31:0] instr_d,pc_d,pcplus4_d;
	wire [31:0]pcPlus4,pcf,pc,instr_f;

	reg [31:0]pc_reg;
	reg [31:0]instr_f_reg,pcPlus4_reg;

	pcmux mcmux(.pcPlus4(pcPlus4),.targetaddr(pc_target),.pcsrc(if_flush),.pcnext(pcf));

	pc pc_module(.clk(clk),.rst(rst),.stall(stall),.pcnext(pcf),.pc(pc));

	pcadder adder(.a(pc),.b(32'h00000004),.c(pcPlus4));

	instructionmem instmem(.rst(rst),.pc(pc),.instrf(instr_f));

	always @(posedge clk or negedge rst) begin
        if(rst == 1'b0 ) begin
            instr_f_reg <= 32'h00000000;
            pc_reg <= 32'h00000000;
            pcPlus4_reg <= 32'h00000000;
        end
		else if(if_flush) begin
            instr_f_reg <= 32'h00000000;
            pc_reg <= 32'h00000000;
            pcPlus4_reg <= 32'h00000000;
        end

        else if(!stall) begin
            instr_f_reg <= instr_f;
            pc_reg <= pc;
            pcPlus4_reg <= pcPlus4;
        end
    end


    assign  instr_d = (rst == 1'b0) ? 32'h00000000 : instr_f_reg;
    assign  pc_d = (rst == 1'b0) ? 32'h00000000 : pc_reg;
    assign  pcplus4_d = (rst == 1'b0) ? 32'h00000000 :  pcPlus4_reg;
endmodule

