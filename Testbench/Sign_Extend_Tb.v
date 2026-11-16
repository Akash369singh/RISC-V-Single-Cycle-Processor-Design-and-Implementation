
`timescale 1ns / 1ps

module Sign_Extend_Tb;

    reg [31:0] In;
    reg [1:0] ImmSrc;
    wire [31:0] Imm_Ext;

    integer passed = 0;
    integer failed = 0;

    Sign_Extend uut (
        .In(In),
        .Imm_Ext(Imm_Ext),
        .ImmSrc(ImmSrc)
    );

    task check;
        input [31:0] expected;
        input [8*30:1] test_name;
        begin
            #10;
            if (Imm_Ext === expected) begin
                $display("PASS: %0s | Expected=%h Actual=%h",
                         test_name, expected, Imm_Ext);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, Imm_Ext);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("Simulation/Sign_Extend.vcd");
        $dumpvars(0, Sign_Extend_Tb);

        $display("--------------------------------");
        $display("SIGN EXTENSION TESTING");
        $display("--------------------------------");

        // I-type: +5
        In = 32'h00500000;
        ImmSrc = 2'b00;
        check(32'h00000005, "I-type Positive");

        // I-type: -1
        In = 32'hFFF00000;
        ImmSrc = 2'b00;
        check(32'hFFFFFFFF, "I-type Negative");

        // S-type: +5
        In = 32'h00500280;
        ImmSrc = 2'b01;
        check(32'h00000005, "S-type Positive");

        // B-type: +8
        In = 32'h00000400;
        ImmSrc = 2'b10;
        check(32'h00000008, "B-type Positive");

        // B-type: -4
        In = 32'hFE000E80;
        ImmSrc = 2'b10;
        check(32'hFFFFFFFC, "B-type Negative");

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

