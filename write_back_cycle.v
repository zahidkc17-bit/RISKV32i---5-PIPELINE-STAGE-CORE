module writeback_cycle(clk,rst,resultsrc_w,pcPlus4_w,aluresult_w,rd_data_w,result_w,wr_addr_w,wr_addr_last,regwrite_w,regwrite_w_last);

	input clk, rst,regwrite_w;
	input [1:0]resultsrc_w;
	input [31:0] pcPlus4_w,aluresult_w,rd_data_w;
	input[4:0] wr_addr_w;

	output [31:0] result_w;
	output [4:0] wr_addr_last;
	output regwrite_w_last;
	Mux_3_by_1 result_mux(.a(aluresult_w),.b(rd_data_w),.c(pcPlus4_w),.s(resultsrc_w),.d(result_w));
	assign wr_addr_last=wr_addr_w;
	assign regwrite_w_last=regwrite_w;
endmodule
