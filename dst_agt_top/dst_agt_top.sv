class dst_agt_top extends uvm_env;

  `uvm_component_utils(dst_agt_top)

  dst_agent dagnth[];
  env_config e_cfg;

  function new(string name = "dst_agt_top", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in dst_agt_top")
	if(e_cfg.has_dagent)
	  begin
		dagnth=new[e_cfg.no_of_dst_agents];
		foreach(dagnth[i])
		 begin
			uvm_config_db#(dst_agent_config)::set(this,$sformatf("dagnth[%0d]*",i),"dst_agent_config",e_cfg.d_cfg[i]);
   			dagnth[i]=dst_agent::type_id::create($sformatf("dagnth[%0d]",i),this);
		 end
	  end
	super.build_phase(phase);
  endfunction

/*  task run_phase(uvm_phase phase);
	uvm_top.print_topology();
  endtask
*/
endclass
