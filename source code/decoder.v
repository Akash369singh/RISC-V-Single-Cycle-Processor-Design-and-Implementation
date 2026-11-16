//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 08:32:43 PM
// Design Name: 
// Module Name: main_decoder
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



module main_decoder(
    op, funct3, zero, Regwrite, Memwrite,
    ResultSrc, ALUSrc, ImmSrc, ALUOp, PCSrc
);

    // Inputs / Outputs
    input zero;
    input [6:0] op;
    input [2:0] funct3;

    output Regwrite, Memwrite, ResultSrc, ALUSrc, PCSrc;
    output [1:0] ImmSrc, ALUOp;

    // Internal wires
    wire branch;
    wire is_beq;
    wire is_bne;

    assign Regwrite = ((op == 7'b0000011) |
                       (op == 7'b0110011)) ? 1'b1 : 1'b0;

    assign Memwrite = (op == 7'b0100011) ? 1'b1 : 1'b0;

    assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;

    assign ALUSrc = ((op == 7'b0000011) |
                     (op == 7'b0100011)) ? 1'b1 : 1'b0;

    // Branch instruction detection
    assign branch = (op == 7'b1100011);

    assign is_beq = branch & (funct3 == 3'b000);
    assign is_bne = branch & (funct3 == 3'b001);

    // Branch decision
    assign PCSrc = (is_beq & zero) |
                   (is_bne & ~zero);

    // Immediate selection
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 :
                    (branch) ? 2'b10 :
                    2'b00;

    // ALU operation selection
    assign ALUOp = (op == 7'b0110011) ? 2'b10 :
                   (branch) ? 2'b01 :
                   2'b00;

endmodule

