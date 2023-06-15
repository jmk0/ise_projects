`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:12:08 08/04/2020 
// Design Name: 
// Module Name:    mux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux
  #(parameter N = 8)
   (input wire sel,
    input wire [N-1:0] d0,
    input wire [N-1:0] d1,
    output wire [N-1:0] q);

   assign q = (sel ? d1 : d0);

endmodule // mux
