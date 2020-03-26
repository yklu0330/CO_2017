// 0416025 0416081
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
        clk_i,
		rst_i
		);
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
wire [31:0] four;
wire [5-1:0] thirty_one;
wire [31:0] pc_o;
wire [31:0] Mux_PC_Source_o; 
//wire [31:0] Adder1_o;
//wire [31:0] Adder2_o;
//wire [31:0] Instr_Memory_o;
//wire [31:0] Read_Data_1;
//wire [31:0] Read_Data_2;
//wire [4:0] Reg_File_o;
wire [2:0] dec_ALUop;
wire dec_ALUSrc;
wire dec_branch;
wire dec_RegWrite;
wire dec_RegDst;
wire dec_MemToReg; 
wire [1:0] dec_BranchType;
wire [1:0] dec_Jump; 
wire dec_MemRead; 
wire dec_MemWrite;
wire [3:0] ALU_Ctrl_o;
//wire [31:0] Sign_Extend_o;
wire [31:0] Mux_ALUSrc_o;
//wire ALU_zero;
//wire [31:0] ALU_result;
wire [31:0] Shifter_o;
wire  pc_source_mux;

/*wire [27:0] Jump_Shift_Two_o;
wire ALU_zero_inverted;
wire MUX_Branch_Type_o;
wire [31:0] Mux_Jump_or_Branch_o;
wire [31:0] DataMemory_o;
wire [31:0] Mux_RegWrite_Src_o;
wire MUX_Branch_data_1;
wire MUX_Branch_data_2;*/

wire [2:0] EX_MEM_M_out;
wire [1:0] EX_MEM_WB_out;

assign four = 32'd4;
assign thirty_one = 5'd31;
assign pc_source_mux = EX_MEM_ALUzero_out & EX_MEM_M_out[2];
/*assign ALU_zero_inverted = ~ALU_zero;
assign MUX_Branch_data_1 = ALU_result[31] | ALU_zero;
assign MUX_Branch_data_2 = ALU_result[31];*/


/**** IF stage ****/
wire [31:0] IF_ID_add_in;
wire [31:0] IF_ID_instr_in;
wire [31:0] IF_ID_add_out;
wire [31:0] IF_ID_instr_out;

/**** ID stage ****/

//control signal

/**** EX stage ****/

//control signal


/**** MEM stage ****/

//control signal


/**** WB stage ****/

//control signal


/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

wire [31:0] EX_MEM_add_in;
wire [31:0] EX_MEM_add_out;

MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(IF_ID_add_in),
        .data1_i(EX_MEM_add_out),
        .select_i(pc_source_mux),
        .data_o(Mux_PC_Source_o)
        );

ProgramCounter PC(
		.clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(Mux_PC_Source_o) ,   
	    .pc_out_o(pc_o) 
        );

Instr_Memory IM(
		.addr_i(pc_o),  
	    .instr_o(IF_ID_instr_in)  
	    );

Adder Add_pc(
		.src1_i(four),     
	    .src2_i(pc_o),     
	    .sum_o(IF_ID_add_in) 
		);

		
Pipe_Reg #(.size(32)) IF_ID_add(       //N is the total length of input/output
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(IF_ID_add_in),
		.data_o(IF_ID_add_out)
		);

Pipe_Reg #(.size(32)) IF_ID_instr(       //N is the total length of input/output
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(IF_ID_instr_in),
		.data_o(IF_ID_instr_out)
		);

//Instantiate the components in ID stage

wire [31:0] ID_EX_RF_data1_in;
wire [31:0] ID_EX_RF_data1_out;
wire [31:0] ID_EX_RF_data2_in;
wire [31:0] ID_EX_RF_data2_out;

wire [4:0] MEM_WB_Instr_out;

wire [31:0] Mux4_out;

wire [1:0] MEM_WB_WB_out;

Reg_File RF(
		.clk_i(clk_i),      
        .rst_i(rst_i) ,     
        .RSaddr_i(IF_ID_instr_out[25:21]) ,  
        .RTaddr_i(IF_ID_instr_out[20:16]) ,  
        .RDaddr_i(MEM_WB_Instr_out) ,  
        .RDdata_i(Mux4_out), 
        .RegWrite_i (MEM_WB_WB_out[1]),
        .RSdata_o(ID_EX_RF_data1_in) ,  
        .RTdata_o(ID_EX_RF_data2_in) 
		);

wire [1:0] ID_EX_WB_in;
wire [2:0] ID_EX_M_in;
wire [6:0] ID_EX_EX_in;

wire [1:0] ID_EX_WB_out;
wire [2:0] ID_EX_M_out;
wire [6:0] ID_EX_EX_out;

assign ID_EX_WB_in = {dec_RegWrite, dec_MemToReg};					//11
assign ID_EX_M_in = {dec_branch, dec_MemRead, dec_MemWrite};				//111
assign ID_EX_EX_in = {dec_RegDst, dec_BranchType, dec_ALUop, dec_ALUSrc};	//1231

Decoder Decoder(
        .instr_op_i(IF_ID_instr_out[31:26]), 
        .instr_func_i(IF_ID_instr_out[5:0]), 
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

wire [31:0] ID_EX_SE_in;
wire [31:0] ID_EX_SE_out;

Sign_Extend Sign_Extend(
		.data_i(IF_ID_instr_out[15:0]),
        .data_o(ID_EX_SE_in)
		);	

Pipe_Reg #(.size(2)) ID_EX_WB(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_WB_in),
		.data_o(ID_EX_WB_out)
		);

Pipe_Reg #(.size(3)) ID_EX_M(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_M_in),
		.data_o(ID_EX_M_out)
		);

Pipe_Reg #(.size(7)) ID_EX_EX(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_EX_in),
		.data_o(ID_EX_EX_out)
		);

