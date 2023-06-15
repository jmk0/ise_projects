// N-bit ring (circular shift) register

// derived from "Digital Design Using Digilent FPGA Boards" by Richard
// E. Haskell and Darrin M. Hanna.

module ring
  #(parameter N = 8)
  (input wire clk,
   input wire clr,
   output reg [N-1:0] q);

   always @(posedge clk or posedge clr)
     begin
        if (clr == 1)
          // this starts with the high bit set
          //q <= {1'b1, { {N-1} {1'b0 }}};
          // this starts with the low bit set
          q <= 1;
        else
          begin
             q[N-1] <= q[0];
             q[N-2:0] <= q[N-1:1];
          end
     end

endmodule // ring
