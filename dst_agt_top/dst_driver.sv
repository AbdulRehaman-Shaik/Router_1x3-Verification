class dst_driver extends uvm_driver#(dst_xtn);

  `uvm_component_utils(dst_driver)

   virtual dst_if.DDRV_MP vif;

   dst_agent_config d_cfg;
     	
	extern function new(string name ="dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(dst_xtn d_xtn);
endclass

//-----------------  constructor new method  -------------------//
 // Define Constructor new() function
	function dst_driver::new(string name ="dst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

//-----------------  build() phase method  -------------------//
 	function void dst_driver::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",d_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the driver's virtual interface instance(handle --> "vif")
 	function void dst_driver::connect_phase(uvm_phase phase);
          vif = d_cfg.vif;
        endfunction


//-----------------  run() phase method  -------------------//
	 // In forever loop
	    // Get the sequence item using seq_item_port
            // Call send_to_dut task 
            // Get the next sequence item using seq_item_port  

	task dst_driver::run_phase(uvm_phase phase);
               	forever 
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task dst_driver :: send_to_dut(dst_xtn d_xtn);

		`uvm_info("DST_DRIVER",$sformatf("printing from dst_driver \n %s",d_xtn.sprint()),UVM_LOW)

		@(vif.dst_drv_cb);
		while(vif.dst_drv_cb.vld_out!==1)
		@(vif.dst_drv_cb);

		repeat(d_xtn.no_of_cycles)
		@(vif.dst_drv_cb);
		vif.dst_drv_cb.read_enb <= 1'b1;
		while(vif.dst_drv_cb.vld_out===1)
		@(vif.dst_drv_cb);
		vif.dst_drv_cb.read_enb <= 1'b0;
		@(vif.dst_drv_cb);
		@(vif.dst_drv_cb);
		
	endtask	