wire [31:0] ID_EX_add_out;

Pipe_Reg #(.size(32)) ID_EX_add(       //N is the total length of input/output
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(IF_ID_add_out),
		.data_o(ID_EX_add_out)
		);
		
Pipe_Reg #(.size(32)) ID_EX_SE(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_SE_in),
		.data_o(ID_EX_SE_out)
		);

Pipe_Reg #(.size(32)) ID_EX_RF_data1(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_RF_data1_in),
		.data_o(ID_EX_RF_data1_out)
		);

Pipe_Reg #(.size(32)) ID_EX_RF_data2(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_RF_data2_in),
		.data_o(ID_EX_RF_data2_out)
		);

wire [14:0] ID_EX_Instr_out;

Pipe_Reg #(.size(15)) ID_EX_Instr(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(IF_ID_instr_out[20:6]),
		.data_o(ID_EX_Instr_out)
		);

//Instantiate the components in EX stage



Pipe_Reg #(.size(2)) EX_MEM_WB(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_WB_out),
		.data_o(EX_MEM_WB_out)
		);

Pipe_Reg #(.size(3)) EX_MEM_M(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_M_out),
		.data_o(EX_MEM_M_out)
		);

/*wire [31:0] EX_MEM_add_in;
wire [31:0] EX_MEM_add_out;*/

Adder Adder2(
        .src1_i(ID_EX_add_out),     
        .src2_i(Shifter_o),     
        .sum_o(EX_MEM_add_in)      
        );


Pipe_Reg #(.size(32)) EX_MEM_add(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_add_in),
		.data_o(EX_MEM_add_out)
		);
        
Shift_Left_Two #(.size(32)) Shifter(
        .data_i(ID_EX_SE_out),
        .data_o(Shifter_o)
        );

wire [31:0] EX_MEM_ALUrt_in;
wire [31:0] EX_MEM_ALUrt_out;
wire EX_MEM_ALUzero_in;
wire EX_MEM_ALUzero_out;

ALU ALU(
		.src1_i(ID_EX_RF_data1_out),
        .src2_i(Mux_ALUSrc_o),
        .ctrl_i(ALU_Ctrl_o),
        .shamt_i(ID_EX_Instr_out[4:0]),        
        .result_o(EX_MEM_ALUrt_in),
        .zero_o(EX_MEM_ALUzero_in)
		);

Pipe_Reg #(.size(32)) EX_MEM_ALUrt(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_ALUrt_in),
		.data_o(EX_MEM_ALUrt_out)
		);

Pipe_Reg #(.size(1)) EX_MEM_ALUzero(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_ALUzero_in),
		.data_o(EX_MEM_ALUzero_out)
		);

wire [31:0] EX_MEM_RD2_out;

Pipe_Reg #(.size(32)) EX_MEM_RD2(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(ID_EX_RF_data2_out),
		.data_o(EX_MEM_RD2_out)
		);

ALU_Ctrl ALU_Ctrl(
		.funct_i(ID_EX_SE_out[5:0]),   
        .ALUOp_i(ID_EX_EX_out[3:1]),   
        .ALUCtrl_o(ALU_Ctrl_o) 
		);

MUX_2to1 #(.size(32)) Mux2(
		.data0_i(ID_EX_RF_data2_out),
        .data1_i(ID_EX_SE_out),
        .select_i(ID_EX_EX_out[0]),
        .data_o(Mux_ALUSrc_o)
        );

wire [4:0] EX_MEM_Instr_in;
wire [4:0] EX_MEM_Instr_out;

MUX_2to1 #(.size(5)) Mux3(
		.data0_i(ID_EX_Instr_out[14:10]),
        .data1_i(ID_EX_Instr_out[9:5]),
        .select_i(ID_EX_EX_out[6]),
        .data_o(EX_MEM_Instr_in)
        );

Pipe_Reg #(.size(5)) EX_MEM_Instr(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_Instr_in),
		.data_o(EX_MEM_Instr_out)
		);

//Instantiate the components in MEM stage



Pipe_Reg #(.size(2)) MEM_WB_WB(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_WB_out),
		.data_o(MEM_WB_WB_out)
		);

wire [31:0] MEM_WB_DM_in;
wire [31:0] MEM_WB_DM_out;

Data_Memory DM(
		.clk_i(clk_i),
        .addr_i(EX_MEM_ALUrt_out),
        .data_i(EX_MEM_RD2_out),
        .MemRead_i(EX_MEM_M_out[1]),
        .MemWrite_i(EX_MEM_M_out[0]),
        .data_o(MEM_WB_DM_in)
	    );

Pipe_Reg #(.size(32)) MEM_WB_DM(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(MEM_WB_DM_in),
		.data_o(MEM_WB_DM_out)
		);

wire [31:0] MEM_WB_addr_in;
wire [31:0] MEM_WB_addr_out;

Pipe_Reg #(.size(32)) MEM_WB_addr(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_ALUrt_out),
		.data_o(MEM_WB_addr_out)
		);

/*wire [4:0] MEM_WB_Instr_in;
wire [4:0] MEM_WB_Instr_out;*/

Pipe_Reg #(.size(5)) MEM_WB_Instr(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.data_i(EX_MEM_Instr_out),
		.data_o(MEM_WB_Instr_out)
		);

//Instantiate the components in WB stage

//wire [31:0] Mux4_out;

MUX_2to1 #(.size(32)) Mux4(
		.data0_i(MEM_WB_addr_out),
        .data1_i(MEM_WB_DM_out),
        .select_i(MEM_WB_WB_out[0]),
        .data_o(Mux4_out)
        );



/****************************************
signal assignment
****************************************/	
endmodule

