
`timescale 1ns / 1ps

module PC_Tb;

    reg clk, rst;
    reg [31:0] PC_NEXT;
    wire [31:0] PC;

    reg [31:0] a, b;
    wire [31:0] c;

    integer passed = 0;
    integer failed = 0;

    P_C pc_unit (
        .PC_NEXT(PC_NEXT),
        .clk(clk),
        .rst(rst),
        .PC(PC)
    );

    PC_Adder adder_unit (
        .a(a),
        .b(b),
        .c(c)
    );

    always #5 clk = ~clk;

    task check_pc;
        input [31:0] expected;
        input [8*30:1] test_name;
        begin
            if (PC === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, PC);
                failed = failed + 1;
            end
        end
    endtask

    task check_adder;
        input [31:0] expected;
        input [8*30:1] test_name;
        begin
            #1;
            if (c === expected) begin
                $display("PASS: %0s", test_name);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, c);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        clk = 0;
        rst = 0;
        PC_NEXT = 0;
        a = 0;
        b = 0;

        $dumpfile("Simulation/PC.vcd");
        $dumpvars(0, PC_Tb);

        $display("--------------------------------");
        $display("PROGRAM COUNTER & ADDER TESTING");
        $display("--------------------------------");

        // Reset test
        @(posedge clk);
        #1;
        check_pc(32'h00000000, "PC Reset");

        // PC update
        rst = 1;
        PC_NEXT = 32'd4;
        @(posedge clk);
        #1;
        check_pc(32'd4, "PC Update 4");

        // Next PC update
        PC_NEXT = 32'd8;
        @(posedge clk);
        #1;
        check_pc(32'd8, "PC Update 8");

        // PC holds value between clock edges
        PC_NEXT = 32'd12;
        #1;
        check_pc(32'd8, "PC Holds Between Edges");

        // PC Adder tests
        a = 32'd0; b = 32'd4;
        check_adder(32'd4, "Adder 0 + 4");

        a = 32'd100; b = 32'd20;
        check_adder(32'd120, "Adder 100 + 20");

        a = 32'hFFFFFFFF; b = 32'd1;
        check_adder(32'd0, "Adder Overflow");

        $display("--------------------------------");
        $display("TOTAL TESTS : %0d", passed+failed);
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
