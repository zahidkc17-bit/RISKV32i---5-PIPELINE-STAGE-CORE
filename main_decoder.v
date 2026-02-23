module main_decoder(rst,opcode,controll);
	input [6:0]opcode;
	input rst;
	output [10:0]controll;

	wire regwrite,alusrc,memwrite,branch,jump;
	wire [1:0]aluop,resultsrc,op1src;

	wire is_load    = (opcode == 7'b0000011); // LW
    wire is_store   = (opcode == 7'b0100011); // SW
    wire is_r_type  = (opcode == 7'b0110011); // ADD, SUB, etc.
    wire is_i_type  = (opcode == 7'b0010011); // ADDI, ANDI, etc.
    wire is_branch  = (opcode == 7'b1100011); // BEQ
	wire is_jal  = (opcode == 7'b1101111);
    wire is_jalr = (opcode == 7'b1100111);
	wire is_lui   = (opcode == 7'b0110111);
	wire is_auipc = (opcode == 7'b0010111);
	wire is_u_type = is_lui | is_auipc;

    assign memwrite  = is_store;
	assign resultsrc[1] = is_jal | is_jalr;
	assign resultsrc[0] = is_load;
    assign branch    = is_branch;
	assign jump = is_jal | is_jalr;
	assign regwrite = is_load | is_r_type | is_i_type | is_jal | is_jalr | is_u_type;
	assign alusrc   = is_load | is_store  | is_i_type | is_jalr | is_u_type;

    // 3. ALUOp: 10 for Math, 01 for Branch, 00 for Load/Store
    assign aluop[1] = is_r_type | is_i_type; 
    assign aluop[0] = is_branch;
	assign op1src[1] = is_lui;   // Force Input A to 0
	assign op1src[0] = is_auipc; // Force Input A to PC

	assign controll=(!rst)?11'b00000000000:{regwrite,alusrc,memwrite,branch,jump,aluop,op1src,resultsrc};
endmodule
