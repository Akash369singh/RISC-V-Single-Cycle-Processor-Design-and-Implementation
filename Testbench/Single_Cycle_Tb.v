//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 04:23:30 PM
// Design Name: 
// Module Name: Single_Cycle_Top_Tb
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





`timescale 1ns / 1ps

module Single_Cycle_Top_Tb();

    reg clk = 1'b0;
    reg rst;

    Single_Cycle_Top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock: 100 ns period
    always #50 clk = ~clk;

    initial begin
        $dumpfile("Simulation/Single Cycle.vcd");
        $dumpvars(0, Single_Cycle_Top_Tb);

        // Reset
        rst = 1'b0;
        #100;
        rst = 1'b1;

        // Instruction 1: OR x7, x5, x6
        #60;
        if (dut.PC_Top === 32'd4)
            $display("PASS: PC after Instruction 1");
        else
            $display("FAIL: PC after Instruction 1 | Actual=%h", dut.PC_Top);

        if (dut.Register_File.Registers[7] === 32'd5)
            $display("PASS: OR Instruction | x7 = 5");
        else
            $display("FAIL: OR Instruction | x7 = %h",
                     dut.Register_File.Registers[7]);

        // Instruction 2: AND x8, x5, x6
        #100;
        if (dut.PC_Top === 32'd8)
            $display("PASS: PC after Instruction 2");
        else
            $display("FAIL: PC after Instruction 2 | Actual=%h", dut.PC_Top);

        if (dut.Register_File.Registers[8] === 32'd4)
            $display("PASS: AND Instruction | x8 = 4");
        else
            $display("FAIL: AND Instruction | x8 = %h",
                     dut.Register_File.Registers[8]);

        // Instruction 3: ADD x9, x5, x6
        #100;
        if (dut.PC_Top === 32'd12)
            $display("PASS: PC after Instruction 3");
        else
            $display("FAIL: PC after Instruction 3 | Actual=%h", dut.PC_Top);

        if (dut.Register_File.Registers[9] === 32'd9)
            $display("PASS: ADD Instruction | x9 = 9");
        else
            $display("FAIL: ADD Instruction | x9 = %h",
                     dut.Register_File.Registers[9]);

        // Instruction 4: SUB x10, x5, x6
        #100;
        if (dut.PC_Top === 32'd16)
            $display("PASS: PC after Instruction 4");
        else
            $display("FAIL: PC after Instruction 4 | Actual=%h", dut.PC_Top);

        if (dut.Register_File.Registers[10] === 32'd1)
            $display("PASS: SUB Instruction | x10 = 1");
        else
            $display("FAIL: SUB Instruction | x10 = %h",
                     dut.Register_File.Registers[10]);

        // Instruction 5: SW x6, 3(x5)
        #100;
        if (dut.PC_Top === 32'd20)
            $display("PASS: PC after Instruction 5");
        else
            $display("FAIL: PC after Instruction 5 | Actual=%h", dut.PC_Top);

        if (dut.Data_Memory.Data[2] === 32'd4)
            $display("PASS: SW Instruction | Memory[2] = 4");
        else
            $display("FAIL: SW Instruction | Memory[2] = %h",
                     dut.Data_Memory.Data[2]);

        // Instruction 6: LW x11, 3(x5)
        #100;
        if (dut.PC_Top === 32'd24)
            $display("PASS: PC after Instruction 6");
        else
            $display("FAIL: PC after Instruction 6 | Actual=%h", dut.PC_Top);

        if (dut.Register_File.Registers[11] === 32'd4)
            $display("PASS: LW Instruction | x11 = 4");
        else
            $display("FAIL: LW Instruction | x11 = %h",
                     dut.Register_File.Registers[11]);

        // Instruction 7: BEQ x5, x5, +8 (Branch Taken)
        #100;
        if (dut.PC_Top === 32'd32)
            $display("PASS: BEQ Taken | PC = 32");
        else
            $display("FAIL: BEQ Taken | Expected=32 Actual=%h",
                     dut.PC_Top);

        // Instruction 8: ADD x13, x5, x6 (Branch Target)
        #100;
        if (dut.PC_Top === 32'd36)
            $display("PASS: PC after Branch Target Instruction");
        else
            $display("FAIL: PC after Branch Target | Actual=%h",
                     dut.PC_Top);

        if (dut.Register_File.Registers[13] === 32'd9)
            $display("PASS: Branch Target ADD | x13 = 9");
        else
            $display("FAIL: Branch Target ADD | x13 = %h",
                     dut.Register_File.Registers[13]);

        // Instruction 9: BEQ x5, x6, +8 (Branch Not Taken)
        #100;
        if (dut.PC_Top === 32'd40)
            $display("PASS: BEQ Not Taken | PC = 40");
        else
            $display("FAIL: BEQ Not Taken | Expected=40 Actual=%h",
                     dut.PC_Top);

        // Instruction 10: ADD x14, x5, x6
        #100;
        if (dut.PC_Top === 32'd44)
            $display("PASS: PC after Not Taken Instruction");
        else
            $display("FAIL: PC after Not Taken Instruction | Actual=%h",
                     dut.PC_Top);

        if (dut.Register_File.Registers[14] === 32'd9)
            $display("PASS: Not Taken ADD | x14 = 9");
        else
            $display("FAIL: Not Taken ADD | x14 = %h",
                     dut.Register_File.Registers[14]);

        // Instruction 11: BNE x5, x6, +8 (Branch Taken)
        #100;
        if (dut.PC_Top === 32'd52)
            $display("PASS: BNE Taken | PC = 52");
        else
            $display("FAIL: BNE Taken | Expected=52 Actual=%h",
                     dut.PC_Top);

        // Instruction 12: ADD x16, x5, x6 (Branch Target)
        #100;
        if (dut.PC_Top === 32'd56)
            $display("PASS: PC after BNE Branch Target");
        else
            $display("FAIL: PC after BNE Branch Target | Actual=%h",
                     dut.PC_Top);

        if (dut.Register_File.Registers[16] === 32'd9)
            $display("PASS: BNE Target ADD | x16 = 9");
        else
            $display("FAIL: BNE Target ADD | x16 = %h",
                     dut.Register_File.Registers[16]);

        // Instruction 13: BNE x5, x5, +8 (Branch Not Taken)
        #100;
        if (dut.PC_Top === 32'd60)
            $display("PASS: BNE Not Taken | PC = 60");
        else
            $display("FAIL: BNE Not Taken | Expected=60 Actual=%h",
                     dut.PC_Top);

        // Instruction 14: ADD x17, x5, x6
        #100;
        if (dut.PC_Top === 32'd64)
            $display("PASS: PC after BNE Not Taken");
        else
            $display("FAIL: PC after BNE Not Taken | Actual=%h",
                     dut.PC_Top);

        if (dut.Register_File.Registers[17] === 32'd9)
            $display("PASS: BNE Not Taken ADD | x17 = 9");
        else
            $display("FAIL: BNE Not Taken ADD | x17 = %h",
                     dut.Register_File.Registers[17]);

        $display("--------------------------------");
        $display("PROCESSOR INTEGRATION TEST COMPLETED");
        $display("--------------------------------");

        $finish;
    end

endmodule
