class router_base_vsequence extends uvm_sequence#(uvm_sequence_item);

  `uvm_object_utils(router_base_vsequence)

  src_sequencer src_seqrh[];
  dst_sequencer dst_seqrh[];

  router_base_vsequencer v_seqrh;

 // small_packet_seq src_seqh;
 // dst_sequence dst_seqh;

  env_config e_cfg;

  function new(string name = "router_base_vsequence");
	  super.new(name);
  endfunction

  task body();
    
	  if(!uvm_config_db #(env_config) :: get(null,get_full_name(),"env_config",e_cfg))
		  `uvm_fatal("FATAL","not getting in virtual_sequence")

	    src_seqrh = new[e_cfg.no_of_src_agents];
	    dst_seqrh = new[e_cfg.no_of_dst_agents];

  	  assert($cast(v_seqrh,m_sequencer))
	      else
	        begin
		        `uvm_error("BODY","Error in $cast of virtual sequencer")
	        end

	  foreach(src_seqrh[i])
		  src_seqrh[i] = v_seqrh.src_seqrh[i];
	  foreach(dst_seqrh[i])
	  	dst_seqrh[i] = v_seqrh.dst_seqrh[i];
    
  endtask

endclass

//we can declare here two or more sequences in random_virtual_sequence

//small packet virtual_sequence

class small_pkt_vseq extends router_base_vsequence;

  `uvm_object_utils(small_pkt_vseq)

  small_packet_seq small_pkt_seqh;
  dst_no_soft_rst  dst_no_soft_rsth;

  function new(string name = "small_pkt_vseq");
	  super.new(name);
  endfunction

 task body();
	
	bit[1:0] addr;
    
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("not_getting"," in src sequences")

  	super.body();

	  small_pkt_seqh = small_packet_seq :: type_id :: create("small_pkt_seqh");
	  dst_no_soft_rsth = dst_no_soft_rst :: type_id :: create("dst_no_soft_rsth");

  fork
	  if(e_cfg.has_sagent)
//	repeat(10)
	  begin
		  foreach(src_seqrh[i])
		    small_pkt_seqh.start(src_seqrh[i]);
	  end

	  if(e_cfg.has_dagent)
	    begin
		    dst_no_soft_rsth.start(dst_seqrh[addr]);
	    end
  join
    
 endtask
  
endclass

//medium packet virtual_sequence


class medium_pkt_vseq extends router_base_vsequence;

  `uvm_object_utils(medium_pkt_vseq)

  medium_packet_seq medium_pkt_seqh;
  dst_no_soft_rst  dst_no_soft_rsth;

  function new(string name = "medium_pkt_vseq");
	  super.new(name);
  endfunction

  task body();

	bit[1:0] addr;

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("not_getting"," in src sequences")

  	super.body();

	  medium_pkt_seqh = medium_packet_seq :: type_id :: create("medium_pkt_seqh");
	  dst_no_soft_rsth = dst_no_soft_rst :: type_id :: create("dst_no_soft_rsth");
  fork
	  if(e_cfg.has_sagent)
  //	repeat(10)
	    begin
		    foreach(src_seqrh[i])
		      medium_pkt_seqh.start(src_seqrh[i]);
	    end

	if(e_cfg.has_dagent)
	  begin
		  foreach(dst_seqrh[i])
	//	dst_no_soft_rsth.start(dst_seqrh[i]);

		    if(addr==0)
		      dst_no_soft_rsth.start(dst_seqrh[0]);
		    if(addr==1)
		      dst_no_soft_rsth.start(dst_seqrh[1]);
		    if(addr==2)
		      dst_no_soft_rsth.start(dst_seqrh[2]);
   end
 join
endtask

endclass

//big packet virtual_sequence

class big_pkt_vseq extends router_base_vsequence;

  `uvm_object_utils(big_pkt_vseq)

  big_packet_seq big_pkt_seqh;
  dst_no_soft_rst  dst_no_soft_rsth;

  function new(string name = "big_pkt_vseq");
	  super.new(name);
  endfunction

  task body();

	bit[1:0] addr;

	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit",addr))
		`uvm_fatal("not_getting"," in src sequences")

  	super.body();

	  big_pkt_seqh = big_packet_seq :: type_id :: create("big_pkt_seqh");
	  dst_no_soft_rsth = dst_no_soft_rst :: type_id :: create("dst_no_soft_rsth");

  fork
	  if(e_cfg.has_sagent)
  //	repeat(10)
	    begin
		    foreach(src_seqrh[i])
		      big_pkt_seqh.start(src_seqrh[i]);
	    end

	if(e_cfg.has_dagent)
	  begin
		  foreach(dst_seqrh[i])
	  //	dst_no_soft_rsth.start(dst_seqrh[i]);

		    if(addr==0)
		      dst_no_soft_rsth.start(dst_seqrh[0]);
		    if(addr==1)
		      dst_no_soft_rsth.start(dst_seqrh[1]);
		    if(addr==2)
		      dst_no_soft_rsth.start(dst_seqrh[2]);

	  end
 join
endtask

endclass	
