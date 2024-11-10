class dst_agent_config extends uvm_object;

  `uvm_object_utils(dst_agent_config)

  virtual dst_if vif;

  uvm_active_passive_enum is_active = UVM_ACTIVE;

  function new(string name = "dst_agent_config");
	super.new(name);
  endfunction

endclass 
