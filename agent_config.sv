class agent_config extends uvm_object;
  
  rand bit active;
  virtual fifo_if vif;

  `uvm_object_utils_begin(agent_config)
    `uvm_field_int(active, UVM_DEFAULT)
  `uvm_object_utils_end

  function new(string name = "agent_config");
    super.new(name);
    active = 1;
  endfunction
endclass
