module Data_Memory(clk,rst,wr_en,wr_data,adress,rd_data);

	input clk,rst,wr_en;
    input [31:0]wr_data,adress;
    output [31:0]rd_data;

    reg [31:0] data_mem[1023:0];

    always@(posedge clk)begin
		if(wr_en) data_mem[adress[31:2]] <= wr_data;
    end
	assign rd_data = (~rst) ? 32'h00000000: data_mem[adress[31:2]];

    initial begin
        data_mem[0] = 32'h00000000;
        //mem[40] = 32'h00000002;
    end
endmodule
