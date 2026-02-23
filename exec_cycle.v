module execute_cycle(clk, rst, regwrite_e, alusrc_e, memwrite_e, resultsrc_e, branch_e, aluop_e,aluresult_f,rd_data1_e, rd_data2_e,immext_e,func7e,fun3e,op5e, wr_addr_e,pc_e,pcPlus4_e,regwrite_m,memwrite_m,resultsrc_m,wr_addr_m,pcPlus4_m,wr_data_m,aluresult_m,result_w, ForwardA_E, ForwardB_E,op1src_e);

    input clk, rst,regwrite_e,alusrc_e,memwrite_e,branch_e,func7e,op5e;
	input [1:0]op1src_e,resultsrc_e;
    input [1:0] aluop_e;
    input [31:0] rd_data1_e,rd_data2_e,immext_e,aluresult_f;
    input [4:0] wr_addr_e;
    input [31:0] pc_e,pcPlus4_e;
    input [31:0] result_w;
    input [1:0] ForwardA_E, ForwardB_E;
	input [2:0]fun3e;

    output regwrite_m,memwrite_m;
	output [1:0]resultsrc_m;
    output [4:0] wr_addr_m; 
    output [31:0] pcPlus4_m,wr_data_m,aluresult_m;

    wire [31:0] Src_A, Src_B_interim, Src_B,Src_A_interim;
    wire [31:0] ResultE;
	wire [3:0]alucon;

    // Declaration of Register
    reg regwrite_e_r, memwrite_e_r;
	reg [1:0] resultsrc_e_r;
    reg [4:0] wr_addr_e_r;
    reg [31:0] pcPlus4_e_r,wr_data_e_r,aluresult_e_r;
	
	Mux_3_by_1 forw_mux1(.a(rd_data1_e),.b(result_w),.c(aluresult_f),.s(ForwardA_E),.d(Src_A_interim));
	Mux_3_by_1 forw_mux2(.a(rd_data2_e),.b(result_w),.c(aluresult_f),.s(ForwardB_E),.d(Src_B_interim));
	Mux alu_src1(.a(Src_B_interim),.b(immext_e),.s(alusrc_e),.c(Src_B));
	Mux_3_by_1 alu_src2(.a(Src_A_interim),.b(pc_e),.c(32'h00000000),.s(op1src_e),.d(Src_A));
	aludecoder alu_contr(.fun7(func7e),.fun3(fun3e),.aluop(aluop_e),.op5(op5e),.alucontrol(alucon));
	alu alu_block(.a(Src_A),.b(Src_B),.result(ResultE),.alucontrol(alucon));

	always@(posedge clk or negedge rst)begin
		if(!rst)begin
			regwrite_e_r<=1'b0;
			memwrite_e_r<=1'b0;
			resultsrc_e_r<=2'b00;
			wr_addr_e_r<=5'b00000;
			pcPlus4_e_r<=32'h00000000;
			wr_data_e_r<=32'h00000000;
			aluresult_e_r<=32'h00000000;
		end
		else begin
			regwrite_e_r<=regwrite_e;
			memwrite_e_r<=memwrite_e;
			resultsrc_e_r<=resultsrc_e;
			wr_addr_e_r<=wr_addr_e;
			pcPlus4_e_r<=pcPlus4_e;
			wr_data_e_r<=Src_B_interim;
			aluresult_e_r<=ResultE;
		end	
	end
	assign regwrite_m=regwrite_e_r;
	assign memwrite_m=memwrite_e_r;
	assign resultsrc_m = resultsrc_e_r;
	assign wr_addr_m=wr_addr_e_r;
	assign pcPlus4_m= pcPlus4_e_r;
	assign wr_data_m=wr_data_e_r;
	assign aluresult_m= aluresult_e_r;
endmodule










	





