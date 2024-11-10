class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  uvm_tlm_analysis_fifo #(src_xtn) fifo_srch[];
  uvm_tlm_analysis_fifo #(dst_xtn) fifo_dsth[];

  env_config e_cfg;

  src_xtn src_data;
  dst_xtn dst_data;

  src_xtn src_cov_data;
  dst_xtn dst_cov_data;

  bit [1:0]addr;

  covergroup src_fcov1;
  	SR_ADD		: coverpoint src_cov_data.header[1:0]{bins ADDRESS ={0,1,2};}
		SR_HEADER	: coverpoint src_cov_data.header [7:2] {bins PAYLOAD_SMALL	={[1:15]};
									                                    bins PAYLOAD_MEDIUM	={[16:30]};
									                                    bins PAYLOAD_LARGE	={[31:63]};}
    SOURCE_FC : cross SR_ADD,SR_HEADER;
  endgroup

  covergroup src_fcov2 with function sample(int i);
		SR_PAYLOAD : coverpoint src_cov_data.payload[i] {bins PAYLOAD={[1:63]};}
  endgroup

  covergroup dst_fcov1;
		DS_ADD		: coverpoint dst_cov_data.header[1:0]{bins ADDRESS ={0,1,2};} 	    	     	     
		DS_HEADER	: coverpoint dst_cov_data.header [7:2] {bins PAYLOAD_SMALL	={[1:15]};
									                                    bins PAYLOAD_MEDIUM	={[16:30]};
									                                    bins PAYLOAD_LARGE	={[31:63]};}
		DESTINATION_FC : cross DS_ADD,DS_HEADER;
  endgroup

  covergroup dst_fcov2 with function sample(int i);
		DS_PAYLOAD : coverpoint dst_cov_data.payload[i] {bins PAYLOAD={[1:63]};}
  endgroup	


  function new(string name = "scoreboard", uvm_component parent);
	super.new(name,parent);

	src_fcov1 = new();
	src_fcov2 = new();
	dst_fcov1 = new();
	dst_fcov2 = new();

	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in scoreboard")
	
	fifo_srch = new[e_cfg.no_of_src_agents];
	foreach(fifo_srch[i])
		fifo_srch[i] = new($sformatf("fifo_srch[%0d]",i),this);

	fifo_dsth = new[e_cfg.no_of_dst_agents];
	foreach(fifo_dsth[i])
		fifo_dsth[i] = new($sformatf("fifo_dsth[%0d]",i),this);

  endfunction

//-----------------  run() phase  -------------------//
  task run_phase(uvm_phase phase);	
	 forever
	  begin
		 fork
			begin
				fifo_srch[0].get(src_data);
				//src_data.print;
			end

			begin
				if(!uvm_config_db #(bit[1:0])::get(this,get_full_name(),"bit",addr))
					`uvm_fatal("not_getting"," in scoreboard")
				fifo_dsth[addr].get(dst_data);
				//dst_data.print;
			end
		join
		//$display("scoreboard data");
		check_data(src_data,dst_data);
	end
endtask

//-----------------------check_data------------------//
  function void check_data(src_xtn src_data,dst_xtn dst_data);

	if(src_data.header == dst_data.header)
	  `uvm_info("SB","header in sb is compared successfully",UVM_LOW)
	else
	  `uvm_info("SB","header in sb is not same",UVM_LOW)


	if(src_data.payload == dst_data.payload)
	  `uvm_info("SB","payload in sb is compared successfully",UVM_LOW)
	else
	  `uvm_info("SB","payload in sb is not same",UVM_LOW)


	if(src_data.parity == dst_data.parity)
	  `uvm_info("SB","parity in sb is compared successfully",UVM_LOW)
	else
	  `uvm_info("SB","parity in sb is not same",UVM_LOW)
	
	 src_cov_data = src_data;
	 dst_cov_data = dst_data;
	
   src_fcov1.sample();
	 dst_fcov1.sample();

	 foreach(src_data.payload[i])
	   begin
	 	    src_fcov2.sample(i);
	   end

	 foreach(dst_data.payload[i])
	   begin
	 	    dst_fcov2.sample(i);
	   end
    
  endfunction
  
endclass
