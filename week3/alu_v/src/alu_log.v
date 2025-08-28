module alu_log (
		input wire [3:0] op_a,
		input wire [3:0] op_b,
		input wire [3:0] alu_opt,
		output reg [3:0] logical_data	
		);

always @(*) begin
	case (alu_opt)
		4'b0000:logical_data = op_a & op_b;
		4'b0001:logical_data = op_a | op_b;
		4'b0010:logical_data = op_a ^ op_b;
		4'b0011:logical_data = ~op_a;
		4'b0100:logical_data = ~op_b;
		4'b0101:logical_data = ~(op_a & op_b);
		4'b0110:logical_data = ~(op_a | op_b);
		4'b0111:logical_data = ~(op_a ^ op_b);
		default: logical_data = 4'b0000;
	endcase
end
endmodule
