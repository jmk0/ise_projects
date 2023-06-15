`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:26:13 08/04/2020 
// Design Name: 
// Module Name:    mrhankey_top 
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
////////////////////////////////////////////////////////////////////////////////
module mrhankey_top
  (input wire mclk,
//   input wire [0:0] sw,
   input wire [3:0] btn,
   output wire [7:0] ld,
   output wire [7:0] LEDA,
   output wire [7:0] LEDB,
   output wire [6:0] a_to_g,
   output wire [3:0] an,
   output wire dp);

   wire            clr;         // reset signal
   wire            clk, clk190; // CPU clock and 7-segment display clock
   wire [3:0]      control;     // fetch, decode, execute, update PC
   wire [7:0]      IP;          // instruction pointer
   wire [7:0]      IR;          // instruction register
   wire [15:0]     x;           // data to be displayed on 7-segment display
   wire            halt;
//   wire [15:0]      regs;
   wire [7:0]      regA;
   wire [7:0]      muxA;
   wire            loadA;
   wire            loadAprime;
   wire            selA;
   wire [7:0]      regB;
   wire [7:0]      muxB;
   wire            loadB;
   wire            loadBprime;
   wire            selB;
   wire [3:0]      dbbtn;
   wire [7:0]      ALUout;
   wire [1:0]      aluOp;
//   wire            ldmux;
   // CPU status flags
   wire            cf;
   wire            ovf;

   // Sync with the execute stage so we don't put the wrong values in
   // the registers.
   assign loadA = loadAprime & control[1];
   assign loadB = loadBprime & control[1];

   // use btn[0] to generate clock pulses.
//   clock_pulse deb
//     (.cclk(clk190),
//      .inp(btn),
//      .outp(dbbtn));

   assign clr = btn[3];
//   assign clr = dbbtn[3];         // btn[3] is effectively a reset button
//   assign clk = dbbtn[0];
   assign x = {IP,IR};          // display IR and IP
   assign ld = ALUout; // ldmux;
   assign LEDA = regA;
   assign LEDB = regB;
//   assign ld[7-:4] = control[3:0];
//   assign ld[3:0] = regA[3:0];

   // Clock divider that results in a 3Hz clock for the CPU and 190 Hz
   // clock for the 7-segment display muxing.
   // Clock signal will stop being generated if halt goes high.
   clkdiv div
     (.mclk(mclk),
      .clr(clr),
      .halt(halt),
      .clk3(clk),
      .clk190(clk190));

   // Sequence generator using a ring shift register.  This results in
   // control[3] indicating the fetch stage
   // control[2] indicating the decode stage
   // control[1] indicating the execute stage
   // control[0] indicating the instruction pointer update stage
   ring #(.N(4))
   seq_generator
     (.clk(clk),
      .clr(clr),
      .q(control));

   // This is 256 bytes of simulated memory using block rom.
   // control[3] is used as the clock signal so that the fetch stage
   // pulls the instruction at address IP (instruction pointer) into
   // IR (instruction register).
   mrhankeytest mem
     (.clka(control[3]),
      .addra(IP),
      .douta(IR));

   // This decodes the instruction in IR when control[2] goes high.
   // halt will be set high if the instruction byte in IR is anything
   // but 0 (NOP).
   decode decoder
     (.clk(control[2]),
      .clr(clr),
      .IR(IR),
      .halt(halt),
      .op(aluOp),
      .selA(selA),
      .loadA(loadAprime),
      .selB(selB),
      .loadB(loadBprime));

   // Increment the instruction pointer by 1 when control[0] goes
   // high.  We're keeping this simple by defining all instructions
   // (all one of them in this case) to be a single byte.
   counter IPcontrol
     (.clr(clr),
      .clk(control[0]),
      .q(IP));

   // Display the instruction pointer (as stored in x) on the 7-segment display.
   x7segbc IPdisplay
     (.clr(clr),
      .cclk(clk190),
      .x(x),
      .a_to_g(a_to_g),
      .an(an),
      .dp(dp));

   mux MUXA
     (.sel(selA),
      .d0({2'b00,IR[5:0]}),
      .d1(ALUout),
      .q(muxA));

   mux MUXB
     (.sel(selB),
      .d0({2'b00,IR[5:0]}),
      .d1(ALUout),
      .q(muxB));

//   mux LEDMUX
//     (.sel(sw[0]),
//      .d0(regA),
//      .d1(regB),
//      .q(ldmux));

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
 //[15-:8]));

   ALU hankeyALU
     (.op(aluOp),
      .a(regA),
      .b(regB),
      .result(ALUout),
      .cf(cf),
      .ovf(ovf));

endmodule // mrhankey_top
