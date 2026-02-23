module forward_unit_e(rst,regwriteM,regwriteW,wr_addr_m,wr_addr_W,rd_addr1_e,rd_addr2_e,ForwardAE,ForwardBE);

    input rst,regwriteM,regwriteW;
    input [4:0] wr_addr_m,wr_addr_W,rd_addr1_e,rd_addr2_e;
    output [1:0] ForwardAE, ForwardBE;
    
    assign ForwardAE = (rst == 1'b0)?2'b00: 
                       ((regwriteM == 1'b1)&(wr_addr_m != 5'h00)&(wr_addr_m == rd_addr1_e))?2'b10:
                       ((regwriteW == 1'b1)&(wr_addr_W != 5'h00)&(wr_addr_W == rd_addr1_e))?2'b01:2'b00;
                       
     assign ForwardBE = (rst == 1'b0)?2'b00: 
                       ((regwriteM == 1'b1)&(wr_addr_m != 5'h00)&(wr_addr_m == rd_addr2_e))?2'b10:
                       ((regwriteW == 1'b1)&(wr_addr_W != 5'h00)&(wr_addr_W == rd_addr2_e))?2'b01:2'b00;

endmodule

module forward_unit_b(rst,regwriteM,regwriteW,wr_addr_m,wr_addr_W,rd_addr1_d,rd_addr2_d,ForwardAd,ForwardBd);

    input rst,regwriteM,regwriteW;
    input [4:0] wr_addr_m,wr_addr_W,rd_addr1_d,rd_addr2_d;
    output [1:0] ForwardAd, ForwardBd;
    
    assign ForwardAd = (rst == 1'b0)?2'b00: 
                       ((regwriteM == 1'b1)&(wr_addr_m != 5'h00)&(wr_addr_m == rd_addr1_d))?2'b10:
                       ((regwriteW == 1'b1)&(wr_addr_W != 5'h00)&(wr_addr_W == rd_addr1_d))?2'b01:2'b00;
                       
     assign ForwardBd = (rst == 1'b0)?2'b00: 
                       ((regwriteM == 1'b1)&(wr_addr_m != 5'h00)&(wr_addr_m == rd_addr2_d))?2'b10:
                       ((regwriteW == 1'b1)&(wr_addr_W != 5'h00)&(wr_addr_W == rd_addr2_d))?2'b01:2'b00;

endmodule
