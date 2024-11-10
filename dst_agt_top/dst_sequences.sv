class dst_sequence extends uvm_sequence#(dst_xtn);

  `uvm_object_utils(dst_sequence)

  function new(string name = "dst_sequence");
	super.new(name);
  endfunction

endclass

class dst_no_soft_rst extends dst_sequence;

  `uvm_object_utils(dst_no_soft_rst)

  function new(string name = "dst_no_soft_rst");
	super.new(name);
  endfunction

  task body();
//	repeat(2)
	  begin
		req = dst_xtn :: type_id :: create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles inside{[1:29]};})
		`uvm_info("dst_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
		finish_item(req);
	  end
  endtask

endclass
/*
class dst_no_soft_rst_seq2  extends dst_sequence;

  `uvm_object_utils(dst_soft_rst)

  function new(string name = "dst_no_soft_rst_seq2");
	super.new(name);
  endfunction

  task body();
//	repeat(2)
	  begin
		req = dst_xtn :: type_id :: create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles == 15;})
		finish_item(req);
	  end
  endtask

endclass

class dst_soft_rst  extends dst_sequence;

  `uvm_object_utils(dst_soft_rst)

  function new(string name = "dst_soft_rst");
	super.new(name);
  endfunction

  task body();
//	repeat(2)
	  begin
		req = dst_xtn :: type_id :: create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles == 30;})
		`uvm_info("dst_sequence",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
		finish_item(req);
	  end
  endtask

endclass	*/

