
`timescale 1ns / 1ps

module Instruction_Memory_Tb;

    reg [31:0] A;
    reg rst;
    wire [31:0] RD;

    integer passed = 0;
    integer failed = 0;

    Instr_Mem uut (
        .A(A),
        .rst(rst),
        .RD(RD)
    );

    task check_read;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            #5;
            if (RD === expected) begin
                $display("PASS: %0s | Expected=%h Actual=%h",
                         test_name, expected, RD);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, RD);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("Simulation/Instruction_Memory.vcd");
        $dumpvars(0, Instruction_Memory_Tb);

        $display("--------------------------------");
        $display("INSTRUCTION MEMORY TESTING");
        $display("--------------------------------");

        // Test 1: Reset active
        rst = 0;
        A = 0;
        check_read(32'h00000000, "Reset Output");

        // Test 2: First instruction
        rst = 1;
        A = 0;
        check_read(32'h0062E3B3, "Instruction Address 0");

        // Test 3: Second instruction
        A = 4;
        check_read(32'h0062F433, "Instruction Address 4");

        // Test 4: Third instruction (not initialized)
        A = 8;
        check_read(32'hxxxxxxxx, "Uninitialized Address 8");

        // Test 5: Reset at another address
        rst = 0;
        A = 4;
        check_read(32'h00000000, "Reset at Address 4");

        $display("--------------------------------");
        $display("TOTAL TESTS : %0d", passed + failed);
        $display("PASSED      : %0d", passed);
        $display("FAILED      : %0d", failed);
        if (failed == 0)
            $display("STATUS: ALL TESTS PASSED");
        else
            $display("STATUS: SOME TESTS FAILED");
        $display("--------------------------------");

        $finish;
    end

endmodule
