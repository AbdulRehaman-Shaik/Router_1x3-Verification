class dst_monitor extends uvm_monitor;
  `uvm_component_utils(dst_monitor)

   virtual dst_if.DMON_MP vif;

   dst_xtn d_xtn;

   dst_agent_config d_cfg;

  uvm_analysis_port #(dst_xtn) monitor_port;

// Standard UVM Methods:
	extern function new(string name = "dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	//extern function void report_phase(uvm_phase phase);

endclass 
//-----------------  constructor new method  -------------------//
	function dst_monitor::new(string name = "dst_monitor", uvm_component parent);
		super.new(name,parent);
		// create object for handle monitor_port using new
 		monitor_port = new("monitor_port", this);

  	endfunction

//-----------------  build() phase method  -------------------//
 	function void dst_monitor::build_phase(uvm_phase phase);
	// call super.build_phase(phase);
          super.build_phase(phase);

	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",d_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
 
        endfunction

//-----------------  connect() phase method  -------------------//
	// in connect phase assign the configuration object's virtual interface
	// to the monitor's virtual interface instance(handle --> "vif")
 	function void dst_monitor::connect_phase(uvm_phase phase);
         vif = d_cfg.vif;
  endfunction


//-----------------  run() phase method  -------------------//
        // In forever loop
        // Call task collect_data
  task dst_monitor::run_phase(uvm_phase phase);
      forever
        // Call collect data task
       collect_data();     
  endtask


   // Collect Reference Data from DUV IF 
task dst_monitor::collect_data();
//		d_xtn = dst_xtn :: type_id :: create("d_xtn");

//	dst_xtn d_xtn;
	
//	d_xtn = dst_xtn :: type_id :: create("d_xtn");

	@(vif.dst_mon_cb);
	while(vif.dst_mon_cb.read_enb!==1)
	@(vif.dst_mon_cb);
	d_xtn = dst_xtn :: type_id :: create("d_xtn");

	@(vif.dst_mon_cb);
	d_xtn.header = vif.dst_mon_cb.data_out;
	d_xtn.payload = new[d_xtn.header[7:2]];
	@(vif.dst_mon_cb);

	foreach(d_xtn.payload[i])
	  begin
		d_xtn.payload[i] = vif.dst_mon_cb.data_out;
		@(vif.dst_mon_cb);
	  end

	d_xtn.parity = vif.dst_mon_cb.data_out;
	@(vif.dst_mon_cb);
	@(vif.dst_mon_cb);
	
	monitor_port.write(d_xtn);
//	@(vif.dst_mon_cb);

	`uvm_info("DST_MONITOR",$sformatf("printing from dst_monitor \n %s",d_xtn.sprint()),UVM_LOW)

endtask
    
