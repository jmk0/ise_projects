`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:20:08 08/05/2020
// Design Name:   decode
// Module Name:   /home/ise/ise_projects/mrhankey/decode_test.v
// Project Name:  mrhankey
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: decode
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module decode_test;

   // Inputs
   reg clk;
   reg clr;
   reg [7:0] IR;

   // Outputs
   wire      halt;
   wire      op;
   wire      selA;
   wire      loadA;
   wire      selB;
   wire      loadB;

   // Instantiate the Unit Under Test (UUT)
   decode uut (
	       .clk(clk), 
	       .clr(clr), 
	       .IR(IR), 
	       .halt(halt),
               .op(op),
               .selA(selA),
               .loadA(loadA),
               .selB(selB),
               .loadB(loadB)
	       );

   initial begin
      $display("---- decode_test begin ----");
      //$monitor("%6d", $time);
      
      // Initialize Inputs
      clk = 0;
      clr = 0;
      IR = 0;

      // Wait 100 ns for global reset to finish
      #100;
      //$monitor("%6d", $time);
      
      // Add stimulus here
      IR = 'hff;
      #5;
      //$monitor("%6d", $time);
      if (halt != 1) $display("FAIL HALT instruction");
      else $display("PASS HALT instruction");

      // Clearing the decoder doesn't reset the instruction register,
      // that happens elsewhere, so we manually clear the IR.
      #15 IR = 0;
      //$monitor("%6d", $time);
      clr = 1;
      #5 clr = 0;
      //$monitor("%6d", $time);
      #5;
      //$monitor("%6d", $time);
      if (halt != 0) $display("FAIL CLR post HALT instruction");
      else $display("PASS CLR post HALT instruction");

      #10;
      //$monitor("%6d", $time);
      IR = 'h05; // LDA 5
      #5;
      //$monitor("%6d", $time);
      if (selA != 1) $display("FAIL LDA instruction select A");
      else $display("PASS LDA instruction select A");
      if (loadA != 1) $display("FAIL LDA instruction load A");
      else $display("PASS LDA instruction load A");
      if (selB != 0) $display("FAIL LDA instruction select B");
      else $display("PASS LDA instruction select B");
      if (loadB != 0) $display("FAIL LDA instruction load B");
      else $display("PASS LDA instruction load B");

      #35;
      //$monitor("%6d", $time);
      IR = 'h6b; // LDB 43
      #5;
      //$monitor("%6d", $time);
      if (selA != 0) $display("FAIL LDB instruction select A");
      else $display("PASS LDB instruction select A");
      if (loadA != 0) $display("FAIL LDB instruction load A");
      else $display("PASS LDB instruction load A");
      if (selB != 0) $display("FAIL LDB instruction select B");
      else $display("PASS LDB instruction select B");
      if (loadB != 1) $display("FAIL LDB instruction load B");
      else $display("PASS LDB instruction load B");

      #35;
      IR = 'h84; // ADD A,B
      #5;
      if (selA != 1) $display("FAIL ADD instruction select A");
      else $display("PASS ADD instruction select A");
      if (loadA != 1) $display("FAIL ADD instruction load A");
      else $display("PASS ADD instruction load A");
      if (selB != 0) $display("FAIL ADD instruction select B");
      else $display("PASS ADD instruction select B");
      if (loadB != 0) $display("FAIL ADD instruction load B");
      else $display("PASS ADD instruction load B");
      if (op != 1) $display("FAIL ADD instruction op");
      else $display("PASS ADD instruction op");

      #35;
      $finish;

   end // initial begin

   always begin
      #20 clk = ~clk;
   end
   
endmodule // decode_test
