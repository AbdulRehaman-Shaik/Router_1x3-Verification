class env extends uvm_env;

  `uvm_component_utils(env)

  src_agt_top sagt_top;
  dst_agt_top dagt_top;

  router_base_vsequencer v_sequencer;

  scoreboard sb;

  env_config e_cfg;

  function new(string name = "env", uvm_component parent);
	    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  if(!uvm_config_db #(env_config) :: get(this,"","env_config",e_cfg))
		  `uvm_fatal("FATAL","not getting in env")

   	if(e_cfg.has_sagent)
	    begin
		  	sagt_top = src_agt_top::type_id :: create("sagt_top", this);
		    //	uvm_config_db #(src_agent_config) :: set(this,"sagt_top", "src_agent_config",e_cfg.s_cfg);
	    end

	 if(e_cfg.has_dagent)
	    begin
		  	dagt_top = dst_agt_top::type_id :: create("dagt_top", this);
	    	//	uvm_config_db #(dst_agent_config) :: set(this,"dagt_top", "dst_agent_config",e_cfg.d_cfg);
	    end

	super.build_phase(phase);
	
	if(e_cfg.has_scoreboard)
	  begin
			sb = scoreboard :: type_id :: create("sb",this);
	  end

	if(e_cfg.has_virtual_sequencer)
		v_sequencer = router_base_vsequencer :: type_id :: create("v_sequencer",this);

  endfunction

  function void connect_phase(uvm_phase phase);
    
	  if(e_cfg.has_virtual_sequencer) 
		  begin
       if(e_cfg.has_sagent)
				for(int i=0;i<e_cfg.no_of_src_agents;i++)
					v_sequencer.src_seqrh[i] = sagt_top.sagnth[i].seqrh;
        
       if(e_cfg.has_dagent)
          for(int i=0;i<e_cfg.no_of_dst_agents;i++)
		 	  		v_sequencer.dst_seqrh[i] = dagt_top.dagnth[i].seqrh;
      end

	  if(e_cfg.has_scoreboard) 
			begin
    		for(int i=0; i<e_cfg.no_of_src_agents;i++)
					sagt_top.sagnth[i].monh.monitor_port.connect(sb.fifo_srch[i].analysis_export);

				for(int i=0; i<e_cfg.no_of_dst_agents;i++)
					dagt_top.dagnth[i].monh.monitor_port.connect(sb.fifo_dsth[i].analysis_export);
			end

  endfunction

endclass
