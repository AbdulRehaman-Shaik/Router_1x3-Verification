class src_driver extends uvm_driver#(src_xtn);

  `uvm_component_utils(src_driver)

   virtual src_if.SDRV_MP vif;

   src_agent_config s_cfg;
     	
	extern function new(string name ="src_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(src_xtn s_xtn);
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function src_driver::new(string name ="src_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build() phase method  -------------------//
 	function void src_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() s_cfg from uvm_config_db. Have you set() it?") 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the driver's virtual interface instance(handle --> "vif")
 	function void src_driver::connect_phase(uvm_phase phase);
          vif = s_cfg.vif;
        endfunction	


//-----------------  run() phase method  -------------------//
	 // In forever loop
	    // Get the sequence item using seq_item_port
            // Call send_to_dut task 
            // Get the next sequence item using seq_item_port  

	task src_driver::run_phase(uvm_phase phase);

		@(vif.source_driver_cb);
		  vif.source_driver_cb.resetn <= 0;
		
		@(vif.source_driver_cb);
		  vif.source_driver_cb.resetn <= 1;

               	forever 
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task src_driver :: send_to_dut(src_xtn s_xtn);
		
		`uvm_info("SRC_DRIVER",$sformatf("printing from src_driver \n %s",s_xtn.sprint()),UVM_LOW)

		@(vif.source_driver_cb);

		  while(vif.source_driver_cb.busy)
		@(vif.source_driver_cb);
		  vif.source_driver_cb.pkt_vld <= 1;
		  vif.source_driver_cb.data_in <= s_xtn.header;
		@(vif.source_driver_cb);

		  foreach(s_xtn.payload[i])
		    begin
		  	while(vif.source_driver_cb.busy)
			@(vif.source_driver_cb);
		  	vif.source_driver_cb.data_in <= s_xtn.payload[i];
			@(vif.source_driver_cb);
		    end

		while(vif.source_driver_cb.busy)
		  @(vif.source_driver_cb);
		    vif.source_driver_cb.pkt_vld <= 0;
		    vif.source_driver_cb.data_in <= s_xtn.parity;
		  @(vif.source_driver_cb);
		  @(vif.source_driver_cb);	
		//s_xtn.error <= vif.source_driver_cb.error;	
	endtask
    
