/* verilator lint_off UNUSED */
module top 
#(
    parameter WIDTH = 4
)
(
    input                    clk_i,
    input  [WIDTH-1:0]      operand_a,
    input  [WIDTH-1:0]      operand_b,
    input  [3:0]            alu_option,  
    input  [1:0]            mode_sel,

    output [WIDTH-1:0]      alu_data,
    output Cout           
);

alu_top dut
  (
      .operand_a(operand_a),
      .operand_b(operand_b),
      .alu_option(alu_option),  
      .mode_sel(mode_sel),
      .alu_data(alu_data),
      .Cout(Cout)           
  );
  
always @(posedge clk_i) begin : process_assert
    case ({mode_sel, alu_option})
        6'b000000: assert(alu_data == (operand_a + operand_b));
        6'b000001: assert(alu_data == (operand_a - operand_b));
        6'b000010: assert(alu_data == (operand_a * operand_b));
        6'b000011: assert(alu_data == (operand_a / operand_b));
        6'b000100: assert(alu_data == (operand_a % operand_b));

        6'b010000: assert(alu_data == (operand_a & operand_b));
        6'b010001: assert(alu_data == (operand_a | operand_b));
        6'b010010: assert(alu_data == (operand_a ^ operand_b));
        6'b010011: assert(alu_data == ~operand_a);
        6'b010100: assert(alu_data == ~operand_b);
        6'b010101: assert(alu_data == ~(operand_a & operand_b));
        6'b010110: assert(alu_data == ~(operand_a | operand_b));
        6'b010111: assert(alu_data == ~(operand_a ^ operand_b));
// 
        6'b100000: assert(alu_data == ((operand_a == operand_b) ? 1 : 0));
        6'b100001: assert(alu_data == ((operand_a != operand_b) ? 1 : 0));
        6'b100010: assert(alu_data == (($signed(operand_a) < $signed(operand_b)) ? 1 : 0)) ;
        6'b100011: assert(alu_data == (($signed(operand_a) >= $signed(operand_b)) ? 1 : 0));
        6'b100100: assert(alu_data == ((operand_a < operand_b) ? 1 : 0)); 
        6'b100101: assert(alu_data == ((operand_a >= operand_b) ? 1 : 0)) ; 
        6'b100110: assert(alu_data == (operand_a << operand_b));           
        6'b100111: assert(alu_data == (operand_a >> operand_b));           
        6'b101000: assert(alu_data == ($signed(operand_a) >>> operand_b)); 
        6'b101001: assert(alu_data == (($signed(operand_a) < $signed(operand_b)) ? 1 : 0));  
        6'b101010: assert(alu_data == ((operand_a < operand_b) ? 1 : 0)); 
        default: assert(0);
    endcase
end
endmodule
