//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 09:21:49 PM
// Design Name: 
// Module Name: Single_Cycle_Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`include "Program_Counter.v"
`include "Instruction_Memory.v"
`include "Register_files.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"

module Single_Cycle_Top(clk, rst);

    // Input and Output
    input clk, rst;

    // Internal Wires
    wire [31:0] PC_Top;
    wire [31:0] RD_Instr;
    wire [31:0] RD1_Top;
    wire [31:0] Imm_Ext_Top;
    wire [2:0] ALUControl_Top;
    wire [31:0] ALUResult;
    wire [31:0] ReadData;
    wire [31:0] PCPlus4;
    wire [31:0] RD2_Top;
    wire RegWrite;
    wire [1:0] ImmSrc;
    wire MemWrite;
    wire ALUSrc;
    wire [31:0] SrcB;
    wire ResultSrc;
    wire [31:0] Result;

    // Branch Control Wires
    wire ALUZero;
    wire PCSrc;
    wire [31:0] PCBranch;
    wire [31:0] PCNext;

    // Program Counter
    P_C PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_NEXT(PCNext)
    );

    // Instruction Memory
    Instr_Mem Instruction_Memory(
        .rst(rst),
        .A(PC_Top),
        .RD(RD_Instr)
    );

    // Register File
    Reg_file Register_File(
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(RD_Instr[11:7]),
        .WD3(Result),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    // Sign Extension
    Sign_Extend Sign_Extend(
        .In(RD_Instr),
        .ImmSrc(ImmSrc),
        .Imm_Ext(Imm_Ext_Top)
    );

    // ALU
    alu ALU(
        .A(RD1_Top),
        .B(SrcB),
        .ALUControl(ALUControl_Top),
        .Result(ALUResult),
        .Z(ALUZero),
        .N(),
        .V(),
        .C()
    );

    // Control Unit
    Control_Unit_Top Control_Unit_Top(
        .op(RD_Instr[6:0]),
        .RegWrite(RegWrite),
        .zero(ALUZero),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .funct3(RD_Instr[14:12]),
        .funct7(RD_Instr[31:25]),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl_Top)
    );

    // Data Memory
    Data_Memory Data_Memory(
        .A(ALUResult),
        .WE(MemWrite),
        .clk(clk),
        .WD(RD2_Top),
        .RD(ReadData)
    );

    // PC + 4 Adder
    PC_Adder PC_Adder(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );

    // Branch Target Address Adder
    PC_Adder Branch_Adder(
        .a(PC_Top),
        .b(Imm_Ext_Top),
        .c(PCBranch)
    );

    // ALU Source MUX
    Mux Mux_Reg_2_Alu(
        .a(RD2_Top),
        .b(Imm_Ext_Top),
        .s(ALUSrc),
        .c(SrcB)
    );

    // Data Memory to Register MUX
    Mux DataMem_2_Reg(
        .a(ALUResult),
        .b(ReadData),
        .s(ResultSrc),
        .c(Result)
    );

    // Next PC Selection MUX
    Mux PC_Mux(
        .a(PCPlus4),
        .b(PCBranch),
        .s(PCSrc),
        .c(PCNext)
    );

endmodule
