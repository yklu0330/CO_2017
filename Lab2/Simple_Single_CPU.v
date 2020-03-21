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
wire dec_RegDst;
wire [3:0] ALU_Ctrl_o;
wire [31:0] Sign_Extend_o;
wire [31:0] Mux_ALUSrc_o;
wire ALU_zero;
wire [31:0] ALU_result;
wire [31:0] Shifter_o;
wire  pc_source_mux;


assign four = 32'd4;
assign pc_source_mux = ALU_zero & dec_branch;

//Greate componentes
ProgramCounter PC(
            .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(Mux_PC_Source_o) ,   
	    .pc_out_o(pc_o) 
	    );
	
Adder Adder1(
            .src1_i(four),     
	    .src2_i(pc_o),     
	    .sum_o(Adder1_o)    
	    );
	
Instr_Memory IM(
            .pc_addr_i(pc_o),  
	    .instr_o(Instr_Memory_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(Instr_Memory_o[20:16]),
        .data1_i(Instr_Memory_o[15:11]),
        .select_i(dec_RegDst),
        .data_o(Reg_File_o)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(Instr_Memory_o[25:21]) ,  
        .RTaddr_i(Instr_Memory_o[20:16]) ,  
        .RDaddr_i(Reg_File_o) ,  
        .RDdata_i(ALU_result), 
        .RegWrite_i (dec_RegWrite),
        .RSdata_o(Read_Data_1) ,  
        .RTdata_o(Read_Data_2)   
        );
	
Decoder Decoder(
        .instr_op_i(Instr_Memory_o[31:26]), 
        .RegWrite_o(dec_RegWrite), 
        .ALU_op_o(dec_ALUop),   
        .ALUSrc_o(dec_ALUSrc),   
        .RegDst_o(dec_RegDst),   
        .Branch_o(dec_branch)   
        );

ALU_Ctrl AC(
        .funct_i(Instr_Memory_o[5:0]),   
        .ALUOp_i(dec_ALUop),   
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
		
Adder Adder2(
        .src1_i(Adder1_o),     
        .src2_i(Shifter_o),     
        .sum_o(Adder2_o)      
        );
		
Shift_Left_Two_32 Shifter(
        .data_i(Sign_Extend_o),
        .data_o(Shifter_o)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(Adder1_o),
        .data1_i(Adder2_o),
        .select_i(pc_source_mux),
        .data_o(Mux_PC_Source_o)
        );	

endmodule
		  


