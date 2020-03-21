# Lab 2: Single Cycle CPU – Simple Edition
## Homework Description
### Goal

Utilizing the ALU in Lab1 to implement a simple single cycle CPU. CPU is the most important unit in computer system. Read the document carefully and do the Lab, and you will have the elementary knowledge of CPU.

### Basic instruction set
<img src="https://i.imgur.com/tirJMh3.png" width="90%">
<img src="https://i.imgur.com/aHf48jE.png" width="90%">



### Architecture diagram

<img src="https://i.imgur.com/rYh4WDU.png" width="80%">

### Advance Instructions

Modify the architecture of the basic design above.  
1. ALUOp should be extended to 3bits to implement I-type instructions.  
Original 2bits ALUOp from textbook:00->000, 01->001, 10->010  
&nbsp;
2. Encode shift right and LUI instruction by using unused ALU_ctrl.  
Ex. ALU_ctrl=0 is AND, 1 is OR..., 0 1 2 6 7 &12 are used by basic Instructions

<img src="https://i.imgur.com/hWQYlxW.png" width="90%">

### Test

There are 3 test patterns, CO_P2_test_data1.txt ~CO_P2_test_data3.txt. The default pattern is the first one. Please change the column 39 in the file “Instr_Memory.v” if you want to test the other cases.  

`$readmemb("CO_P2_test_data1.txt", Instr_Mem)`

The following are the assembly code for the test patterns.  

<img src="https://i.imgur.com/eT8KDOH.png" width="70%">
<img src="https://i.imgur.com/DvSf977.png" width="70%">

&nbsp;
The file”CO_P2_Result.txt” will be generated after executing the Testbench. Check your answer with it.




## Experiment
### Detailed description of the implementation

1. Decoder.v  
將指令的 opfield 傳入其中一個 input Instr_op_i，依據每個不同的 opcode， 控制所有其他的 module，例如:
    - RegWrite_o 控制要不要把運算結果寫入 register
    - ALU_op_o 告訴 ALU Ctrl 是哪種 Opcode
    - RegDst_o 告訴 Reg_File 要存到哪個 register
    - Branch_o 判斷 opcode 是不是 j-type 的指令
    - ALUSrc_o 控制 ALU 的第二個運算元是來自 Register 或 Instruction Memory
2. ALU_Ctrl.v  
透過 Input funct_i 和 ALUOp_i 判斷 ALU 要做哪種計算
3. ALU.v  
根據 ctrl_i 對 src1_i 和 src2_i 做出不同的運算，種類有 and, or, add, sub, nor, nand, slt, sra, srav, lui, ori, bne。  
    - 如果要做的運算是 bne 且相減結果不等於零，則 zero 等於 1。  
    - 如果要做的運算是 beq 且相減結果等於零，則 zero 也等於 1。  
    - 為了做出 sra、srav 的運算，把 src2_i 改成 signed 的型態，並且增加一個 input shamt_i 將 instruction 的第6 ~ 10位傳入 module，判斷 sra 指令要右移幾位。
    - 要做出 lui 的運算，直接將第0 ~ 15位的數字換到第16 ~ 31位，原本的第0 ~ 15位則都為 0。
4. Adder.v  
把兩數相加並輸出。
5. MUX_2to1.v  
根據 select_i 判斷要輸出 data0_i 還是 data1_i。
6. Shift_Left_Two_32.v  
把 data_i 左移兩位後輸出。
7. Sign_Extend.v  
把原本只有 16bit 的 data_i 增加為 32bit，作法是將 sign extend 過後的數字第 16~31 位等於原本的第 15 位。
8. Simple_Single_CPU.v  
主要是將各個 module 呼叫並把 module 之間的線接起來。以下說明各個 module 之間的關係:
    - PC, Adder1, Adder2, Mux_PC_Source:
將 PC 的 output 結果接到 Adder1 讓 address 加 4，然後再傳入 Adder2，若 運算指令為 j-type，則會把 address 再相加到應該要 jump 到的位址，最後透 過 Mux_PC_Source 判斷要不要跳到 j-type 指令要跳的位址。
    - PC, IM:
將 PC 的 output 結果接到 IM，IM 再根據傳入的 address 讀出 register 裡面 的 instruction。
    - Decoder, Mux_Write_Reg, RF, Mux_PC_Source, Mux_ALUSrc, AC: Decoder 將 IM 輸出的指令第 31~26bit 接進來，然後根據指令種類分別控制 Mux_Write_Reg, RF, Mux_PC_Source, Mux_ALUSrc, AC。
    - IM, RF, Mux_Write_Reg, SE, AC:
將 IM 輸出的指令第25 ~ 21, 20 ~ 16位傳入 RF，輸出兩個 register 的兩筆資料; 第20 ~ 16, 15 ~ 11位傳入 Mux_Write_Reg，判斷要把運算結果存到哪個 register;第15 ~ 0位傳入 SE，若 instruction 為 I-type，則第15 ~ 0位為一個 常數，將該常數做 sign extension 然後輸出，若 instruction 為 J-type，則第15 ~ 0位為一個 address，將該常數做 sign extension 然後輸出;第 6 ~ 0位傳入 AC，AC 判斷做出甚麼運算後再傳入 ALU。
    - RF, Mux_ALUSrc, AC, ALU, Mux_PC_Source:
ALU 根據 AC 的結果判斷要做甚麼運算，然後將 RE 和 Mux_ALUSrc 的 output 做運算，並將運算結果傳回 RF，讓 RF 將結果寫入 register。若 instruction 為 J-type 指令，則將 output zero_o 傳入 Mux_PC_Source