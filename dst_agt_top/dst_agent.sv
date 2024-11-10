class dst_agent extends uvm_agent;

  `uvm_component_utils(dst_agent)

  dst_agent_config d_cfg;
       
   // Declare handles of src_monitor,src_sequencer and src_driver
   // with Handle names as monh, seqrh, drvh respectively

  dst_monitor monh;
  dst_sequencer seqrh;
  dst_driver drvh;

// Standard UVM Methods:
  extern function new(string name = "dst_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass
//-----------------  constructor new method  -------------------//

       function dst_agent::new(string name = "dst_agent", uvm_component parent = null);
         super.new(name, parent);
       endfunction
       
//-----------------  build() phase method  -------------------//
         // Call parent build_phase
         // Create src_monitor instance
         // If is_active=UVM_ACTIVE, create src_driver and src_sequencer instances
	function void dst_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
                // get the config object using uvm_config_db 
	  if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",d_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
	        monh = dst_monitor::type_id::create("monh",this);	
		if(d_cfg.is_active==UVM_ACTIVE)
		  begin
			drvh = dst_driver::type_id::create("drvh",this);
			seqrh = dst_sequencer::type_id::create("seqrh",this);
		  end
	endfunction

//-----------------  connect() phase method  -------------------//
	//If is_active=UVM_ACTIVE, 
        //connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
	function void dst_agent::connect_phase(uvm_phase phase);
		if(d_cfg.is_active==UVM_ACTIVE)
		  begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		  end
	endfunction
    
