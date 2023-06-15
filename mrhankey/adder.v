// derived from "Digital Design Using Digilent FPGA Boards" by Richard
// E. Haskell and Darrin M. Hanna.

module adder
  #(parameter N = 8)
  (input wire [N-1:0] a,
   input wire [N-1:0] b,
   output reg [N-1:0] sum,
   output reg cf,
   output reg ovf);

   reg [N:0]  temp;

   always @(*) begin
      temp = {1'b0,a} + {1'b0,b};
      sum = temp[N-1:0];
      cf = temp[N];
      ovf = sum[N-1] ^ a[N-1] ^ b[N-1] ^ cf;
   end
endmodule // adder
