`timescale 1ps/1ps
`include "uvm_macros.svh"
import uvm_pkg::*;
import tx_pkg::*;

module top;

  // Clock and Reset
  logic clk_wr, clk_rd, rst_n;

  initial begin
    clk_wr = 0;
    forever #5 clk_wr = ~clk_wr;
  end

  initial begin
    clk_rd = 0;
    forever #7 clk_rd = ~clk_rd;
  end
  // Instantiate interface
    fifo_if fifoi(clk_wr, clk_rd, rst_n);
    fifo dur(.clk_wr   (fifoi.clk_wr),
             .clk_rd   (fifoi.clk_rd),
             .rst_n    (fifoi.rst_n),
             .write_en (fifoi.write_en),
             .read_en  (fifoi.read_en),
             .data_in  (fifoi.data_in),
             .data_out (fifoi.data_out),
             .full     (fifoi.full),
             .empty    (fifoi.empty));

  // DUT instantiation using modport

  // Clock generation

  // Reset logic
  initial begin
    rst_n = 1;
    #1 rst_n = 0;
    #1 rst_n = 1;
  end

  // UVM test initialization
  agent_config cfg ;
  initial begin
    cfg= agent_config::type_id::create("cfg");
    // Pass virtual interface to UVM testbench
    uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fifoi);
    cfg.vif = fifoi;
    uvm_config_db#(agent_config)::set(null, "*", "agt_cfg", cfg);
    // Run the test
    
    run_test("fifo_test");
  end

endmodule
