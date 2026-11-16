
`timescale 1ns / 1ps

module Control_Unit_Tb;

    reg [6:0] op, funct7;
    reg [2:0] funct3;
    reg zero;

    wire RegWrite, ALUSrc, MemWrite, ResultSrc, PCSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl;

    integer passed = 0;
    integer failed = 0;

    Control_Unit_Top uut (
        .op(op),
        .RegWrite(RegWrite),
        .zero(zero),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .funct3(funct3),
        .funct7(funct7),
        .PCSrc(PCSrc),
        .ALUControl(ALUControl)
    );

    task check;
        input [9:0] expected;
        input [8*30:1] test_name;
        begin
            #10;
            if ({RegWrite, MemWrite, ResultSrc, ALUSrc,
                 ImmSrc, PCSrc, ALUControl} === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%b Actual=%b",
                         test_name, expected,
                         {RegWrite, MemWrite, ResultSrc, ALUSrc,
                          ImmSrc, PCSrc, ALUControl});
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("Simulation/Control_Unit.vcd");
        $dumpvars(0, Control_Unit_Tb);

        $display("--------------------------------");
        $display("CONTROL UNIT TESTING");
        $display("--------------------------------");

        // R-type ADD
        op=7'b0110011; funct3=3'b000;
        funct7=7'b0000000; zero=0;
        check({1'b1,1'b0,1'b0,1'b0,2'b00,1'b0,3'b000},
              "R-type ADD");

        // R-type SUB
        op=7'b0110011; funct3=3'b000;
        funct7=7'b0100000; zero=0;
        check({1'b1,1'b0,1'b0,1'b0,2'b00,1'b0,3'b001},
              "R-type SUB");

        // Load
        op=7'b0000011; funct3=3'b010;
        funct7=0; zero=0;
        check({1'b1,1'b0,1'b1,1'b1,2'b00,1'b0,3'b000},
              "Load");

        // Store
        op=7'b0100011; funct3=3'b010;
        funct7=0; zero=0;
        check({1'b0,1'b1,1'b0,1'b1,2'b01,1'b0,3'b000},
              "Store");

        // Branch, zero = 1
        op=7'b1100011; funct3=3'b000;
        funct7=0; zero=1;
        check({1'b0,1'b0,1'b0,1'b0,2'b10,1'b1,3'b001},
              "Branch Taken");

        // Branch, zero = 0
        op=7'b1100011; funct3=3'b000;
        funct7=0; zero=0;
        check({1'b0,1'b0,1'b0,1'b0,2'b10,1'b0,3'b001},
              "Branch Not Taken");

        $display("--------------------------------");
        $display("TOTAL TESTS : %0d", passed+failed);
        $display("PASSED      : %0d", passed);
        $display("FAILED      : %0d", failed);

        if (failed==0)
            $display("STATUS: ALL TESTS PASSED");
        else
            $display("STATUS: TESTS FAILED");

        $display("--------------------------------");
        $finish;
    end

endmodule
