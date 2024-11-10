class src_agt_top extends uvm_env;

  `uvm_component_utils(src_agt_top)

  src_agent sagnth[];
  env_config e_cfg;

  function new(string name = "src_agt_top", uvm_component parent);
	super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		`uvm_fatal("FATAL","not getting in src_agt_top")
	if(e_cfg.has_sagent)
	 begin
		sagnth=new[e_cfg.no_of_src_agents];
		foreach(sagnth[i])
		 begin
			uvm_config_db#(src_agent_config)::set(this,$sformatf("sagnth[%0d]*",i),"src_agent_config",e_cfg.s_cfg[i]);
   			sagnth[i]=src_agent::type_id::create($sformatf("sagnth[%0d]",i),this);
		 end
	  end
	super.build_phase(phase);
  endfunction

/*   task run_phase(uvm_phase phase);
	uvm_top.print_topology();
  endtask
*/

endclass
