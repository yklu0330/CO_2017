`timescale 1ns/1ps
// 0416025 呂翊愷
// 0416081 趙賀笙
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2011 
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           cout;

wire real_a, real_b;
assign real_a = (A_invert)? ~src1: src1;
assign real_b = (B_invert)? ~src2: src2;

always@( * )
begin
	 case(operation)
			2'b00:
			begin
				  result <= real_a & real_b;
				  cout <= 0;
			end
			2'b01:
			begin
				  result <= real_a | real_b;
				  cout <= 0;
			end
			2'b10:
			begin
				  result <= real_a ^ real_b ^ cin;
				  cout <= (real_a & real_b) | (real_a & cin) | (real_b & cin);
			end
			2'b11:
			begin
				  result <= less;
				  cout <= (real_a & real_b) | (real_a & cin) | (real_b & cin);
			end
		endcase
end

endmodule