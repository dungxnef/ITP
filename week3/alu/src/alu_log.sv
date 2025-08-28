module alu_log #(
    parameter WIDTH = 4 // Operand width
)(
    input  logic [WIDTH-1:0]      operand_a,
    input  logic [WIDTH-1:0]      operand_b,
    input  logic [3:0]            alu_option,
    output logic [WIDTH-1:0]      logical_data
);
    localparam ALU_AND   = 4'b0000;
    localparam ALU_OR    = 4'b0001;
    localparam ALU_XOR   = 4'b0010;
    localparam ALU_NOT_A = 4'b0011;
    localparam ALU_NOT_B = 4'b0100;
    localparam ALU_NAND  = 4'b0101;
    localparam ALU_NOR   = 4'b0110;
    localparam ALU_XNOR  = 4'b0111;

    logic [WIDTH-1:0] and_result;
    logic [WIDTH-1:0] or_result;
    logic [WIDTH-1:0] xor_result;
    logic [WIDTH-1:0] not_a_result;
    logic [WIDTH-1:0] not_b_result;
    logic [WIDTH-1:0] nand_result;
    logic [WIDTH-1:0] nor_result;
    logic [WIDTH-1:0] xnor_result;

    assign and_result   = operand_a & operand_b;  
    assign or_result    = operand_a | operand_b;  
    assign xor_result   = operand_a ^ operand_b;  
    assign not_a_result = ~operand_a;          
    assign not_b_result = ~operand_b;            
    assign nand_result  = ~(operand_a & operand_b); 
    assign nor_result   = ~(operand_a | operand_b); 
    assign xnor_result  = ~(operand_a ^ operand_b); 

    always_comb begin
        case (alu_option)
            ALU_AND:   logical_data = and_result;   
            ALU_OR:    logical_data = or_result;   
            ALU_XOR:   logical_data = xor_result;   
            ALU_NOT_A: logical_data = not_a_result; 
            ALU_NOT_B: logical_data = not_b_result; 
            ALU_NAND:  logical_data = nand_result;  
            ALU_NOR:   logical_data = nor_result;   
            ALU_XNOR:  logical_data = xnor_result;  
            default:   logical_data = {WIDTH{1'bx}}; 
        endcase
    end

endmodule
