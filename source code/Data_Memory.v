`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 10:09:42 PM
// Design Name: 
// Module Name: Data_Memory
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




module Data_Memory(A,WE,clk,WD,RD);

   // Input and Output declaration
   input [31:0] A,WD;
   input clk,WE;
   output [31:0] RD;

   // Declaring 4 KB Data Memory
   reg [31:0] Data [1023:0];

   // Read operation using word-aligned address
   assign RD = (WE == 1'b0) ? Data[A[11:2]] : 32'd0;

   // Initial memory values
   initial begin
      Data[28] = 32'h00000020;
      Data[40] = 32'h00000002;
   end

   // Write operation
   always @(posedge clk) begin
      if (WE) begin
         Data[A[11:2]] <= WD;
      end
   end

endmodule
