class src_agent extends uvm_agent;

  `uvm_component_utils(src_agent)

  src_agent_config s_cfg;
       
   // Declare handles of src_monitor,src_sequencer and src_driver
   // with Handle names as monh, seqrh, drvh respectively

  src_monitor monh;
  src_sequencer seqrh;
  src_driver drvh;

// Standard UVM Methods:
  extern function new(string name = "src_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : src_agent
//-----------------  constructor new method  -------------------//

       function src_agent::new(string name = "src_agent", 
                               uvm_component parent = null);
         super.new(name, parent);
       endfunction
       
//-----------------  build() phase method  -------------------//
         // Call parent build_phase
         // Create src_monitor instance
         // If is_active=UVM_ACTIVE, create src_driver and src_sequencer instances
	function void src_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
                // get the config object using uvm_config_db 
	  if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
	        monh = src_monitor::type_id::create("monh",this);	
		if(s_cfg.is_active==UVM_ACTIVE)
		  begin
			drvh = src_driver::type_id::create("drvh",this);
			seqrh = src_sequencer::type_id::create("seqrh",this);
		  end
	endfunction

//-----------------  connect() phase method  -------------------//
	//If is_active=UVM_ACTIVE, 
        //connect driver(TLM seq_item_port) and sequencer(TLM seq_item_export)
      
	function void src_agent::connect_phase(uvm_phase phase);
		if(s_cfg.is_active==UVM_ACTIVE)
		  begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
  		end
	endfunction
