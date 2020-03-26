// 0416025 0416081
//Subject:     CO project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
  	src2_i,
  	ctrl_i,
  	shamt_i,
  	result_o,
  	zero_o
	);
     
  //I/O ports
  input  [32-1:0]  src1_i;
  input  signed [32-1:0]	 src2_i;
  input  [4-1:0]   ctrl_i;
  input  [5-1:0]   shamt_i;

  output [32-1:0]	 result_o;
  output           zero_o;

  //Internal signals
  reg    [32-1:0]  result_o;
  wire             zero_o;
  wire [31:0] lui_o;
  //Parameter

  assign zero_o = (result_o == 0)? 1 : 0;
  assign lui_o = {src2_i[15:0], 16'b0000000000000000};

  //Main function
  always @(ctrl_i, src1_i, src2_i) begin
    case (ctrl_i)
      4'b0000:  result_o <= src1_i & src2_i; //and
      4'b0001:  result_o <= src1_i | src2_i; //or
      4'b0010:  result_o <= src1_i + src2_i; //add
      4'b0110:  result_o <= src1_i - src2_i; //sub
      4'b1100:  result_o <= ~(src1_i | src2_i); //nor
      4'b1101:  result_o <= ~(src1_i & src2_i); //nand
      4'b0111:  result_o <= src1_i < src2_i ? 1 : 0; //slt
      4'b1001:  result_o <= src2_i >>> shamt_i; //sra
      4'b1011:  result_o <= src2_i >>> src1_i; //srav
      4'b1000:  result_o <= {src2_i[15:0], 16'b0000000000000000}; //lui
      4'b0001:  result_o <= src1_i | src2_i; //ori
      4'b1010:  result_o <= src1_i - src2_i; //bne
      4'b1111:  result_o <= src1_i * src2_i; //mul
      default: result_o <= 0;
    endcase
  end

endmodule





                    
                    