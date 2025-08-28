module alu_arith (
		input wire [3:0] operand_a,
		input wire [3:0] operand_b,
		input wire [3:0] alu_opt,
		output reg [3:0] ari_data,
		output reg carry);

always @(*) begin
	case (alu_opt)
		4'b0000: {carry, ari_data} = operand_a + operand_b;
		4'b0001: {carry, ari_data} = operand_a - operand_b;
		4'b0010: begin
			carry = 1'b0;
			ari_data = operand_a * operand_b;
			end
		4'b0011: begin
			carry = 1'b0;
			ari_data = operand_a / operand_b;
			end
		4'b0100: begin
			carry = 1'b0;
			ari_data = operand_a % operand_b;
			end
		default: {carry, ari_data} = 5'b0;
	endcase
end
endmodule
