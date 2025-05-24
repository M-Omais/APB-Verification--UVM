class tx_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(tx_scoreboard)

  // Analysis import declarations
  `uvm_analysis_imp_decl(_expected)
  `uvm_analysis_imp_decl(_actual)

  // Analysis implementation ports
  uvm_analysis_imp_expected#(tx_item, tx_scoreboard) in_port;
  uvm_analysis_imp_actual#(tx_item, tx_scoreboard)   out_port;

  // FIFO to hold expected data values
  logic [7:0] expected_data[$];

  // Statistics
  int unsigned match;
  int unsigned mismatch;

  // Constructor: create imp ports and initialize stats
  function new(string name, uvm_component parent);
    super.new(name, parent);
    match    = 0;
    mismatch = 0;
  endfunction

  // Build phase: nothing additional needed
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_port  = new("in_port", this);
    out_port = new("out_port", this);
  endfunction

  // Collect expected transactions
  virtual function void write_expected(tx_item t);
    if (t.write_en) begin
      expected_data.push_back(t.data_in);

    end
  endfunction

  // Collect and compare actual transactions
  virtual function void write_actual(tx_item t);
    if (t.read_en) begin
                `uvm_info(get_type_name(),t.convert2string(),UVM_LOW);
      if (expected_data.size() == 0) begin
        `uvm_error(get_type_name(), "No expected transaction available")
      end
      else begin
        logic [7:0] exp_val = 0;
        logic [7:0] act_val = 0;
        if (act_val === exp_val) begin
          `uvm_info(get_type_name(), $sformatf("MATCH: Expected=%0d, Actual=%0d", exp_val, act_val), UVM_LOW);
          match=match+1;
        end else begin
          `uvm_error(get_type_name(), $sformatf("MISMATCH: Expected=%0d, Actual=%0d", exp_val, act_val));
          mismatch=mismatch+1;
        end
        exp_val = expected_data.pop_front();
        act_val = t.data_out;
      end
    end
  endfunction

  // Report final statistics
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), $sformatf("SCOREBOARD SUMMARY: Matches=%0d, Mismatches=%0d", match, mismatch), UVM_LOW);
  endfunction

endclass : tx_scoreboard
