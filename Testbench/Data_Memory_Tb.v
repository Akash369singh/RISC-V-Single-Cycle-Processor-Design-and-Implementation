
`timescale 1ns / 1ps

module Data_Memory_Tb;

    reg [31:0] A, WD;
    reg clk, WE;
    wire [31:0] RD;

    integer passed = 0;
    integer failed = 0;

    Data_Memory DUT (
        .A(A),
        .WE(WE),
        .clk(clk),
        .WD(WD),
        .RD(RD)
    );

    always #5 clk = ~clk;

    task check_read;
        input [31:0] expected;
        input [255:0] test_name;
        begin
            #1;
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
        $dumpfile("Simulation/Data_Memory.vcd");
        $dumpvars(0, Data_Memory_Tb);

        clk = 0;
        A = 0;
        WD = 0;
        WE = 0;

        // Test 1: Initial memory value at Data[28]
        A = 32'd112;
        check_read(32'h00000020, "Initial Data[28]");

        // Test 2: Initial memory value at Data[40]
        A = 32'd160;
        check_read(32'h00000002, "Initial Data[40]");

        // Test 3: Write at byte address 0
        @(negedge clk);
        A = 32'd0;
        WD = 32'h12345678;
        WE = 1;

        @(posedge clk);
        #1;
        WE = 0;
        check_read(32'h12345678, "Write/Read Address 0");

        // Test 4: Write at byte address 4
        @(negedge clk);
        A = 32'd4;
        WD = 32'hAABBCCDD;
        WE = 1;

        @(posedge clk);
        #1;
        WE = 0;
        check_read(32'hAABBCCDD, "Write/Read Address 4");

        // Test 5: Write at byte address 8
        @(negedge clk);
        A = 32'd8;
        WD = 32'h00000055;
        WE = 1;

        @(posedge clk);
        #1;
        WE = 0;
        check_read(32'h00000055, "Write/Read Address 8");

        // Final report
        $display("--------------------------------");
        $display("TOTAL TESTS : %0d", passed + failed);
        $display("PASSED      : %0d", passed);
        $display("FAILED      : %0d", failed);

        if (failed == 0)
            $display("STATUS: ALL TESTS PASSED");
        else
            $display("STATUS: TESTS FAILED");

        $display("--------------------------------");
        $finish;
    end

endmodule
