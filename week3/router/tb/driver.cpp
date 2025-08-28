#define MAX_SIM 100

void set_random(Vtop *dut, vluint64_t sim_unit) {
    static uint8_t packet_length = 0;
    static uint8_t address = 0;
    static int byte_counter = 0;
    static bool transmission_started = false;
    static bool header_active = false; // Tracks if the header is actively being sent
    static int header_counter = 0;    // Counter for maintaining header transmission length
    static uint8_t parity = 0;

    if (sim_unit <= 2) {
        dut->rst_ni = 0;
        transmission_started = false;
        header_active = false;
        byte_counter = 0;
        parity = 0;
        header_counter = 0;
    } else {
        dut->rst_ni = 1;

        if (!transmission_started) {
            packet_length = (rand() % 16) + 1;
            address = rand() % 4;
            uint8_t header = (packet_length << 2) | address;

            dut->data_i = header;
            dut->packet_valid = 1;  
            transmission_started = true;
            header_active = true; // Begin header transmission
            header_counter = 2;   // Initialize header transmission length to 3 cycles
            byte_counter = 0;
            parity = 0;
        } else if (header_active) {
            if (header_counter > 1) {
                header_counter--; // Continue header transmission
                dut->packet_valid = 1; // Keep packet_valid high during header
            } else {
                header_active = false; // End header transmission after 3 cycles
                dut->packet_valid = 0;
            }
        } else if (byte_counter < packet_length) {
            uint8_t payload = rand() % 256;
            dut->data_i = payload;
            dut->packet_valid = 1;
            parity ^= payload;
            byte_counter++;
        } else if (byte_counter == packet_length) {
            dut->data_i = parity;
            dut->packet_valid = 0;
            byte_counter++;
        } else {
            dut->data_i = 0;
            dut->packet_valid = 0;
            transmission_started = false;
            byte_counter = 0;
        }
    }

    dut->read_enb_0 = 1;
    dut->read_enb_1 = 1;
    dut->read_enb_2 = 1;
}
