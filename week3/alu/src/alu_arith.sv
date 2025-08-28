module alu_arith 
#(
    parameter WIDTH = 4
)
(
    input  logic [WIDTH-1:0]      operand_a,
    input  logic [WIDTH-1:0]      operand_b,
    input  logic [3:0]            alu_option,  

    output logic [WIDTH-1:0]      arithmetic_data,
    output logic                  carry           
);
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_MULT= 4'b0010;
    localparam ALU_DIV = 4'b0011;
    localparam ALU_MOD = 4'b0100;

    logic [WIDTH-1:0] add; 
    logic [WIDTH-1:0] sub;  
    logic [WIDTH-1:0] mult; 
    logic [WIDTH-1:0] div;
    logic [WIDTH-1:0] mod;
    logic add_carry, sub_carry;

    // ADD / SUB
    logic [WIDTH:0] adder_result;
    logic  adder_op_b_negate;
    assign adder_op_b_negate = (alu_option == ALU_SUB);
    assign adder_result = {1'b0, operand_a} + {1'b0, (adder_op_b_negate ? ~operand_b : operand_b)} + {{WIDTH{1'b0}}, adder_op_b_negate};

    assign add = adder_result[WIDTH-1:0];
    assign sub = adder_result[WIDTH-1:0];
    assign add_carry = adder_result[WIDTH];
    assign sub_carry = ~adder_result[WIDTH];

    // MUL
    // assign mult = operand_a * operand_b;
    always_comb begin
        mult = 0;
        mult = mult + (operand_b[0] ? operand_a : 0);
        mult = mult + (operand_b[1] ? operand_a << 1 : 0);
        mult = mult + (operand_b[2] ? operand_a << 2 : 0);
        mult = mult + (operand_b[3] ? operand_a << 3 : 0);
    end

    // DIV / REM
    assign div = (operand_b != 0) ? operand_a / operand_b : {WIDTH{1'b0}};
    assign mod = (operand_b != 0) ? operand_a % operand_b : {WIDTH{1'b0}};

    // Output selection for arithmetic_data
    always_comb begin
        case (alu_option)
            ALU_ADD:    arithmetic_data = add;
            ALU_SUB:    arithmetic_data = sub;
            ALU_MULT:   arithmetic_data = mult;
            ALU_DIV:   arithmetic_data = div;
            ALU_MOD:   arithmetic_data = mod;
            default:    arithmetic_data = {WIDTH{1'b0}};
        endcase
    end

    // Carry flag logic (only relevant for ADD and SUB)
    always_comb begin
        case (alu_option)
            ALU_ADD:    carry = add_carry;
            ALU_SUB:    carry = sub_carry;
            default:    carry = 1'b0; // Default value for other operations
        endcase
    end
endmodule
