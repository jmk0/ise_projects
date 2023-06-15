// display 4 hex digits on the 7-segment display

// derived from "Digital Design Using Digilent FPGA Boards" by Richard
// E. Haskell and Darrin M. Hanna.

module x7segbc
  (input wire [15:0] x,      // value to display
   input wire cclk,          // clock for muxing the 4 digits
   input wire clr,           // reset signal
   output reg [6:0] a_to_g,  // a to g cathodes on 7-segment display
   output reg [3:0] an,      // anodes for each of the 4 digits on the display
   output wire dp            // decimal point cathode (unused, always off)
   );


   reg [1:0]   s;
   reg [3:0]   digit;
   wire [3:0]  aen;

   assign dp = 1; // decimal points off
   // set aen[3:0] for leading blanks
   //assign aen[3] = x[15] | x[14] | x[13] | x[12];
   //assign aen[2] = x[15] | x[14] | x[13] | x[12] | x[11] | x[10] | x[9] | x[8];
   //assign aen[1] = x[15] | x[14] | x[13] | x[12] | x[11] | x[10] | x[9] | x[8]
   //         | x[7] | x[6] | x[5] | x[4];
   //assign aen[0] = 1; // digit 0 always on
   // set aen[3:0] to always show all digits
   assign aen = 4'b1111;

   // quad 4-to-1 MUX: mux44
   always @(*)
     case (s)
       0: digit = x[3:0];
       1: digit = x[7:4];
       2: digit = x[11:8];
       3: digit = x[15:12];
       default: digit = x[3:0];
     endcase // case (s)

   // 7-segment decoder: hex7seg
   always @(*)
     case (digit)
       4'b0001 : a_to_g = 7'b1111001;   //1
       4'b0010 : a_to_g = 7'b0100100;   //2
       4'b0011 : a_to_g = 7'b0110000;   //3
       4'b0100 : a_to_g = 7'b0011001;   //4
       4'b0101 : a_to_g = 7'b0010010;   //5
       4'b0110 : a_to_g = 7'b0000010;   //6
       4'b0111 : a_to_g = 7'b1111000;   //7
       4'b1000 : a_to_g = 7'b0000000;   //8
       4'b1001 : a_to_g = 7'b0010000;   //9
       4'b1010 : a_to_g = 7'b0001000;   //A
       4'b1011 : a_to_g = 7'b0000011;   //b
       4'b1100 : a_to_g = 7'b1000110;   //C
       4'b1101 : a_to_g = 7'b0100001;   //d
       4'b1110 : a_to_g = 7'b0000110;   //E
       4'b1111 : a_to_g = 7'b0001110;   //F
       default : a_to_g = 7'b1000000;   //0
     endcase // case (digit)

   // digit select
   always @(*)
     begin
        an = 4'b1111;
        if (aen[s] == 1)
          an[s] = 0;
     end

   // 2-bit counter
   always @(posedge cclk or posedge clr)
     begin
        if (clr == 1)
          s <= 0;
        else
          s <= s + 1;
     end
   
endmodule // x7segbc
