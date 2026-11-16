//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2026 11:47:31 PM
// Design Name: 
// Module Name: Sign_Extend
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


// module Sign_Extend(In,Imm_Ext,ImmSrc);
      
//       input[31:0] In;
//       input ImmSrc;
//       output [31:0] Imm_Ext;
      
//       assign Imm_Ext = (ImmSrc == 1'b1) ? ({{20{In[31]}},In[31:25],In[11:7]}):
//                         {{20{In[31]}},In[31:20]};
// endmodule

module Sign_Extend(In, Imm_Ext, ImmSrc);

    input [31:0] In;
    input [1:0] ImmSrc;
    output [31:0] Imm_Ext;

    assign Imm_Ext = (ImmSrc == 2'b00) ?
                     {{20{In[31]}}, In[31:20]} :

                     (ImmSrc == 2'b01) ?
                     {{20{In[31]}}, In[31:25], In[11:7]} :

                     (ImmSrc == 2'b10) ?
                     {{19{In[31]}}, In[31], In[7],
                      In[30:25], In[11:8], 1'b0} :

                     32'b0;

endmodule
