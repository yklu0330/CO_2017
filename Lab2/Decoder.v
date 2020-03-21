// 0416025 0416081
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input [6-1:0] instr_op_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function
always @(*)
begin
	case (instr_op_i)
		6'd0:    //add, sub, and, or, slt, sra, srav
		begin
			RegWrite_o <= 1;
			ALU_op_o <= 3'b000;
			RegDst_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 0;
		end
		6'd8:    //addi
		begin
			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd9:    //sltiu
		begin
			RegWrite_o <= 1;
			ALU_op_o <= 3'b010;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd4:    //beq
		begin
			RegWrite_o <= 0;
			ALU_op_o <= 3'b011;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end
		6'd15:    //lui
		begin
			RegWrite_o <= 1;
			ALU_op_o <= 3'b100;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd13:    //ori
		begin
			RegWrite_o <= 1;
			ALU_op_o <= 3'b101;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd5:    //bne
		begin
			RegWrite_o <= 0;
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end
endcase
end

endmodule





                    
                    