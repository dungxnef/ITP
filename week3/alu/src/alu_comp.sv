module alu_comp #(
    parameter WIDTH = 4
)(
    input  logic [WIDTH-1:0]      operand_a,
    input  logic [WIDTH-1:0]      operand_b,
    input  logic [3:0]            alu_option,
    output logic [WIDTH-1:0]      comp_shift_data
);

    localparam ALU_EQ   = 4'b0000;
    localparam ALU_NE   = 4'b0001;
    localparam ALU_LT   = 4'b0010;
    localparam ALU_GE   = 4'b0011;
    localparam ALU_LEU  = 4'b0100;
    localparam ALU_GEU  = 4'b0101;
    localparam ALU_SLL  = 4'b0110;
    localparam ALU_SRL  = 4'b0111;
    localparam ALU_SRA  = 4'b1000;
    localparam ALU_SLT  = 4'b1001;
    localparam ALU_SLTU = 4'b1010;

    logic [WIDTH-1:0] beq;
    logic [WIDTH-1:0] bne;
    logic [WIDTH-1:0] blt;
    logic [WIDTH-1:0] bge;
    logic [WIDTH-1:0] bltu;
    logic [WIDTH-1:0] bgeu;
    logic [WIDTH-1:0] sll;
    logic [WIDTH-1:0] srl;
    logic [WIDTH-1:0] sra;
    logic [WIDTH-1:0] slt;
    logic [WIDTH-1:0] sltu;

    logic is_equal;
    logic is_greater;
    logic is_greater_u;
    logic [WIDTH-1:0] shift_result;

    assign is_equal     = (operand_a == operand_b);
    assign is_greater   = ($signed(operand_a) > $signed(operand_b));
    assign is_greater_u = (operand_a > operand_b);

    assign shift_result = (alu_option == ALU_SLL) ? (operand_a << operand_b) :
                          (alu_option == ALU_SRL) ? (operand_a >> operand_b) :
                          (alu_option == ALU_SRA) ? ($signed(operand_a) >>> operand_b) :
                          {WIDTH{1'b0}};

    assign beq  = {{(WIDTH-1){1'b0}}, is_equal};                
    assign bne  = {{(WIDTH-1){1'b0}}, ~is_equal};               
    assign blt  = {{(WIDTH-1){1'b0}}, ~is_greater & ~is_equal}; 
    assign bge  = {{(WIDTH-1){1'b0}}, is_greater | is_equal};   
    assign bltu = {{(WIDTH-1){1'b0}}, ~is_greater_u & ~is_equal}; 
    assign bgeu = {{(WIDTH-1){1'b0}}, is_greater_u | is_equal};  
    assign sll  = shift_result;                                 
    assign srl  = shift_result;                             
    assign sra  = shift_result;                                 
    assign slt  = {{(WIDTH-1){1'b0}}, ~is_greater & ~is_equal}; 
    assign sltu = {{(WIDTH-1){1'b0}}, ~is_greater_u & ~is_equal}; 

    always_comb begin
        case (alu_option)
            ALU_EQ:   comp_shift_data = beq;
            ALU_NE:   comp_shift_data = bne;
            ALU_LT:   comp_shift_data = blt;
            ALU_GE:   comp_shift_data = bge;
            ALU_LEU:  comp_shift_data = bltu;
            ALU_GEU:  comp_shift_data = bgeu;
            ALU_SLL:  comp_shift_data = sll;
            ALU_SRL:  comp_shift_data = srl;
            ALU_SRA:  comp_shift_data = sra;
            ALU_SLT:  comp_shift_data = slt;
            ALU_SLTU: comp_shift_data = sltu;
            default:  comp_shift_data = {WIDTH{1'b0}};
        endcase
    end

endmodule
