// make an N-bit counter

// derived from "Digital Design Using Digilent FPGA Boards" by Richard
// E. Haskell and Darrin M. Hanna.

module counter
  #(parameter N = 8)
   (input wire clr,        // reset signal
    input wire clk,        // clock pulse
    output reg [N-1:0] q   // register for counter
    );

   always @(posedge clk or posedge clr)
     begin
        if (clr == 1)
          q <= 0;
        else
          q <= q + 1;
     end

endmodule // counter
