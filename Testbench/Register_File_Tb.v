
`timescale 1ns / 1ps

module Register_File_Tb;

    reg clk, rst, WE3;
    reg [4:0] A1, A2, A3;
    reg [31:0] WD3;

    wire [31:0] RD1, RD2;

    integer passed = 0;
    integer failed = 0;

    Reg_file uut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .WD3(WD3),
        .clk(clk),
        .WE3(WE3),
        .rst(rst),
        .RD1(RD1),
        .RD2(RD2)
    );

    always #5 clk = ~clk;

    task check_read;
        input [31:0] expected;
        input [31:0] actual;
        input [255:0] test_name;
        begin
            if (actual === expected) begin
                $display("PASS: %0s | Expected=%h Actual=%h",
                         test_name, expected, actual);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, actual);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 0;
        WE3 = 0;
        A1 = 0;
        A2 = 0;
        A3 = 0;
        WD3 = 0;

        $dumpfile("Simulation/Register_File.vcd");
        $dumpvars(0, Register_File_Tb);

        $display("--------------------------------");
        $display("REGISTER FILE TESTING");
        $display("--------------------------------");

        // Test 1: Reset read output
        #2;
        check_read(32'h00000000, RD1, "Reset RD1");
        check_read(32'h00000000, RD2, "Reset RD2");

        // Release reset
        rst = 1;

        // Test 2: Initial x5 value
        A1 = 5;
        #2;
        check_read(32'h00000005, RD1, "Initial x5");

        // Test 3: Initial x6 value
        A2 = 6;
        #2;
        check_read(32'h00000004, RD2, "Initial x6");

        // Test 4: Write x7
        A3 = 7;
        WD3 = 32'h12345678;
        WE3 = 1;
        @(posedge clk);
        #1;
        WE3 = 0;
        A1 = 7;
        #1;
        check_read(32'h12345678, RD1, "Write and Read x7");

        // Test 5: Write x8
        A3 = 8;
        WD3 = 32'hAABBCCDD;
        WE3 = 1;
        @(posedge clk);
        #1;
        WE3 = 0;
        A2 = 8;
        #1;
        check_read(32'hAABBCCDD, RD2, "Write and Read x8");

        // Test 6: Read x0
        A1 = 0;
        #2;
        check_read(32'h00000000, RD1, "Read x0");

        // Test 7: Attempt to write x0
        A3 = 0;
        WD3 = 32'hFFFFFFFF;
        WE3 = 1;
        @(posedge clk);
        #1;
        WE3 = 0;
        A1 = 0;
        #1;
        check_read(32'h00000000, RD1, "x0 Must Remain Zero");

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
