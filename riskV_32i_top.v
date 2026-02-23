`include "fetch_cycle.v"
`include "decode_cycle.v"
`include "exec_cycle.v"
`include "memory_cycle.v"
`include "write_back_cycle.v"    
`include "pc.v"
`include "pcadder.v"
`include "pcmux.v"
`include "Mux.v"
`include "instructionmem.v"
`include "reg_file.v"
`include "imm_generator.v"
`include "main_decoder.v"
`include "aludecoder.v"
`include "alu.v"
`include "comparator.v"
`include "stall_mux.v"
`include "hazard_unit.v"
`include "forward_unit.v"
`include "data_mem.v"
module riskV_32i_top(clk,rst);

    input clk, rst;

    wire if_flush,regwrite_w,regwrite_e,alusrc_e,memwrite_e,branch_e,regwrite_m,memwrite_m,func7e,op5e,jump_e,stall,regwrite_w_last;
	wire [1:0]resultsrc_e,resultsrc_m,resultsrc_w,aluop_e,op1src_e;
    wire [2:0] fun3e;
    wire [4:0] wr_addr_e, wr_addr_m,wr_addr_w,wr_addr_last;
    wire [31:0] pc_target,instr_d,pc_d,pcplus4_d,result_w, rd_data1_e, rd_data2_e,immext_e,pc_e,pcPlus4_e,pcPlus4_m,wr_data_m, aluresult_m,aluresult_f,rd_data_md;
    wire [31:0] pcPlus4_w,aluresult_w,rd_data_w;
    wire [4:0] rd_addr1_e, rd_addr2_e;
    wire [1:0] ForwardBE, ForwardAE,ForwardAd,ForwardBd;
    
    fetch_cycle Fetch	(
                        .clk(clk), 
                        .rst(rst), 
                        .if_flush(if_flush),
						.stall(stall),
                        .pc_target(pc_target), 
                        .instr_d(instr_d), 
                        .pc_d(pc_d), 
                        .pcplus4_d(pcplus4_d)
                    );

    decode_cycle decode(.clk(clk),.rst(rst),.instr_d(instr_d),.pc_d(pc_d),.pcplus4_d(pcplus4_d),.RegWrite_W(regwrite_w_last),.Result_W(result_w),.wr_addr_W(wr_addr_last),.regwrite_e(regwrite_e),.memwrite_e(memwrite_e),.jump_e(jump_e),.branch_e(branch_e),.alusrc_e(alusrc_e),.resultsrc_e(resultsrc_e),.aluop_e(aluop_e),.rd_data1_e(rd_data1_e),.rd_data2_e(rd_data2_e),.immext_e(immext_e),.rd_addr1_e(rd_addr1_e),.rd_addr2_e(rd_addr2_e),.wr_addr_e(wr_addr_e),.pc_e(pc_e),.pcPlus4_e(pcPlus4_e),.if_flush(if_flush),.pc_target(pc_target),.func7e(func7e),.fun3e(fun3e),.op5e(op5e),.stall(stall),.op1src_e(op1src_e),.ForwardAd(ForwardAd),.ForwardBd(ForwardBd),.regwrite_m(regwrite_m),.rd_data_m(rd_data_md));

	execute_cycle execute(.clk(clk), .rst(rst), .regwrite_e(regwrite_e), .alusrc_e(alusrc_e), .memwrite_e(memwrite_e), .resultsrc_e(resultsrc_e), .branch_e(branch_e), .aluop_e(aluop_e),.rd_data1_e(rd_data1_e), .rd_data2_e(rd_data2_e),.immext_e(immext_e),.func7e(func7e),.fun3e(fun3e),.op5e(op5e), .wr_addr_e(wr_addr_e),.pc_e(pc_e),.pcPlus4_e(pcPlus4_e),.regwrite_m(regwrite_m),.aluresult_f(aluresult_f),.memwrite_m(memwrite_m),.resultsrc_m(resultsrc_m),.wr_data_m(wr_data_m),.pcPlus4_m(pcPlus4_m),.wr_addr_m(wr_addr_m),.aluresult_m(aluresult_m),.result_w(result_w), .ForwardA_E(ForwardAE), .ForwardB_E(ForwardBE),.op1src_e(op1src_e));

    
	memory_cycle memory(.clk(clk),.rst(rst),.regwrite_m(regwrite_m),.memwrite_m(memwrite_m),.resultsrc_m(resultsrc_m),.wr_addr_m(wr_addr_m),.pcPlus4_m(pcPlus4_m),.wr_data_m(wr_data_m),.aluresult_m(aluresult_m),.regwrite_w(regwrite_w),.resultsrc_w(resultsrc_w),.wr_addr_w(wr_addr_w),.pcPlus4_w(pcPlus4_w),.aluresult_w(aluresult_w),.rd_data_w(rd_data_w),.aluresult_f(aluresult_f),.rd_data_md(rd_data_md));
  
     writeback_cycle writeback(.clk(clk),.rst(rst),.resultsrc_w(resultsrc_w),.pcPlus4_w(pcPlus4_w),.aluresult_w(aluresult_w),.rd_data_w(rd_data_w),.result_w(result_w),.wr_addr_w(wr_addr_w),.wr_addr_last(wr_addr_last),.regwrite_w(regwrite_w),.regwrite_w_last(regwrite_w_last));



  forward_unit_e forwarde(.rst(rst),.regwriteM(regwrite_m),.regwriteW(regwrite_w),.wr_addr_m(wr_addr_m),.wr_addr_W(wr_addr_last),.rd_addr1_e(rd_addr1_e),.rd_addr2_e(rd_addr2_e),.ForwardAE(ForwardAE),.ForwardBE(ForwardBE));

  forward_unit_b forwardeb(.rst(rst),.regwriteM(regwrite_m),.regwriteW(regwrite_w),.wr_addr_m(wr_addr_m),.wr_addr_W(wr_addr_last),.rd_addr1_d(instr_d[19:15]),.rd_addr2_d(instr_d[24:20]),.ForwardAd(ForwardAd),.ForwardBd(ForwardBd));

endmodule

/*module tb;
	reg	clk, rst;
	integer i,k;

	riskV_32i_top dut(.clk(clk),.rst(rst));	

	initial begin
		clk=0;
		forever #5 clk=~clk;
	end
	initial begin
		for(k=0;k<32;k=k+1) dut.decode.register.reg_file[k]=k;
	end

	initial begin
		rst=0;
		#15;
		rst=1;
		dut.decode.register.reg_file[5'b00000]=32'h00000000;
		forever begin
			repeat(5)@(posedge clk);
			$display("reg_file = %d",dut.decode.register.reg_file[1]);
		end
	end
	initial begin
		#1000;
		for(i=0;i<32;i=i+1) $display("reg_file == %p",dut.decode.register.reg_file[i]);
		$finish;
	end

endmodule*/
