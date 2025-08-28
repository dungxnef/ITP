module alu_top 
#(
    parameter WIDTH = 4
)
(
    input  logic [WIDTH-1:0]      operand_a,
    input  logic [WIDTH-1:0]      operand_b,
    input  logic [3:0]            alu_option,  
    input  logic [1:0]            mode_sel,

    output logic [WIDTH-1:0]      alu_data,
    output logic                  Cout           
);

logic [WIDTH-1 :0] arithmetic_data;
logic [WIDTH-1 :0] logical_data;
logic [WIDTH-1 :0] comp_shift_data;

localparam ARTHM = 2'b00;
localparam LOGIC = 2'b01;
localparam COMP_SHIFT = 2'b10;

alu_arith 
    #(
        .WIDTH(WIDTH)
    )
    Arithmetic_Unit
    (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_option(alu_option),
        
        .arithmetic_data(arithmetic_data),
        .carry(Cout)       
    );

alu_log
    #(
        .WIDTH(WIDTH)
    )
    Logical_Unit
    (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_option(alu_option),

        .logical_data(logical_data)
    );

alu_comp 
    #(
        .WIDTH(WIDTH)
    )
    Comparision_Shift_Bit_Unit
    (
        .operand_a(operand_a),
        .operand_b(operand_b),
        .alu_option(alu_option),

        .comp_shift_data(comp_shift_data)
    );

always_comb begin
        case (mode_sel)
            ARTHM:      alu_data = arithmetic_data;   
            LOGIC:      alu_data = logical_data;   
            COMP_SHIFT: alu_data = comp_shift_data;   
            default:    alu_data = {WIDTH{1'bx}}; 
        endcase
    end


endmodule
