`timescale 1ns/1ps
// 0416025 呂翊愷
// 0416081 趙賀笙
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2010
// Design Name:
// Module Name:    alu
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

module alu(
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
     //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );


input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input   [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

// reg    [32-1:0] result;
// reg             zero;
// reg             cout;
// reg             overflow;

reg invertA;
reg invertB;
reg firstCin;
reg [1:0]oper;
wire carry[0:30]; 

assign zero = (result == 0)? 1 : 0;
assign overflow = ((cout == 0 && carry[30] == 1) || (cout == 1 && carry[30] == 0))? 1 : 0;


always @(*)
begin
	if(~rst_n)
	begin
		oper <= 2'b00;
		invertA <= 0;
		invertB <= 0;
		firstCin <= 0;
	end
	else
	begin 
		case(ALU_control)
			4'b0000:
			begin
					 oper <= 2'b00;
					 invertA <= 0;
					 invertB <= 0;
					 firstCin <= 0;
			end
			4'b0001:
			begin
					 oper <= 2'b01;
					 invertA <= 0;
					 invertB <= 0;
					 firstCin <= 0;
			end
			4'b0010:
			begin
					 oper <= 2'b10;
					 invertA <= 0;
					 invertB <= 0;
					 firstCin <= 0;
			end
			4'b0110:
			begin
					 oper <= 2'b10;
					 invertA <= 0;
					 invertB <= 1;
					 firstCin <= 1;
			end
			4'b1100:
			begin
					 oper <= 2'b00;
					 invertA <= 1;
					 invertB <= 1;
					 firstCin <= 0;
			end
			4'b1101:
			begin
					 oper <= 2'b01;
					 invertA <= 1;
					 invertB <= 1;
					 firstCin <= 0;
			end
			4'b0111:
			begin
					 oper <= 2'b11;
					 invertA <= 0;
					 invertB <= 1;
					 firstCin <= 1;
			end
		endcase 
	end
end 


alu_top alu_0(.src1(src1[0]),.src2(src2[0]),.less(cout),.A_invert(invertA),.B_invert(invertB),.cin(firstCin),.operation(oper),.result(result[0]),.cout(carry[0]));
alu_top alu_1(.src1(src1[1]),.src2(src2[1]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[0]),.operation(oper),.result(result[1]),.cout(carry[1]));
alu_top alu_2(.src1(src1[2]),.src2(src2[2]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[1]),.operation(oper),.result(result[2]),.cout(carry[2]));
alu_top alu_3(.src1(src1[3]),.src2(src2[3]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[2]),.operation(oper),.result(result[3]),.cout(carry[3]));
alu_top alu_4(.src1(src1[4]),.src2(src2[4]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[3]),.operation(oper),.result(result[4]),.cout(carry[4]));
alu_top alu_5(.src1(src1[5]),.src2(src2[5]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[4]),.operation(oper),.result(result[5]),.cout(carry[5]));
alu_top alu_6(.src1(src1[6]),.src2(src2[6]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[5]),.operation(oper),.result(result[6]),.cout(carry[6]));
alu_top alu_7(.src1(src1[7]),.src2(src2[7]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[6]),.operation(oper),.result(result[7]),.cout(carry[7]));
alu_top alu_8(.src1(src1[8]),.src2(src2[8]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[7]),.operation(oper),.result(result[8]),.cout(carry[8]));
alu_top alu_9(.src1(src1[9]),.src2(src2[9]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[8]),.operation(oper),.result(result[9]),.cout(carry[9]));
alu_top alu_10(.src1(src1[10]),.src2(src2[10]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[9]),.operation(oper),.result(result[10]),.cout(carry[10]));
alu_top alu_11(.src1(src1[11]),.src2(src2[11]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[10]),.operation(oper),.result(result[11]),.cout(carry[11]));
alu_top alu_12(.src1(src1[12]),.src2(src2[12]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[11]),.operation(oper),.result(result[12]),.cout(carry[12]));
alu_top alu_13(.src1(src1[13]),.src2(src2[13]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[12]),.operation(oper),.result(result[13]),.cout(carry[13]));
alu_top alu_14(.src1(src1[14]),.src2(src2[14]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[13]),.operation(oper),.result(result[14]),.cout(carry[14]));
alu_top alu_15(.src1(src1[15]),.src2(src2[15]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[14]),.operation(oper),.result(result[15]),.cout(carry[15]));
alu_top alu_16(.src1(src1[16]),.src2(src2[16]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[15]),.operation(oper),.result(result[16]),.cout(carry[16]));
alu_top alu_17(.src1(src1[17]),.src2(src2[17]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[16]),.operation(oper),.result(result[17]),.cout(carry[17]));
alu_top alu_18(.src1(src1[18]),.src2(src2[18]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[17]),.operation(oper),.result(result[18]),.cout(carry[18]));
alu_top alu_19(.src1(src1[19]),.src2(src2[19]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[18]),.operation(oper),.result(result[19]),.cout(carry[19]));
alu_top alu_20(.src1(src1[20]),.src2(src2[20]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[19]),.operation(oper),.result(result[20]),.cout(carry[20]));
alu_top alu_21(.src1(src1[21]),.src2(src2[21]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[20]),.operation(oper),.result(result[21]),.cout(carry[21]));
alu_top alu_22(.src1(src1[22]),.src2(src2[22]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[21]),.operation(oper),.result(result[22]),.cout(carry[22]));
alu_top alu_23(.src1(src1[23]),.src2(src2[23]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[22]),.operation(oper),.result(result[23]),.cout(carry[23]));
alu_top alu_24(.src1(src1[24]),.src2(src2[24]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[23]),.operation(oper),.result(result[24]),.cout(carry[24]));
alu_top alu_25(.src1(src1[25]),.src2(src2[25]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[24]),.operation(oper),.result(result[25]),.cout(carry[25]));
alu_top alu_26(.src1(src1[26]),.src2(src2[26]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[25]),.operation(oper),.result(result[26]),.cout(carry[26]));
alu_top alu_27(.src1(src1[27]),.src2(src2[27]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[26]),.operation(oper),.result(result[27]),.cout(carry[27]));
alu_top alu_28(.src1(src1[28]),.src2(src2[28]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[27]),.operation(oper),.result(result[28]),.cout(carry[28]));
alu_top alu_29(.src1(src1[29]),.src2(src2[29]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[28]),.operation(oper),.result(result[29]),.cout(carry[29]));
alu_top alu_30(.src1(src1[30]),.src2(src2[30]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[29]),.operation(oper),.result(result[30]),.cout(carry[30]));
alu_top alu_31(.src1(src1[31]),.src2(src2[31]),.less(0),.A_invert(invertA),.B_invert(invertB),.cin(carry[30]),.operation(oper),.result(result[31]),.cout(cout));

endmodule

