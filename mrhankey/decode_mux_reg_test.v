`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:40:15 08/05/2020
// Design Name:   decode
// Module Name:   /home/ise/ise_projects/mrhankey/decode_mux_reg_test.v
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

module decode_mux_reg_test;

   // Inputs
   reg clk;
   reg clr;
   reg [7:0] IR;

   // Outputs
   wire      halt;
   wire      selA;
   wire      loadA;
   wire      loadAprime;
   wire      selB;
   wire      loadB;
   wire      loadBprime;
   wire [1:0] op;
   wire [7:0] IP;
   wire [7:0] ALUout;

   wire [7:0]      regA;
   wire [7:0]      muxA;
   wire [7:0]      regB;
   wire [7:0]      muxB;

   wire [3:0] 	   control;     // fetch, decode, execute, update PC
   // CPU status flags
   wire            cf;
   wire            ovf;

   assign loadA = loadAprime & control[1];
   assign loadB = loadBprime & control[1];

   ring #(.N(4))
   seq_generator
     (.clk(clk),
      .clr(clr),
      .q(control));

   // Instantiate the Unit Under Test (UUT)
   decode uut (
	       .clk(control[2]), 
	       .clr(clr), 
	       .IR(IR), 
	       .halt(halt),
	       .op(op),
	       .selA(selA), 
	       .loadA(loadAprime), 
	       .selB(selB), 
	       .loadB(loadBprime)
	       );

   counter IPcontrol
     (.clr(clr),
      .clk(control[0]),
      .q(IP));

   mux MUXAwuxa
     (.sel(selA),
      .d0({2'b00,IR[5:0]}),
      .d1(ALUout),
      .q(muxA));

   mux MUXBwuxb
     (.sel(selB),
      .d0({2'b00,IR[5:0]}),
      .d1(ALUout),
      .q(muxB));

   register RA
     (.load(loadAprime),
      .clk(loadA),
      .clr(clr),
      .d(muxA),
      .q(regA));

   register RB
     (.load(loadBprime),
      .clk(loadB),
      .clr(clr),
      .d(muxB),
      .q(regB));

   ALU hankeyALU
     (.op(op),
      .a(regA),
      .b(regB),
      .result(ALUout),
      .cf(cf),
      .ovf(ovf));

   initial begin
      $display("---- decode_mux_reg_test begin ----");
      // Initialize Inputs
      clk = 0;
      clr = 1;
      IR = 'h05; // LDA 5

      // Wait 100 ns for global reset to finish
      #100;
      clr = 0;
      #160;
      if ((halt != 0) || (selA != 0) || (loadAprime != 1) || (selB != 0) ||
	  (loadBprime != 0) || (op != 0) || (regA != 5)) begin
	 $display("%t FAIL LDA instruction", $time);
      end
      else begin
	 $display("%t PASS LDA instruction", $time);
      end

      IR = 'h6b; // LDB 43
      #160;
      if ((halt != 0) || (selA != 0) || (loadAprime != 0) || (selB != 0) ||
	  (loadBprime != 1) || (op != 0) || (regB != 43)) begin
	 $display("%t FAIL LDB instruction", $time);
      end
      else begin
	 $display("%t PASS LDB instruction", $time);
      end

      IR = 'h84; // ADD A,B
      #160;
      if ((halt != 0) || (selA != 1) || (loadAprime != 1) || (selB != 0) ||
	  (loadBprime != 0) || (op != 1) || (regA != 48)) begin
	 $display("%t FAIL ADD A,B instruction", $time);
      end
      else begin
	 $display("%t PASS ADD A,B instruction", $time);
      end

      IR = 'h80; // ADD A,A
      #160;
      if ((halt != 0) || (selA != 1) || (loadAprime != 1) || (selB != 0) ||
	  (loadBprime != 0) || (op != 2) || (regA != 96)) begin
	 $display("%t FAIL ADD A,A instruction", $time);
      end
      else begin
	 $display("%t PASS ADD A,A instruction", $time);
      end

      IR = 'h90; // ADD B,A
      #160;
      if ((halt != 0) || (selA != 0) || (loadAprime != 0) || (selB != 1) ||
	  (loadBprime != 1) || (op != 1) || (regB != 139)) begin
	 $display("%t FAIL ADD B,A instruction", $time);
      end
      else begin
	 $display("%t PASS ADD B,A instruction", $time);
      end

      IR = 'hff; // HALT
      #160;
      if (halt != 1) begin
	 $display("%t FAIL HALT instruction", $time);
      end
      else begin
	 $display("%t PASS HALT instruction", $time);
      end

      $finish;
      
      // Add stimulus here

   end
   
   always begin
      #20 clk = ~clk;
   end

endmodule // decode_mux_reg_test
