// clock divider

// derived from "Digital Design Using Digilent FPGA Boards" by Richard
// E. Haskell and Darrin M. Hanna.

module clkdiv
  (input wire mclk,    // master clock signal
   input wire clr,     // reset signal
   input wire halt,    // stop the output clocks when high
   output wire clk190, // 190 Hz
   output wire clk25,  // 25 Mhz
   output wire clk3    // 3 Hz
   );
   
   // 24-bit counter
   reg [23:0]  q = 0;

   always @(posedge mclk or posedge clr or posedge halt) begin
      if (halt == 1) q <= q;
      else if (clr == 1) q <= 0;
      else q <= q + 1;
   end

   // The counter is incremented with each clock so each bit can be
   // treated as a square wave clock signal that divides the master
   // clock by 2^(N+1) where N is the bit number in the counter.
   // e.g. q[0], 50 MHz / 2^(N+1) = 50 Mhz / 2^(0+1) = 50 Mhz / 2 = 25
   // Mhz.

   // 190 Hz would be bit 17, but that results in a lot of flicker if
   // I try to record video.  Bit 14 at 1.525 kHz seems to be a
   // reasonable refresh rate that minimizes flicker on camera while
   // not being so fast that wrong segments are lit.
   assign clk190 = q[14];
   assign clk25 = q[0];
   assign clk3 = q[23]; // 23 = 2.98 Hz

endmodule // clkdiv
