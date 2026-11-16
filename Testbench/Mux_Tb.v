
`timescale 1ns / 1ps

module Mux_Tb;

    reg [31:0] a, b;
    reg s;
    wire [31:0] c;

    integer passed = 0;
    integer failed = 0;

    Mux uut (
        .a(a),
        .b(b),
        .s(s),
        .c(c)
    );

    task check;
        input [31:0] expected;
        input [8*30:1] test_name;
        begin
            #10;
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
        $dumpfile("Simulation/Mux.vcd");
        $dumpvars(0, Mux_Tb);

        $display("--------------------------------");
        $display("MUX TESTING");
        $display("--------------------------------");

        a = 32'h12345678;
        b = 32'hAABBCCDD;
        s = 0;
        check(32'h12345678, "Select A");

        s = 1;
        check(32'hAABBCCDD, "Select B");

        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        s = 0;
        check(32'hFFFFFFFF, "All Ones");

        s = 1;
        check(32'h00000000, "All Zeros");

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
