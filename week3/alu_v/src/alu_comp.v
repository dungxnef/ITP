module alu_comp (
		input wire [3:0] oper_a,
		input wire [3:0] oper_b,
		input wire [3:0] alu_opt,
		output reg [3:0] comp_shift_data );

always @(*) begin
	case (alu_opt)
	4'b0000: begin
			if (oper_a == oper_b) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0001: begin
			if (oper_a != oper_b) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0010: begin
			if ($signed(oper_a) < $signed(oper_b)) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0011: begin
			if ($signed(oper_a) >= $signed(oper_b)) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0100: begin
			if (oper_a < oper_b) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0101: begin
			if (oper_a >= oper_b) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b0110: comp_shift_data = oper_a << oper_b;
	4'b0111: comp_shift_data = oper_a >> oper_b;
	4'b1000: comp_shift_data = oper_a >>> oper_b;
	4'b1001: begin
			if ($signed(oper_a) < $signed(oper_b)) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	4'b1010: begin
			if (oper_a < oper_b) begin
				comp_shift_data = 4'b0001;
			end else begin
				comp_shift_data = 4'b0000;
			end
		end
	default: comp_shift_data = 4'b0000;	
    endcase
end
endmodule
