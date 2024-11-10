class src_monitor extends uvm_monitor;
  `uvm_component_utils(src_monitor)

   virtual src_if.SMON_MP vif;

   src_agent_config s_cfg;

  uvm_analysis_port #(src_xtn) monitor_port;

// Standard UVM Methods:
	extern function new(string name = "src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
//	extern function void report_phase(uvm_phase phase);

endclass 
//-----------------  constructor new method  -------------------//
	function src_monitor::new(string name = "src_monitor", uvm_component parent);
		super.new(name,parent);
		// create object for handle monitor_port using new
 		monitor_port = new("monitor_port", this);

  	endfunction

//-----------------  build() phase method  -------------------//
 	function void src_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);

	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the monitor's virtual interface instance(handle --> "vif")
 	function void src_monitor::connect_phase(uvm_phase phase);
          vif = s_cfg.vif;
        endfunction


//-----------------  run() phase method  -------------------//
	

        // In forever loop
        // Call task collect_data
       task src_monitor::run_phase(uvm_phase phase);

        forever
        // Call collect data task
      		collect_data();     
       endtask


   // Collect Reference Data from DUV IF 
       task src_monitor::collect_data();
begin
	src_xtn data_sent;
	data_sent=src_xtn::type_id::create("data_sent");

//header
	@(vif.source_monitor_cb);

	while(vif.source_monitor_cb.pkt_vld!==1)
	@(vif.source_monitor_cb);

	while(vif.source_monitor_cb.busy===1)
	@(vif.source_monitor_cb);

	data_sent.header=vif.source_monitor_cb.data_in;
	@(vif.source_monitor_cb);

//payload
	data_sent.payload=new[data_sent.header[7:2]];
//	data_sent.payload=new[vif.source_monitor_cb.data_in[7:2]];	
	foreach(data_sent.payload[i])
	begin

		while(vif.source_monitor_cb.busy)
		@(vif.source_monitor_cb);
		data_sent.payload[i]=vif.source_monitor_cb.data_in;
		@(vif.source_monitor_cb);
	end
//parity
//	@(vif.source_monitor_cb);

	while(vif.source_monitor_cb.busy)
	@(vif.source_monitor_cb);
	data_sent.parity=vif.source_monitor_cb.data_in;
	@(vif.source_monitor_cb);

	monitor_port.write(data_sent);
	//@(vif.source_monitor_cb);

	`uvm_info("SRC_MONITOR",$sformatf("MONITORING FROM DUT :\n %s",data_sent.sprint()), UVM_LOW)
end
	endtask
    
