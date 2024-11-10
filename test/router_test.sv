class router_test extends uvm_test;

  `uvm_component_utils(router_test)

  env envh;
  env_config e_cfg;

  src_agent_config s_cfg[];
  dst_agent_config d_cfg[]; 

  int no_of_src_agents = 1;
  int no_of_dst_agents = 3;
  int has_sagent = 1;
  int has_dagent = 1;
 
  bit [1:0]addr;

  function new(string name = "router_test", uvm_component parent);
	  super.new(name,parent);
  endfunction

function void config_router();

	if(has_sagent)
	  begin

		    s_cfg = new[no_of_src_agents];

		  foreach(s_cfg[i])
		    begin
		    	s_cfg[i] = src_agent_config :: type_id :: create($sformatf("s_cfg[%0d]",i));
          s_cfg[i].is_active = UVM_ACTIVE;
          
			    if(!uvm_config_db #(virtual src_if) :: get(this,"",$sformatf("src_if_%0d",i),s_cfg[i].vif))
				    `uvm_fatal("FATAL","not getting in router_test")
            e_cfg.s_cfg[i] = s_cfg[i];
	  	  end
	  end

   	if(has_dagent)
	   begin

		  d_cfg = new[no_of_dst_agents];

		 foreach(d_cfg[i])
		  begin
			 d_cfg[i] = dst_agent_config :: type_id :: create($sformatf("d_cfg[%0d]",i));

			 d_cfg[i].is_active = UVM_ACTIVE;
        
			if(!uvm_config_db #(virtual dst_if) :: get(this,"",$sformatf("dst_if_%0d",i),d_cfg[i].vif))
				`uvm_fatal("FATAL","not getting in router_test")

			e_cfg.d_cfg[i] = d_cfg[i];
	   end
	  end

 	  e_cfg.no_of_src_agents = no_of_src_agents;
	  e_cfg.no_of_dst_agents = no_of_dst_agents;
	  e_cfg.has_sagent = has_sagent;
	  e_cfg.has_dagent = has_dagent;

  endfunction

  function void build_phase(uvm_phase phase);
	  e_cfg = env_config :: type_id :: create("e_cfg");

	if(has_sagent)
		e_cfg.s_cfg = new[no_of_src_agents];

	if(has_dagent)
		e_cfg.d_cfg = new[no_of_dst_agents];
	
	config_router();

	uvm_config_db #(env_config) :: set(this,"*","env_config",e_cfg);
	
	  super.build_phase(phase);

	  envh = env :: type_id :: create("envh",this);

  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
	  uvm_top.print_topology();
  endfunction	

endclass
	
//small packet testcase
 
class small_packet_test extends router_test;

  `uvm_component_utils(small_packet_test)

  small_pkt_vseq s_pkt_vseqh;	

  function new(string name = "small_packet_test", uvm_component parent);
	  super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
  endfunction

 task run_phase(uvm_phase phase);
   //  repeat(2)
	begin
		addr = {$random}%3;
		uvm_config_db #(bit[1:0]) :: set(this,"*","bit",addr);
	
		phase.raise_objection(this);
	
		s_pkt_vseqh = small_pkt_vseq :: type_id :: create("s_pkt_vseqh");

		s_pkt_vseqh.start(envh.v_sequencer);
	//	#100;
		phase.drop_objection(this);
	end
endtask

endclass

//medium packet testcase
 
class medium_packet_test extends router_test;

  `uvm_component_utils(medium_packet_test)

  medium_pkt_vseq m_pkt_vseqh;	

  function new(string name = "medium_packet_test", uvm_component parent);
	  super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
  endfunction

task run_phase(uvm_phase phase);
  //   repeat(2)
	begin

		addr = {$random}%3;
		uvm_config_db #(bit[1:0]) :: set(this,"*","bit",addr);
	
		phase.raise_objection(this);
	
		m_pkt_vseqh = medium_pkt_vseq :: type_id :: create("m_pkt_vseqh");

		m_pkt_vseqh.start(envh.v_sequencer);
	//	#100;
		phase.drop_objection(this);
	end
endtask

endclass

//big packet testcase
 
class big_packet_test extends router_test;

  `uvm_component_utils(big_packet_test)

  big_pkt_vseq b_pkt_vseqh;	

  function new(string name = "big_packet_test", uvm_component parent);
	  super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
  endfunction

 task run_phase(uvm_phase phase);
 //    repeat(2)
	begin	

		addr = {$random}%3;
		uvm_config_db #(bit[1:0]) :: set(this,"*","bit",addr);

		phase.raise_objection(this);
	
		b_pkt_vseqh = big_pkt_vseq :: type_id :: create("b_pkt_vseqh");

		b_pkt_vseqh.start(envh.v_sequencer);
	//	#100;
		phase.drop_objection(this);
	end
endtask

endclass	
