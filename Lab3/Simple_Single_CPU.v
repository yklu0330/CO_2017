// 0416025 0416081
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire [31:0] four;
wire [5-1:0] thirty_one;
wire [31:0] pc_o;
wire [31:0] Mux_PC_Source_o; 
wire [31:0] Adder1_o;
wire [31:0] Adder2_o;
wire [31:0] Instr_Memory_o;
wire [31:0] Read_Data_1;
wire [31:0] Read_Data_2;
wire [4:0] Reg_File_o;
wire [2:0] dec_ALUop;
wire dec_ALUSrc;
wire dec_branch;
wire dec_RegWrite;
wire [1:0] dec_RegDst;
wire [1:0] dec_MemToReg; 
wire [1:0] dec_BranchType;
wire [1:0] dec_Jump; 
wire dec_MemRead; 
wire dec_MemWrite;
wire [3:0] ALU_Ctrl_o;
wire [31:0] Sign_Extend_o;
wire [31:0] Mux_ALUSrc_o;
wire ALU_zero;
wire [31:0] ALU_result;
wire [31:0] Shifter_o;
wire  pc_source_mux;

wire [27:0] Jump_Shift_Two_o;
wire ALU_zero_inverted;
wire MUX_Branch_Type_o;
wire [31:0] Mux_Jump_or_Branch_o;
wire [31:0] DataMemory_o;
wire [31:0] Mux_RegWrite_Src_o;
wire MUX_Branch_data_1;
wire MUX_Branch_data_2;

assign four = 32'd4;
assign thirty_one = 5'd31;
assign pc_source_mux = MUX_Branch_Type_o & dec_branch;
assign ALU_zero_inverted = ~ALU_zero;
assign MUX_Branch_data_1 = ALU_result[31] | ALU_zero;
assign MUX_Branch_data_2 = ALU_result[31];

//Greate componentes
ProgramCounter PC(
            .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(Mux_Jump_or_Branch_o) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
            .src1_i(four),     
	    .src2_i(pc_o),     
	    .sum_o(Adder1_o)    
	    );
	
Instr_Memory IM(
            .addr_i(pc_o),  
	    .instr_o(Instr_Memory_o)    
	    );

Shift_Left_Two #(.size(28)) Jump_Shift_Two(
        .data_i({2'b0, Instr_Memory_o[25:0]}),
        .data_o(Jump_Shift_Two_o)
        );  

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(Instr_Memory_o[20:16]),
        .data1_i(Instr_Memory_o[15:11]),
        .data2_i(thirty_one),
        .select_i(dec_RegDst),
        .data_o(Reg_File_o)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(Instr_Memory_o[25:21]) ,  
        .RTaddr_i(Instr_Memory_o[20:16]) ,  
        .RDaddr_i(Reg_File_o) ,  
        .RDdata_i(Mux_RegWrite_Src_o), 
        .RegWrite_i (dec_RegWrite),
        .RSdata_o(Read_Data_1) ,  
        .RTdata_o(Read_Data_2)   
        );
	
Decoder Decoder(
        .instr_op_i(Instr_Memory_o[31:26]), 
        .instr_func_i(Instr_Memory_o[5:0]), 
        .RegWrite_o(dec_RegWrite), 
        .ALU_op_o(dec_ALUop),   
        .ALUSrc_o(dec_ALUSrc),   
        .RegDst_o(dec_RegDst),   
        .Branch_o(dec_branch),
        .MemToReg_o(dec_MemToReg), 
        .BranchType_o(dec_BranchType),
        .Jump_o(dec_Jump), 
        .MemRead_o(dec_MemRead), 
        .MemWrite_o(dec_MemWrite)
        );

Adder Adder2(
        .src1_i(Adder1_o),     
        .src2_i(Shifter_o),     
        .sum_o(Adder2_o)      
        );
        
Shift_Left_Two #(.size(32)) Shifter(
        .data_i(Sign_Extend_o),
        .data_o(Shifter_o)
        );

ALU_Ctrl AC(
        .funct_i(Instr_Memory_o[5:0]),   
        .ALUOp_Ｉi(dec_ALUop),   
        .ALUCtrl_o(ALU_Ctrl_o) 
        );
	
Sign_Extend SE(
        .data_i(Instr_Memory_o[15:0]),
        .data_o(Sign_Extend_o)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(Read_Data_2),
        .data1_i(Sign_Extend_o),
        .select_i(dec_ALUSrc),
        .data_o(Mux_ALUSrc_o)
        );	
		
ALU ALU(
        .src1_i(Read_Data_1),
        .src2_i(Mux_ALUSrc_o),
        .ctrl_i(ALU_Ctrl_o),
        .shamt_i(Instr_Memory_o[10:6]),        
        .result_o(ALU_result),
        .zero_o(ALU_zero)
        );

MUX_4to1 #(.size(1)) MUX_Branch_Type(
       .data0_i(ALU_zero),
       .data1_i(MUX_Branch_data_1),
       .data2_i(MUX_Branch_data_2),
       .data3_i(ALU_zero_inverted),
       .select_i(dec_BranchType),
       .data_o(MUX_Branch_Type_o)
       );

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(Adder1_o),
        .data1_i(Adder2_o),
        .select_i(pc_source_mux),
        .data_o(Mux_PC_Source_o)
        );  

MUX_3to1 #(.size(32)) Mux_Jump_or_Branch(
        .data0_i({Adder1_o[31:28],Jump_Shift_Two_o}),
        .data1_i(Mux_PC_Source_o),
        .data2_i(Read_Data_1),
        .select_i(dec_Jump),
        .data_o(Mux_Jump_or_Branch_o)
        );  

Data_Memory Data_Memory (
        .clk_i(clk_i),
        .addr_i(ALU_result),
        .data_i(Read_Data_2),
        .MemRead_i(dec_MemRead),
        .MemWrite_i(dec_MemWrite),
        .data_o(DataMemory_o)
        );  

MUX_4to1 #(.size(32)) Mux_RegWrite_Src(
        .data0_i(ALU_result),
        .data1_i(DataMemory_o),
        .data2_i(Sign_Extend_o),
		.data3_i(Adder1_o),
        .select_i(dec_MemToReg),
        .data_o(Mux_RegWrite_Src_o)
        );  

		 		
		

endmodule
		  


