class router_base_vsequencer extends uvm_sequencer #(uvm_sequence_item);

  `uvm_component_utils(router_base_vsequencer)

  src_sequencer src_seqrh[];
  dst_sequencer dst_seqrh[];

  env_config e_cfg;

  function new(string name = "router_base_vsequencer", uvm_component parent);
	  super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		  `uvm_fatal("FATAL","not getting in virtual_sequencer")

	  super.build_phase(phase);
  
	  src_seqrh = new[e_cfg.no_of_src_agents];
	  dst_seqrh = new[e_cfg.no_of_dst_agents];

  endfunction

endclass
