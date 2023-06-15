`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:13:32 07/19/2020 
// Design Name: 
// Module Name:    register 
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
module register
  #(parameter N = 8)
   (input wire load,
    input wire clk,
    input wire clr,
    input wire [N-1:0] d,
    output reg [N-1:0] q);

   always @(posedge clk or posedge clr)
     if (clr == 1)
       q <= 0;
     else if (load == 1)
       q <= d;

endmodule
