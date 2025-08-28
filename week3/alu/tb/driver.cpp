#include <iostream>
#include <iomanip>
#include <bitset>
#include <string>
#include <vector>
#include <stdexcept>

#define MAX_SIM 500
std::string get_mode_name(const uint32_t& mode_sel) {
    switch (mode_sel) {
        case 0x0: return "Arithmetic";
        case 0x1: return "Logical";
        case 0x2: return "Comparison/Shift";
        default:  return "Unknown";
    }
}

std::string get_alu_operation_name(const uint32_t& mode_sel, const uint32_t& alu_option) {
    if (mode_sel == 0x0) { // Arithmetic mode
        switch (alu_option) {
            case 0x0: return "ADD";
            case 0x1: return "SUB";
            case 0x2: return "MULT";
            case 0x3: return "DIV";
            case 0x4: return "MOD";
            default:  return "Unknown";
        }
    } else if (mode_sel == 0x1) { // Logical mode
        switch (alu_option) {
            case 0x0: return "AND";
            case 0x1: return "OR";
            case 0x2: return "XOR";
            case 0x3: return "NOT_A";
            case 0x4: return "NOT_B";
            case 0x5: return "NAND";
            case 0x6: return "NOR";
            case 0x7: return "XNOR";
            default:  return "Unknown";
        }
    } else if (mode_sel == 0x2) { // Comparison/shift mode
        switch (alu_option) {
            case 0x0: return "EQ";
            case 0x1: return "NE";
            case 0x2: return "LT";
            case 0x3: return "GE";
            case 0x4: return "LEU";
            case 0x5: return "GEU";
            case 0x6: return "SLL";
            case 0x7: return "SRL";
            case 0x8: return "SRA";
            case 0x9: return "SLT";
            case 0xA: return "SLTU";
            default:  return "Unknown";
        }
    } else {
        return "Unknown";
    }
}

std::pair<uint32_t, uint32_t> calculate_expected_value(const uint32_t& mode_sel, const uint32_t& alu_option, const uint32_t& operand_a, const uint32_t& operand_b) {
    uint32_t result = 0;
    uint32_t cout = 0;

    switch (mode_sel) {
        case 0x0: // Arithmetic mode
            switch (alu_option) {
                case 0x0: // ADD
                    result = operand_a + operand_b;
                    cout = (result >> 4) & 0x1; // Cout is the carry-out of the addition
                    break;
                case 0x1: // SUB
                    result = operand_a - operand_b;
                    cout = (operand_a < operand_b) ? 1 : 0; // Cout is 1 if borrow occurs
                    break;
                case 0x2: // MULT
                    result = operand_a * operand_b;
                    cout = (result >> 4) & 0x1; // Cout is the overflow of multiplication
                    break;
                case 0x3: // DIV
                    result = operand_b == 0 ? 0 : operand_a / operand_b;
                    cout = 0; // No carry-out for division
                    break;
                case 0x4: // MOD
                    result = operand_b == 0 ? 0 : operand_a % operand_b;
                    cout = 0; // No carry-out for modulus
                    break;
                default: throw std::invalid_argument("Invalid arithmetic operation");
            }
            break;
        case 0x1: // Logical mode
            switch (alu_option) {
                case 0x0: result = operand_a & operand_b; break;
                case 0x1: result = operand_a | operand_b; break;
                case 0x2: result = operand_a ^ operand_b; break;
                case 0x3: result = ~operand_a; break;
                case 0x4: result = ~operand_b; break;
                case 0x5: result = ~(operand_a & operand_b); break;
                case 0x6: result = ~(operand_a | operand_b); break;
                case 0x7: result = ~(operand_a ^ operand_b); break;
                default: throw std::invalid_argument("Invalid logical operation");
            }
            cout = 0; // No carry-out for logical operations
            break;
        case 0x2: // Comparison/shift mode
            switch (alu_option) {
                case 0x0: result = operand_a == operand_b; break; // EQ (unsigned)
                case 0x1: result = operand_a != operand_b; break; // NE (unsigned)
                case 0x2: result = static_cast<int32_t>(static_cast<int8_t>(operand_a << 4) >> 4) < static_cast<int32_t>(static_cast<int8_t>(operand_b << 4) >> 4); break; // LT (signed)
                case 0x3: result = static_cast<int32_t>(static_cast<int8_t>(operand_a << 4) >> 4) >= static_cast<int32_t>(static_cast<int8_t>(operand_b << 4) >> 4); break; // GE (signed)
                case 0x4: result = operand_a <= operand_b; break; // LEU (unsigned)
                case 0x5: result = operand_a >= operand_b; break; // GEU (unsigned)
                case 0x6: result = operand_a << operand_b; break; // SLL
                case 0x7: result = operand_a >> operand_b; break; // SRL
                case 0x8: result = static_cast<int32_t>(operand_a) >> operand_b; break; // SRA
                case 0x9: result = static_cast<int32_t>(static_cast<int8_t>(operand_a << 4) >> 4) < static_cast<int32_t>(static_cast<int8_t>(operand_b << 4) >> 4); break; // SLT (signed)
                case 0xA: result = operand_a < operand_b; break; // SLTU (unsigned)
                default: throw std::invalid_argument("Invalid comparison/shift operation");
            }
            cout = 0; // No carry-out for comparison/shift operations
            break;
        default: throw std::invalid_argument("Invalid mode");
    }

    // Mask the result to 4 bits
    result &= 0xF;
    return {result, cout};
}

