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
   instr_func_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemToReg_o, 
	BranchType_o,
	Jump_o, 
	MemRead_o, 
	MemWrite_o
	);
     
//I/O ports
input [6-1:0] instr_op_i;
input [6-1:0] instr_func_i;
output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output [1:0]   RegDst_o;
output         Branch_o;
output [1:0]   Jump_o;
output         MemRead_o;
output         MemWrite_o;
output [1:0]   MemToReg_o;
output [1:0] BranchType_o;

 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg    [1:0]   RegDst_o;
reg            Branch_o;
reg    [1:0]   Jump_o;
reg            MemRead_o;
reg            MemWrite_o;
reg    [1:0]   MemToReg_o;
reg    [2-1:0] BranchType_o;

//Parameter


//Main function
always @(*)
begin
	case (instr_op_i)
		6'd0:    //add, sub, and, or, slt, sra, srav, mul
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			if(instr_func_i == 6'b001000)
			begin
				RegWrite_o <= 0;
				Jump_o <= 2'b10;
			end
			else
			begin
				RegWrite_o <= 1;				
				Jump_o <= 2'b01;
			end
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			ALU_op_o <= 3'b000;
			RegDst_o <= 1;
			Branch_o <= 0;
			ALUSrc_o <= 0;
		end
		6'd8:    //addi
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd9:    //sltiu
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b010;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd4:    //beq
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 0;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b011;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end

////////////////////////////////////////////////////////

		6'd15:    //lui
		begin
			/*MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;*/

			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd13:    //ori
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b101;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'd5:    //bne
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b11;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b111;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end
		6'd6:    //ble
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b01;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b110;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end
		6'd1:    //bltz
		begin
			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 0;
			BranchType_o <= 2'b10;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b110;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 1;
		end
		6'b100011:  //lw
		begin
			MemRead_o <= 1;
			MemWrite_o <= 0;
			Jump_o <= 1;
			MemToReg_o <= 1;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;
		end
		6'b101011:   //sw
		begin
			MemRead_o <= 0;
			MemWrite_o <= 1;
			Jump_o <= 1;
			MemToReg_o <= 1;
			BranchType_o <= 2'b0;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 1;
			RegDst_o <= 0;
			Branch_o <= 0;		
		end
		6'b000010:   //j
		begin

			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 0;
			MemToReg_o <= 0;
			BranchType_o <= 2'b0;

			RegWrite_o <= 0;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 0;
			Branch_o <= 0;			
		end
		6'b000011:   //jal
		begin

			MemRead_o <= 0;
			MemWrite_o <= 0;
			Jump_o <= 0;
			MemToReg_o <= 3;
			BranchType_o <= 2'b0;

			RegWrite_o <= 1;
			ALU_op_o <= 3'b001;
			ALUSrc_o <= 0;
			RegDst_o <= 2;
			Branch_o <= 0;			
		end
endcase
end

endmodule





                    
                    