`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:10:42 08/05/2020
// Design Name:   register
// Module Name:   /home/ise/ise_projects/mrhankey/register_test.v
// Project Name:  mrhankey
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module register_test;

   // Inputs
   reg load;
   reg clk;
   reg clr;
   reg [7:0] d;

   // Outputs
   wire [7:0] q;

   // Instantiate the Unit Under Test (UUT)
   register uut (
		 .load(load), 
		 .clk(clk), 
		 .clr(clr), 
		 .d(d), 
		 .q(q)
	         );

   initial begin
      // Initialize Inputs
      load = 0;
      clk = 0;
      clr = 0;
      d = 0;

      // Wait 100 ns for global reset to finish
      #100;

      // Add stimulus here
      // wait another 25 ns to go off clock cycle.
      #25;
      clr = 1;
      #5 clr = 0;
      if (q != 0) $display("FAIL CLR");
      else $display("PASS CLR");

      #10 d = 'haa;
      #5;
      if (q != 0) $display("FAIL Q change with load low");
      else $display("PASS Q change with load low");

      #35 d = 'h55;
      load = 1;
      #5;
      if (q != 'h55) $display("FAIL Q change with load high");
      else $display("PASS Q change with load high");

      #35;
      $finish;
   end

   always begin
      #20 clk = ~clk;
   end

endmodule // register_test
