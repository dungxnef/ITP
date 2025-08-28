module alu_top ( 
		input wire [3:0] operand_a,
		input wire [3:0] operand_b,
		input wire [3:0] alu_option,
		input wire [1:0] mode_sel,
		output reg [3:0] alu_data,
		output reg Cout);

wire [3:0] ari_result, comp_result, log_result;


alu_arith U_AriUnit(
		   .operand_a(operand_a),
		   .operand_b(operand_b),
		   .alu_opt(alu_option),
		   .ari_data(ari_result),
  		   .carry(Cout)
		);
alu_comp U_CompUnit(
		   .oper_a(operand_a),
		   .oper_b(operand_b),
		   .alu_opt(alu_option),
		   .comp_shift_data(comp_result)
		);
alu_log U_LogUnit(
		   .op_a(operand_a),
		   .op_b(operand_b),
		   .alu_opt(alu_option),
		   .logical_data(log_result)
		);
	
always@(*) begin
        case (mode_sel)
            2'b00:      alu_data = ari_result;   
            2'b01:      alu_data = log_result;   
            2'b10: 		alu_data = comp_result;   
            default:    alu_data = {4{1'bx}}; 
        endcase
    end
endmodule 
