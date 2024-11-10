module top;
   	
  import router_test_pkg::*;
   
	//import uvm_pkg.sv
	import uvm_pkg::*;

   	// Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;     

   	// Instantiate 2 src_if,dst_if interface instances in0,in1 with clock as input
   	src_if in0(clock);
   	dst_if in1(clock);
  	dst_if in2(clock);
  	dst_if in3(clock);

  // Instantiate 2 router_top duv instances mif0,mif1 with interface as input
  router_top  DUV(.clock(clock),.resetn(in0.resetn),.pkt_valid(in0.pkt_vld),.data_in(in0.data_in),.read_enb_0(in1.read_enb),.read_enb_1(in2.read_enb),.read_enb_2(in3.read_enb),.data_out_0(in1.data_out),.data_out_1(in2.data_out),.data_out_2(in3.data_out),.vld_out_0(in1.vld_out),.vld_out_1(in2.vld_out),.vld_out_2(in3.vld_out),.busy(in0.busy),.error(in0.error));	

	// In initial block
    initial 
		begin

			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
	
			//set the virtual interface instances as strings vif_0,vif_1,vif_2,vif_3 using the uvm_config_db
			
			uvm_config_db #(virtual src_if)::set(null,"*","src_if_0",in0);
			uvm_config_db #(virtual dst_if)::set(null,"*","dst_if_0",in1);
			uvm_config_db #(virtual dst_if)::set(null,"*","dst_if_1",in2);
			uvm_config_db #(virtual dst_if)::set(null,"*","dst_if_2",in3);

			// Call run_test
			run_test();
		end   
endmodule
