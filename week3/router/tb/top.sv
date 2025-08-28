module top (
  // inputs
  input logic        clk_i,rst_ni,packet_valid,
  input logic        read_enb_0,read_enb_1, read_enb_2,
  input logic [7:0] data_i, 
  // outputs
  output logic [7:0] data_o_0,data_o_1, data_o_2,
  output logic vldout_0, vldout_1, vldout_2, err, busy
);

router_top dut(
.clk(clk_i), 
.resetn(rst_ni), 
.packet_valid(packet_valid), 
.read_enb_0(read_enb_0), 
.read_enb_1(read_enb_1), 
.read_enb_2(read_enb_2),
				  
.datain(data_i),

.vldout_0(vldout_0), 
.vldout_1(vldout_1), 
.vldout_2(vldout_2), 

.err(err), 
.busy(busy),

.data_out_0(data_o_0), 
.data_out_1(data_o_1), 
.data_out_2(data_o_2)
);


endmodule
