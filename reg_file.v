module reg_file(clk,rst,wr_en,rd_addr1,rd_addr2,wr_addr,wr_data,rd_data1,rd_data2);
	input clk,rst;
	input wr_en;
	input [4:0]rd_addr1,rd_addr2,wr_addr;
	input [31:0]wr_data;
	output reg [31:0]rd_data1,rd_data2;

	reg [31:0] reg_file[31:0];

	assign rd_data1=(!rst)?32'h00000000 :
					(rd_addr1==5'b00000)? 32'h00000000:
					(wr_en==1'b1 && wr_addr==rd_addr1)? wr_data : reg_file[rd_addr1];
	assign rd_data2=(!rst)?32'h00000000 :
					(rd_addr2==5'b00000)? 32'h00000000:
					(wr_en==1'b1 && wr_addr==rd_addr2)? wr_data : reg_file[rd_addr2];

	always@(posedge clk)begin
		if(wr_en==1'b1)begin
			if(wr_addr==5'b00000) reg_file[wr_addr]<=32'h00000000;
			else reg_file[wr_addr]<=wr_data;
		end
	end
	
endmodule
