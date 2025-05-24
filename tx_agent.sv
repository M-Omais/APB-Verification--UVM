class tx_agent extends uvm_agent;
    `uvm_component_utils(tx_agent)
    function new(string name , uvm_component parent);
        super.new(name,parent);
    endfunction //new()
    
    tx_driver drv;
    tx_monitor mon;
    tx_sequencer sqr;

    agent_config agt_cfg;
    uvm_analysis_port #(tx_item) dut_in_tx_port;
    uvm_analysis_port #(tx_item) dut_out_tx_port;

    virtual function void build_phase (uvm_phase phase);
        mon = tx_monitor::type_id::create("mon",this);
        dut_in_tx_port=new("dut_in_tx_port",this);
        dut_out_tx_port=new("dut_out_tx_port",this);
        // if(agt_cfg.active == UVM_ACTIVE) begin
            drv = tx_driver::type_id::create("drv",this);
            sqr = new("sqr",this);
        // end
    endfunction
    virtual function void connect_phase(uvm_phase phase);
        mon.dut_in_tx_port.connect(dut_in_tx_port);
        mon.dut_out_tx_port.connect(dut_out_tx_port);
        // if(agt_cfg.active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
        // end
    endfunction
endclass //tx_agent extends uvm_agen
