
`timescale 1ns / 1ps

module ALU_Tb;

    reg [31:0] A, B;
    reg [2:0] ALUControl;

    wire [31:0] Result;
    wire Z, N, V, C;

    integer passed = 0;
    integer failed = 0;

    alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .Result(Result),
        .Z(Z),
        .N(N),
        .V(V),
        .C(C)
    );

    task check_result;
        input [31:0] expected;
        input [8*40:1] test_name;
        begin
            #10;
            if (Result === expected) begin
                $display("PASS: %0s | Expected=%h Actual=%h",
                         test_name, expected, Result);
                passed = passed + 1;
            end
            else begin
                $display("FAIL: %0s | Expected=%h Actual=%h",
                         test_name, expected, Result);
                failed = failed + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("Simulation/ALU.vcd");
        $dumpvars(0, ALU_Tb);

        $display("--------------------------------");
        $display("ALU TESTING");
        $display("--------------------------------");

        // Addition
        A = 32'd10; B = 32'd5; ALUControl = 3'b000;
        check_result(32'd15, "Addition");

        // Subtraction
        A = 32'd10; B = 32'd5; ALUControl = 3'b001;
        check_result(32'd5, "Subtraction");

        // AND
        A = 32'hF0F0F0F0; B = 32'h0F0F0F0F;
        ALUControl = 3'b010;
        check_result(32'h00000000, "AND");

        // OR
        A = 32'hF0F00000; B = 32'h00000F0F;
        ALUControl = 3'b011;
        check_result(32'hF0F00F0F, "OR");

        // SLT: 5 < 10
        A = 32'd5; B = 32'd10; ALUControl = 3'b101;
        check_result(32'd1, "SLT Positive");

        // SLT: 10 < 5
        A = 32'd10; B = 32'd5; ALUControl = 3'b101;
        check_result(32'd0, "SLT Negative");

        // Zero flag
        A = 32'd5; B = 32'd5; ALUControl = 3'b001;
        #10;
        if (Z === 1'b1) begin
            $display("PASS: Zero Flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Zero Flag");
            failed = failed + 1;
        end

        // Negative flag
        A = 32'd5; B = 32'd10; ALUControl = 3'b001;
        #10;
        if (N === 1'b1) begin
            $display("PASS: Negative Flag");
            passed = passed + 1;
        end
        else begin
            $display("FAIL: Negative Flag");
            failed = failed + 1;
        end

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
