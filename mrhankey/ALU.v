module ALU
  #(parameter N = 8)
  (input wire [1:0] op, // 0 = ???, 1 = add, 2 = left shift A, 3 = left shift B
   input wire [N-1:0] a,
   input wire [N-1:0] b,
   output reg [N-1:0] result,
   output reg cf,
   output reg ovf);

   wire [N-1:0] adderSum;
   wire         adderCF, adderOVF;

   adder #(.N(N)) ALUadder
     (.a(a),
      .b(b),
      .sum(adderSum),
      .cf(adderCF),
      .ovf(adderOVF));

   always @(*) begin
      //$display("%t hello", $time);
      case (op)
	2'b00: begin // NOP
	   result <= result;
	   cf <= 0;
	   ovf <= 0;
	end
	2'b01: begin // result <= A+B
           result <= adderSum;
           cf <= adderCF;
           ovf <= adderOVF;
	end
	2'b10: begin // result <= A<<1 (or A*2 or A+A)
	   cf <= a[N-1];
	   ovf <= 0;
	   result[N-1:0] <= { a[N-2:0], 1'b0 };
	   //$display("%t left shifting A a=%b cf=%b result=%b sub_A=%b", $time, a, cf, result, a[N-2:0]);
	end
	2'b11: begin // result <= B<<1 (or B*2 or B+B)
	   cf <= b[N-1];
	   ovf <= 0;
	   result[N-1:0] <= { b[N-2:0], 1'b0 };
	   //$display("%t left shifting B", $time);
	end
	default: begin // result <= 0
           result <= 0;
           cf <= 0;
           ovf <= 0;
	end
      endcase // case (op)
   end // always @ (*)
endmodule // ALU