void print_alu_data_clean(const std::vector<std::tuple<uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t>>& alu_data_rows) {
    // Calculate total rows and determine width for Test # column
    int total_rows = alu_data_rows.size();
    int test_num_width = total_rows > 0 ? static_cast<int>(std::to_string(total_rows).length()) + 1 : 6; // Minimum width of 6 if no rows
    test_num_width = std::max(test_num_width, 6); // Ensure at least "Test #" fits

    // Create dynamic border strings
    std::string test_border = std::string(test_num_width + 1, '-'); // +1 for the '|' character
    std::string mode_border = std::string(17, '-'); // Mode column (16 + 1 for space)
    std::string op_border = std::string(6, '-');    // Op column (5 + 1)
    std::string opa_border = std::string(6, '-');   // OpA column (5 + 1)
    std::string opb_border = std::string(6, '-');   // OpB column (5 + 1)
    std::string alu_border = std::string(9, '-');   // alu_data column (8 + 1)
    std::string exp_border = std::string(9, '-');   // Expected column (8 + 1)
    std::string cout_border = std::string(6, '-');  // Cout column (5 + 1)
    std::string match_border = std::string(7, '-'); // Match? column (6 + 1)

    // Print table header
    std::cout << "+" << test_border << "+" << mode_border << "+" << op_border << "+"
              << opa_border << "+" << opb_border << "+" << alu_border << "+"
              << exp_border << "+" << cout_border << "+" << match_border << "+" << std::endl;
    std::cout << "| " << std::setw(test_num_width - 1) << std::left << "Test #" << "| "
              << std::setw(16) << std::left << "Mode" << "| "
              << std::setw(5) << std::left << "Op" << "| "
              << std::setw(5) << "OpA" << "| "
              << std::setw(5) << "OpB" << "| "
              << std::setw(8) << "alu_data" << " | "
              << std::setw(8) << "Expected" << "| "
              << std::setw(5) << "Cout" << "| "
              << std::setw(6) << "Match?" << "|" << std::endl;
    std::cout << "+" << test_border << "+" << mode_border << "+" << op_border << "+"
              << opa_border << "+" << opb_border << "+" << alu_border << "+"
              << exp_border << "+" << cout_border << "+" << match_border << "+" << std::endl;

    // Variables to track matching
    int match_count = 0;
    int test_number = 1; // Start test numbering from 1

    // Print each row of data
    for (const auto& row : alu_data_rows) {
        uint32_t mode_sel = std::get<0>(row);
        uint32_t alu_option = std::get<1>(row);
        uint32_t operand_a = std::get<2>(row);
        uint32_t operand_b = std::get<3>(row);
        uint32_t alu_data = std::get<4>(row);
        uint32_t expected_value = std::get<5>(row);
        uint32_t cout_value = std::get<6>(row); // Extract Cout value

        // Calculate expected result and Cout
        auto [expected_result, expected_cout] = calculate_expected_value(mode_sel, alu_option, operand_a, operand_b);

        std::string mode_name = get_mode_name(mode_sel);
        std::string alu_operation_name = get_alu_operation_name(mode_sel, alu_option);

        // Format the binary values with "4b" prefix
        std::string operand_a_bin = "4b" + std::bitset<4>(operand_a).to_string();
        std::string operand_b_bin = "4b" + std::bitset<4>(operand_b).to_string();
        std::string alu_data_bin = "4b" + std::bitset<4>(alu_data).to_string();
        std::string expected_bin = "4b" + std::bitset<4>(expected_result).to_string();
        std::string cout_bin = "1b" + std::bitset<1>(cout_value).to_string(); // Format Cout as 1-bit binary
        std::string expected_cout_bin = "1b" + std::bitset<1>(expected_cout).to_string(); // Format expected Cout as 1-bit binary

        // Check if alu_data and Cout match the expected values
        bool is_match = (alu_data == expected_result) && (cout_value == expected_cout);
        std::string match = is_match ? "Yes" : "No";
        if (is_match) {
            match_count++;
        }

        // Print the row with dynamic test number width
        std::cout << "|" << std::setw(test_num_width - 1) << test_number << "  |"
                  << std::setw(16) << std::left << mode_name << " | "
                  << std::setw(5) << std::left << alu_operation_name << "|"
                  << std::setw(5) << operand_a_bin << "| "
                  << std::setw(5) << operand_b_bin << "| "
                  << std::setw(8) << alu_data_bin << "| "
                  << std::setw(8) << expected_bin << "| "
                  << std::setw(5) << cout_bin << "| "
                  << std::setw(6) << match << "|" << std::endl;

        test_number++; // Increment test number for the next row
    }

    // Print table footer
    std::cout << "+" << test_border << "+" << mode_border << "+" << op_border << "+"
              << opa_border << "+" << opb_border << "+" << alu_border << "+"
              << exp_border << "+" << cout_border << "+" << match_border << "+" << std::endl;

    // Calculate and print the percentage of matches
    if (total_rows > 0) {
        double match_percentage = (static_cast<double>(match_count) / total_rows) * 100.0;
        std::cout << "Match Percentage: " << std::fixed << std::setprecision(2) << match_percentage << "% "
                  << "(" << match_count << " out of " << total_rows << " tests passed)" << std::endl;
        std::cout << "\nDieu kien xet Cout thieu, nen bo sung, de gay conflict neu gap nhung param trung voi ADD va SUB" << std::endl;
        std::cout << "MULT nhan bi tran so, Output chi toi da 4bit" << std::endl;
        std::cout << "Comp va Shift bij conflict trong viec quy dinh size output. Trong spec ghi 4bit nhung lenh set lai out ra 1 bit" << std::endl;
    } else {
        std::cout << "Match Percentage: N/A (no tests run)" << std::endl;
    }
}
void set_random(Vtop *dut, vluint64_t sim_unit) {
    static std::vector<std::tuple<uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t, uint32_t>> alu_data_rows;
    static uint32_t prev_mode_sel = 0;
    static uint32_t prev_alu_option = 0;
    static uint32_t prev_operand_a = 0;
    static uint32_t prev_operand_b = 0;
    static bool inputs_set = false;

    // Seed the random number generator
    static bool seeded = false;
    if (!seeded) {
        srand(time(NULL));
        seeded = true;
    }

    // Collect data from the previous cycle's inputs (after hardware has processed them)
    if (inputs_set && sim_unit <= MAX_SIM) {
        // Calculate expected result and Cout
        auto [expected_result, expected_cout] = calculate_expected_value(prev_mode_sel, prev_alu_option, prev_operand_a, prev_operand_b);

        // Add dut->alu_data and dut->Cout to the collected data
        alu_data_rows.push_back(std::make_tuple(prev_mode_sel, prev_alu_option, prev_operand_a, prev_operand_b, dut->alu_data, expected_result, dut->Cout));
    }

    // Set new inputs for the current cycle (to be processed in the next cycle)
    if (sim_unit <= MAX_SIM) {
        dut->operand_a = rand() % 16;
        dut->operand_b = rand() % 16;
        dut->mode_sel = rand() % 3;

        if (dut->mode_sel == 0x0) {
            dut->alu_option = rand() % 5;
        } else if (dut->mode_sel == 0x1) {
            dut->alu_option = rand() % 8;
        } else if (dut->mode_sel == 0x2) {
            dut->alu_option = rand() % 11;
        } else {
            dut->alu_option = 0x0;
        }

        // Store the inputs for the next cycle's collection
        prev_mode_sel = dut->mode_sel;
        prev_alu_option = dut->alu_option;
        prev_operand_a = dut->operand_a;
        prev_operand_b = dut->operand_b;
        inputs_set = true;
    }

    // Print the table at the end of the simulation
    if (sim_unit == MAX_SIM - 1) {
        print_alu_data_clean(alu_data_rows);
    }
}