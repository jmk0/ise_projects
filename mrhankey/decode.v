`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:49:01 08/01/2020 
// Design Name: 
// Module Name:    decode 
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
module decode
  (input wire clk,      // clock pulse
   input wire clr,      // reset signal, will clear halt state
   input wire [7:0] IR, // 8-bit instruction register
   output reg halt,     // set halt high on illegal instruction
   output reg [1:0] op, // ALU operation
   output reg selA,     // Reg A data source is either 0=IR or 1=ALU
   output reg loadA,    // Reg A load enable
   output reg selB,     // Reg B data source is either 0=IR or 1=ALU
   output reg loadB     // Reg B load enable
   );

   always @(posedge clk or posedge clr) begin
      if (clr == 1) begin
         halt <= 0;
         selA <= 0;
         loadA <= 0;
         selB <= 0;
         loadB <= 0;
         op <= 0;
      end
      else begin
         if (IR == 8'hff) begin
            halt <= 1;
            selA <= 0;
            loadA <= 0;
            selB <= 0;
            loadB <= 0;
            op <= 0;
         end
         else if (IR[7:6] == 2'b00) begin // LDA
            halt <= 0;
            selA <= 0;
            loadA <= 1;
            selB <= 0;
            loadB <= 0;
            op <= 0;
         end
         else if (IR[7:6] == 2'b01) begin // LDB
            halt <= 0;
            selA <= 0;
            loadA <= 0;
            selB <= 0;
            loadB <= 1;
            op <= 0;
         end
         else if (IR[7:6] == 2'b10) begin // ADD
            halt <= 0;
            selA <= ~|IR[5:3];
            loadA <= ~|IR[5:3];
            selB <= ~IR[5] & IR[4] & ~IR[3];
            loadB <= ~IR[5] & IR[4] & ~IR[3];
            op[1] <= ~|IR[5:2] | (~IR[5] & IR[4] & ~IR[3] & IR[2]);
            op[0] <= (~|IR[5:3] & IR[2]) | (~IR[5] & IR[4] & ~IR[3]);
            //$display("@ %t op = %b  IR[5:2] = %b", $time, op, IR[5:2]);
            //$display("  term 1 = %b", ~|IR[5:2]);
            //$display("  term 2 = %b", (~IR[5] & IR[4] & ~IR[3] & IR[2]));
            //$display("  term 3 = %b", (~|IR[5:3] & IR[2]));
            //$display("  term 4 = %b", (~IR[5] & IR[4] & ~IR[3]));
//               dest
//               sLsL
// 76 5432 10 op AABB
// 10 0000 XX 10 1100  ADD A,A
// 10 0001 XX 01 1100  ADD A,B
// 10 0010 XX 00 0000  N/A
// 10 0011 XX 00 0000  N/A
// 10 0100 XX 01 0011  ADD B,A
// 10 0101 XX 11 0011  ADD B,B
// 10 0110 XX 00 0000  N/A
// 10 0111 XX 00 0000  N/A
// 10 1000 XX 00 0000  N/A
// 10 1001 XX 00 0000  N/A
// 10 1010 XX 00 0000  N/A
// 10 1011 XX 00 0000  N/A
// 10 1100 XX 00 0000  N/A
// 10 1101 XX 00 0000  N/A
// 10 1110 XX 00 0000  N/A
// 10 1111 XX 00 0000  N/A
         end
         else begin
            halt <= 0;
            selA <= 0;
            loadA <= 0;
            selB <= 0;
            loadB <= 0;
            op <= 0;
         end
      end
   end

endmodule // decode
