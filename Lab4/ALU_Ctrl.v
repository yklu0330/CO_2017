// 0416025 0416081
//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always @(funct_i,ALUOp_i)
begin
  case (ALUOp_i)
    3'b001: ALUCtrl_o <= 4'b0010; //addi
    3'b010: ALUCtrl_o <= 4'b0111; //sltiu
    3'b011: ALUCtrl_o <= 4'b0110; //beq
    3'b100: ALUCtrl_o <= 4'b1000; //lui
    3'b101: ALUCtrl_o <= 4'b0001; //ori
    3'b110: ALUCtrl_o <= 4'b0110; //ble, bltz
    3'b111: ALUCtrl_o <= 4'b1010; //bne
    3'b000:
    begin
      case (funct_i)
        6'd32: ALUCtrl_o <= 4'b0010; //add
        6'd34: ALUCtrl_o <= 4'b0110; //sub
        6'd36: ALUCtrl_o <= 4'b0000; //and
        6'd37: ALUCtrl_o <= 4'b0001; //or
        6'd42: ALUCtrl_o <= 4'b0111; //slt
        6'd3: ALUCtrl_o <= 4'b1001; //sra
        6'd7: ALUCtrl_o <= 4'b1011; //srav
        6'd24: ALUCtrl_o <= 4'b1111; //mul
      endcase
    end
  endcase
end

endmodule     





                    
                    