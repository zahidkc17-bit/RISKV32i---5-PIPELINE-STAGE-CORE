module decode_cycle(clk,rst,instr_d,pc_d,pcplus4_d,RegWrite_W,regwrite_m,rd_data_m,Result_W,wr_addr_W,regwrite_e,stall,memwrite_e,jump_e,branch_e,alusrc_e,resultsrc_e,aluop_e,rd_data1_e,rd_data2_e,immext_e,rd_addr1_e,rd_addr2_e,wr_addr_e,pc_e,pcPlus4_e,if_flush,pc_target,fun3e,func7e,op5e,op1src_e,ForwardAd,ForwardBd);
	input	clk, rst;
    input	[31:0] instr_d,pc_d,pcplus4_d;
	input	RegWrite_W,regwrite_m;
    input  	[4:0] wr_addr_W;   
    input  	[31:0] Result_W,rd_data_m;
	input 	[1:0] ForwardAd,ForwardBd;

	output regwrite_e,memwrite_e,jump_e,branch_e, alusrc_e,if_flush,func7e,op5e,stall;
    output [1:0]  resultsrc_e,aluop_e,op1src_e; 
    output [31:0] rd_data1_e, rd_data2_e,immext_e;
    output [4:0]  rd_addr1_e, rd_addr2_e, wr_addr_e;
    output [31:0] pc_e, pcPlus4_e,pc_target;
	output [2:0] fun3e;
	
	wire regwrite_d,memwrite_d,jump_d,branch_d,alusrc_d,zero_flag,neg_flag;
	wire [1:0]aluop_d,resultsrc_d,op1src_d;
	wire [31:0]rd_data1_d, rd_data2_d,immext_d,pc_target,branch_srcb,compare_srca,compare_srcb;
	wire [10:0]controll;
	wire [10:0]controllD;


	reg regwrite_d_r,memwrite_d_r,jump_d_r,branch_d_r, alusrc_d_r,func7_r,op5_r;
    reg [1:0]  resultsrc_d_r,aluop_d_r,op1src_d_r; 
    reg [31:0] rd_data1_d_r, rd_data2_d_r,immext_d_r;
    reg [4:0]  rd_addr1_d_r, rd_addr2_d_r, wr_addr_d_r;
    reg [31:0] pc_d_r, pcPlus4_d_r;
	reg [2:0] fun3_r;
	reg [10:0] controld;

	main_decoder decoder(.rst(rst),.opcode(instr_d[6:0]),.controll(controll));

	reg_file register(.clk(clk),.rst(rst),.wr_en(RegWrite_W),.rd_addr1(instr_d[19:15]),.rd_addr2(instr_d[24:20]),.wr_addr(wr_addr_W),.wr_data(Result_W),.rd_data1(rd_data1_d),.rd_data2(rd_data2_d));

	comparator comp(.a(compare_srca),.b(compare_srcb),.zero(zero_flag),.neg(neg_flag));

	pcadder branch_adder(.a(branch_srcb),.b(immext_d),.c(pc_target));

	imm_generator immediate(.instr(instr_d),.immext(immext_d));
	hazard_unit hazard(.rst(rst),.Rs1D(instr_d[19:15]),.Rs2D(instr_d[24:20]),.RdE(wr_addr_e),.MemReadE(resultsrc_e),.Stall(stall));

	stall_mux stall1(.a(11'b00000000000),.b(controll),.c(stall),.controllD(controllD));
	
	Mux_3_by_1 forward_dsrca(.a(rd_data1_d),.b(result_w),.c(rd_data_m),.s(ForwardAd),.d(compare_srca));

	Mux_3_by_1 forward_dsrcb(.a(rd_data2_d),.b(result_w),.c(rd_data_m),.s(ForwardBd),.d(compare_srcb));

	assign if_flush= (zero_flag & controllD[7])|(controllD[6]);
	assign branch_srcb = (controllD[6]&instr_d[6:0]==7'b1100111)? rd_data1_d : pc_d;
	assign controld = controllD;

	always @(posedge clk or negedge rst) begin
        if(rst == 1'b0) begin
            regwrite_d_r <= 1'b0;
            alusrc_d_r <= 1'b0;
            memwrite_d_r <= 1'b0;
            resultsrc_d_r <= 1'b0;
            branch_d_r <= 1'b0;
			jump_d_r <= 1'b0;
			op1src_d_r <= 2'b00;
            aluop_d_r <= 2'b00;
            rd_data1_d_r <= 32'h00000000; 
            rd_data2_d_r <= 32'h00000000; 
            immext_d_r <= 32'h00000000;
            wr_addr_d_r <= 5'h00;
            pc_d_r <= 32'h00000000; 
            pcPlus4_d_r <= 32'h00000000;
            rd_addr1_d_r <= 5'h00;
            rd_addr2_d_r <= 5'h00;
			func7_r<=1'b0;
			op5_r<=1'b0;
			fun3_r<=3'b000;
			//controllD <=11'b00000000000;
        end
        else begin
            regwrite_d_r <= controld[10];
            alusrc_d_r <= controld[9];
            memwrite_d_r <= controld[8];
            resultsrc_d_r <= controld[1:0];
            branch_d_r <= controld[7];
			jump_d_r <= controld[6];
            aluop_d_r <= controld[5:4];
			op1src_d_r <= controld[3:2];
            rd_data1_d_r <= rd_data1_d; 
            rd_data2_d_r <= rd_data2_d; 
            immext_d_r <= immext_d;
            wr_addr_d_r <= instr_d[11:7];
            pc_d_r <= pc_d; 
            pcPlus4_d_r <= pcplus4_d;
            rd_addr1_d_r <= instr_d[19:15];
            rd_addr2_d_r <= instr_d[24:20];
			func7_r<=instr_d[30];
			fun3_r<=instr_d[14:12];
			op5_r<=instr_d[5];
        end
    end

    // Output asssign statements
    assign regwrite_e = regwrite_d_r;
    assign alusrc_e = alusrc_d_r;
    assign memwrite_e = memwrite_d_r;
    assign resultsrc_e = resultsrc_d_r;
    assign branch_e = branch_d_r;
	assign jump_e = jump_d_r;
	assign op1src_e = op1src_d_r;
    assign aluop_e = aluop_d_r;
    assign rd_data1_e = rd_data1_d_r;
    assign rd_data2_e = rd_data2_d_r;
    assign immext_e = immext_d_r;
    assign wr_addr_e = wr_addr_d_r;
    assign pc_e = pc_d_r;
    assign pcPlus4_e = pcPlus4_d_r;
    assign rd_addr1_e = rd_addr1_d_r;
    assign rd_addr2_e = rd_addr2_d_r;
	assign func7e = func7_r;
	assign op5e= op5_r;
	assign fun3e= fun3_r;

endmodule
