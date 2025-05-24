package tx_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // List components in dependency order
  `include "agent_config.sv"
  `include "tx_item.sv"
  `include "tx_sequence.sv"
  `include "tx_sequencer.sv"
  `include "tx_monitor.sv"
  `include "tx_driver.sv"
  `include "tx_agent.sv"
  `include "scoreboard.sv"
  // `include "evaluator.sv"
  `include "tx_env.sv"
  `include "fifo_test.sv"
endpackage