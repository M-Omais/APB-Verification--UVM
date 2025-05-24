class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  tx_agent      agent;
  tx_scoreboard scoreboard;         // NEW scoreboard

  // virtual fifo_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = tx_agent::type_id::create("agent", this);
    scoreboard = tx_scoreboard::type_id::create("scoreboard", this);  // changed
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.drv.seq_item_port.connect(agent.sqr.seq_item_export);

    // Connect both monitor ports to scoreboard
    agent.mon.dut_in_tx_port.connect(scoreboard.in_port);
    agent.mon.dut_out_tx_port.connect(scoreboard.out_port);
  endfunction

endclass : fifo_env
