`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   03:16:05 08/06/2020
// Design Name:   ALU
// Module Name:   /home/ise/ise_projects/mrhankey/ALU_test.v
// Project Name:  mrhankey
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ALU_test;

   // Inputs
   reg op;
   reg [7:0] a;
   reg [7:0] b;

   // Outputs
   wire [7:0] result;
   wire       cf;
   wire       ovf;

   // Instantiate the Unit Under Test (UUT)
   ALU uut (
	    .op(op), 
	    .a(a), 
	    .b(b), 
	    .result(result), 
	    .cf(cf), 
	    .ovf(ovf)
	    );

   initial begin
      $display("---- ALU_test begin ----");

      // Initialize Inputs
      op = 0;
      a = 0;
      b = 0;

      // Wait 100 ns for global reset to finish
      #100;
      
      // Add stimulus here

      op <= 1;
      a <= 5;
      b <= 43;
      #5;
      if (result != 48) $display("FAIL ADD 5+43");
      else $display("PASS ADD 5+43");
      #35;

      a <= 8'b10000000;
      b <= 8'b10000000;
      #5;
      if (result != 0) $display("FAIL CF test result");
      else $display("PASS CF test result");
      if (cf != 1) $display("FAIL CF test flag");
      else $display("PASS CF test flag");
      #35;
      
      $finish;

   end
   
endmodule

