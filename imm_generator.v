module imm_generator(instr,immext);
	input [31:0] instr;
	output [31:0]immext;

	wire i_type,s_type,b_type,j_type,u_type;

	assign j_type=instr[3];
	assign u_type=(instr[2] && !instr[6]); 
	assign b_type=(instr[6] && !instr[2]); 
	assign s_type=(instr[5] && !instr[6] && !instr[2] && !instr[4]);
	assign i_type=(!j_type && !u_type && !b_type && !s_type);

	assign immext[31:20]= (u_type)?instr[31:20]:{12{instr[31]}};
	assign immext[19:12]= (u_type || j_type)?instr[19:12]:{8{instr[31]}};
	assign immext[11] = (i_type || s_type)?instr[31]:(((u_type)?1'b0:((b_type)?instr[7]:instr[20])));
	assign immext[10:5]=(u_type)?6'b000000:instr[30:25];
	assign immext[4:0]= (i_type)?instr[24:20]:
						(j_type)?{instr[24:21],1'b0}:
						(u_type)?5'b00000:
						(b_type)?{instr[11:8],1'b0}:instr[11:7];
endmodule
