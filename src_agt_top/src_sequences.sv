class src_sequence extends uvm_sequence#(src_xtn);

  `uvm_object_utils(src_sequence)

  function new(string name = "src_sequence");
	super.new(name);
  endfunction

endclass

//small packet sequence

class small_packet_seq extends src_sequence;
 
  `uvm_object_utils(small_packet_seq)

  function new(string name = "small_packet_seq");
	super.new(name);
  endfunction

  task body();
   // repeat(2)

	bit [1:0]addr;
	  if(!uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit",addr))
		`uvm_fatal("FATAL","not getting in src_sequences")
       begin	
	req = src_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;})	//small packet with payload size of [1:15]
	`uvm_info("src_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
	finish_item(req);
      end
  endtask

endclass

//medium packet sequence

class medium_packet_seq extends src_sequence;
 
  `uvm_object_utils(medium_packet_seq)

  function new(string name = "medium_packet_seq");
	super.new(name);
  endfunction

  task body();
  //  repeat(2)

     	bit [1:0]addr;
        if(!uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit",addr))
		`uvm_fatal("FATAL","not getting in src_sequences")

      begin	
	req = src_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] == addr;})  //medium packet with payload size of [16:30]
	`uvm_info("src_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
	finish_item(req);
      end
  endtask

endclass

//big packet sequence

class big_packet_seq extends src_sequence;
 
  `uvm_object_utils(big_packet_seq)

  function new(string name = "big_packet_seq");
	super.new(name);
  endfunction

  task body();
   // repeat(2)

	bit [1:0]addr;
        if(!uvm_config_db #(bit[1:0]) :: get(null,get_full_name(),"bit",addr))
		`uvm_fatal("FATAL","not getting in src_sequences")

      begin	
	req = src_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0] == addr;})	//big packet with payload size of [31:63]
	`uvm_info("src_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
	finish_item(req);
      end
  endtask

endclass	
