module memory_cycle(clk, rst,regwrite_m,memwrite_m,resultsrc_m,aluresult_f,wr_addr_m,pcPlus4_m,wr_data_m,aluresult_m,regwrite_w,rd_data_md,resultsrc_w,wr_addr_w,pcPlus4_w,aluresult_w,rd_data_w);
    
    input clk,rst,regwrite_m,memwrite_m;
	input [1:0]resultsrc_m;
    input [4:0] wr_addr_m; 
    input [31:0] pcPlus4_m,wr_data_m,aluresult_m;

    output regwrite_w;
	output [1:0]resultsrc_w; 
    output [4:0] wr_addr_w;
    output [31:0] pcPlus4_w,aluresult_w,rd_data_w,aluresult_f,rd_data_md;

    wire [31:0] rd_data_m;

    reg regwrite_m_r;
	reg [1:0]resultsrc_m_r;
    reg [4:0] wr_addr_m_r;
    reg [31:0] pcPlus4_m_r,aluresult_m_r,rd_data_m_r;

    Data_Memory dataMemory(.clk(clk),.rst(rst),.wr_en(memwrite_m),.wr_data(wr_data_m),.adress(aluresult_m),.rd_data(rd_data_m));
	assign aluresult_f=aluresult_m;
	assign rd_data_md = rd_data_m;

    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            regwrite_m_r <= 1'b0; 
            resultsrc_m_r <= 2'b00;
            wr_addr_m_r <= 5'h00;
            pcPlus4_m_r <= 32'h00000000; 
            aluresult_m_r <= 32'h00000000; 
            rd_data_m_r <= 32'h00000000;
        end
        else begin
            regwrite_m_r <= regwrite_m; 
            resultsrc_m_r <= resultsrc_m;
            wr_addr_m_r <= wr_addr_m;
            pcPlus4_m_r <= pcPlus4_m; 
            aluresult_m_r <= aluresult_m; 
            rd_data_m_r <= rd_data_m;
        end
    end 

    assign regwrite_w = regwrite_m_r;
    assign resultsrc_w = resultsrc_m_r;
    assign wr_addr_w = wr_addr_m_r;
    assign pcPlus4_w = pcPlus4_m_r;
    assign aluresult_w = aluresult_m_r;
    assign rd_data_w = rd_data_m_r;

endmodule
