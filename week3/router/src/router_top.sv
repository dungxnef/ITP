module router_top(input logic clk, resetn, packet_valid, read_enb_0, read_enb_1, read_enb_2,
				  input logic [7:0]datain, 
				  output logic vldout_0, vldout_1, vldout_2, err, busy,
				  output logic [7:0]data_out_0, data_out_1, data_out_2);

logic [2:0]w_enb;
logic [2:0]soft_reset;
logic [2:0]read_enb; 
logic [2:0]empty;
logic [2:0]full;
logic lfd_state_w;
// logic [7:0]data_out_temp[2:0];
logic [7:0]dout;

logic fifo_full;
logic detect_add;
logic ld_state;
logic laf_state;
logic full_state;
logic rst_int_reg;
logic parity_done;
logic low_packet_valid;  
logic write_enb_reg;



router_fifo f0(  .clk(clk), .resetn(resetn), .soft_reset(soft_reset[0]),
                .lfd_state(lfd_state_w), .write_enb(w_enb[0]), .datain(dout), .read_enb(read_enb[0]), 
                .full(full[0]), .empty(empty[0]), .dataout(data_out_0));

router_fifo f1(  .clk(clk), .resetn(resetn), .soft_reset(soft_reset[1]),
                .lfd_state(lfd_state_w), .write_enb(w_enb[1]), .datain(dout), .read_enb(read_enb[1]), 
                .full(full[1]), .empty(empty[1]), .dataout(data_out_1));

router_fifo f2(  .clk(clk), .resetn(resetn), .soft_reset(soft_reset[2]),
                .lfd_state(lfd_state_w), .write_enb(w_enb[2]), .datain(dout), .read_enb(read_enb[2]), 
                .full(full[2]), .empty(empty[2]), .dataout(data_out_2));

router_reg r1(.clk(clk), .resetn(resetn), .packet_valid(packet_valid), .datain(datain), 
			  .dout(dout), .fifo_full(fifo_full), .detect_add(detect_add), 
			  .ld_state(ld_state),  .laf_state(laf_state), .full_state(full_state), 
			  .lfd_state(lfd_state_w), .rst_int_reg(rst_int_reg),  .err(err), .parity_done(parity_done), .low_packet_valid(low_packet_valid));

router_fsm fsm(.clk(clk), .resetn(resetn), .packet_valid(packet_valid), 
			   .datain(datain[1:0]), .soft_reset_0(soft_reset[0]), .soft_reset_1(soft_reset[1]), .soft_reset_2(soft_reset[2]), 
			   .fifo_full(fifo_full), .fifo_empty_0(empty[0]), .fifo_empty_1(empty[1]), .fifo_empty_2(empty[2]),
			   .parity_done(parity_done), .low_packet_valid(low_packet_valid), .busy(busy), .rst_int_reg(rst_int_reg), 
			   .full_state(full_state), .lfd_state(lfd_state_w), .laf_state(laf_state), .ld_state(ld_state), 
			   .detect_add(detect_add), .write_enb_reg(write_enb_reg));

router_sync s(.clk(clk), .resetn(resetn), .datain(datain[1:0]), .detect_add(detect_add), 
              .full_0(full[0]), .full_1(full[1]), .full_2(full[2]), .read_enb_0(read_enb[0]), 
			  .read_enb_1(read_enb[1]), .read_enb_2(read_enb[2]), .write_enb_reg(write_enb_reg), 
			  .empty_0(empty[0]), .empty_1(empty[1]), .empty_2(empty[2]), .vld_out_0(vldout_0), .vld_out_1(vldout_1), .vld_out_2(vldout_2), 
			  .soft_reset_0(soft_reset[0]), .soft_reset_1(soft_reset[1]), .soft_reset_2(soft_reset[2]), .write_enb(w_enb), .fifo_full(fifo_full));
			  
assign read_enb[0]= read_enb_0;
assign read_enb[1]= read_enb_1;
assign read_enb[2]= read_enb_2;
endmodule
